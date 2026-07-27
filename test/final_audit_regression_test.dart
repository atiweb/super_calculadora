import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_calculadora/models/calc_exception.dart';
import 'package:super_calculadora/models/complex.dart';
import 'package:super_calculadora/services/big_decimal.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/number_analysis_service.dart';
import 'package:super_calculadora/services/number_theory_advanced_service.dart';
import 'package:super_calculadora/services/polynomial_service.dart';
import 'package:super_calculadora/services/settings_service.dart';
import 'package:super_calculadora/services/special_functions_service.dart';

/// Regressions for the last group of audit findings: latent API defects and
/// silently wrong results that no earlier package covered.
void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await SettingsService.init();
  });

  void type(CalculatorService c, String digits) {
    for (final d in digits.split('')) {
      c.addDigit(d);
    }
  }

  group('Scientific notation inside a typed expression', () {
    test('1.0e+15 + 5 is not read as Euler\'s e', () {
      final c = CalculatorService();
      // The parser treats a bare 'e' as Euler's number, so this evaluated to
      // 22.718… and that wrong value was stored in history.
      final String result = c.evaluateCompleteExpression('1.0e+15 + 5');
      expect(result.startsWith('err:'), isFalse);
      expect(double.parse(result), closeTo(1000000000000005.0, 1.0));
    });

    test('a negative exponent keeps its sign', () {
      final c = CalculatorService();
      final String result = c.evaluateCompleteExpression('1.5e-7*2');
      expect(result.startsWith('err:'), isFalse);
      expect(double.parse(result), closeTo(3e-7, 1e-15));
    });
  });

  group('Unary minus binds the same way in both evaluators', () {
    test('-2^2 is -4 for a small operand', () {
      final c = CalculatorService();
      type(c, '2');
      c.toggleSign();
      c.addOperator('^');
      type(c, '2');
      c.calculate();
      expect(c.display, '-4');
    });

    test('-n^2 is negative for a big operand too', () {
      final c = CalculatorService();
      type(c, '99999999999'); // 11 digits → BigDecimal path
      c.toggleSign();
      c.addOperator('^');
      type(c, '2');
      c.calculate();
      // Used to fold the sign into the base, flipping the result positive.
      expect(c.display.startsWith('-'), isTrue);
    });
  });

  group('Complex.toString survives large magnitudes', () {
    test('1e20 prints its value, not a saturated int', () {
      // (v * 1e9).toInt() saturated at 2^63 → "9223372036854775807".
      expect(Complex(1e20, 0).toString(), isNot(contains('9223372036854775807')));
      expect(double.parse(Complex(1e20, 0).toString()), 1e20);
    });

    test('1e301 does not throw', () {
      expect(() => Complex(1e301, 0).toString(), returnsNormally);
    });

    test('small values still get their noise cleaned', () {
      expect(Complex(2.0000000000001, 0).toString(), '2');
      expect(Complex(0, 3).toString(), '3i');
      expect(Complex(1, -2).toString(), '1 - 2i');
    });
  });

  group('BigDecimal contracts', () {
    test('equal values hash equally', () {
      final a = BigDecimal.fromString('1.5');
      final b = BigDecimal.fromString('1.50');
      expect(a, b);
      expect(a.hashCode, b.hashCode);

      final z1 = BigDecimal.fromString('0');
      final z2 = BigDecimal.fromString('0.0');
      expect(z1, z2);
      expect(z1.hashCode, z2.hashCode);

      // A Set must therefore collapse them.
      expect({a, b}.length, 1);
    });

    test('a division result round-trips through its own string form', () {
      // Chained division reached scale 40 while fromString clips at 20, so the
      // extra digits shown vanished the moment the display was re-parsed.
      final x = BigDecimal.fromString('1') / BigDecimal.fromString('3');
      final y = x / BigDecimal.fromString('3');
      expect(BigDecimal.fromString(y.toString()), y);
    });
  });

  group('Latent number-theory defects', () {
    test('isPerfectPower finds exponents above 64', () {
      final r = NumberAnalysisService.isPerfectPower(BigInt.two.pow(67));
      expect(r['isPower'], isTrue);
      expect(r['base'], BigInt.two);
      expect(r['exponent'], 67);
    });

    test('isPerfectPower still rejects non-powers', () {
      expect(NumberAnalysisService.isPerfectPower(BigInt.from(12))['isPower'],
          isFalse);
      expect(NumberAnalysisService.isPerfectPower(BigInt.from(64))['isPower'],
          isTrue);
    });

    test('fibonacciSequence respects a limit below its seeds', () {
      expect(NumberAnalysisService.fibonacciSequence(BigInt.zero),
          [BigInt.zero]);
      expect(NumberAnalysisService.fibonacciSequence(BigInt.from(-5)), isEmpty);
      // Normal use is unchanged.
      expect(NumberAnalysisService.fibonacciSequence(BigInt.from(10)),
          [0, 1, 1, 2, 3, 5, 8].map(BigInt.from).toList());
    });

    test('discreteLog finds solutions beyond the baby-step table', () {
      // 2^50 ≡ 100 (mod 202); g is not invertible, so this returned null.
      expect(
        NumberTheoryAdvancedService.discreteLog(
            BigInt.two, BigInt.from(100), BigInt.from(202)),
        BigInt.from(50),
      );
    });

    test('discreteLog still reports genuinely unsolvable cases', () {
      expect(
        NumberTheoryAdvancedService.discreteLog(
            BigInt.two, BigInt.from(3), BigInt.from(8)),
        isNull,
      );
    });

    test('primorial rejects a size that would exhaust memory', () {
      expect(() => SpecialFunctionsService.primorial(100000000),
          throwsArgumentError);
      expect(SpecialFunctionsService.primorial(10), BigInt.from(210));
    });
  });

  group('Polynomial parsing is bounded and localizable', () {
    test('an oversized exponent is a domain error, not a raw FormatException',
        () {
      expect(
        () => PolynomialService.parse('x^999999999999999999999'),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.inputTooLarge)),
      );
      expect(
        () => PolynomialService.parse('x^1000000'),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.inputTooLarge)),
      );
    });

    test('ordinary polynomials still parse', () {
      expect(PolynomialService.parse('x^3-6x^2+11x-6').degree, 3);
      expect(PolynomialService.parse('x^1000').degree, 1000);
    });
  });
}
