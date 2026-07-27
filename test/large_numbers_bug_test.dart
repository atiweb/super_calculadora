import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  group('Bug Test: Números Grandes', () {
    late CalculatorService calculatorService;

    setUp(() {
      calculatorService = CalculatorService();
    });

    test('Suma de números grandes (más de 16 dígitos)', () {
      // Try the addition that yields 0 instead of the correct result
      calculatorService.addDigit('1');
      calculatorService.addDigit('2');
      calculatorService.addDigit('3');
      calculatorService.addDigit('4');
      calculatorService.addDigit('5');
      calculatorService.addDigit('6');
      calculatorService.addDigit('7');
      calculatorService.addDigit('8');
      calculatorService.addDigit('9');
      calculatorService.addDigit('0');
      calculatorService.addDigit('1');
      calculatorService.addDigit('2');
      calculatorService.addDigit('3');
      calculatorService.addDigit('4');
      calculatorService.addDigit('5');
      calculatorService.addDigit('6');
      calculatorService.addDigit('7');
      calculatorService.addDigit('8');
      calculatorService.addDigit('9');
      calculatorService.addDigit('0');
      // Now we have: 12345678901234567890 (20 digits)
      
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      expect(calculatorService.display, '12345678901234567891');
      expect(calculatorService.hasError, false);
    });

    test('Suma de números de 16 dígitos', () {
      // Try with numbers of exactly 16 digits
      calculatorService.addDigit('1');
      calculatorService.addDigit('2');
      calculatorService.addDigit('3');
      calculatorService.addDigit('4');
      calculatorService.addDigit('5');
      calculatorService.addDigit('6');
      calculatorService.addDigit('7');
      calculatorService.addDigit('8');
      calculatorService.addDigit('9');
      calculatorService.addDigit('0');
      calculatorService.addDigit('1');
      calculatorService.addDigit('2');
      calculatorService.addDigit('3');
      calculatorService.addDigit('4');
      calculatorService.addDigit('5');
      calculatorService.addDigit('6');
      // Now we have: 1234567890123456 (16 digits)
      
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      expect(calculatorService.display, '1234567890123457');
      expect(calculatorService.hasError, false);
    });

    test('Suma de números de 17 dígitos - caso que falla', () {
      // Try with 17-digit numbers that trigger the bug
      calculatorService.addDigit('1');
      calculatorService.addDigit('2');
      calculatorService.addDigit('3');
      calculatorService.addDigit('4');
      calculatorService.addDigit('5');
      calculatorService.addDigit('6');
      calculatorService.addDigit('7');
      calculatorService.addDigit('8');
      calculatorService.addDigit('9');
      calculatorService.addDigit('0');
      calculatorService.addDigit('1');
      calculatorService.addDigit('2');
      calculatorService.addDigit('3');
      calculatorService.addDigit('4');
      calculatorService.addDigit('5');
      calculatorService.addDigit('6');
      calculatorService.addDigit('7');
      // Now we have: 12345678901234567 (17 digits)
      
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      // This is where the bug happens - instead of 12345678901234568, it gives 0, 3, 6, etc.
      print('Resultado: ${calculatorService.display}');
      expect(calculatorService.display, '12345678901234568');
      expect(calculatorService.hasError, false);
    });

    test('Multiplicación de números grandes', () {
      // Try multiplication, which also fails
      calculatorService.addDigit('1');
      calculatorService.addDigit('2');
      calculatorService.addDigit('3');
      calculatorService.addDigit('4');
      calculatorService.addDigit('5');
      calculatorService.addDigit('6');
      calculatorService.addDigit('7');
      calculatorService.addDigit('8');
      calculatorService.addDigit('9');
      calculatorService.addDigit('0');
      calculatorService.addDigit('1');
      calculatorService.addDigit('2');
      calculatorService.addDigit('3');
      calculatorService.addDigit('4');
      calculatorService.addDigit('5');
      calculatorService.addDigit('6');
      calculatorService.addDigit('7');
      // Now we have: 12345678901234567 (17 digits)
      
      calculatorService.addOperator('×');
      calculatorService.addDigit('2');
      calculatorService.calculate();
      
      print('Resultado multiplicación: ${calculatorService.display}');
      expect(calculatorService.display, '24691357802469134');
      expect(calculatorService.hasError, false);
    });

    test('Resta de números grandes', () {
      // Try subtraction, which also fails
      calculatorService.addDigit('1');
      calculatorService.addDigit('2');
      calculatorService.addDigit('3');
      calculatorService.addDigit('4');
      calculatorService.addDigit('5');
      calculatorService.addDigit('6');
      calculatorService.addDigit('7');
      calculatorService.addDigit('8');
      calculatorService.addDigit('9');
      calculatorService.addDigit('0');
      calculatorService.addDigit('1');
      calculatorService.addDigit('2');
      calculatorService.addDigit('3');
      calculatorService.addDigit('4');
      calculatorService.addDigit('5');
      calculatorService.addDigit('6');
      calculatorService.addDigit('7');
      // Now we have: 12345678901234567 (17 digits)
      
      calculatorService.addOperator('-');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      print('Resultado resta: ${calculatorService.display}');
      expect(calculatorService.display, '12345678901234566');
      expect(calculatorService.hasError, false);
    });
  });
}
