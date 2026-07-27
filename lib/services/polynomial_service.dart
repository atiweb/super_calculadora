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

      // Bounded and reported as a domain error. int.parse threw a raw
      // FormatException (shown verbatim, in English, whatever the UI language)
      // on a huge exponent, and an accepted one like x^1000000 allocated a
      // million-entry coefficient list on the UI thread.
      int power = 0;
      if (hasX) {
        if (powStr == null) {
          power = 1;
        } else {
          final int? parsed = int.tryParse(powStr);
          if (parsed == null || parsed > 1000) {
            throw CalcException(CalcError.inputTooLarge, {'max': '1000'});
          }
          power = parsed;
        }
      }

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

  /// (Approximate) real roots of ax³+bx²+cx+d = 0, without repetitions.
  ///
  /// Rather than classifying the cubic by the sign of its discriminant — a
  /// test so ill-conditioned that (x−1)²(x−14) was reported as having only
  /// x = 14, losing the double root in 1076 of 3540 sampled cases — this finds
  /// one real root (every cubic has one), polishes it, deflates to a quadratic
  /// and solves that. The quadratic's discriminant is far better conditioned,
  /// so repeated roots survive.
  static List<double> solveCubicReal(double a, double b, double c, double d) {
    if (a == 0) {
      throw CalcException(CalcError.notCubic);
    }
    final double bn = b / a, cn = c / a, dn = d / a;

    // A repeated root is also a root of f' = 3x² + 2·bn·x + cn, a quadratic
    // that is well conditioned even when the cubic's own discriminant is not.
    // Identifying it this way keeps double roots exact; deflating from an
    // approximate simple root instead split them into two neighbours
    // (14.99947 and 15.00053 in place of a single 15).
    final double discPrime = 4 * bn * bn - 12 * cn;
    if (discPrime >= 0) {
      final double sp = math.sqrt(discPrime);
      for (final double r in [(-2 * bn - sp) / 6, (-2 * bn + sp) / 6]) {
        if (_isCubicRoot(r, bn, cn, dn)) {
          // f = (x − r)²(x − t), and the roots sum to −bn.
          final double t = -bn - 2 * r;
          if ((r - t).abs() <= 1e-6 * math.max(1.0, r.abs())) return [r];
          return r < t ? [r, t] : [t, r];
        }
      }
    }

    final double r1 = _polishCubicRoot(_oneRealCubicRoot(bn, cn, dn), bn, cn, dn);

    // Deflate: x³ + bn·x² + cn·x + dn = (x − r1)(x² + B·x + C)
    final double bq = bn + r1;
    final double cq = cn + r1 * bq;

    final List<double> roots = [r1];
    final double disc = bq * bq - 4 * cq;
    final double discTolerance =
        1e-9 * math.max(1.0, math.max(bq * bq, (4 * cq).abs()));

    if (disc > discTolerance) {
      final double s = math.sqrt(disc);
      roots.add((-bq - s) / 2);
      roots.add((-bq + s) / 2);
    } else if (disc.abs() <= discTolerance) {
      roots.add(-bq / 2); // double root of the deflated quadratic
    }

    roots.sort();

    // Collapse values that coincide to within double precision, so a repeated
    // root is reported once no matter which one deflation happened to find.
    final List<double> distinct = [];
    for (final r in roots) {
      if (distinct.isEmpty ||
          (r - distinct.last).abs() > 1e-6 * math.max(1.0, r.abs())) {
        distinct.add(r);
      }
    }
    return distinct;
  }

  /// Whether [r] nulls x³ + bn·x² + cn·x + dn, judged against the size of the
  /// terms that had to cancel (an absolute threshold is meaningless here).
  static bool _isCubicRoot(double r, double bn, double cn, double dn) {
    final double x3 = r * r * r;
    final double x2 = bn * r * r;
    final double x1 = cn * r;
    final double value = x3 + x2 + x1 + dn;
    final double scale = math.max(
        1.0,
        math.max(x3.abs(),
            math.max(x2.abs(), math.max(x1.abs(), dn.abs()))));
    return value.abs() <= 1e-10 * scale;
  }

  /// One real root of the monic depressed cubic (Cardano, or the
  /// trigonometric form when three real roots exist).
  static double _oneRealCubicRoot(double bn, double cn, double dn) {
    final double p = cn - bn * bn / 3;
    final double q = 2 * bn * bn * bn / 27 - bn * cn / 3 + dn;
    final double shift = bn / 3;
    final double disc = q * q / 4 + p * p * p / 27;

    if (disc >= 0) {
      final double s = math.sqrt(disc);
      return _cbrt(-q / 2 + s) + _cbrt(-q / 2 - s) - shift;
    }

    final double m = 2 * math.sqrt(-p / 3);
    final double theta = math.acos(((3 * q) / (p * m)).clamp(-1.0, 1.0)) / 3;
    return m * math.cos(theta) - shift;
  }

  /// Newton refinement of a root of x³ + bn·x² + cn·x + dn.
  static double _polishCubicRoot(double x, double bn, double cn, double dn) {
    for (int i = 0; i < 12; i++) {
      final double f = ((x + bn) * x + cn) * x + dn;
      final double df = (3 * x + 2 * bn) * x + cn;
      if (df == 0 || !f.isFinite || !df.isFinite) break;
      final double step = f / df;
      x -= step;
      if (step.abs() <= 1e-15 * math.max(1.0, x.abs())) break;
    }
    return x;
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
