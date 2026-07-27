import '../models/calc_exception.dart';
import '../models/fraction.dart';

/// Generation of sequences defined by linear recurrences.
class SequenceService {
  /// Generates the first [count] terms of a linear recurrence
  ///   aₙ = c₁·aₙ₋₁ + c₂·aₙ₋₂ + … + cₖ·aₙ₋ₖ
  /// given the coefficients [coeffs] = [c₁,…,cₖ] and the [initial] = [a₀,…,aₖ₋₁].
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
        // cⱼ₊₁ multiplies aₙ₋(j+1)
        next = next + coeffs[j] * terms[n - 1 - j];
      }
      terms.add(next);
    }
    return terms;
  }

  /// Convenience: Fibonacci-like sequence with integer seeds and coefficients.
  static List<Fraction> linearRecurrenceInts(
      List<int> coeffs, List<int> initial, int count) {
    return linearRecurrence(
      coeffs.map((c) => Fraction.fromInt(c)).toList(),
      initial.map((c) => Fraction.fromInt(c)).toList(),
      count,
    );
  }
}
