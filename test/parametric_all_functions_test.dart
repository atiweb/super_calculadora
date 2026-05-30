import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

// Helpers for expected math on small integers (fast, independent of app services)
BigInt _gcd(BigInt a, BigInt b) {
  a = a.abs();
  b = b.abs();
  while (b != BigInt.zero) {
    final t = b;
    b = a % b;
    a = t;
  }
  return a;
}

BigInt _lcm(BigInt a, BigInt b) {
  if (a == BigInt.zero || b == BigInt.zero) return BigInt.zero;
  return (a ~/ _gcd(a, b)) * b;
}

// _digits ya no se usa (las medias usan sistema N-param)

List<int> _sievePrimes(int n) {
  final sieve = List<bool>.filled(n + 1, true);
  sieve[0] = false; if (n >= 1) sieve[1] = false;
  for (int p = 2; p * p <= n; p++) {
    if (sieve[p]) {
      for (int k = p * p; k <= n; k += p) {
        sieve[k] = false;
      }
    }
  }
  return [for (int i = 2; i <= n; i++) if (sieve[i]) i];
}

Map<int, int> _primeFactorization(int n, List<int> primes) {
  final map = <int, int>{};
  int x = n.abs();
  for (final p in primes) {
    if (p * p > x) break;
    while (x % p == 0) {
      map[p] = (map[p] ?? 0) + 1;
      x ~/= p;
    }
  }
  if (x > 1) map[x] = (map[x] ?? 0) + 1;
  return map;
}

BigInt _phi(int n, List<int> primes) {
  if (n == 0) return BigInt.zero;
  BigInt result = BigInt.from(n);
  final factors = _primeFactorization(n, primes);
  for (var p in factors.keys) {
    result = (result ~/ BigInt.from(p)) * BigInt.from(p - 1);
  }
  return result;
}

BigInt _primorial(int n, List<int> primes) {
  BigInt res = BigInt.one;
  for (final p in primes) {
    if (p > n) break;
    res *= BigInt.from(p);
  }
  return res;
}

int _tau(int n, List<int> primes) {
  if (n == 0) return 0;
  final f = _primeFactorization(n, primes);
  int res = 1;
  f.forEach((_, e) => res *= (e + 1));
  return res;
}

BigInt _sigma(int n, List<int> primes) {
  if (n == 0) return BigInt.zero;
  final f = _primeFactorization(n, primes);
  BigInt res = BigInt.one;
  f.forEach((p, e) {
    // (p^(e+1) - 1) / (p - 1)
    BigInt pe1 = BigInt.one;
    for (int i = 0; i < e + 1; i++) {
      pe1 *= BigInt.from(p);
    }
    final num = pe1 - BigInt.one;
    final den = BigInt.from(p - 1);
    res *= (num ~/ den);
  });
  return res;
}

int _moebius(int n, List<int> primes) {
  if (n == 1) return 1;
  final f = _primeFactorization(n, primes);
  // If any exponent > 1 then 0
  if (f.values.any((e) => e > 1)) return 0;
  // Otherwise (-1)^(number of prime factors)
  return (f.length % 2 == 0) ? 1 : -1;
}

int _v2(int n) {
  int c = 0, x = n.abs();
  while (x % 2 == 0 && x > 0) { c++; x ~/= 2; }
  return c;
}

BigInt _radical(int n, List<int> primes) {
  if (n == 0) return BigInt.zero;
  final f = _primeFactorization(n, primes);
  BigInt res = BigInt.one;
  for (final p in f.keys) {
    res *= BigInt.from(p);
  }
  return res;
}

BigInt _factorialBig(int n) {
  BigInt r = BigInt.one;
  for (int i = 2; i <= n; i++) {
    r *= BigInt.from(i);
  }
  return r;
}

double _relErr(num a, num b) {
  final aa = a.abs();
  final bb = b.abs();
  if (aa == 0 && bb == 0) return 0.0;
  return ((a - b).abs()) / math.max(aa.toDouble(), bb.toDouble());
}

