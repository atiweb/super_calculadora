import '../models/calc_exception.dart';
import '../models/fraction.dart';

/// Resolución exacta de sistemas lineales 2×2 y 3×3 por la regla de Cramer.
///
/// Las soluciones se devuelven como fracciones exactas; si el determinante es
/// cero (sistema sin solución única) se devuelve `null`.
class LinearSystemService {
  /// Resuelve el sistema dado por la matriz aumentada [rows]: cada fila tiene
  /// n coeficientes y el término independiente al final (n filas, n = 2 o 3).
  /// Devuelve [x, y] o [x, y, z], o `null` si el determinante es cero.
  static List<Fraction>? solveCramer(List<List<Fraction>> rows) {
    final int n = rows.length;
    if (n < 2 || n > 3) {
      throw CalcException(CalcError.invalidSystem);
    }
    for (final row in rows) {
      if (row.length != n + 1) {
        throw CalcException(CalcError.invalidSystem);
      }
    }

    if (n == 2) {
      final Fraction det = _det2(
        rows[0][0], rows[0][1],
        rows[1][0], rows[1][1],
      );
      if (det.isZero) return null;
      final Fraction dx = _det2(
        rows[0][2], rows[0][1],
        rows[1][2], rows[1][1],
      );
      final Fraction dy = _det2(
        rows[0][0], rows[0][2],
        rows[1][0], rows[1][2],
      );
      return [dx / det, dy / det];
    }

    final Fraction det = _det3(rows, 0, 1, 2);
    if (det.isZero) return null;
    final List<Fraction> result = [];
    for (int col = 0; col < 3; col++) {
      // Sustituir la columna `col` por los términos independientes.
      final replaced = [
        for (final row in rows)
          [for (int j = 0; j < 3; j++) j == col ? row[3] : row[j]],
      ];
      result.add(_det3(replaced, 0, 1, 2) / det);
    }
    return result;
  }

  /// Determinante del sistema (sin la columna aumentada), útil para mostrar.
  static Fraction determinant(List<List<Fraction>> rows) {
    final int n = rows.length;
    if (n == 2) {
      return _det2(rows[0][0], rows[0][1], rows[1][0], rows[1][1]);
    }
    if (n == 3) {
      return _det3(rows, 0, 1, 2);
    }
    throw CalcException(CalcError.invalidSystem);
  }

  static Fraction _det2(Fraction a, Fraction b, Fraction c, Fraction d) =>
      a * d - b * c;

  static Fraction _det3(List<List<Fraction>> m, int c0, int c1, int c2) =>
      m[0][c0] * _det2(m[1][c1], m[1][c2], m[2][c1], m[2][c2]) -
      m[0][c1] * _det2(m[1][c0], m[1][c2], m[2][c0], m[2][c2]) +
      m[0][c2] * _det2(m[1][c0], m[1][c1], m[2][c0], m[2][c1]);
}
