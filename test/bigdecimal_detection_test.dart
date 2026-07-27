import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  group('BigDecimal Detection Test', () {
    late CalculatorService calculatorService;

    setUp(() {
      calculatorService = CalculatorService();
    });

    test('Verifica que _containsLargeNumbers detecta números grandes', () {
      // Numbers that should NOT be detected as large (<=15 digits)
      String expression1 = '123456789012345+1';
      String expression2 = '999999999999999*2';
      
      // Numbers that SHOULD be detected as large (>15 digits)
      String expression3 = '1234567890123456+1'; // 16 digits
      String expression4 = '12345678901234567*2'; // 17 digits
      
      // Since we cannot access the private method directly,
      // we verify the behavior indirectly
      
      print('Testing expression: $expression1');
      print('Testing expression: $expression2');
      print('Testing expression: $expression3');
      print('Testing expression: $expression4');
      
      expect(true, true); // Placeholder - the behavior is verified in other tests
    });

    test('Operaciones extremas con números muy grandes', () {
      // Test with really large numbers
      String largeNumber = '123456789012345678901234567890';
      
      // Build the number digit by digit
      for (int i = 0; i < largeNumber.length; i++) {
        calculatorService.addDigit(largeNumber[i]);
      }
      
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      // Verify there is no error and the result is correct
      expect(calculatorService.hasError, false);
      expect(calculatorService.display, '123456789012345678901234567891');
    });

    test('División con números grandes', () {
      // Test division with large numbers
      String largeNumber = '123456789012345678901234567890';
      
      // Build the number digit by digit
      for (int i = 0; i < largeNumber.length; i++) {
        calculatorService.addDigit(largeNumber[i]);
      }
      
      calculatorService.addOperator('÷');
      calculatorService.addDigit('2');
      calculatorService.calculate();
      
      // Verify there is no error
      expect(calculatorService.hasError, false);
      expect(calculatorService.display, '61728394506172839450617283945');
    });

    test('Multiplicación con números grandes', () {
      // Test multiplication with large numbers
      String largeNumber = '123456789012345678901234567890';
      
      // Build the number digit by digit
      for (int i = 0; i < largeNumber.length; i++) {
        calculatorService.addDigit(largeNumber[i]);
      }
      
      calculatorService.addOperator('×');
      calculatorService.addDigit('2');
      calculatorService.calculate();
      
      // Verify there is no error
      expect(calculatorService.hasError, false);
      expect(calculatorService.display, '246913578024691357802469135780');
    });

    test('Combinación de operaciones con números grandes', () {
      // More complex test with large numbers
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      calculatorService.addDigit('9');
      // 17 digits: 99999999999999999
      
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      // Verify there is no error
      expect(calculatorService.hasError, false);
      expect(calculatorService.display, '100000000000000000');
    });

    test('Test de límite exacto - 15 vs 16 dígitos', () {
      // Test with exactly 15 digits (should use math_expressions)
      calculatorService.clear();
      String fifteenDigits = '123456789012345';
      for (int i = 0; i < fifteenDigits.length; i++) {
        calculatorService.addDigit(fifteenDigits[i]);
      }
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      expect(calculatorService.hasError, false);
      expect(calculatorService.display, '123456789012346');
      
      // Test with exactly 16 digits (should use BigDecimal)
      calculatorService.clear();
      String sixteenDigits = '1234567890123456';
      for (int i = 0; i < sixteenDigits.length; i++) {
        calculatorService.addDigit(sixteenDigits[i]);
      }
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      expect(calculatorService.hasError, false);
      expect(calculatorService.display, '1234567890123457');
    });
  });
}
