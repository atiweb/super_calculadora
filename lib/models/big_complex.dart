import '../vendor/computable_reals/computable_reals.dart';
import 'calc_exception.dart';

/// **Arbitrary-precision** complex number, with real and imaginary parts
/// as constructive reals ([CReal]).
///
/// Unlike `Complex` (based on `double`), the arithmetic is exact and
/// only rounds when formatting. Intended for the high-precision layer
/// (Phase 2). Purely algebraic operations (+, −, ×, ÷, integer
/// power) are exact; those requiring roots/angles (modulus, nth
/// roots of unity) use [CReal] functions at the requested precision.
class BigComplex {
  final CReal re;
  final CReal im;

  /// `true` only when both parts were built from zero literals
  /// (text or integers). Deciding whether an arbitrary CReal is zero is
  /// semi-decidable (inverting it iterates increasing precisions until a
  /// late 'precision overflow'), so this flag at least allows
  /// failing fast in the detectable cases.
  final bool knownZero;

  BigComplex(this.re, this.im) : knownZero = false;

  BigComplex._(this.re, this.im, this.knownZero);

  factory BigComplex.fromInts(int re, int im) =>
      BigComplex._(CReal.from(re), CReal.from(im), re == 0 && im == 0);

  /// Parses real and imaginary parts from text (integer or decimal, signed).
  /// Throws [FormatException] if the text is not a valid number.
  factory BigComplex.parse(String re, String im) => BigComplex._(
        _parseReal(re),
        _parseReal(im),
        _decimalSign(re) == 0 && _decimalSign(im) == 0,
      );

  static CReal _parseReal(String s) =>
      CReal.parse(s.trim().replaceAll('−', '-').replaceAll('+', ''));

  static final BigComplex zero =
      BigComplex._(CReal.from(0), CReal.from(0), true);
  static final BigComplex one = BigComplex(CReal.from(1), CReal.from(0));

  BigComplex operator +(BigComplex o) => BigComplex(re + o.re, im + o.im);
  BigComplex operator -(BigComplex o) => BigComplex(re - o.re, im - o.im);

  /// (a+bi)(c+di) = (ac−bd) + (ad+bc)i.
  BigComplex operator *(BigComplex o) =>
      BigComplex(re * o.re - im * o.im, re * o.im + im * o.re);

  /// (a+bi)/(c+di) = [(ac+bd) + (bc−ad)i] / (c²+d²).
  BigComplex operator /(BigComplex o) {
    if (o.knownZero) throw CalcException(CalcError.divisionByZero);
    final denom = o.re * o.re + o.im * o.im;
    return BigComplex(
      (re * o.re + im * o.im) / denom,
      (im * o.re - re * o.im) / denom,
    );
  }

  BigComplex conjugate() => BigComplex(re, -im);

  /// |z|² (exact, no root).
  CReal modulusSquared() => re * re + im * im;

  /// |z| = √(re² + im²).
  CReal modulus() => modulusSquared().sqrt();

  /// Integer power via binary exponentiation (exact: only multiplications,
  /// no trigonometry). Supports negative exponent.
  BigComplex pow(int n) {
    if (n == 0) return one;
    // 0^negative is 1/0: without the flag, inverting the zero CReal does not
    // fail fast (see [knownZero]).
    if (n < 0 && knownZero) throw CalcException(CalcError.divisionByZero);
    if (n < 0) return one / pow(-n);
    BigComplex result = one;
    BigComplex base = this;
    int e = n;
    while (e > 0) {
      if (e & 1 == 1) result = result * base;
      base = base * base;
      e >>= 1;
    }
    return result;
  }

  /// The n nth roots of unity: e^(2πik/n) = cos(2πk/n) + i·sin(2πk/n).
  /// The angles are exact (no atan2 needed), so the result is clean
  /// high precision.
  static List<BigComplex> rootsOfUnity(int n) {
    if (n < 1) throw ArgumentError('n must be ≥ 1');
    final twoPi = CReal.pi * CReal.from(2);
    return List.generate(n, (k) {
      final angle = twoPi * CReal.from(k) / CReal.from(n);
      return BigComplex(angle.cos(), angle.sin());
    });
  }

  /// Formats "a + bi" to [digits] digits, cleaning trailing zeros and choosing
  /// the sign from the textual representation (avoids deciding the sign of
  /// a constructive real, which is semi-decidable).
  String toStringAsPrecision(int digits) {
    String fmt(CReal x) {
      var s = x.toStringAsPrecision(digits);
      return s == '-0' ? '0' : s;
    }

    final sre = fmt(re);
    final sim = fmt(im);

    if (sim == '0') return sre;
    final bool neg = sim.startsWith('-');
    final mag = neg ? sim.substring(1) : sim;
    final imPart = mag == '1' ? 'i' : '${mag}i';
    if (sre == '0') return neg ? '-$imPart' : imPart;
    return neg ? '$sre - $imPart' : '$sre + $imPart';
  }

