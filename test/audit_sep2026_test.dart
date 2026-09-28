import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/models/point.dart';
import 'package:super_calculadora/screens/olympiad/olympiad_tool_screens.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/polynomial_service.dart';
import 'package:super_calculadora/services/prime_utils.dart';
import 'package:super_calculadora/services/special_functions_service.dart';

/// Regressions from the late-September 2026 audit: the six high-priority
/// findings. Each test names the wrong output or hang it used to produce.
void main() {
  setUpAll(() => TestWidgetsFlutterBinding.ensureInitialized());

  late CalculatorService calc;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    calc = CalculatorService();
  });

  void keys(String seq) {
    for (final k in seq.split(' ')) {
      switch (k) {
        case '=':
          calc.calculate();
        case '+' || '-' || '×' || '÷' || '^':
          calc.addOperator(k);
        case '⌫':
          calc.backspace();
        case '±':
          calc.toggleSign();
        default:
          for (final d in k.split('')) {
            calc.addDigit(d);
          }
      }
    }
  }

  group('a digit over a shown result starts a new number', () {
    test('2 + 3 = 7 (was 57)', () {
      keys('2 + 3 = 7');
      expect(calc.display, '7');
    });
    test('2 + 3 = 7 × 2 = (was 114)', () {
      keys('2 + 3 = 7 × 2 =');
      expect(calc.display, '14');
    });
    test('a point over a result starts 0.', () {
      keys('2 + 3 = .');
      expect(calc.display, '0.');
    });
    test('1 ÷ 3 = then 2 drops the exact carry of 1/3', () {
      keys('1 ÷ 3 = 2 × 3 =');
      expect(calc.display, '6');
    });
    test('an operator still continues from the result', () {
      keys('2 + 3 = × 2 =');
      expect(calc.display, '10');
    });
    test('editing the result with ⌫ keeps typing into it', () {
      keys('20 + 3 = ⌫ 5');
      expect(calc.display, '25');
    });
    test('± then back to the result value keeps appending', () {
      keys('2 + 3 = ± ± 1');
      expect(calc.display, '51');
    });
  });

  group('double results are rounded at every magnitude', () {
    String ev(String e) => calc.evaluateCompleteExpression(e);
    test('asin(0.5) in DEG (was 30.000000000000004)', () {
      expect(calc.isRadianMode, isFalse);
      expect(ev('asin(0.5)'), '30');
      expect(ev('acos(-0.5)'), '120');
    });
    test('10.1 + 0.2 (was 10.299999999999999)', () {
      expect(ev('10.1+0.2'), '10.3');
    });
    test('1.005 × 1000 (was 1004.9999999999999)', () {
      expect(ev('1.005*1000'), '1005');
    });
    test('100 × sin(30) (was 49.99999999999999)', () {
      expect(ev('100*sin(30)'), '50');
    });
    test('20! has no trailing .0', () {
      expect(ev('20!'), '2432902008176640000');
    });
    test('1/3/1000000 has no exponent with scientific notation off', () {
      expect(ev('1/3/1000000'), isNot(contains('e')));
    });
  });

  test('next prime works through compute (the web has no Isolate.spawn)',
      () async {
    expect(await findNextPrime(BigInt.from(10000000000)), '10000000019');
    expect(await findNextPrime(BigInt.from(13)), '17');
  });

  group('Pick lattice sweep', () {
    Point p(int x, int y) => Point.ints(x, y);
    test('huge vertices return no points instead of hanging (int overflow)',
        () {
      final r = latticePointsOf(
          [p(0, 0), p(4000000000, 0), p(0, 4000000000)]);
      expect(r.boundary, isEmpty);
      expect(r.interior, isEmpty);
    }, timeout: const Timeout(Duration(seconds: 5)));
    test('small triangle still enumerated: B = 12, I = 7 for (0,0),(4,0),(0,6)',
        () {
      final r = latticePointsOf([p(0, 0), p(4, 0), p(0, 6)]);
      // B = gcd(4,0) + gcd(4,6) + gcd(0,6) = 4 + 2 + 6; Pick: I = A − B/2 + 1.
      expect(r.boundary.length, 12);
      expect(r.interior.length, 12 - 6 + 1);
    });
  });

  group('rational roots', () {
    test('735134400x² − 735134400 is instant (was 7.5 s)', () {
      final sw = Stopwatch()..start();
      final roots =
          PolynomialService.rationalRoots(PolynomialService.parse('735134400x^2-735134400'));
      expect(roots, [Fraction.fromInt(-1), Fraction.one]);
      expect(sw.elapsedMilliseconds, lessThan(1000));
    });
    test('non-monic roots still found: 6x² − x − 2 → −1/2, 2/3', () {
      final roots =
          PolynomialService.rationalRoots(PolynomialService.parse('6x^2-x-2'));
      expect(roots, [Fraction(BigInt.from(-1), BigInt.two),
          Fraction(BigInt.two, BigInt.from(3))]);
    });
    test('the candidate list is duplicate-free and in lowest terms', () {
      final c = PolynomialService.rationalRootCandidates(
          PolynomialService.parse('4x^2-4'));
      // After dividing out 4: ±1.
      expect(c, [Fraction.fromInt(-1), Fraction.one]);
    });
  });

  group('primitive roots', () {
    test('non-cyclic modulus answers at once (was 60 s)', () {
      final sw = Stopwatch()..start();
      expect(
          SpecialFunctionsService.findPrimitiveRoot(
              BigInt.from(105) * BigInt.from(1000000007)),
          isNull);
      expect(sw.elapsedMilliseconds, lessThan(1000));
    });
    test('matches the brute-force smallest root for n ≤ 600', () {
      for (int n = 2; n <= 600; n++) {
        final BigInt bn = BigInt.from(n);
        BigInt? expected;
        for (int g = 1; g < n; g++) {
          if (SpecialFunctionsService.isPrimitiveRoot(BigInt.from(g), bn)) {
            expected = BigInt.from(g);
            break;
          }
        }
        // isPrimitiveRoot(1, 2) holds; the service returns 1 for n = 2 too.
        expect(SpecialFunctionsService.findPrimitiveRoot(bn), expected,
            reason: 'n = $n');
      }
    });
  });
}
