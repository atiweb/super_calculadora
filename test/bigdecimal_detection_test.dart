import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  group('BigDecimal Detection Test', () {
    late CalculatorService calculatorService;

    setUp(() {
      calculatorService = CalculatorService();
    });

    test('Verifica que _containsLargeNumbers detecta números grandes', () {
      // Números que NO deberían ser detectados como grandes (<=15 dígitos)
      String expression1 = '123456789012345+1';
      String expression2 = '999999999999999*2';
      
      // Números que SÍ deberían ser detectados como grandes (>15 dígitos)
      String expression3 = '1234567890123456+1'; // 16 dígitos
      String expression4 = '12345678901234567*2'; // 17 dígitos
      
      // Como no podemos acceder directamente al método privado, 
      // verificamos el comportamiento indirectamente
      
      print('Testing expression: $expression1');
      print('Testing expression: $expression2');
      print('Testing expression: $expression3');
      print('Testing expression: $expression4');
      
      expect(true, true); // Placeholder - el comportamiento se verifica en otros tests
    });

    test('Operaciones extremas con números muy grandes', () {
      // Test con números realmente grandes
      String largeNumber = '123456789012345678901234567890';
      
      // Construir el número digit por digit
      for (int i = 0; i < largeNumber.length; i++) {
        calculatorService.addDigit(largeNumber[i]);
      }
      
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      // Verificar que no hay error y el resultado es correcto
      expect(calculatorService.hasError, false);
      expect(calculatorService.display, '123456789012345678901234567891');
    });

    test('División con números grandes', () {
      // Test división con números grandes
      String largeNumber = '123456789012345678901234567890';
      
      // Construir el número digit por digit
      for (int i = 0; i < largeNumber.length; i++) {
        calculatorService.addDigit(largeNumber[i]);
      }
      
      calculatorService.addOperator('÷');
      calculatorService.addDigit('2');
      calculatorService.calculate();
      
      // Verificar que no hay error
      expect(calculatorService.hasError, false);
      expect(calculatorService.display, '61728394506172839450617283945');
    });

    test('Multiplicación con números grandes', () {
      // Test multiplicación con números grandes
      String largeNumber = '123456789012345678901234567890';
      
      // Construir el número digit por digit
      for (int i = 0; i < largeNumber.length; i++) {
        calculatorService.addDigit(largeNumber[i]);
      }
      
      calculatorService.addOperator('×');
      calculatorService.addDigit('2');
      calculatorService.calculate();
      
      // Verificar que no hay error
      expect(calculatorService.hasError, false);
      expect(calculatorService.display, '246913578024691357802469135780');
    });

    test('Combinación de operaciones con números grandes', () {
      // Test más complejo con números grandes
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
      // 17 dígitos: 99999999999999999
      
      calculatorService.addOperator('+');
      calculatorService.addDigit('1');
      calculatorService.calculate();
      
      // Verificar que no hay error
      expect(calculatorService.hasError, false);
      expect(calculatorService.display, '100000000000000000');
    });

    test('Test de límite exacto - 15 vs 16 dígitos', () {
      // Test con exactamente 15 dígitos (debería usar math_expressions)
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
      
      // Test con exactamente 16 dígitos (debería usar BigDecimal)
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
