import 'dart:math' as math;
import '../models/calc_exception.dart';
import '../models/fraction.dart';
import '../models/polynomial.dart';

/// Vieta's relations for a polynomial.
class VietaRelations {
  /// Sum of the roots (e₁).
  final Fraction sumOfRoots;

  /// Product of the roots (eₙ).
  final Fraction productOfRoots;

  /// Elementary symmetric functions e₁..eₙ (index 0 = e₁).
  final List<Fraction> elementarySymmetric;

  const VietaRelations(
      this.sumOfRoots, this.productOfRoots, this.elementarySymmetric);
}

/// Nature of the roots of a quadratic (language-neutral).
enum QuadraticNature { twoRealDistinct, doubleRoot, complexConjugate }

/// Exact solution of a quadratic equation.
class QuadraticSolution {
  final Fraction discriminant;

  final QuadraticNature nature;

  /// Exact rational roots (empty if the roots are irrational/complex).
  final List<Fraction> rationalRoots;

  /// Approximate real roots (empty if they are complex).
  final List<double> realRoots;

  const QuadraticSolution(
      this.discriminant, this.nature, this.rationalRoots, this.realRoots);
}

/// Operations on polynomials with rational coefficients.
class PolynomialService {
  /// Parses expressions like "x^2-5x+6", "2x^3 - x + 1", "3/2 x - 1".
  static Polynomial parse(String input) {
    String s = input.replaceAll(' ', '').replaceAll('*', '');
    if (s.isEmpty) throw CalcException(CalcError.emptyExpression);

    // Split into terms, preserving the sign.
    s = s.replaceAll('-', '+-');
    final List<String> rawTerms =
        s.split('+').where((t) => t.isNotEmpty).toList();

    final Map<int, Fraction> byPower = {};
    final RegExp termRe = RegExp(r'^([+-]?[0-9/.]*)(x(\^([0-9]+))?)?$');

    for (final term in rawTerms) {
      final m = termRe.firstMatch(term);
      if (m == null) {
        throw CalcException(CalcError.invalidTerm, {'value': term});
      }
      final String coeffStr = m.group(1) ?? '';
      final bool hasX = m.group(2) != null;
      final String? powStr = m.group(4);

      final int power = hasX ? (powStr != null ? int.parse(powStr) : 1) : 0;

      Fraction coeff;
      if (coeffStr.isEmpty || coeffStr == '+') {
        coeff = Fraction.one;
      } else if (coeffStr == '-') {
        coeff = Fraction.fromInt(-1);
      } else {
        coeff = Fraction.parse(coeffStr);
      }
      // A lone sign is only an implicit coefficient (±1) next to an x;
      // as a constant term ("5-", "3--2") it is invalid input.
      if (!hasX && (coeffStr.isEmpty || coeffStr == '+' || coeffStr == '-')) {
        throw CalcException(CalcError.invalidTerm, {'value': term});
      }

      byPower[power] = (byPower[power] ?? Fraction.zero) + coeff;
    }

    final int maxPower =
        byPower.keys.isEmpty ? 0 : byPower.keys.reduce(math.max);
    final List<Fraction> coeffs =
        List.filled(maxPower + 1, Fraction.zero);
    byPower.forEach((power, value) => coeffs[power] = value);
    return Polynomial(coeffs);
  }

  /// GCD of two polynomials (monic).
  static Polynomial gcd(Polynomial a, Polynomial b) {
    Polynomial x = a;
    Polynomial y = b;
    while (!y.isZero) {
      final Polynomial r = x % y;
      x = y;
      y = r;
    }
    return x.isZero ? x : x.toMonic();
  }

  /// Vieta's relations: eₖ = (−1)ᵏ · a_{n−k} / aₙ.
  static VietaRelations vieta(Polynomial p) {
    if (p.degree < 1) {
      throw CalcException(CalcError.degreeAtLeastOne);
    }
    final int n = p.degree;
    final Fraction an = p.leadingCoefficient;
    final List<Fraction> e = [];
    for (int k = 1; k <= n; k++) {
      Fraction ek = p.coefficient(n - k) / an;
      if (k.isOdd) ek = -ek;
      e.add(ek);
    }
    return VietaRelations(e.first, e.last, e);
  }

