import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_calculadora/models/calc_exception.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/models/operation_entry.dart';
import 'package:super_calculadora/models/point.dart';
import 'package:super_calculadora/screens/olympiad/olympiad_tool_screens.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/geometry_service.dart';
import 'package:super_calculadora/services/number_analysis_service.dart';
import 'package:super_calculadora/services/polynomial_service.dart';
import 'package:super_calculadora/utils/app_locale.dart';
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

  group('keypad (medium priority)', () {
    test('5 + 4 √ acts on the 4 (was Error)', () async {
      keys('5 + 4');
      await calc.squareRoot();
      expect(calc.display, '5 + 2');
      calc.calculate();
      expect(calc.display, '7');
    });
    test('x² and ∛ on the trailing operand', () async {
      keys('1 + 3');
      await calc.power('2');
      expect(calc.display, '1 + 9');
      calc.clear();
      keys('2 × 27');
      await calc.cubeRoot();
      expect(calc.display, '2 × 3');
    });
    test('= over an error keeps the original message', () {
      keys('5 ÷ 0 =');
      final String first = calc.errorMessage;
      calc.calculate();
      expect(calc.errorMessage, first);
      expect(first, isNot('errGeneric'));
    });
    test('17 mod, 2 + 4 = is 17 mod 6 (was 17 mod 4 = 1)', () {
      keys('17');
      calc.modFunction();
      keys('2 + 4 =');
      expect(calc.display, '5');
    });
    test('12 LCM 18 = = LCM is 36 (a phantom 0 made it 0)', () {
      keys('12');
      calc.lcmFunction();
      keys('18 =');
      calc.calculate();
      calc.lcmFunction();
      expect(calc.display, '36');
    });
    test('CE clears the last operand only', () {
      keys('5 + 3');
      calc.clearEntry();
      expect(calc.display, '5 + ');
      keys('4 =');
      expect(calc.display, '9');
    });
    test('⌫ on a scientific-notation result clears it', () {
      calc.setDisplay('9.999999999999998e-15');
      // Mark it as a result, as calculate() would.
      calc.loadResultFromHistory(OperationEntry(
          expression: 'x', result: '9.999999999999998e-15'));
      calc.backspace();
      expect(calc.display, '0');
    });
    test('loading a history result clears a previous error', () {
      keys('5 ÷ 0 =');
      expect(calc.hasError, isTrue);
      calc.loadResultFromHistory(OperationEntry(expression: '6×7', result: '42'));
      expect(calc.hasError, isFalse);
      keys('+ 1 =');
      expect(calc.display, '43');
    });
  });

  group('evaluator (medium priority)', () {
    String ev(String e) => calc.evaluateCompleteExpression(e);
    test('exp(x) works (was a FormatException)', () {
      expect(ev('exp(0)'), '1');
      expect(ev('2exp(0)'), '2');
      expect(double.parse(ev('exp(1)')), closeTo(2.718281828459045, 1e-12));
    });
    test('implicit products allow a space', () {
      expect(ev('3 sin(30)'), '1.5');
      expect(ev('2 (3)'), '6');
      expect(ev('(3) 2'), '6');
      expect(double.parse(ev('2 π')), closeTo(6.283185307179586, 1e-12));
      expect(ev('2floor(2.5)'), '4');
    });
    test('non-integer and negative factorials are refused (0.5! gave 1)', () {
      expect(ev('0.5!'), 'err:errFactorialNonNeg');
      expect(ev('2.5!'), 'err:errFactorialNonNeg');
      expect(ev('(-3)!'), 'err:errFactorialNonNeg');
      expect(ev('3!'), '6');
      expect(ev('3.0!'), '6');
    });
    test('5/0! and 5/0^0 are 5, not a division by zero', () {
      expect(ev('5/0!'), '5');
      expect(ev('5/0^0'), '5');
      expect(ev('5/0'), 'err:errExprDivZero');
    });
    test('ℯ from the keypad is Euler\'s number, next to scientific notation',
        () {
      expect(double.parse(ev('2ℯ-1')), closeTo(2 * 2.718281828459045 - 1, 1e-12));
      expect(ev('2e-1'), '0.2');
    });
  });

  group('olympiad tools (medium priority)', () {
    test('fused numbers are refused: 2*3x was 23x, x^2*3 was x^23', () {
      for (final s in ['2*3x', '2 3x', 'x^2*3']) {
        expect(() => PolynomialService.parse(s),
            throwsA(isA<CalcException>()
                .having((e) => e.code, 'code', CalcError.invalidTerm)),
            reason: s);
      }
      expect(PolynomialService.parse('3/2 x - 1').toString(),
          PolynomialService.parse('3/2x-1').toString());
      expect(PolynomialService.parse('2 * x').toString(),
          PolynomialService.parse('2x').toString());
    });
    Point p(int x, int y) => Point.ints(x, y);
    test('bow tie and flat polygons are refused (bow tie gave I = −3)', () {
      Matcher notSimple = throwsA(isA<CalcException>()
          .having((e) => e.code, 'code', CalcError.polygonNotSimple));
      expect(() => GeometryService.pickAnalysis(
          [p(0, 0), p(2, 0), p(0, 2), p(2, 2)]), notSimple);
      expect(() => GeometryService.pickAnalysis(
          [p(0, 0), p(1, 0), p(2, 0)]), notSimple);
      expect(() => GeometryService.shoelaceArea(
          [p(0, 0), p(2, 0), p(1, 0), p(1, 1)]), notSimple);
    });
    test('simple polygons still work, convex and concave', () {
      expect(GeometryService.pickAnalysis([p(0, 0), p(4, 0), p(0, 6)]).interior,
          BigInt.from(7));
      // An L shape (concave), area 3.
      expect(
          GeometryService.shoelaceArea(
              [p(0, 0), p(2, 0), p(2, 1), p(1, 1), p(1, 2), p(0, 2)]),
          Fraction.fromInt(3));
    });
  });

  group('platform and performance (medium priority)', () {
    tearDown(() => appLanguage = 'en');
    test('no localized "not prime" value for a composite, in any language',
        () {
      for (final lang in ['es', 'en', 'pt', 'fr', 'it', 'ru', 'vi', 'id']) {
        appLanguage = lang;
        final a = NumberAnalysisService.completeAnalysis(
            BigInt.from(10).pow(16));
        expect(a['nextPrime'], isNull, reason: lang);
        expect(a['previousPrime'], isNull, reason: lang);
      }
    });
    test('previous prime of a large number comes from the isolate', () async {
      expect(await NumberAnalysisService.previousPrimeAsync(
          BigInt.from(10000000000)), BigInt.from(9999999967));
    });
    test('F(n), Cat(n), D(n), n!! refuse n past their bound', () async {
      Future<void> over(String n, Future<void> Function() op) async {
        calc.clear();
        keys(n);
        await op();
        expect(calc.errorMessage, 'errResultTooLarge', reason: n);
      }
      await over('100001', calc.fibonacciN);
      await over('10001', calc.catalanNumber);
      await over('10001', calc.derangementFunction);
      await over('20001', calc.doubleFactorialFunction);
      calc.clear();
      keys('10');
      await calc.fibonacciN();
      expect(calc.display, '55');
    });
    test('Legendre symbol needs a prime (2/9 gave 0)', () {
      expect(() => SpecialFunctionsService.legendreSymbol(BigInt.two, BigInt.from(9)),
          throwsArgumentError);
      expect(SpecialFunctionsService.legendreSymbol(BigInt.two, BigInt.from(7)), 1);
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
