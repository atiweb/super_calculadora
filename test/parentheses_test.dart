import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Parentheses Expression Tests', () {
    test('Simple parentheses expressions should work correctly', () {
      final calculator = CalculatorService();
      
      // Basic test: 1 + (1+1) = 3
      String result = calculator.evaluateCompleteExpression('1 + (1+1)');
      expect(result, '3');
      
      // Test: (5 + 3) * 2 = 16
      result = calculator.evaluateCompleteExpression('(5 + 3) * 2');
      expect(result, '16');
      
      // Test: 2 * (4 + 6) = 20
      result = calculator.evaluateCompleteExpression('2 * (4 + 6)');
      expect(result, '20');
      
      // Test: (10 - 2) / (3 + 1) = 2
      result = calculator.evaluateCompleteExpression('(10 - 2) / (3 + 1)');
      expect(result, '2');
    });

    test('Nested parentheses should work correctly', () {
      final calculator = CalculatorService();
      
      // Test: ((2 + 3) * 4) - 1 = 19
      String result = calculator.evaluateCompleteExpression('((2 + 3) * 4) - 1');
      expect(result, '19');
      
      // Test: 2 * ((3 + 4) * (5 - 2)) = 42
      result = calculator.evaluateCompleteExpression('2 * ((3 + 4) * (5 - 2))');
      expect(result, '42');
    });

    test('Parentheses with functions should work correctly', () {
      final calculator = CalculatorService();
      
      // Test: sqrt(16) + (3 * 2) = 10
      String result = calculator.evaluateCompleteExpression('sqrt(16) + (3 * 2)');
      expect(result, '10');
      
      // Test: (sqrt(9) + 1) * 2 = 8
      result = calculator.evaluateCompleteExpression('(sqrt(9) + 1) * 2');
      expect(result, '8');
    });

    test('Complex expression from user example should work', () {
      final calculator = CalculatorService();
      
      // The user's specific example
      String result = calculator.evaluateCompleteExpression('1 + (1+1)');
      expect(result, '3');
      
      // Variations
      result = calculator.evaluateCompleteExpression('5 + (2+3)');
      expect(result, '10');
      
      result = calculator.evaluateCompleteExpression('(1+1) + 1');
      expect(result, '3');
    });

    test('Should prioritize math_expressions over BigDecimal for parentheses', () {
      final calculator = CalculatorService();
      
      // Even with "large" numbers, if it has parentheses it must use math_expressions
      String result = calculator.evaluateCompleteExpression('12345 + (67890 + 1)');
      expect(result, '80236');
      
      // Test with decimals and parentheses
      result = calculator.evaluateCompleteExpression('1.5 + (2.5 * 3)');
      expect(result, '9'); // Result is 9, not 9.0
    });

    test('Error cases with parentheses should be handled correctly', () {
      final calculator = CalculatorService();
      
      // Unbalanced parentheses
      String result = calculator.evaluateCompleteExpression('1 + (2 + 3');
      expect(result, startsWith('err:'));
      
      result = calculator.evaluateCompleteExpression('1 + 2 + 3)');
      expect(result, startsWith('err:'));
      
      // Empty parentheses
      result = calculator.evaluateCompleteExpression('1 + ()');
      expect(result, startsWith('err:'));
    });
  });
}
