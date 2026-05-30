import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('New Display Behavior Tests', () {
    late CalculatorService calculator;

    setUp(() {
      calculator = CalculatorService();
    });

    test('Should show expression in display before calculating', () {
      // Test: 2 + 3
      calculator.addDigit('2');
      expect(calculator.display, equals('2'));
      
      calculator.addOperator('+');
      expect(calculator.display, equals('2 + '));
      
      calculator.addDigit('3');
      expect(calculator.display, equals('2 + 3'));
      
      // Now calculate
      calculator.calculate();
      expect(calculator.display, equals('5'));
    });

    test('Should handle parentheses in display', () {
      // Test: (2 + 3)
      calculator.addOpenParenthesis();
      expect(calculator.display, equals('('));
      
      calculator.addDigit('2');
      expect(calculator.display, equals('(2'));
      
      calculator.addOperator('+');
      expect(calculator.display, equals('(2 + '));
      
      calculator.addDigit('3');
      expect(calculator.display, equals('(2 + 3'));
      
      calculator.addCloseParenthesis();
      expect(calculator.display, equals('(2 + 3)'));
      
      // Calculate
      calculator.calculate();
      expect(calculator.display, equals('5'));
    });

    test('Should handle factorial in display', () async {
      // Test: 5!
      calculator.addDigit('5');
      expect(calculator.display, equals('5'));
      
      await calculator.factorial();
      expect(calculator.display, equals('120'));
    });

    test('Should handle backspace with operators', () {
      // Test: 2 + 3, then backspace
      calculator.addDigit('2');
      calculator.addOperator('+');
      calculator.addDigit('3');
      expect(calculator.display, equals('2 + 3'));
      
      // Backspace should remove '3'
      calculator.backspace();
      expect(calculator.display, equals('2 + '));
      
      // Backspace should remove ' + '
      calculator.backspace();
      expect(calculator.display, equals('2'));
      
      // Backspace should remove '2'
      calculator.backspace();
      expect(calculator.display, equals('0'));
    });

    test('Should handle complex expression with multiple operations', () {
      // Test: 2 × (3 + 4)
      calculator.addDigit('2');
      calculator.addOperator('×');
      calculator.addOpenParenthesis();
      calculator.addDigit('3');
      calculator.addOperator('+');
      calculator.addDigit('4');
      calculator.addCloseParenthesis();
      
      expect(calculator.display, equals('2 × (3 + 4)'));
      
      // Calculate
      calculator.calculate();
      expect(calculator.display, equals('14'));
    });

    test('Should handle power operation in display', () {
      // Test: 2^3
      calculator.addDigit('2');
      calculator.addOperator('^');
      calculator.addDigit('3');
      
      expect(calculator.display, equals('2 ^ 3'));
      
      // Calculate
      calculator.calculate();
      expect(calculator.display, equals('8'));
    });

    test('Should replace operator when multiple operators are pressed', () {
      // Test: 2 + - × (should end as 2 × )
      calculator.addDigit('2');
      calculator.addOperator('+');
      expect(calculator.display, equals('2 + '));
      
      calculator.addOperator('-');
      expect(calculator.display, equals('2 - '));
      
      calculator.addOperator('×');
      expect(calculator.display, equals('2 × '));
    });
  });
}
