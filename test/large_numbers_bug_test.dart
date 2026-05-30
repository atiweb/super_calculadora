import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  group('Bug Test: Números Grandes', () {
    late CalculatorService calculatorService;

    setUp(() {
      calculatorService = CalculatorService();
    });

    test('Suma de números grandes (más de 16 dígitos)', () {
      // Probar la suma que da 0 en lugar del resultado correcto
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
      // Ahora tenemos: 12345678901234567890 (20 dígitos)
      
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      expect(calculatorService.display, '12345678901234567891');
      expect(calculatorService.hasError, false);
    });

    test('Suma de números de 16 dígitos', () {
      // Probar con números de exactamente 16 dígitos
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
      // Ahora tenemos: 1234567890123456 (16 dígitos)
      
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      expect(calculatorService.display, '1234567890123457');
      expect(calculatorService.hasError, false);
    });

    test('Suma de números de 17 dígitos - caso que falla', () {
      // Probar con números de 17 dígitos que causan el bug
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
      // Ahora tenemos: 12345678901234567 (17 dígitos)
      
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      // Aquí es donde ocurre el bug - en lugar de 12345678901234568, da 0, 3, 6, etc.
      print('Resultado: ${calculatorService.display}');
      expect(calculatorService.display, '12345678901234568');
      expect(calculatorService.hasError, false);
    });

    test('Multiplicación de números grandes', () {
      // Probar multiplicación que también falla
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
      // Ahora tenemos: 12345678901234567 (17 dígitos)
      
      calculatorService.addOperator('×');
      calculatorService.addDigit('2');
      calculatorService.calculate();
      
      print('Resultado multiplicación: ${calculatorService.display}');
      expect(calculatorService.display, '24691357802469134');
      expect(calculatorService.hasError, false);
    });

    test('Resta de números grandes', () {
      // Probar resta que también falla
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
      // Ahora tenemos: 12345678901234567 (17 dígitos)
      
      calculatorService.addOperator('-');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      print('Resultado resta: ${calculatorService.display}');
      expect(calculatorService.display, '12345678901234566');
      expect(calculatorService.hasError, false);
    });
  });
}
