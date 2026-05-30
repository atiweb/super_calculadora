import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Power Operator Test', () {
    test('Should handle power operator ^ in basic calculator like scientific', () {
      final calculator = CalculatorService();
      
      // Test case: 2^3 = 8
      calculator.addDigit('2');
      calculator.addOperator('^');
      calculator.addDigit('3');
      calculator.calculate();
      
      print('Test: 2^3');
      print('Result: ${calculator.display}');
      expect(calculator.display, '8');
      
      // Test case: 5^2 = 25
      calculator.clear();
      calculator.addDigit('5');
      calculator.addOperator('^');
      calculator.addDigit('2');
      calculator.calculate();
      
      print('Test: 5^2');
      print('Result: ${calculator.display}');
      expect(calculator.display, '25');
      
      // Test case: 3^4 = 81
      calculator.clear();
      calculator.addDigit('3');
      calculator.addOperator('^');
      calculator.addDigit('4');
      calculator.calculate();
      
      print('Test: 3^4');
      print('Result: ${calculator.display}');
      expect(calculator.display, '81');
      
      // Test case: 10^3 = 1000
      calculator.clear();
      calculator.addDigit('1');
      calculator.addDigit('0');
      calculator.addOperator('^');
      calculator.addDigit('3');
      calculator.calculate();
      
      print('Test: 10^3');
      print('Result: ${calculator.display}');
      expect(calculator.display, '1000');
    });
    
    test('Should work with complex expressions containing powers', () {
      final calculator = CalculatorService();
      
      // Test evaluateCompleteExpression directly
      String result = calculator.evaluateCompleteExpression('2^3 + 1');
      print('Test: 2^3 + 1');
      print('Result: $result');
      expect(result, '9');
      
      result = calculator.evaluateCompleteExpression('2 * 3^2');
      print('Test: 2 * 3^2');
      print('Result: $result');
      expect(result, '18');
      
      result = calculator.evaluateCompleteExpression('(2+1)^3');
      print('Test: (2+1)^3');
      print('Result: $result');
      expect(result, '27');
    });
  });
}