  /// Discriminant (degrees 2 and 3).
  static Fraction discriminant(Polynomial p) {
    if (p.degree == 2) {
      final a = p.coefficient(2), b = p.coefficient(1), c = p.coefficient(0);
      return b * b - Fraction.fromInt(4) * a * c;
    }
    if (p.degree == 3) {
      final a = p.coefficient(3),
          b = p.coefficient(2),
          c = p.coefficient(1),
          d = p.coefficient(0);
      // 18abcd − 4b³d + b²c² − 4ac³ − 27a²d²
      return Fraction.fromInt(18) * a * b * c * d -
          Fraction.fromInt(4) * b.pow(3) * d +
          b.pow(2) * c.pow(2) -
          Fraction.fromInt(4) * a * c.pow(3) -
          Fraction.fromInt(27) * a.pow(2) * d.pow(2);
    }
    throw CalcException(CalcError.discriminantDegree);
  }

  /// Rational root candidates (rational root theorem).
  static List<Fraction> rationalRootCandidates(Polynomial p) {
    if (p.isZero) {
      throw CalcException(CalcError.zeroPolynomialRoots);
    }
    // Scale to integer coefficients.
    final List<BigInt> intCoeffs = _toIntegerCoefficients(p);

    // Factor out trailing powers of x (root 0).
    int lowZeros = 0;
    while (lowZeros < intCoeffs.length && intCoeffs[lowZeros] == BigInt.zero) {
      lowZeros++;
    }
    final Set<Fraction> candidates = {};
    if (lowZeros > 0) candidates.add(Fraction.zero);

    final List<BigInt> reduced = intCoeffs.sublist(lowZeros);
    if (reduced.length >= 2) {
      final BigInt a0 = reduced.first.abs();
      final BigInt an = reduced.last.abs();
      for (final p0 in _divisors(a0)) {
        for (final q0 in _divisors(an)) {
          candidates.add(Fraction(p0, q0));
          candidates.add(Fraction(-p0, q0));
        }
      }
    }

    final List<Fraction> sorted = candidates.toList()
      ..sort((x, y) => x.compareTo(y));
    return sorted;
  }

  /// Real rational roots of the polynomial.
  static List<Fraction> rationalRoots(Polynomial p) {
    final List<Fraction> roots = [];
    for (final cand in rationalRootCandidates(p)) {
      if (p.evaluate(cand).isZero) roots.add(cand);
    }
    return roots;
  }

  /// Solves ax² + bx + c = 0 exactly where possible.
  static QuadraticSolution solveQuadratic(Fraction a, Fraction b, Fraction c) {
    if (a.isZero) {
      throw CalcException(CalcError.notQuadratic);
    }
    final Fraction d = b * b - Fraction.fromInt(4) * a * c;

    final QuadraticNature nature;
    if (d.isZero) {
      nature = QuadraticNature.doubleRoot;
    } else if (d.isPositive) {
      nature = QuadraticNature.twoRealDistinct;
    } else {
      nature = QuadraticNature.complexConjugate;
    }

    final List<Fraction> rationalRoots = [];
    final List<double> realRoots = [];

    final Fraction? sqrtD = _fractionSqrt(d);
    final Fraction twoA = Fraction.fromInt(2) * a;
    if (sqrtD != null) {
      // Exact rational roots.
      final r1 = (-b + sqrtD) / twoA;
      final r2 = (-b - sqrtD) / twoA;
      if (r1 == r2) {
        rationalRoots.add(r1);
      } else {
        rationalRoots
          ..add(r1)
          ..add(r2);
        rationalRoots.sort((x, y) => x.compareTo(y));
      }
    }

    if (!d.isNegative) {
      final double dd = math.sqrt(d.toDouble());
      final double da = twoA.toDouble();
      final double x1 = (-b.toDouble() + dd) / da;
      final double x2 = (-b.toDouble() - dd) / da;
      if (d.isZero) {
        realRoots.add(x1);
      } else {
        realRoots
          ..add(math.min(x1, x2))
          ..add(math.max(x1, x2));
      }
    }

    return QuadraticSolution(d, nature, rationalRoots, realRoots);
  }