void _setN(CalculatorService svc, int n) {
  svc.setDisplay(n.toString());
}

void main() {
  // Sampled coverage across 1..100 to keep runtime acceptable
  final sampleNs = [
    for (int i = 1; i <= 20; i++) i,
    25, 30, 40, 50, 60, 75, 90, 100,
  ];
  final primesUpTo100 = _sievePrimes(100);

  group('Parametric coverage for standard operations (sampled 1..100)', () {
    test('power 2 and 3', () async {
      final svc = CalculatorService();
      for (final n in sampleNs) {
        _setN(svc, n);
        await svc.power('2');
        expect(svc.display, BigInt.from(n) * BigInt.from(n) == BigInt.from(n * n) ? (n * n).toString() : (n * n).toString());
        _setN(svc, n);
        await svc.power('3');
        expect(svc.display, (BigInt.from(n) * BigInt.from(n) * BigInt.from(n)).toString());
      }
    });

    test('sqrt and cbrt', () async {
      final svc = CalculatorService();
      for (final n in sampleNs) {
        _setN(svc, n);
        await svc.squareRoot();
        final s = double.parse(svc.display);
        final expectS = math.sqrt(n);
        if ((math.sqrt(n)).roundToDouble() == math.sqrt(n)) {
          // perfect square → exact integer
          expect(s % 1 == 0, true);
        }
        expect(_relErr(s, expectS) < 1e-12, true, reason: 'sqrt($n)');

        _setN(svc, n);
        await svc.cubeRoot();
        final c = double.parse(svc.display);
        final expectC = math.pow(n, 1 / 3).toDouble();
        expect(_relErr(c, expectC) < 1e-9, true, reason: 'cbrt($n)');
      }
    });

    test('percentage and reciprocal', () async {
      final svc = CalculatorService();
      for (final n in sampleNs) {
        _setN(svc, n);
        await svc.percentage();
        expect(_relErr(double.parse(svc.display), n / 100.0) < 1e-12, true);

        _setN(svc, n);
        await svc.reciprocal();
        expect(_relErr(double.parse(svc.display), 1.0 / n) < 1e-12, true);
      }
    });

    test('factorial small n (1..12)', () async {
      final svc = CalculatorService();
      for (int n = 1; n <= 12; n++) {
        _setN(svc, n);
        await svc.factorial();
        expect(svc.display, _factorialBig(n).toString());
      }
    });
  });

  group('Parametric coverage for scientific functions (targeted inputs)', () {
    test('sin/cos/tan in degrees (safe angles)', () async {
      final svc = CalculatorService();
      for (final deg in <int>[0, 30, 45, 60]) {
        _setN(svc, deg);
        await svc.sin();
        expect(_relErr(double.parse(svc.display), math.sin(deg * math.pi / 180)) < 1e-12, true, reason: 'sin($deg)');

        _setN(svc, deg);
        await svc.cos();
        expect(_relErr(double.parse(svc.display), math.cos(deg * math.pi / 180)) < 1e-12, true, reason: 'cos($deg)');

        _setN(svc, deg);
        await svc.tan();
        final expected = math.tan(deg * math.pi / 180);
        expect(_relErr(double.parse(svc.display), expected) < 1e-9, true, reason: 'tan($deg)');
      }
    });

    test('asin/acos domain [-1,1] and atan basic', () async {
      final svc = CalculatorService();
      for (final v in <double>[-1, -0.5, 0, 0.5, 1]) {
        svc.setDisplay(v.toString());
        await svc.asin();
        final asinExpected = (180 / math.pi) * math.asin(v);
        expect(_relErr(double.parse(svc.display), asinExpected) < 1e-12, true, reason: 'asin($v)');

        svc.setDisplay(v.toString());
        await svc.acos();
        final acosExpected = (180 / math.pi) * math.acos(v);
        expect(_relErr(double.parse(svc.display), acosExpected) < 1e-12, true, reason: 'acos($v)');
      }

      for (final v in <double>[-1, 0, 1, 10]) {
        svc.setDisplay(v.toString());
        await svc.atan();
        final atanExpected = (180 / math.pi) * math.atan(v);
        expect(_relErr(double.parse(svc.display), atanExpected) < 1e-12, true, reason: 'atan($v)');
      }
    });

    test('ln / log / exp / 10^x', () async {
      final svc = CalculatorService();
      for (final v in <double>[1, 2, 10, 100]) {
        svc.setDisplay(v.toString());
        await svc.ln();
        expect(_relErr(double.parse(svc.display), math.log(v)) < 1e-12, true, reason: 'ln($v)');

        svc.setDisplay(v.toString());
        await svc.log();
        expect(_relErr(double.parse(svc.display), math.log(v) / math.ln10) < 1e-12, true, reason: 'log($v)');
      }

      for (final v in <double>[0, 1, 2, 3]) {
        svc.setDisplay(v.toString());
        await svc.exp();
        expect(_relErr(double.parse(svc.display), math.exp(v)) < 1e-12, true, reason: 'exp($v)');

        svc.setDisplay(v.toString());
        await svc.pow10();
        expect(_relErr(double.parse(svc.display), math.pow(10, v).toDouble()) < 1e-12, true, reason: '10^$v');
      }
    });

    test('constants π and e set correctly', () async {
      final svc = CalculatorService();
      svc.addPi();
      expect(svc.display.startsWith('3.14159'), true);
      svc.addE();
      expect(svc.display.startsWith('2.71828'), true);
    });
  });

  group('Parametric coverage for special functions (sampled 1..100)', () {
    test('phi, primorial, tau, sigma', () async {
      final svc = CalculatorService();
      for (final n in sampleNs) {
        _setN(svc, n);
        await svc.eulerPhi();
        expect(svc.display, _phi(n, primesUpTo100).toString(), reason: 'phi($n)');

        _setN(svc, n);
        await svc.primorial();
        expect(svc.display, _primorial(n, primesUpTo100).toString(), reason: 'primorial($n)');

        _setN(svc, n);
        await svc.divisorCount();
        expect(svc.display, _tau(n, primesUpTo100).toString(), reason: 'tau($n)');

        _setN(svc, n);
        await svc.divisorSum();
        expect(svc.display, _sigma(n, primesUpTo100).toString(), reason: 'sigma($n)');
      }
    });

    test('gcd(n,n-1)=1 and lcm(n,n+1)=n*(n+1)', () async {
      final svc = CalculatorService();
      for (final n in sampleNs) {
        // gcdFunction usa sistema pendiente variable: presionar función otra vez ejecuta
        _setN(svc, n);
        svc.gcdFunction(); // captura n, display='0'
        svc.addDigit('${n - 1}');
        svc.gcdFunction(); // agrega param y ejecuta
        expect(svc.display, '1', reason: 'gcd($n, ${n-1})');

        _setN(svc, n);
        svc.lcmFunction(); // captura n, display='0'
        svc.addDigit('${n + 1}');
        svc.lcmFunction(); // agrega param y ejecuta
        final expected = _lcm(BigInt.from(n), BigInt.from(n + 1)).toString();
        expect(svc.display, expected, reason: 'lcm($n, ${n+1})');
      }
    });

    test('floor/ceil on integer, Möbius, mod 10, v2(n)', () async {
      final svc = CalculatorService();
      for (final n in sampleNs) {
        _setN(svc, n);
        await svc.floorCeil();
        expect(svc.display, n.toString());

        _setN(svc, n);
        await svc.moebiusMu();
        expect(svc.display, _moebius(n, primesUpTo100).toString(), reason: 'mu($n)');

        // modFunction ahora usa 2 parámetros con sistema pendiente
        _setN(svc, n);
        svc.modFunction(); // inicia operación pendiente
        svc.addDigit('1');
        svc.addDigit('0');
        svc.calculate(); // ejecuta mod 10
        expect(svc.display, (n % 10).toString(), reason: 'mod10($n)');

        // pAdicValuation ahora usa 2 parámetros con sistema pendiente
        _setN(svc, n);
        svc.pAdicValuation(); // inicia operación pendiente
        svc.addDigit('2');
        svc.calculate(); // ejecuta V₂
        expect(svc.display, _v2(n).toString(), reason: 'v2($n)');
      }
    });

    test('combinations C(n,2) and variations V(n,2)', () async {
      final svc = CalculatorService();
      for (final n in sampleNs) {
        // combinations ahora usa 2 parámetros
        _setN(svc, n);
        svc.combinations();
        svc.addDigit('2');
        svc.calculate();
        final c = (BigInt.from(n) * BigInt.from(n - 1)) ~/ BigInt.two;
        expect(svc.display, c.toString(), reason: 'C($n,2)');

        // variations ahora usa 2 parámetros
        _setN(svc, n);
        svc.variations();
        svc.addDigit('2');
        svc.calculate();
        final v = BigInt.from(n) * BigInt.from(n - 1);
        expect(svc.display, v.toString(), reason: 'V($n,2)');
      }
    });

    test('means over digits; min/max; radical; modular inverse mod 97', () async {
      final svc = CalculatorService();
      for (final n in sampleNs) {
        // Media aritmética N-param: MedA(n, n+1) = (n + n+1) / 2
        final meanAExpected = (n + (n + 1)) / 2.0;
        _setN(svc, n);
        svc.arithmeticMeanN(); // inicia pendiente con n
        svc.addDigit('${n + 1}');
        svc.arithmeticMeanN(); // ejecuta
        expect(_relErr(double.parse(svc.display), meanAExpected) < 1e-12, true, reason: 'meanA($n, ${n+1})');

        // Min/Max N-param: min(n, n+1) = n, max(n, n+1) = n+1
        _setN(svc, n);
        svc.minimumN();
        svc.addDigit('${n + 1}');
        svc.minimumN();
        expect(svc.display, n.toString(), reason: 'min($n, ${n+1})');

        _setN(svc, n);
        svc.maximumN();
        svc.addDigit('${n + 1}');
        svc.maximumN();
        expect(svc.display, (n + 1).toString(), reason: 'max($n, ${n+1})');

        _setN(svc, n);
        await svc.radical();
        expect(svc.display, _radical(n, primesUpTo100).toString(), reason: 'rad($n)');

        // modularInverse ahora usa 2 parámetros
        _setN(svc, n);
        svc.modularInverse();
        svc.addDigit('9');
        svc.addDigit('7');
        svc.calculate();
        if (n % 97 == 0) {
          expect(svc.hasError, true, reason: 'no inverse when n % 97 == 0');
        } else {
          final inv = int.parse(svc.display);
          expect(((inv * n) % 97) == 1, true, reason: 'inverse mod 97');
        }
      }
    });
  });

  group('Memory functions basic behavior', () {
    test('MC/MR/M+/M-', () {
      final svc = CalculatorService();
      svc.memoryClear();
      expect(svc.hasMemoryValue, false);

      svc.setDisplay('5');
      svc.memoryStore();
      expect(svc.hasMemoryValue, true);

      svc.setDisplay('2');
      svc.memoryPlus(); // M = 5 + 2 = 7
      svc.memoryRecall();
      expect(svc.display, '7');

      svc.setDisplay('3');
      svc.memoryMinus(); // M = 7 - 3 = 4
      svc.memoryRecall();
      expect(svc.display, '4');

      svc.memoryClear();
      expect(svc.hasMemoryValue, false);
    });
  });
}
