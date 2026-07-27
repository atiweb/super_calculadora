import '../models/calc_exception.dart';
import '../models/fraction.dart';

/// Exact solving of 2×2 and 3×3 linear systems via Cramer's rule.
///
/// Solutions are returned as exact fractions; if the determinant is
/// zero (system without a unique solution) `null` is returned.
class LinearSystemService {
  /// Solves the system given by the augmented matrix [rows]: each row holds
  /// n coefficients with the constant term at the end (n rows, n = 2 or 3).
  /// Returns [x, y] or [x, y, z], or `null` if the determinant is zero.
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
      // Replace column `col` with the constant terms.
      final replaced = [
        for (final row in rows)
          [for (int j = 0; j < 3; j++) j == col ? row[3] : row[j]],
      ];
      result.add(_det3(replaced, 0, 1, 2) / det);
    }
    return result;
  }

  /// Determinant of the system (without the augmented column), useful for display.
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
