import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/models/operation_entry.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  group('Mathematical Expressions Tests', () {
    test('Simple arithmetic expressions should be evaluated correctly', () {
      final calculator = CalculatorService();
      
      // Pruebas básicas
      expect(calculator.evaluateCompleteExpression('2+3'), '5');
      expect(calculator.evaluateCompleteExpression('10-4'), '6');
      expect(calculator.evaluateCompleteExpression('3*4'), '12');
      expect(calculator.evaluateCompleteExpression('15/3'), '5');
    });

    test('Complex expressions with parentheses should work', () {
      final calculator = CalculatorService();
      
      // Expresiones con paréntesis
      expect(calculator.evaluateCompleteExpression('(5+3)*2'), '16');
      expect(calculator.evaluateCompleteExpression('2*(3+4)'), '14');
      expect(calculator.evaluateCompleteExpression('(10-5)/(2+3)'), '1');
    });

    test('Mathematical functions should be supported', () {
      final calculator = CalculatorService();
      
      // Raíz cuadrada
      expect(calculator.evaluateCompleteExpression('sqrt(9)'), '3');
      expect(calculator.evaluateCompleteExpression('sqrt(16)'), '4');
      
      // Potencias
      expect(calculator.evaluateCompleteExpression('2^3'), '8');
      expect(calculator.evaluateCompleteExpression('5^2'), '25');
    });

    test('Symbol replacement should work correctly', () {
      final calculator = CalculatorService();
      
      // Verificar reemplazo de símbolos
      String prepared = calculator.evaluateCompleteExpression('3×4');
      expect(prepared, '12');
      
      prepared = calculator.evaluateCompleteExpression('12÷3');
      expect(prepared, '4');
    });

    test('Constants should be supported', () {
      final calculator = CalculatorService();
      
      // Pi (aproximadamente)
      String piResult = calculator.evaluateCompleteExpression('π');
      expect(double.parse(piResult), closeTo(3.14159, 0.001));
    });

    test('OperationEntry model should work correctly', () {
      final entry = OperationEntry(
        expression: '2+3',
        result: '5',
      );
      
      expect(entry.expression, '2+3');
      expect(entry.result, '5');
      expect(entry.toString(), '2+3 = 5');
      
      // Test storage string conversion
      String storageString = entry.toStorageString();
      OperationEntry restored = OperationEntry.fromStorageString(storageString);
      
      expect(restored.expression, entry.expression);
      expect(restored.result, entry.result);
    });

    test('Expression preparation should handle implicit multiplication', () {
      final calculator = CalculatorService();
      
      // Test implicit multiplication (not directly accessible, so test through evaluation)
      // 2(3+4) should become 2*(3+4) = 14
      expect(calculator.evaluateCompleteExpression('2(3+4)'), '14');
    });

    test('Complex mathematical expression example should work', () {
      final calculator = CalculatorService();
      
      // Expresión similar al ejemplo: (5 + 3) * sqrt(9) - 2^3
      String result = calculator.evaluateCompleteExpression('(5+3)*sqrt(9)-2^3');
      
      // (5+3) = 8, sqrt(9) = 3, 2^3 = 8
      // 8 * 3 - 8 = 24 - 8 = 16
      expect(result, '16');
    });

    test('Error handling should work for invalid expressions', () {
      final calculator = CalculatorService();
      
      // División por cero
      String result = calculator.evaluateCompleteExpression('5/0');
      expect(result, startsWith('err:'));

      // Expresión malformada - paréntesis no balanceados
      result = calculator.evaluateCompleteExpression('(5 + 3');
      expect(result, startsWith('err:'));

      // Función sin paréntesis
      result = calculator.evaluateCompleteExpression('sin 45');
      expect(result, startsWith('err:'));
    });
  });
}
