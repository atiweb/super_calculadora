import '../models/fraction.dart';
import '../models/surd.dart';

/// Resultado de racionalizar un denominador con binomio `c + √d`:
/// el valor queda como `rational + surd` (parte racional + parte radical).
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

/// Operaciones sobre radicales (surds) para resultados exactos.
class SurdService {
  /// Simplifica √n: devuelve (coeficiente, radicando) tal que
  /// √n = coeficiente · √radicando, con radicando libre de cuadrados.
  /// Ej: √72 → (6, 2).
  static ({BigInt coefficient, BigInt radicand}) simplifySqrt(BigInt n) {
    final s = Surd.sqrt(n);
    return (coefficient: s.coefficient.numerator, radicand: s.radicand);
  }

  /// Simplifica la raíz k-ésima de n: devuelve (coeficiente, radicando) tal que
  /// ⁿ√n = coeficiente · ᵏ√radicando, extrayendo factores dᵏ.
  /// Ej: ³√54 → (3, 2)  (54 = 27·2).
  static ({BigInt coefficient, BigInt radicand}) simplifyNthRoot(
      BigInt n, int k) {
    if (k < 2) {
      throw ArgumentError('El índice de la raíz debe ser ≥ 2');
    }
    if (n.isNegative && k.isEven) {
      throw ArgumentError('Raíz de índice par de un número negativo');
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

    // El signo (raíz de índice impar de negativo) va al coeficiente.
    if (negative) outside = -outside;
    return (coefficient: outside, radicand: inside);
  }

  /// Racionaliza a/√b → (a/b)·√b. Devuelve el Surd equivalente.
  static Surd rationalizeOverSqrt(Fraction a, BigInt b) {
    if (b == BigInt.zero) {
      throw ArgumentError('División por √0');
    }
    if (b.isNegative) {
      throw ArgumentError('Radicando negativo: no es un número real');
    }
    // a/√b = a·√b / b = (a/b)·√b
    return Surd(a / Fraction.fromBigInt(b), b);
  }

  /// Racionaliza a/(c + √d) multiplicando por el conjugado (c − √d):
  ///   a(c − √d) / (c² − d)
  /// Devuelve la parte racional y la parte radical por separado.
  static RationalizedBinomial rationalizeOverBinomial(
      Fraction a, Fraction c, BigInt d) {
    if (d.isNegative) {
      throw ArgumentError('Radicando negativo: no es un número real');
    }
    final Fraction denom = c * c - Fraction.fromBigInt(d);
    if (denom.isZero) {
      throw ArgumentError('Denominador nulo: c² = d (el binomio se anula)');
    }
    final Fraction rational = (a * c) / denom;
    final Surd surd = Surd(-(a / denom), d);
    return RationalizedBinomial(rational, surd);
  }
}
