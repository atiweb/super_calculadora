import 'dart:math' as math;
import 'calc_exception.dart';
import 'fraction.dart';

/// Quadratic radical in simplified form: `coefficient · √radicand`.
///
/// Invariants:
///   - `radicand >= 1` and **square-free** (no square factors),
///   - the zero value is represented as coefficient 0 and radicand 1,
///   - a rational value has `radicand == 1`.
///
/// Examples: √72 → 6√2 ; (1/2)√12 → √3.
class Surd {
  final Fraction coefficient;
  final BigInt radicand;

  const Surd._(this.coefficient, this.radicand);

  /// Builds and simplifies `coefficient · √radicand` by extracting the
  /// square factors of the radicand into the coefficient.
  factory Surd(Fraction coefficient, BigInt radicand) {
    if (radicand.isNegative) {
      throw CalcException(CalcError.negativeRadicand);
    }
    if (radicand == BigInt.zero || coefficient.isZero) {
      return Surd._(Fraction.zero, BigInt.one);
    }

    BigInt outside = BigInt.one;
    BigInt inside = radicand;
    // Extract every d² factor from the radicand. Does not require d to be
    // prime: squares of composite factors are already removed earlier.
    for (BigInt d = BigInt.two; d * d <= inside; d += BigInt.one) {
      final BigInt dd = d * d;
      while (inside % dd == BigInt.zero) {
        outside *= d;
        inside ~/= dd;
      }
    }

    final Fraction newCoeff = coefficient * Fraction.fromBigInt(outside);
    return Surd._(newCoeff, inside);
  }

  /// Simplified √n.
  factory Surd.sqrt(BigInt n) => Surd(Fraction.one, n);

  /// A purely rational value as a Surd (radicand 1).
  factory Surd.fromFraction(Fraction f) => Surd._(f, BigInt.one);

  bool get isZero => coefficient.isZero;

  /// True if the value is rational (no root remains).
  bool get isRational => radicand == BigInt.one || coefficient.isZero;

  double toDouble() =>
      coefficient.toDouble() * math.sqrt(radicand.toDouble());

  /// Product of two surds: c₁√r₁ · c₂√r₂ = c₁c₂ · √(r₁r₂).
  Surd operator *(Surd other) {
    if (isZero || other.isZero) return Surd._(Fraction.zero, BigInt.one);
    return Surd(coefficient * other.coefficient, radicand * other.radicand);
  }

  Surd operator -() => Surd._(-coefficient, radicand);

  @override
  String toString() {
    if (isZero) return '0';
    if (radicand == BigInt.one) return coefficient.toString();

    final String radStr = '√$radicand';
    if (coefficient == Fraction.one) return radStr;
    if (coefficient == -Fraction.one) return '-$radStr';

    if (coefficient.isInteger) {
      return '$coefficient$radStr';
    }
    // Fractional coefficient p/q → "p√r/q" (omitting |p|=1).
    final BigInt p = coefficient.numerator;
    final BigInt q = coefficient.denominator;
    final String head = p == BigInt.one
        ? radStr
        : (p == -BigInt.one ? '-$radStr' : '$p$radStr');
    return '$head/$q';
  }

  @override
  bool operator ==(Object other) =>
      other is Surd &&
      coefficient == other.coefficient &&
      radicand == other.radicand;

  @override
  int get hashCode => Object.hash(coefficient, radicand);
}
