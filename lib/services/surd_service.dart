import '../models/calc_exception.dart';
import '../models/fraction.dart';
import '../models/surd.dart';

/// Result of rationalizing a denominator with a binomial `c + √d`:
/// the value is left as `rational + surd` (rational part + radical part).
class RationalizedBinomial {
  final Fraction rational;
  final Surd surd;

  const RationalizedBinomial(this.rational, this.surd);

  @override
  String toString() {
    if (surd.isZero) return rational.toString();
    if (rational.isZero) return surd.toString();
    final String surdStr = surd.toString();
    final String sign = surdStr.startsWith('-') ? ' - ' : ' + ';
    final String surdAbs =
        surdStr.startsWith('-') ? surdStr.substring(1) : surdStr;
    return '$rational$sign$surdAbs';
  }
}

/// Operations on radicals (surds) for exact results.
class SurdService {
  /// Simplifies √n: returns (coefficient, radicand) such that
  /// √n = coefficient · √radicand, with a squarefree radicand.
  /// E.g.: √72 → (6, 2).
  static ({BigInt coefficient, BigInt radicand}) simplifySqrt(BigInt n) {
    final s = Surd.sqrt(n);
    return (coefficient: s.coefficient.numerator, radicand: s.radicand);
  }

  /// Simplifies the k-th root of n: returns (coefficient, radicand) such that
  /// ⁿ√n = coefficient · ᵏ√radicand, extracting dᵏ factors.
  /// E.g.: ³√54 → (3, 2)  (54 = 27·2).
  static ({BigInt coefficient, BigInt radicand}) simplifyNthRoot(
      BigInt n, int k) {
    if (k < 2) {
      throw CalcException(CalcError.rootIndexTooSmall);
    }
    if (n.isNegative && k.isEven) {
      throw CalcException(CalcError.evenRootOfNegative);
    }

    final bool negative = n.isNegative;
    BigInt inside = n.abs();
    if (inside == BigInt.zero) return (coefficient: BigInt.zero, radicand: BigInt.zero);

    BigInt outside = BigInt.one;

    for (BigInt d = BigInt.two; d.pow(k) <= inside; d += BigInt.one) {
      final BigInt dk = d.pow(k);
      while (inside % dk == BigInt.zero) {
        outside *= d;
        inside ~/= dk;
      }
    }

    // The sign (odd-index root of a negative) goes to the coefficient.
    if (negative) outside = -outside;
    return (coefficient: outside, radicand: inside);
  }

  /// Rationalizes a/√b → (a/b)·√b. Returns the equivalent Surd.
  static Surd rationalizeOverSqrt(Fraction a, BigInt b) {
    if (b == BigInt.zero) {
      throw CalcException(CalcError.divisionByRootZero);
    }
    if (b.isNegative) {
      throw CalcException(CalcError.negativeRadicand);
    }
    // a/√b = a·√b / b = (a/b)·√b
    return Surd(a / Fraction.fromBigInt(b), b);
  }

  /// Rationalizes a/(c + √d) by multiplying by the conjugate (c − √d):
  ///   a(c − √d) / (c² − d)
  /// Returns the rational part and the radical part separately.
  static RationalizedBinomial rationalizeOverBinomial(
      Fraction a, Fraction c, BigInt d) {
    if (d.isNegative) {
      throw CalcException(CalcError.negativeRadicand);
    }
    final Fraction denom = c * c - Fraction.fromBigInt(d);
    if (denom.isZero) {
      throw CalcException(CalcError.binomialVanishes);
    }
    final Fraction rational = (a * c) / denom;
    final Surd surd = Surd(-(a / denom), d);
    return RationalizedBinomial(rational, surd);
  }
}
