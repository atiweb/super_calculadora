import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Display con Historial', () {
    setUp(() async {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('Mostrar última operación en display', () async {
      final calculator = CalculatorService();
      
      // Verify there is initially no last operation
      expect(calculator.lastOperation, isNull);
      
      // Perform an operation
      calculator.addDigit('2');
      calculator.addOperator('+');
      calculator.addDigit('3');
      calculator.calculate();
      
      // Verify there is now a last operation
      expect(calculator.lastOperation, isNotNull);
      expect(calculator.lastOperation!.expression, '2 + 3');
      expect(calculator.lastOperation!.result, '5');
      
      // Clear and perform another operation
      calculator.clear();
      calculator.addDigit('4');
      calculator.addOperator('×');
      calculator.addDigit('5');
      calculator.calculate();
      
      // Verify the last operation changed
      expect(calculator.lastOperation!.expression, '4 × 5');
      expect(calculator.lastOperation!.result, '20');
    });

    test('Historial vacío no tiene última operación', () async {
      final calculator = CalculatorService();
      
      // Clear history
      await calculator.clearHistory();
      
      // Verify there is no last operation
      expect(calculator.lastOperation, isNull);
    });

    test('Múltiples operaciones mantienen orden correcto', () async {
      final calculator = CalculatorService();
      
      // Perform several operations
      calculator.addDigit('1');
      calculator.addOperator('+');
      calculator.addDigit('1');
      calculator.calculate();
      
      calculator.clear();
      calculator.addDigit('3');
      calculator.addOperator('×');
      calculator.addDigit('4');
      calculator.calculate();
      
      calculator.clear();
      calculator.addDigit('10');
      calculator.addOperator('÷');
      calculator.addDigit('2');
      calculator.calculate();
      
      // The last operation must be the most recent one
      expect(calculator.lastOperation!.expression, '10 ÷ 2');
      expect(calculator.lastOperation!.result, '5');
      
      // Verify the history holds the 3 operations
      expect(calculator.history.length, 3);
      
      // The operations must be in reverse order (most recent first)
      expect(calculator.history[0].expression, '10 ÷ 2');
      expect(calculator.history[1].expression, '3 × 4');
      expect(calculator.history[2].expression, '1 + 1');
    });

    test('Operación con resultado largo', () async {
      final calculator = CalculatorService();
      
      // Simulate factorial operation (long result)
      calculator.addDigit('10');
      await calculator.factorial();
      
      // The result should be in the history but truncated for display
      // Note: The factorial is applied directly to the display, it doesn't generate history automatically
      // so we need to simulate an operation that generates history
      
      calculator.clear();
      calculator.addDigit('999999999');
      calculator.addOperator('+');
      calculator.addDigit('1');
      calculator.calculate();
      
      expect(calculator.lastOperation, isNotNull);
      expect(calculator.lastOperation!.expression, '999999999 + 1');
      expect(calculator.lastOperation!.result, '1000000000');
    });
  });
}
