import '../models/calc_exception.dart';
import '../models/step_result.dart';

/// Versiones "con procedimiento" de algoritmos clásicos, para uso didáctico.
///
/// El parámetro [spanish] elige el idioma de la prosa; las líneas matemáticas
/// (ecuaciones) son neutrales al idioma.
class StepsService {
  static final BigInt _zero = BigInt.zero;
  static final BigInt _one = BigInt.one;

  static String _t(bool es, String spanish, String english) =>
      es ? spanish : english;

  /// Algoritmo de Euclides con pasos, incluyendo la identidad de Bézout
  /// g = x·a + y·b. El resultado es el mcd.
  static StepResult euclidSteps(BigInt a, BigInt b, {bool spanish = false}) {
    final BigInt origA = a, origB = b;
    final List<String> steps = [];

    BigInt x = a.abs();
    BigInt y = b.abs();
    if (y == _zero) {
      steps.add(_t(spanish, 'mcd($origA, $origB) = $x (el segundo término es 0)',
          'gcd($origA, $origB) = $x (second term is 0)'));
      return StepResult(x.toString(), steps);
    }

    steps.add(_t(spanish, 'Algoritmo de Euclides para mcd($x, $y):',
        'Euclidean algorithm for gcd($x, $y):'));
    while (y != _zero) {
      final BigInt q = x ~/ y;
      final BigInt r = x - q * y;
      steps.add('$x = $q · $y + $r');
      x = y;
      y = r;
    }
    final BigInt g = x;
    steps.add(_t(spanish, 'Último resto no nulo ⇒ mcd = $g',
        'Last nonzero remainder ⇒ gcd = $g'));

    // Bézout por Euclides extendido.
    final ext = _extendedGcd(origA.abs(), origB.abs());
    BigInt bx = ext[1], by = ext[2];
    if (origA.isNegative) bx = -bx;
    if (origB.isNegative) by = -by;
    steps.add(_t(spanish, 'Identidad de Bézout: $g = ($bx)·$origA + ($by)·$origB',
        'Bézout identity: $g = ($bx)·$origA + ($by)·$origB'));

    return StepResult(g.toString(), steps);
  }

  /// Factorización en primos con los pasos de división sucesiva.
  static StepResult factorizationSteps(BigInt n, {bool spanish = false}) {
    final List<String> steps = [];
    if (n < BigInt.from(2)) {
      steps.add(_t(spanish, '$n no tiene factorización en primos (n < 2)',
          '$n has no prime factorization (n < 2)'));
      return StepResult(n.toString(), steps);
    }

    steps.add(_t(spanish, 'Factorización de $n por divisiones sucesivas:',
        'Factorization of $n by successive division:'));
    BigInt remaining = n;
    final Map<BigInt, int> factors = {};

    BigInt d = BigInt.from(2);
    while (d * d <= remaining) {
      while (remaining % d == _zero) {
        steps.add('$remaining ÷ $d = ${remaining ~/ d}');
        remaining ~/= d;
        factors[d] = (factors[d] ?? 0) + 1;
      }
      d += _one;
    }
    if (remaining > _one) {
      if (factors.isNotEmpty || remaining != n) {
        steps.add(_t(spanish, '$remaining es primo', '$remaining is prime'));
      }
      factors[remaining] = (factors[remaining] ?? 0) + 1;
    }

    final String factorStr = factors.entries
        .map((e) => e.value == 1 ? '${e.key}' : '${e.key}^${e.value}')
        .join(' × ');
    steps.add('$n = $factorStr');
    return StepResult(factorStr, steps);
  }

  /// Teorema Chino del Resto con pasos, combinando las congruencias de a pares.
  /// Devuelve la solución como "x ≡ r (mod m)" o indica incompatibilidad.
  static StepResult crtSteps(List<BigInt> remainders, List<BigInt> moduli,
      {bool spanish = false}) {
    if (remainders.length != moduli.length || remainders.isEmpty) {
      throw CalcException(CalcError.listsSameSize);
    }
    final List<String> steps = [];
    steps.add(_t(spanish, 'Sistema de congruencias:', 'System of congruences:'));
    for (int i = 0; i < remainders.length; i++) {
      steps.add('  x ≡ ${remainders[i]} (mod ${moduli[i]})');
    }

    BigInt curR = remainders[0] % moduli[0];
    if (curR.isNegative) curR += moduli[0];
    BigInt curM = moduli[0];

    for (int i = 1; i < remainders.length; i++) {
      final BigInt a2 = remainders[i];
      final BigInt m2 = moduli[i];
      final BigInt g = _gcd(curM, m2);

      if ((a2 - curR) % g != _zero) {
        steps.add(_t(
            spanish,
            'Combinar con x ≡ $a2 (mod $m2): mcd($curM, $m2) = $g no divide '
                'a ${a2 - curR} ⇒ sistema incompatible',
            'Combine with x ≡ $a2 (mod $m2): gcd($curM, $m2) = $g does not '
                'divide ${a2 - curR} ⇒ incompatible system'));
        return StepResult(_t(spanish, 'sin solución', 'no solution'), steps);
      }

      final BigInt lcm = curM ~/ g * m2;
      final ext = _extendedGcd(curM, m2);
      final BigInt diff = a2 - curR;
      BigInt t = (diff ~/ g) * ext[1] % (m2 ~/ g);
      BigInt newR = curR + curM * t;
      newR %= lcm;
      if (newR.isNegative) newR += lcm;

      steps.add(_t(spanish, 'Combinar con x ≡ $a2 (mod $m2) ⇒ x ≡ $newR (mod $lcm)',
          'Combine with x ≡ $a2 (mod $m2) ⇒ x ≡ $newR (mod $lcm)'));
      curR = newR;
      curM = lcm;
    }

    final String result = 'x ≡ $curR (mod $curM)';
    steps.add(_t(spanish, 'Solución: $result', 'Solution: $result'));
    return StepResult(result, steps);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static BigInt _gcd(BigInt a, BigInt b) {
    a = a.abs();
    b = b.abs();
    while (b != _zero) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  /// Euclides extendido: devuelve [g, x, y] con a·x + b·y = g.
  static List<BigInt> _extendedGcd(BigInt a, BigInt b) {
    if (b == _zero) return [a, _one, _zero];
    final r = _extendedGcd(b, a % b);
    return [r[0], r[2], r[1] - (a ~/ b) * r[2]];
  }
}
