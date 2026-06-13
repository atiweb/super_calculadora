import '../models/calc_exception.dart';

/// Combinatoria adicional: filas del triángulo de Pascal y coeficientes
/// multinomiales.
class CombinatoricsExtraService {
  static final BigInt _one = BigInt.one;

  /// Fila n del triángulo de Pascal: [C(n,0), C(n,1), …, C(n,n)].
  static List<BigInt> pascalRow(int n) {
    if (n < 0) throw CalcException(CalcError.nNonNegative);
    final List<BigInt> row = [_one];
    BigInt value = _one;
    for (int k = 1; k <= n; k++) {
      // C(n,k) = C(n,k-1) · (n-k+1) / k
      value = value * BigInt.from(n - k + 1) ~/ BigInt.from(k);
      row.add(value);
    }
    return row;
  }

  /// Triángulo de Pascal completo hasta la fila n (inclusive).
  static List<List<BigInt>> pascalTriangle(int n) =>
      List.generate(n + 1, (i) => pascalRow(i));

  /// Triángulo de Pascal módulo m hasta la fila n (inclusive), construido
  /// aditivamente (sin números grandes). Con m = 2 aparece el patrón de
  /// Sierpiński.
  static List<List<int>> pascalTriangleMod(int n, int m) {
    if (n < 0) throw CalcException(CalcError.nNonNegative);
    if (m < 2) throw CalcException(CalcError.nGreaterThanOne);
    final List<List<int>> rows = [
      [1 % m]
    ];
    for (int i = 1; i <= n; i++) {
      final prev = rows.last;
      final row = List<int>.filled(i + 1, 1 % m);
      for (int k = 1; k < i; k++) {
        row[k] = (prev[k - 1] + prev[k]) % m;
      }
      rows.add(row);
    }
    return rows;
  }

  /// Coeficiente multinomial (k₁+k₂+…)! / (k₁!·k₂!·…).
  static BigInt multinomial(List<int> parts) {
    if (parts.any((k) => k < 0)) {
      throw CalcException(CalcError.partsNonNegative);
    }
    int total = 0;
    BigInt result = _one;
    for (final k in parts) {
      for (int j = 1; j <= k; j++) {
        total++;
        // Multiplicar por total y dividir por j mantiene el valor entero
        // (es un coeficiente multinomial parcial).
        result = result * BigInt.from(total) ~/ BigInt.from(j);
      }
    }
    return result;
  }
}
