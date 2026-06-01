/// Combinatoria adicional: filas del triángulo de Pascal y coeficientes
/// multinomiales.
class CombinatoricsExtraService {
  static final BigInt _one = BigInt.one;

  /// Fila n del triángulo de Pascal: [C(n,0), C(n,1), …, C(n,n)].
  static List<BigInt> pascalRow(int n) {
    if (n < 0) throw ArgumentError('n debe ser ≥ 0');
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

  /// Coeficiente multinomial (k₁+k₂+…)! / (k₁!·k₂!·…).
  static BigInt multinomial(List<int> parts) {
    if (parts.any((k) => k < 0)) {
      throw ArgumentError('Las partes deben ser no negativas');
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
