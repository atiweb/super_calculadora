import 'dart:math' as math;
import 'calc_exception.dart';
import 'fraction.dart';

/// Radical cuadrático en forma simplificada: `coefficient · √radicand`.
///
/// Invariantes:
///   - `radicand >= 1` y **libre de cuadrados** (sin factores cuadrados),
///   - el valor cero se representa como coeficiente 0 y radicando 1,
///   - un valor racional tiene `radicand == 1`.
///
/// Ejemplos: √72 → 6√2 ; (1/2)√12 → √3.
class Surd {
  final Fraction coefficient;
  final BigInt radicand;

  const Surd._(this.coefficient, this.radicand);

  /// Construye y simplifica `coefficient · √radicand` extrayendo los
  /// factores cuadrados del radicando hacia el coeficiente.
  factory Surd(Fraction coefficient, BigInt radicand) {
    if (radicand.isNegative) {
      throw CalcException(CalcError.negativeRadicand);
    }
    if (radicand == BigInt.zero || coefficient.isZero) {
      return Surd._(Fraction.zero, BigInt.one);
    }

    BigInt outside = BigInt.one;
    BigInt inside = radicand;
    // Extraer todo factor d² del radicando. No requiere que d sea primo:
    // los cuadrados de factores compuestos ya quedan removidos antes.
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

  /// √n simplificado.
  factory Surd.sqrt(BigInt n) => Surd(Fraction.one, n);

  /// Un valor puramente racional como Surd (radicando 1).
  factory Surd.fromFraction(Fraction f) => Surd._(f, BigInt.one);

  bool get isZero => coefficient.isZero;

  /// Verdadero si el valor es racional (no queda raíz).
  bool get isRational => radicand == BigInt.one || coefficient.isZero;

  double toDouble() =>
      coefficient.toDouble() * math.sqrt(radicand.toDouble());

  /// Producto de dos surds: c₁√r₁ · c₂√r₂ = c₁c₂ · √(r₁r₂).
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
    // Coeficiente fraccionario p/q → "p√r/q" (omitiendo |p|=1).
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
