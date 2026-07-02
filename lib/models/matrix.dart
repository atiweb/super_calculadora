import 'calc_exception.dart';
import 'fraction.dart';

/// Matriz de racionales **exactos** ([Fraction]). Las operaciones (determinante,
/// inversa, resolución de sistemas) usan eliminación gaussiana con fracciones,
/// por lo que el resultado es exacto (sin error de punto flotante).
class Matrix {
  final List<List<Fraction>> rows;
  final int rowCount;
  final int colCount;

  Matrix._(this.rows, this.rowCount, this.colCount);

  factory Matrix(List<List<Fraction>> rows) {
    if (rows.isEmpty || rows.first.isEmpty) {
      throw CalcException(CalcError.invalidSystem);
    }
    final cols = rows.first.length;
    for (final r in rows) {
      if (r.length != cols) throw CalcException(CalcError.invalidSystem);
    }
    return Matrix._(rows, rows.length, cols);
  }

  factory Matrix.fromInts(List<List<int>> data) => Matrix(data
      .map((r) => r.map((v) => Fraction.fromInt(v)).toList())
      .toList());

  factory Matrix.identity(int n) => Matrix(List.generate(
      n,
      (i) => List.generate(
          n, (j) => i == j ? Fraction.one : Fraction.zero)));

  bool get isSquare => rowCount == colCount;

  Fraction at(int r, int c) => rows[r][c];

  List<List<Fraction>> _copy() => [for (final r in rows) [...r]];

  Matrix transpose() => Matrix(List.generate(colCount,
      (j) => List.generate(rowCount, (i) => rows[i][j])));

  Matrix operator +(Matrix o) {
    if (rowCount != o.rowCount || colCount != o.colCount) {
      throw CalcException(CalcError.invalidSystem);
    }
    return Matrix(List.generate(rowCount,
        (i) => List.generate(colCount, (j) => rows[i][j] + o.rows[i][j])));
  }

  /// Producto matricial (colCount de este = rowCount del otro).
  Matrix operator *(Matrix o) {
    if (colCount != o.rowCount) {
      throw CalcException(CalcError.invalidSystem);
    }
    return Matrix(List.generate(rowCount, (i) {
      return List.generate(o.colCount, (j) {
        Fraction sum = Fraction.zero;
        for (int k = 0; k < colCount; k++) {
          sum = sum + rows[i][k] * o.rows[k][j];
        }
        return sum;
      });
    }));
  }

  Matrix scale(Fraction k) => Matrix(
      rows.map((r) => r.map((v) => v * k).toList()).toList());

  /// Determinante por eliminación gaussiana (solo matrices cuadradas).
  Fraction determinant() {
    if (!isSquare) throw CalcException(CalcError.invalidSystem);
    final n = rowCount;
    final m = _copy();
    Fraction det = Fraction.one;
    for (int col = 0; col < n; col++) {
      int pivot = -1;
      for (int r = col; r < n; r++) {
        if (!m[r][col].isZero) {
          pivot = r;
          break;
        }
      }
      if (pivot == -1) return Fraction.zero;
      if (pivot != col) {
        final tmp = m[pivot];
        m[pivot] = m[col];
        m[col] = tmp;
        det = -det;
      }
      det = det * m[col][col];
      final pivVal = m[col][col];
      for (int r = col + 1; r < n; r++) {
        if (m[r][col].isZero) continue;
        final factor = m[r][col] / pivVal;
        for (int c = col; c < n; c++) {
          m[r][c] = m[r][c] - factor * m[col][c];
        }
      }
    }
    return det;
  }

  /// Inversa por Gauss-Jordan; `null` si es singular o no cuadrada.
  Matrix? inverse() {
    if (!isSquare) return null;
    final n = rowCount;
    final a = _copy();
    final inv = List.generate(
        n,
        (i) => List.generate(
            n, (j) => i == j ? Fraction.one : Fraction.zero));
    for (int col = 0; col < n; col++) {
      int pivot = -1;
      for (int r = col; r < n; r++) {
        if (!a[r][col].isZero) {
          pivot = r;
          break;
        }
      }
      if (pivot == -1) return null; // singular
      if (pivot != col) {
        var t = a[pivot]; a[pivot] = a[col]; a[col] = t;
        t = inv[pivot]; inv[pivot] = inv[col]; inv[col] = t;
      }
      final pivVal = a[col][col];
      for (int c = 0; c < n; c++) {
        a[col][c] = a[col][c] / pivVal;
        inv[col][c] = inv[col][c] / pivVal;
      }
      for (int r = 0; r < n; r++) {
        if (r == col) continue;
        final f = a[r][col];
        if (f.isZero) continue;
        for (int c = 0; c < n; c++) {
          a[r][c] = a[r][c] - f * a[col][c];
          inv[r][c] = inv[r][c] - f * inv[col][c];
        }
      }
    }
    return Matrix(inv);
  }

  /// Resuelve A·x = b (A cuadrada). Devuelve x o `null` si no hay solución única.
  List<Fraction>? solve(List<Fraction> b) {
    if (!isSquare || b.length != rowCount) {
      throw CalcException(CalcError.invalidSystem);
    }
    final n = rowCount;
    final a = _copy();
    final x = [...b];
    for (int col = 0; col < n; col++) {
      int pivot = -1;
      for (int r = col; r < n; r++) {
        if (!a[r][col].isZero) {
          pivot = r;
          break;
        }
      }
      if (pivot == -1) return null; // singular
      if (pivot != col) {
        final t = a[pivot]; a[pivot] = a[col]; a[col] = t;
        final tb = x[pivot]; x[pivot] = x[col]; x[col] = tb;
      }
      final pivVal = a[col][col];
      for (int c = col; c < n; c++) {
        a[col][c] = a[col][c] / pivVal;
      }
      x[col] = x[col] / pivVal;
      for (int r = 0; r < n; r++) {
        if (r == col) continue;
        final f = a[r][col];
        if (f.isZero) continue;
        for (int c = col; c < n; c++) {
          a[r][c] = a[r][c] - f * a[col][c];
        }
        x[r] = x[r] - f * x[col];
      }
    }
    return x;
  }

  /// Rango por eliminación gaussiana (cuenta filas no nulas tras reducir).
  int rank() {
    final m = _copy();
    final n = rowCount;
    int rank = 0;
    for (int col = 0; col < colCount && rank < n; col++) {
      int pivot = -1;
      for (int r = rank; r < n; r++) {
        if (!m[r][col].isZero) {
          pivot = r;
          break;
        }
      }
      if (pivot == -1) continue;
      final t = m[pivot]; m[pivot] = m[rank]; m[rank] = t;
      final pivVal = m[rank][col];
      for (int r = 0; r < n; r++) {
        if (r == rank) continue;
        if (m[r][col].isZero) continue;
        final f = m[r][col] / pivVal;
        for (int c = col; c < colCount; c++) {
          m[r][c] = m[r][c] - f * m[rank][c];
        }
      }
      rank++;
    }
    return rank;
  }

  @override
  String toString() => rows
      .map((r) => '[${r.map((f) => f.toString()).join(', ')}]')
      .join('\n');
}
