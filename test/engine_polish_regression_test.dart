import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_calculadora/models/big_complex.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/settings_service.dart';

/// Regressions for the lower-severity engine and parsing bugs from the audit.
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

  group('BigComplex parsing rejects malformed input', () {
    test('"1+2" is not silently read as 12', () {
      // replaceAll('+','') concatenated the operands into a different number.
      expect(() => BigComplex.parse('1+2', '0'), throwsA(anything));
      expect(() => BigComplex.parse('3', '4+5'), throwsA(anything));
    });

    test('a leading sign is still accepted', () {
      expect(BigComplex.parse('+3', '-4').re.toStringAsPrecision(1), '3');
      expect(BigComplex.parse('3', '4').re.toStringAsPrecision(1), '3');
    });
  });

  group('History entries name their operand', () {
    // `history` is also repopulated from storage asynchronously, so assert on
    // the entry being present rather than on its position.
    test('phi records the number it was applied to', () async {
      SharedPreferences.setMockInitialValues({});
      final c = CalculatorService();
      await Future<void>.delayed(Duration.zero);
      type(c, '10');
      await c.eulerPhi();
      expect(c.display, '4');
      // Used to be recorded as a bare 'φ', with no way to tell φ of what.
      expect(c.history.any((e) => e.expression == 'φ(10)'), isTrue);
    });

    test('factorial-style labels keep their notation', () async {
      SharedPreferences.setMockInitialValues({});
      final c = CalculatorService();
      await Future<void>.delayed(Duration.zero);
      type(c, '5');
      await c.factorialFunction();
      expect(c.history.any((e) => e.expression == '5!'), isTrue);
    });
  });

  group('Repeated "=" does not pile up junk history', () {
    test('pressing = on a settled result is a no-op', () {
      final c = CalculatorService();
      type(c, '5');
      c.addOperator('+');
      type(c, '3');
      c.calculate();
      expect(c.display, '8');
      final int after = c.history.length;

      c.calculate();
      c.calculate();
      c.calculate();
      expect(c.history.length, after); // no "8 = 8" entries
    });
  });

  group('Operator entry', () {
    test('a minus after "(" starts a negative operand instead of deleting it',
        () {
      final c = CalculatorService();
      type(c, '2');
      c.addOperator('×');
      c.addOpenParenthesis();
      c.addOperator('-');
      // Used to yield "2 × - ", dropping the bracket and unbalancing it.
      expect(c.display.contains('('), isTrue);

      type(c, '3');
      c.addCloseParenthesis();
      c.calculate();
      expect(c.hasError, isFalse);
      expect(c.display, '-6');
    });

    test('pre-spaced operators do not double-space or break backspace', () {
      final c = CalculatorService();
      type(c, '5');
      c.addOperator(' ÷ '); // the special keyboard used to send this
      expect(c.display.contains('  '), isFalse);

      c.backspace();
      type(c, '3');
      // Used to leave the display reading "5 3" — two separate numbers on
      // screen that the parser then evaluated as 53.
      expect(c.display, '53');
    });

    test('a dangling operator reports a malformed expression, not a RangeError',
        () {
      final c = CalculatorService();
      type(c, '17');
      c.addOperator('+');
      c.calculate();
      expect(c.hasError, isTrue);
      expect(c.errorMessage, 'errExprMalformed');
    });

    test('a second decimal point is ignored', () {
      final c = CalculatorService();
      c.addDigit('.');
      c.addDigit('.');
      expect(c.display, '0.');
      type(c, '5');
      c.calculate();
      expect(c.hasError, isFalse);
      expect(c.display, '0.5');
    });
  });

  group('Functions keep the pending expression', () {
    test('% applies to the last operand and preserves the prefix', () {
      final c = CalculatorService();
      type(c, '50');
      c.addOperator('+');
      type(c, '10');
      c.percentage();
      // Used to collapse the display to "0.1", losing "50 + ".
      expect(c.display, '50 + 0.1');
      c.calculate();
      expect(c.display, '50.1');
    });

    test('trig functions preserve the prefix too', () async {
      final c = CalculatorService();
      type(c, '5');
      c.addOperator('+');
      type(c, '30');
      await c.sin(); // degrees by default
      expect(c.display, '5 + 0.5');
    });

    test('a bare operand still works normally', () {
      final c = CalculatorService();
      type(c, '50');
      c.percentage();
      expect(c.display, '0.5');
    });
  });

  group('Sign toggle', () {
    test('± negates the operand being entered, not the whole expression', () {
      final c = CalculatorService();
      type(c, '5');
      c.addOperator('+');
      type(c, '3');
      c.toggleSign();
      // Used to produce "-5 + 3" (= -2) instead of negating the 3.
      c.calculate();
      expect(c.display, '2');
    });

    test('± still toggles a lone number both ways', () {
      final c = CalculatorService();
      type(c, '7');
      c.toggleSign();
      expect(c.display, '-7');
      c.toggleSign();
      expect(c.display, '7');
    });
  });

  group('Division by zero is one error, not two', () {
    test('a computed zero divisor reports division by zero', () {
      final c = CalculatorService();
      type(c, '5');
      c.addOperator('÷');
      c.addOpenParenthesis();
      type(c, '3');
      c.addOperator('-');
      type(c, '3');
      c.addCloseParenthesis();
      c.calculate();
      expect(c.hasError, isTrue);
      // Used to surface as errResultInvalid while 8 ÷ 0 said division by zero.
      expect(c.errorMessage, 'errDivisionByZero');
    });
  });
}
