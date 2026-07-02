import 'calc_exception.dart';

/// Número racional exacto p/q usando aritmética de precisión arbitraria.
///
/// La matemática de olimpiada es exacta: una respuesta es `22/7`, no
/// `3.142857…`. Esta clase mantiene siempre la forma canónica:
///   - denominador estrictamente positivo,
///   - mcd(|numerador|, denominador) == 1,
///   - el cero se representa como 0/1.
class Fraction implements Comparable<Fraction> {
  final BigInt numerator;
  final BigInt denominator;

  const Fraction._(this.numerator, this.denominator);

  /// Constructor principal: reduce y canoniza el signo.
  factory Fraction(BigInt numerator, BigInt denominator) {
    if (denominator == BigInt.zero) {
      throw CalcException(CalcError.zeroDenominator);
    }

    // Mover el signo al numerador.
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

  /// Parsea "3/4", "-3/4", "5", o un decimal "0.25".
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

  /// Convierte un decimal exacto ("0.25", "-3.14") a fracción.
  factory Fraction.fromDecimalString(String input) {
    final s = input.trim();
    final bool negative = s.startsWith('-');
    final String body =
        (negative || s.startsWith('+')) ? s.substring(1) : s;
    final parts = body.split('.');
    // Tras extraer el signo inicial solo se admiten dígitos (BigInt.parse
    // aceptaría signos incrustados como "5.-5" y corrompería el valor) y
    // debe haber al menos un dígito ("." no es un número).
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

  // ── Propiedades ──────────────────────────────────────────────────────────

  bool get isZero => numerator == BigInt.zero;
  bool get isNegative => numerator.isNegative;
  bool get isPositive => numerator > BigInt.zero;
  bool get isInteger => denominator == BigInt.one;

  // ── Operadores aritméticos ───────────────────────────────────────────────

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

  /// Potencia entera (admite exponente negativo).
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

  /// Mediant (a/b ⊕ c/d = (a+c)/(b+d)). Útil para Stern-Brocot / Farey.
  Fraction mediant(Fraction other) => Fraction(
        numerator + other.numerator,
        denominator + other.denominator,
      );

  // ── Redondeos a entero ───────────────────────────────────────────────────

  /// Mayor entero ≤ valor.
  BigInt floor() => _floorDiv(numerator, denominator);

  /// Menor entero ≥ valor.
  BigInt ceil() => -_floorDiv(-numerator, denominator);

  /// Redondeo al entero más cercano (mitades hacia +∞).
  BigInt round() => _floorDiv(
        numerator * BigInt.two + denominator,
        denominator * BigInt.two,
      );

  /// Parte entera truncada hacia cero.
  BigInt truncate() => numerator ~/ denominator;

  // ── Comparación ──────────────────────────────────────────────────────────

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

  // ── Conversión / formato ─────────────────────────────────────────────────

  double toDouble() => numerator / denominator;

  /// "7/3", o "5" si es entero.
  @override
  String toString() =>
      isInteger ? numerator.toString() : '$numerator/$denominator';

  /// Número mixto: -7/3 → "-2 1/3"; enteros sin parte fraccionaria.
  String toMixedString() {
    if (isInteger) return numerator.toString();
    final BigInt whole = numerator ~/ denominator; // hacia cero
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

  /// División con redondeo hacia abajo (floor) para divisor positivo.
  static BigInt _floorDiv(BigInt a, BigInt b) {
    // Normalizar para que b sea positivo.
    if (b.isNegative) {
      a = -a;
      b = -b;
    }
    final BigInt q = a ~/ b;
    // En Dart, a % b es no negativo cuando b > 0; si hay resto y a es
    // negativo, el truncamiento hacia cero quedó por encima del floor.
    if (a.isNegative && a % b != BigInt.zero) {
      return q - BigInt.one;
    }
    return q;
  }
}