  @override
  String toString() => toStringAsPrecision(15);
}

/// Sign (-1, 0, 1) of a decimal literal from its digits. Does not use
/// `double.parse`, which underflows to 0.0 below ~1e-308 whereas
/// inputs here may exceed double precision.
double _decimalSign(String s) {
  var t = s.trim().replaceAll('−', '-');
  final bool neg = t.startsWith('-');
  if (neg || t.startsWith('+')) t = t.substring(1);
  final bool nonZero =
      t.codeUnits.any((c) => c >= 0x31 && c <= 0x39); // digits 1-9
  if (!nonZero) return 0;
  return neg ? -1 : 1;
}

/// Worker (isolate-safe via `compute`) for high-precision (re+im·i)^n.
/// Input: `{re, im, n, digits}`. Output: `{ok:true, result}` or
/// `{ok:false, error}`. A division by zero (0^negative) is thrown as
/// [CalcException] so the caller can localize it.
Map<String, dynamic> bigComplexPowWorker(Map<String, dynamic> a) {
  try {
    final z = BigComplex.parse(a['re'] as String, a['im'] as String);
    // 0^negative throws CalcException from pow (see BigComplex.knownZero)
    final r = z.pow(a['n'] as int);
    return {'ok': true, 'result': r.toStringAsPrecision(a['digits'] as int)};
  } on CalcException {
    rethrow; // sendable: crosses the isolate and the caller translates it
  } catch (e) {
    return {'ok': false, 'error': e.toString()};
  }
}

/// Worker (isolate-safe) for the n high-precision nth roots of
/// unity. Input: `{n, digits}`. Output: `{ok, result}` (one root per
/// line) or `{ok:false, error}`.
Map<String, dynamic> bigComplexRootsOfUnityWorker(Map<String, dynamic> a) {
  try {
    final digits = a['digits'] as int;
    final roots = BigComplex.rootsOfUnity(a['n'] as int);
    return {
      'ok': true,
      'result': roots.map((z) => z.toStringAsPrecision(digits)).join('\n'),
    };
  } catch (e) {
    return {'ok': false, 'error': e.toString()};
  }
}

/// Exact atan2(im, re) with CReal. The quadrant is decided using the signs
/// `reSign`/`imSign` (derived from the input as `double`), avoiding deciding
/// the sign of a constructive real (semi-decidable).
CReal _atan2(CReal im, CReal re, double reSign, double imSign) {
  final halfPi = CReal.pi / CReal.from(2);
  if (reSign > 0) return (im / re).atan();
  if (reSign < 0) {
    final base = (im / re).atan();
    return imSign >= 0 ? base + CReal.pi : base - CReal.pi;
  }
  if (imSign > 0) return halfPi;
  if (imSign < 0) return -halfPi;
  return CReal.from(0);
}

/// Worker (isolate-safe) for the n nth roots of an arbitrary complex
/// z = re + im·i, in high precision. Each root is
/// |z|^(1/n)·[cos((θ+2πk)/n) + i·sin(...)] with θ = atan2(im, re).
/// Input: `{re, im, n, digits}`. Output: `{ok, result}` or `{ok:false, error}`.
Map<String, dynamic> bigComplexNthRootsWorker(Map<String, dynamic> a) {
  try {
    final n = a['n'] as int;
    final digits = a['digits'] as int;
    if (n < 1) throw ArgumentError('n must be ≥ 1');
    final reStr = a['re'] as String;
    final imStr = a['im'] as String;
    final re = BigComplex._parseReal(reStr);
    final im = BigComplex._parseReal(imStr);
    final reSign = _decimalSign(reStr);
    final imSign = _decimalSign(imStr);

    if (reSign == 0 && imSign == 0) {
      return {'ok': true, 'result': List.filled(n, '0').join('\n')};
    }

    final r = (re * re + im * im).sqrt(); // |z|
    final rn = (r.ln() / CReal.from(n)).exp(); // |z|^(1/n)
    final theta = _atan2(im, re, reSign, imSign);
    final twoPi = CReal.pi * CReal.from(2);

    final roots = <String>[];
    for (int k = 0; k < n; k++) {
      final angle = (theta + twoPi * CReal.from(k)) / CReal.from(n);
      final root = BigComplex(rn * angle.cos(), rn * angle.sin());
      roots.add(root.toStringAsPrecision(digits));
    }
    return {'ok': true, 'result': roots.join('\n')};
  } catch (e) {
    return {'ok': false, 'error': e.toString()};
  }
}
