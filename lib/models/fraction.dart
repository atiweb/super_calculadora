import 'calc_exception.dart';

/// Exact rational number p/q using arbitrary-precision arithmetic.
///
/// Olympiad math is exact: an answer is `22/7`, not
/// `3.142857…`. This class always maintains the canonical form:
///   - strictly positive denominator,
///   - gcd(|numerator|, denominator) == 1,
///   - zero is represented as 0/1.
class Fraction implements Comparable<Fraction> {
  final BigInt numerator;
  final BigInt denominator;

  const Fraction._(this.numerator, this.denominator);

  /// Main constructor: reduces and canonicalizes the sign.
  factory Fraction(BigInt numerator, BigInt denominator) {
    if (denominator == BigInt.zero) {
      throw CalcException(CalcError.zeroDenominator);
    }

    // Move the sign to the numerator.
    if (denominator.isNegative) {
      numerator = -numerator;
      denominator = -denominator;
    }

    if (numerator == BigInt.zero) {
      return Fraction._(BigInt.zero, BigInt.one);
    }

    final BigInt g = _gcd(numerator.abs(), denominator);
    return Fraction._(numerator ~/ g, denominator ~/ g);
  }

  factory Fraction.fromInt(int value) =>
      Fraction._(BigInt.from(value), BigInt.one);

  factory Fraction.fromBigInt(BigInt value) => Fraction._(value, BigInt.one);

  /// Parses "3/4", "-3/4", "5", or a decimal "0.25".
  factory Fraction.parse(String input) {
    final s = input.trim();
    if (s.isEmpty) {
      throw CalcException(CalcError.emptyInput);
    }
    if (s.contains('/')) {
      final parts = s.split('/');
      if (parts.length != 2) {
        throw CalcException(CalcError.invalidFraction, {'value': input});
      }
      final n = BigInt.tryParse(parts[0].trim());
      final d = BigInt.tryParse(parts[1].trim());
      if (n == null || d == null) {
        throw CalcException(CalcError.invalidFraction, {'value': input});
      }
      return Fraction(n, d);
    }
    if (s.contains('.')) {
      return Fraction.fromDecimalString(s);
    }
    final n = BigInt.tryParse(s);
    if (n == null) {
      throw CalcException(CalcError.invalidNumber, {'value': input});
    }
    return Fraction.fromBigInt(n);
  }

  /// Converts an exact decimal ("0.25", "-3.14") to a fraction.
  factory Fraction.fromDecimalString(String input) {
    final s = input.trim();
    final bool negative = s.startsWith('-');
    final String body =
        (negative || s.startsWith('+')) ? s.substring(1) : s;
    final parts = body.split('.');
    // After stripping the leading sign only digits are allowed (BigInt.parse
    // would accept embedded signs like "5.-5" and corrupt the value) and
    // there must be at least one digit ("." is not a number).
    final RegExp digitsOnly = RegExp(r'^[0-9]*$');
    if (parts.length > 2 ||
        parts.any((p) => !digitsOnly.hasMatch(p)) ||
        parts.every((p) => p.isEmpty)) {
      throw CalcException(CalcError.invalidNumber, {'value': input});
    }
    final BigInt intPart =
        parts[0].isEmpty ? BigInt.zero : BigInt.parse(parts[0]);
    if (parts.length == 1) {
      final value = negative ? -intPart : intPart;
      return Fraction.fromBigInt(value);
    }
    final String fracStr = parts[1];
    final BigInt fracPart =
        fracStr.isEmpty ? BigInt.zero : BigInt.parse(fracStr);
    final BigInt scale = BigInt.from(10).pow(fracStr.length);
    BigInt num = intPart * scale + fracPart;
    if (negative) num = -num;
    return Fraction(num, scale);
  }

  static final Fraction zero = Fraction._(BigInt.zero, BigInt.one);
  static final Fraction one = Fraction._(BigInt.one, BigInt.one);

  // ── Properties ───────────────────────────────────────────────────────────

  bool get isZero => numerator == BigInt.zero;
  bool get isNegative => numerator.isNegative;
  bool get isPositive => numerator > BigInt.zero;
  bool get isInteger => denominator == BigInt.one;

