import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Parentheses Manual Test', () {
    test('Should correctly evaluate expressions with parentheses', () {
      final calculator = CalculatorService();
      
      // Test case específico del usuario
      String result = calculator.evaluateCompleteExpression('1 + (1+1)');
      print('Input: 1 + (1+1)');
      print('Output: $result');
      expect(result, '3');
      
      // Casos adicionales
      result = calculator.evaluateCompleteExpression('2 * (3 + 4)');
      print('Input: 2 * (3 + 4)');
      print('Output: $result');
      expect(result, '14');
      
      result = calculator.evaluateCompleteExpression('(5 + 3) / (2 + 2)');
      print('Input: (5 + 3) / (2 + 2)');
      print('Output: $result');
      expect(result, '2');
      
      result = calculator.evaluateCompleteExpression('((2 + 3) * 4)');
      print('Input: ((2 + 3) * 4)');
      print('Output: $result');
      expect(result, '20');
    });
  });
}
