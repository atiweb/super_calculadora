import '../models/calc_exception.dart';
import '../models/fraction.dart';

/// Generación de sucesiones definidas por recurrencias lineales.
class SequenceService {
  /// Genera los primeros [count] términos de una recurrencia lineal
  ///   aₙ = c₁·aₙ₋₁ + c₂·aₙ₋₂ + … + cₖ·aₙ₋ₖ
  /// dados los coeficientes [coeffs] = [c₁,…,cₖ] y los [initial] = [a₀,…,aₖ₋₁].
  static List<Fraction> linearRecurrence(
      List<Fraction> coeffs, List<Fraction> initial, int count) {
    final int k = coeffs.length;
    if (initial.length != k) {
      throw CalcException(CalcError.needKInitialTerms, {'k': '$k'});
    }
    if (count < 0) throw CalcException(CalcError.countNonNegative);

    final List<Fraction> terms = List.of(initial);
    if (count <= k) return terms.sublist(0, count);

    for (int n = k; n < count; n++) {
      Fraction next = Fraction.zero;
      for (int j = 0; j < k; j++) {
        // cⱼ₊₁ multiplica a aₙ₋(j+1)
        next = next + coeffs[j] * terms[n - 1 - j];
      }
      terms.add(next);
    }
    return terms;
  }

  /// Conveniencia: sucesión tipo Fibonacci con semillas y coeficientes enteros.
  static List<Fraction> linearRecurrenceInts(
      List<int> coeffs, List<int> initial, int count) {
    return linearRecurrence(
      coeffs.map((c) => Fraction.fromInt(c)).toList(),
      initial.map((c) => Fraction.fromInt(c)).toList(),
      count,
    );
  }
}
