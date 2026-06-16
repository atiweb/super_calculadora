import '../vendor/computable_reals/computable_reals.dart';

/// Número complejo de **precisión arbitraria**, con parte real e imaginaria
/// como reales constructivos ([CReal]).
///
/// A diferencia de `Complex` (basado en `double`), la aritmética es exacta y
/// solo se redondea al formatear. Pensado para la capa de alta precisión
/// (Fase 2). Las operaciones puramente algebraicas (+, −, ×, ÷, potencia
/// entera) son exactas; las que requieren raíces/ángulos (módulo, raíces
/// n-ésimas de la unidad) usan funciones de [CReal] a la precisión pedida.
class BigComplex {
  final CReal re;
  final CReal im;

  BigComplex(this.re, this.im);

  factory BigComplex.fromInts(int re, int im) =>
      BigComplex(CReal.from(re), CReal.from(im));

  /// Parsea partes real e imaginaria desde texto (entero o decimal, con signo).
  /// Lanza [FormatException] si el texto no es un número válido.
  factory BigComplex.parse(String re, String im) =>
      BigComplex(_parseReal(re), _parseReal(im));

  static CReal _parseReal(String s) =>
      CReal.parse(s.trim().replaceAll('−', '-').replaceAll('+', ''));

  static final BigComplex zero = BigComplex(CReal.from(0), CReal.from(0));
  static final BigComplex one = BigComplex(CReal.from(1), CReal.from(0));

  BigComplex operator +(BigComplex o) => BigComplex(re + o.re, im + o.im);
  BigComplex operator -(BigComplex o) => BigComplex(re - o.re, im - o.im);

  /// (a+bi)(c+di) = (ac−bd) + (ad+bc)i.
  BigComplex operator *(BigComplex o) =>
      BigComplex(re * o.re - im * o.im, re * o.im + im * o.re);

  /// (a+bi)/(c+di) = [(ac+bd) + (bc−ad)i] / (c²+d²).
  BigComplex operator /(BigComplex o) {
    final denom = o.re * o.re + o.im * o.im;
    return BigComplex(
      (re * o.re + im * o.im) / denom,
      (im * o.re - re * o.im) / denom,
    );
  }

  BigComplex conjugate() => BigComplex(re, -im);

  /// |z|² (exacto, sin raíz).
  CReal modulusSquared() => re * re + im * im;

  /// |z| = √(re² + im²).
  CReal modulus() => modulusSquared().sqrt();

  /// Potencia entera por exponenciación binaria (exacta: solo multiplicaciones,
  /// sin trigonometría). Admite exponente negativo.
  BigComplex pow(int n) {
    if (n == 0) return one;
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

  /// Las n raíces n-ésimas de la unidad: e^(2πik/n) = cos(2πk/n) + i·sin(2πk/n).
  /// Los ángulos son exactos (no requieren atan2), así que el resultado es de
  /// alta precisión limpio.
  static List<BigComplex> rootsOfUnity(int n) {
    if (n < 1) throw ArgumentError('n must be ≥ 1');
    final twoPi = CReal.pi * CReal.from(2);
    return List.generate(n, (k) {
      final angle = twoPi * CReal.from(k) / CReal.from(n);
      return BigComplex(angle.cos(), angle.sin());
    });
  }

  /// Formatea "a + bi" a [digits] dígitos, limpiando ceros finales y eligiendo
  /// el signo a partir de la representación textual (evita decidir el signo de
  /// un real constructivo, que es semidecidible).
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

/// Worker (isolate-safe vía `compute`) para (re+im·i)^n de alta precisión.
/// Entrada: `{re, im, n, digits}`. Salida: `{ok:true, result}` o
/// `{ok:false, error}`.
Map<String, dynamic> bigComplexPowWorker(Map<String, dynamic> a) {
  try {
    final z = BigComplex.parse(a['re'] as String, a['im'] as String);
    final r = z.pow(a['n'] as int);
    return {'ok': true, 'result': r.toStringAsPrecision(a['digits'] as int)};
  } catch (e) {
    return {'ok': false, 'error': e.toString()};
  }
}

/// Worker (isolate-safe) para las n raíces n-ésimas de la unidad de alta
/// precisión. Entrada: `{n, digits}`. Salida: `{ok, result}` (una raíz por
/// línea) o `{ok:false, error}`.
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

/// atan2(im, re) exacto con CReal. El cuadrante se decide con los signos
/// `reSign`/`imSign` (derivados de la entrada en `double`), evitando decidir el
/// signo de un real constructivo (semidecidible).
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

/// Worker (isolate-safe) para las n raíces n-ésimas de un complejo arbitrario
/// z = re + im·i, en alta precisión. Cada raíz es
/// |z|^(1/n)·[cos((θ+2πk)/n) + i·sin(...)] con θ = atan2(im, re).
/// Entrada: `{re, im, n, digits}`. Salida: `{ok, result}` o `{ok:false, error}`.
Map<String, dynamic> bigComplexNthRootsWorker(Map<String, dynamic> a) {
  try {
    final n = a['n'] as int;
    final digits = a['digits'] as int;
    if (n < 1) throw ArgumentError('n must be ≥ 1');
    final reStr = a['re'] as String;
    final imStr = a['im'] as String;
    final re = BigComplex._parseReal(reStr);
    final im = BigComplex._parseReal(imStr);
    final reSign = double.parse(reStr.trim().replaceAll('−', '-'));
    final imSign = double.parse(imStr.trim().replaceAll('−', '-'));

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
