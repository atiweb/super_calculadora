import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  group('Numeric Precision Regression', () {
    test('Rounding stabilizes near-floating artifacts (uses central precision)', () {
      final calc = CalculatorService();
      // Simulate scientific function output artifact
      calc.setDisplay('0.49999999999999994');
      // Force internal formatting path by reloading the number
      calc.loadNumber('0.49999999999999994');
      expect(calc.display, '0.5');

      calc.setDisplay('2.7182818284590451'); // e rounded to 15 should stay stable
      calc.loadNumber('2.7182818284590451');
      expect(calc.display.startsWith('2.718281828459045'), isTrue);
    });

    test('Large integers are preserved as strings without double conversion', () {
      final calc = CalculatorService();
      // 16+ digits should not be coerced to double; keep exact string
      const big = '12345678901234567';
      calc.loadNumber(big);
      expect(calc.display, big);
    });
  });
}