  /// (Approximate) real roots of ax³+bx²+cx+d = 0.
  static List<double> solveCubicReal(double a, double b, double c, double d) {
    if (a == 0) {
      throw CalcException(CalcError.notCubic);
    }
    // Normalize and depress: x = t − b/(3a) ⇒ t³ + pt + q = 0
    final double bn = b / a, cn = c / a, dn = d / a;
    final double p = cn - bn * bn / 3;
    final double q = 2 * bn * bn * bn / 27 - bn * cn / 3 + dn;
    final double shift = bn / 3;

    final List<double> roots = [];
    final double disc = q * q / 4 + p * p * p / 27;

    if (disc > 1e-12) {
      // One real root.
      final double sqrtDisc = math.sqrt(disc);
      final double u = _cbrt(-q / 2 + sqrtDisc);
      final double v = _cbrt(-q / 2 - sqrtDisc);
      roots.add(u + v - shift);
    } else if (disc.abs() <= 1e-12) {
      // Repeated root, all roots real.
      final double u = _cbrt(-q / 2);
      roots.add(2 * u - shift);
      roots.add(-u - shift);
    } else {
      // Three distinct real roots (trigonometric case).
      final double m = 2 * math.sqrt(-p / 3);
      final double theta =
          math.acos(((3 * q) / (p * m)).clamp(-1.0, 1.0)) / 3;
      for (int k = 0; k < 3; k++) {
        roots.add(m * math.cos(theta - 2 * math.pi * k / 3) - shift);
      }
    }
    roots.sort();
    return roots;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static List<BigInt> _toIntegerCoefficients(Polynomial p) {
    // Multiply by the lcm of the denominators.
    BigInt l = BigInt.one;
    for (final c in p.coefficients) {
      l = _lcm(l, c.denominator);
    }
    return p.coefficients
        .map((c) => (c.numerator * l) ~/ c.denominator)
        .toList();
  }

  static Set<BigInt> _divisors(BigInt n) {
    n = n.abs();
    final Set<BigInt> result = {};
    if (n == BigInt.zero) return result;
    for (BigInt i = BigInt.one; i * i <= n; i += BigInt.one) {
      if (n % i == BigInt.zero) {
        result.add(i);
        result.add(n ~/ i);
      }
    }
    return result;
  }

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

  static BigInt _lcm(BigInt a, BigInt b) {
    if (a == BigInt.zero || b == BigInt.zero) return BigInt.zero;
    return (a * b).abs() ~/ _gcd(a, b);
  }

  /// Exact square root of a fraction if it is a rational perfect square.
  static Fraction? _fractionSqrt(Fraction f) {
    if (f.isNegative) return null;
    if (f.isZero) return Fraction.zero;
    final BigInt? n = _integerSqrtExact(f.numerator);
    final BigInt? d = _integerSqrtExact(f.denominator);
    if (n == null || d == null) return null;
    return Fraction(n, d);
  }

  static BigInt? _integerSqrtExact(BigInt n) {
    if (n < BigInt.zero) return null;
    if (n < BigInt.two) return n;
    BigInt x = n;
    BigInt y = (x + BigInt.one) >> 1;
    while (y < x) {
      x = y;
      y = (x + n ~/ x) >> 1;
    }
    return x * x == n ? x : null;
  }

  static double _cbrt(double x) =>
      x < 0 ? -math.pow(-x, 1 / 3).toDouble() : math.pow(x, 1 / 3).toDouble();
}
