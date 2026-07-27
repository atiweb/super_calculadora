import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/settings_service.dart';

/// Regressions for the calculator state-machine bugs found in the audit.
/// Each test reproduces the exact button sequence a user would press.
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

  group('Variable-parameter operations no longer inject a phantom operand', () {
    test('the documented "12 → LCM → 18 → = → LCM" flow gives 36, not 0', () {
      final c = CalculatorService();
      type(c, '12');
      c.lcmFunction();
      type(c, '18');
      c.calculate(); // '=' adds the parameter
      c.lcmFunction(); // pressing the key again solves
      // Used to append a placeholder 0 → lcm(12, 18, 0) = 0.
      expect(c.display, '36');
    });

    test('GCD does not pick up a stale previous result', () {
      final c = CalculatorService();
      // Leave a stale _lastResult behind first.
      type(c, '5');
      c.addOperator('+');
      type(c, '5');
      c.calculate();
      expect(c.display, '10');

      c.clear();
      type(c, '12');
      c.gcdFunction();
      type(c, '18');
      c.calculate();
      c.gcdFunction();
      // Used to append the stale '10' → gcd(12, 18, 10) = 2.
      expect(c.display, '6');
    });

    test('three operands still work: 12 → GCD → 18 → = → 24 → GCD', () {
      final c = CalculatorService();
      type(c, '12');
      c.gcdFunction();
      type(c, '18');
      c.calculate();
      type(c, '24');
      c.gcdFunction();
      expect(c.display, '6');
    });

    test('short flow without "=" still works: 12 → GCD → 18 → GCD', () {
      final c = CalculatorService();
      type(c, '12');
      c.gcdFunction();
      type(c, '18');
      c.gcdFunction();
      expect(c.display, '6');
    });

    test('a typed zero is still a real operand', () {
      final c = CalculatorService();
      type(c, '12');
      c.gcdFunction();
      type(c, '0');
      c.gcdFunction();
      expect(c.display, '12'); // gcd(12, 0) = 12
    });

    test('CRT accepts the documented pair flow instead of erroring', () {
      final c = CalculatorService();
      // x ≡ 2 (mod 3), x ≡ 3 (mod 5)  →  x ≡ 8 (mod 15)
      type(c, '2');
      c.crtFunction();
      type(c, '3');
      c.calculate();
      type(c, '3');
      c.calculate();
      type(c, '5');
      c.crtFunction();
      // The phantom operand made the count odd → errCRTNeedPairs every time.
      expect(c.hasError, isFalse);
      expect(c.display.contains('8'), isTrue);
    });

    test('means work through the same flow', () {
      final c = CalculatorService();
      type(c, '3');
      c.arithmeticMeanN();
      type(c, '7');
      c.calculate();
      c.arithmeticMeanN();
      expect(c.display, '5'); // mean(3, 7)
    });
  });

  group('mod operator on the scientific keyboard', () {
    test('17 mod 5 evaluates to 2 instead of throwing', () {
      final c = CalculatorService();
      type(c, '17');
      c.addOperator('mod');
      type(c, '5');
      c.calculate();
      expect(c.hasError, isFalse);
      expect(c.display, '2');
    });

    test('mod composes with other operators', () {
      final c = CalculatorService();
      type(c, '17');
      c.addOperator('mod');
      type(c, '5');
      c.addOperator('+');
      type(c, '1');
      c.calculate();
      expect(c.display, '3');
    });
  });

  group('Scientific-notation displays are read as whole numbers', () {
    test('percentage acts on the value, not on the exponent', () {
      final c = CalculatorService();
      // 1 ÷ 3000000 = 3.3333...e-7
      type(c, '1');
      c.addOperator('÷');
      type(c, '3000000');
      c.calculate();
      expect(c.display.contains('e'), isTrue,
          reason: 'precondition: result shown in scientific notation');

      c.percentage();
      // Used to parse "-7" out of the exponent and show -0.07.
      expect(c.display.startsWith('-0.07'), isFalse);
      expect(double.parse(c.display), closeTo(3.3333333e-9, 1e-15));
    });
  });

  group('Cancelling a long operation disowns its result', () {
    test('a cancelled power does not overwrite what the user types next',
        () async {
      final c = CalculatorService();
      // 200-digit base with a large exponent takes the isolate path.
      type(c, '9' * 200);
      final Future<void> op = c.power('500');
      c.cancelCurrentOperation();
      expect(c.hasError, isTrue);

      // The user starts over while the isolate is still running.
      c.clear();
      type(c, '5');
      await op; // the late result must be discarded
      expect(c.display, '5');
    }, timeout: const Timeout(Duration(seconds: 60)));
  });
}
