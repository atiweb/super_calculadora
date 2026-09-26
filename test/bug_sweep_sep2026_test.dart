import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_calculadora/models/custom_function.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/models/polynomial.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/geometry_service.dart';
import 'package:super_calculadora/services/number_theory_advanced_service.dart';
import 'package:super_calculadora/services/polynomial_service.dart';
import 'package:super_calculadora/services/prime_utils.dart';
import 'package:super_calculadora/services/special_functions_service.dart';
import 'package:super_calculadora/services/custom_function_service.dart';

/// Regressions from the September 2026 bug sweep (engine driven with ~330
/// key sequences and expressions). Each test names the wrong output it used
/// to produce.
void main() {
  setUpAll(() => TestWidgetsFlutterBinding.ensureInitialized());

  late CalculatorService calc;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    calc = CalculatorService();
  });

  String ev(String e) => calc.evaluateCompleteExpression(e);

  group('exact results past 2^53', () {
    test('123456789 × 987654321 (was 121932631112635260.0)', () {
      expect(ev('123456789×987654321'), '121932631112635269');
    });
    test('99999^4 by products (was …600000.0)', () {
      expect(ev('99999×99999×99999×99999'), '99996000059999600001');
    });
    test('10^20 ÷ 7 × 7 is exact (was …99.99999999999999999996)', () {
      expect(ev('10^20÷7×7'), '100000000000000000000');
    });
    test('1 ÷ 10^25 is not 0', () {
      expect(ev('1÷10^25'), '0.0000000000000000000000001');
    });
    test('1 ÷ 3^50 keeps significant digits (was 0)', () {
      expect(ev('1÷3^50'), startsWith('0.000000000000000000000001392'));
    });
    test('1 ÷ 123456789012 keeps 20 significant digits', () {
      expect(ev('1÷123456789012'), startsWith('0.0000000000081000000729226806'));
    });
  });

  group('big-number path: mod and exponents', () {
    test('12345678901 mod 7 (was FormatException)', () {
      expect(ev('12345678901 mod 7'), '3');
    });
    test('negative exponent (was "not supported")', () {
      expect(ev('2^20×2^-1'), '524288');
      expect(ev('12345678901×2^-1'), '6172839450.5');
    });
    test('fractional exponent falls back to doubles', () {
      final r = double.parse(ev('2^20+2^0.5'));
      expect(r, closeTo(1048577.41421356, 1e-6));
    });
  });

  group('expression parsing', () {
    test('2e is 2·e, not e² (was 7.389)', () {
      expect(double.parse(ev('2e')), closeTo(5.43656365691809, 1e-12));
      expect(double.parse(ev('e2')), closeTo(5.43656365691809, 1e-12));
    });
    test('eπ is e·π, not e^π', () {
      expect(double.parse(ev('eπ')), closeTo(8.53973422267357, 1e-12));
      expect(double.parse(ev('e π')), closeTo(8.53973422267357, 1e-12));
    });
    test('scientific notation still works', () {
      expect(ev('2e3+1'), '2001');
    });
    test('one-argument log is base 10 (was RangeError)', () {
      expect(ev('log(100)'), '2');
      expect(double.parse(ev('log(2,8)')), closeTo(3, 1e-12));
    });
    test('√16 without parentheses (was "Variable not bound")', () {
      expect(ev('√16'), '4');
      expect(ev('2√9'), '6');
    });
    test(')sqrt( is a product', () {
      expect(ev('sqrt(16)sqrt(4)'), '8');
    });
    test('asin/acos/atan accepted; degrees when in DEG', () {
      expect(double.parse(ev('asin(0.5)')), closeTo(30, 1e-9));
      expect(double.parse(ev('arccos(0.5)')), closeTo(60, 1e-9));
      expect(double.parse(ev('atan(1)')), closeTo(45, 1e-9));
    });
    test('dangling operator / empty parens are malformed, not raw errors', () {
      expect(ev('2+'), 'err:errExprMalformed');
      expect(ev('()'), 'err:errExprMalformed');
    });
  });

  group('error classification', () {
    test('tan(90) in the expression is undefined, not 1.6e16', () {
      expect(ev('tan(90)'), 'err:errTanUndefined');
      expect(ev('tan(270)'), 'err:errTanUndefined');
      expect(double.parse(ev('tan(45)')), closeTo(1, 1e-12));
    });
    test('overflow is "too large", not division by zero', () {
      expect(ev('(10^200000)×2'), 'err:errResultTooLarge');
    });
    test('parenthesized products past double range are exact', () {
      expect(ev('(10^200)×(10^200)'), '1${'0' * 400}');
      expect(ev('(123456789)×(987654321)'), '121932631112635269');
      expect(ev('-(2^60)+1'), '-1152921504606846975');
    });
    test('ln(0) is a domain error', () {
      expect(ev('ln(0)'), 'err:errLnDomain');
    });
  });

  group('small results are not flattened', () {
    test('10^-20 via the expression', () {
      expect(ev('1e-20'), isNot('0'));
    });
  });

  group('keypad state machine', () {
    void keys(String seq) {
      for (final k in seq.split(' ')) {
        switch (k) {
          case '=':
            calc.calculate();
          case 'CE':
            calc.clearEntry();
          case 'BS':
            calc.backspace();
          case '±':
            calc.toggleSign();
          case 'MOD':
            calc.modFunction();
          case 'mod':
            calc.addOperator('mod');
          case 'MS':
            calc.memoryStore();
          case 'MR':
            calc.memoryRecall();
          case 'π':
            calc.addPi();
          case '+' || '-' || '×' || '÷' || '^':
            calc.addOperator(k);
          case '(':
            calc.addOpenParenthesis();
          case ')':
            calc.addCloseParenthesis();
          default:
            for (final d in k.split('')) {
              calc.addDigit(d);
            }
        }
      }
    }

    test('a typed 0 is the MOD operand, not the stale result (was 1)', () {
      keys('5 + 5 = CE 0 MOD 3 =');
      expect(calc.display, '0');
    });
    test('backspace removes the whole word "mod"', () {
      keys('5 mod BS');
      expect(calc.display.trim(), '5');
      keys('3 =');
      expect(calc.display, '53');
    });
    test('backspace after "5 × 3 mod" keeps "5 × 3"', () {
      keys('5 × 3 mod BS');
      expect(calc.display.replaceAll(' ', ''), '5×3');
    });
    test('± after an operator does not negate the first operand', () {
      keys('5 + ±');
      expect(calc.display.replaceAll(' ', ''), '5+');
      calc.clear();
      keys('5 + 3 ±');
      expect(calc.display.replaceAll(' ', ''), '5+-3');
    });
    test('MR keeps the pending expression (5 MS 2 + MR = 7)', () {
      keys('5 MS');
      calc.clear();
      keys('2 + MR =');
      expect(calc.display, '7');
    });
    test('empty MR leaves the display alone', () {
      keys('2 + MR');
      expect(calc.display.replaceAll(' ', ''), '2+');
    });
    test('π replaces only the operand being typed', () {
      keys('2 + 3 π');
      expect(calc.display.replaceAll(' ', ''), startsWith('2+3.14159'));
    });
  });

  group('custom functions', () {
    CustomFunction def(String t) => CustomFunctionService.parseDefinition(t);

    test('2x uses the parameter as a coefficient (was "unknown name x")', () {
      final f = def('f(x) = 2x+1');
      expect(calc.validateCustomFunction(f), isNull);
      calc.debugSetCustomFunctions([f]);
      expect(calc.evaluateCompleteExpression('f(3)'), '7');
    });
    test('unary minus after an operator is valid in a body', () {
      final f = def('f(x) = x*-1');
      expect(calc.validateCustomFunction(f), isNull);
      calc.debugSetCustomFunctions([f]);
      expect(calc.evaluateCompleteExpression('f(3)'), '-3');
      expect(calc.evaluateCompleteExpression('2^-1'), '0.5');
    });
    test('"sin (x)" is rejected at save time, not at every call', () {
      expect(calc.validateCustomFunction(def('f(x) = sin (x)')),
          'cfErrBodyInvalid');
    });
    test('doubling definitions hit the size cap instead of eating memory', () {
      final fns = [
        def('h1(x) = x+x+x+x+x+x+x+x+x+x'),
        def('h2(x) = h1(h1(x))'),
        def('h3(x) = h2(h2(x))'),
        def('h4(x) = h3(h3(x))'),
      ];
      calc.debugSetCustomFunctions(fns.sublist(0, 3));
      final sw = Stopwatch()..start();
      expect(calc.validateCustomFunction(fns[3]), 'errResultTooLarge');
      expect(sw.elapsed.inSeconds, lessThan(5));
    });
    test('deleting g breaks f(x)=2g(x): the removal probe sees it', () {
      calc.debugSetCustomFunctions(
          [def('g(x) = x+1'), def('f(x) = 2g(x)')]);
      expect(calc.evaluateCompleteExpression('f(1)'), '4');
      expect(calc.customFunctionsBrokenByRemoval('g'), ['f']);
      expect(CustomFunctionService.referencesFunction('2g(x)', 'g'), isTrue);
    });
    test('a parameter named like a function does not block its removal', () {
      calc.debugSetCustomFunctions([def('g(x) = x+1'), def('f(g) = g(2)')]);
      expect(calc.customFunctionsBrokenByRemoval('g'), isEmpty);
    });
    test('custom call on a 20-digit argument stays exact', () {
      calc.debugSetCustomFunctions([def('f(x) = x+1')]);
      expect(calc.evaluateCompleteExpression('f(12345678901234567890)'),
          '12345678901234567891');
    });
    test('corrupt stored params fail at load, not inside build()', () {
      expect(
          () => CustomFunction.fromStorageString(
              '{"name":"f","params":[1],"body":"x"}'),
          throwsA(anything));
    });
  });

  group('math services', () {
    BigInt b(String v) => BigInt.parse(v);

    test('ψ12 and ψ13 (OEIS A014233) are composite', () {
      // ψ12 = 399165290221 × 798330580441 was reported prime.
      expect(isProbablyPrime(b('318665857834031151167461')), isFalse);
      expect(factorize(b('318665857834031151167461')),
          {b('399165290221'): 1, b('798330580441'): 1});
      // ψ13 fools all 13 bases; only the Lucas half of BPSW catches it.
      expect(isProbablyPrime(b('3317044064679887385961981')), isFalse);
    });
    test('Mersenne primes past the deterministic bound stay prime', () {
      for (final e in [89, 107, 127, 521]) {
        expect(isProbablyPrime((BigInt.one << e) - BigInt.one), isTrue);
      }
      expect(isProbablyPrime((BigInt.one << 67) - BigInt.one), isFalse);
    });
    test('strong Lucas pseudoprimes < 20000 match OEIS A217255', () {
      bool naive(int n) {
        for (int i = 2; i * i <= n; i++) {
          if (n % i == 0) return false;
        }
        return true;
      }
      final psp = [
        for (int n = 3; n < 20000; n += 2)
          if (!naive(n) && isStrongLucasProbablePrime(BigInt.from(n))) n,
      ];
      expect(psp, [5459, 5777, 10877, 16109, 18971]);
    });
    test('sumOfFourSquares(99999999) is instant (was minutes)', () {
      final sw = Stopwatch()..start();
      for (final n in [99999999, 9999991, 7, 0, 310]) {
        final r = NumberTheoryAdvancedService.sumOfFourSquares(BigInt.from(n));
        expect(r.a * r.a + r.b * r.b + r.c * r.c + r.d * r.d, BigInt.from(n));
      }
      expect(sw.elapsed.inSeconds, lessThan(3));
    });
    test('rational roots of x − 10^16 are instant (was 66 s)', () {
      final sw = Stopwatch()..start();
      final p = Polynomial([Fraction.fromBigInt(-BigInt.from(10).pow(16)), Fraction.one]);
      expect(PolynomialService.rationalRoots(p),
          [Fraction.fromBigInt(BigInt.from(10).pow(16))]);
      expect(sw.elapsed.inSeconds, lessThan(3));
    });
    test('quadratic small root without cancellation', () {
      final s = PolynomialService.solveQuadratic(
          Fraction.one, Fraction.fromInt(-100000000), Fraction.one);
      expect(s.realRoots.first, closeTo(1e-8, 1e-20));
    });
    test('partitions, Bell, Stirling agree with known values', () {
      expect(SpecialFunctionsService.partition(100), BigInt.from(190569292));
      expect(SpecialFunctionsService.bellNumber(10), BigInt.from(115975));
      expect(SpecialFunctionsService.stirlingFirst(10, 3), BigInt.from(1172700));
      final sw = Stopwatch()..start();
      SpecialFunctionsService.partition(10000);
      SpecialFunctionsService.bellNumber(500);
      expect(sw.elapsed.inSeconds, lessThan(4));
    });
    test('Frobenius of two large coins by Sylvester', () {
      expect(NumberTheoryAdvancedService.frobeniusNumber([1000003, 1000033]),
          BigInt.from(1000003) * BigInt.from(1000033) -
              BigInt.from(1000003) - BigInt.from(1000033));
      expect(NumberTheoryAdvancedService.frobeniusNumber([6, 9, 20]),
          BigInt.from(43));
    });
    test('primitive triples are capped', () {
      expect(() => GeometryService.primitivePythagoreanTriples(100000000),
          throwsA(anything));
    });
    test('CRT with one congruence is reduced', () {
      expect(
          SpecialFunctionsService.chineseRemainderTheorem(
              [BigInt.from(17)], [BigInt.from(5)])['solution'],
          BigInt.two);
    });
    test('Fraction.toDouble beyond double range', () {
      final big = BigInt.from(10).pow(400);
      expect(Fraction(big + BigInt.one, big).toDouble(), 1.0);
    });
  });
}