  // ── Arithmetic operators ─────────────────────────────────────────────────

  Fraction operator +(Fraction other) => Fraction(
        numerator * other.denominator + other.numerator * denominator,
        denominator * other.denominator,
      );

  Fraction operator -(Fraction other) => Fraction(
        numerator * other.denominator - other.numerator * denominator,
        denominator * other.denominator,
      );

  Fraction operator *(Fraction other) =>
      Fraction(numerator * other.numerator, denominator * other.denominator);

  Fraction operator /(Fraction other) {
    if (other.isZero) {
      throw CalcException(CalcError.divisionByZero);
    }
    return Fraction(numerator * other.denominator, denominator * other.numerator);
  }

  Fraction operator -() => Fraction._(-numerator, denominator);

  /// Integer power (supports negative exponent).
  Fraction pow(int exponent) {
    if (exponent == 0) return one;
    if (exponent < 0) {
      if (isZero) throw CalcException(CalcError.zeroToNegativePower);
      return Fraction(
        denominator.pow(-exponent),
        numerator.pow(-exponent),
      );
    }
    return Fraction(numerator.pow(exponent), denominator.pow(exponent));
  }

  Fraction abs() => isNegative ? -this : this;

  Fraction reciprocal() {
    if (isZero) throw CalcException(CalcError.reciprocalOfZero);
    return Fraction(denominator, numerator);
  }

  /// Mediant (a/b ⊕ c/d = (a+c)/(b+d)). Useful for Stern-Brocot / Farey.
  Fraction mediant(Fraction other) => Fraction(
        numerator + other.numerator,
        denominator + other.denominator,
      );

  // ── Rounding to integer ──────────────────────────────────────────────────

  /// Largest integer ≤ value.
  BigInt floor() => _floorDiv(numerator, denominator);

  /// Smallest integer ≥ value.
  BigInt ceil() => -_floorDiv(-numerator, denominator);

  /// Rounding to the nearest integer (halves toward +∞).
  BigInt round() => _floorDiv(
        numerator * BigInt.two + denominator,
        denominator * BigInt.two,
      );

  /// Integer part truncated toward zero.
  BigInt truncate() => numerator ~/ denominator;

  // ── Comparison ───────────────────────────────────────────────────────────

  @override
  int compareTo(Fraction other) =>
      (numerator * other.denominator).compareTo(other.numerator * denominator);

  bool operator <(Fraction other) => compareTo(other) < 0;
  bool operator >(Fraction other) => compareTo(other) > 0;
  bool operator <=(Fraction other) => compareTo(other) <= 0;
  bool operator >=(Fraction other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      other is Fraction &&
      numerator == other.numerator &&
      denominator == other.denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);

  // ── Conversion / formatting ──────────────────────────────────────────────

  double toDouble() => numerator / denominator;

  /// "7/3", or "5" if it is an integer.
  @override
  String toString() =>
      isInteger ? numerator.toString() : '$numerator/$denominator';

  /// Mixed number: -7/3 → "-2 1/3"; integers without a fractional part.
  String toMixedString() {
    if (isInteger) return numerator.toString();
    final BigInt whole = numerator ~/ denominator; // toward zero
    if (whole == BigInt.zero) return toString();
    final BigInt rem = (numerator - whole * denominator).abs();
    return '$whole $rem/$denominator';
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static BigInt _gcd(BigInt a, BigInt b) {
    a = a.abs();
    b = b.abs();
    while (b != BigInt.zero) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  /// Division rounding downward (floor) for a positive divisor.
  static BigInt _floorDiv(BigInt a, BigInt b) {
    // Normalize so that b is positive.
    if (b.isNegative) {
      a = -a;
      b = -b;
    }
    final BigInt q = a ~/ b;
    // In Dart, a % b is non-negative when b > 0; if there is a remainder and
    // a is negative, truncation toward zero ended up above the floor.
    if (a.isNegative && a % b != BigInt.zero) {
      return q - BigInt.one;
    }
    return q;
  }
}
