import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Basic Calculator Functions', () {
    late CalculatorService calculator;

    setUp(() {
      // Configurar mock para SharedPreferences
      SharedPreferences.setMockInitialValues({});
      calculator = CalculatorService();
    });

    group('Factorial Tests', () {
      test('calculates factorial of positive integers', () async {
        // Test factorial of 5
        calculator.addDigit('5');
        await calculator.factorial();
        
        expect(calculator.display, equals('120'));
        expect(calculator.errorMessage, isEmpty);
      });

      test('calculates factorial of 0', () async {
        calculator.addDigit('0');
        await calculator.factorial();
        
        expect(calculator.display, equals('1'));
        expect(calculator.errorMessage, isEmpty);
      });

      test('handles factorial of negative numbers', () async {
        calculator.addDigit('5');
        calculator.toggleSign();
        await calculator.factorial();
        
        expect(calculator.errorMessage, isNotEmpty);
        expect(calculator.errorMessage, 'errFactorialNonNeg');
      });

      test('handles factorial of decimal numbers', () async {
        calculator.addDigit('3');
        calculator.addDigit('.');
        calculator.addDigit('5');
        await calculator.factorial();

        expect(calculator.errorMessage, isNotEmpty);
        expect(calculator.errorMessage, 'errFactorialNonNeg');
      });

      test('handles factorial of large numbers', () async {
        calculator.addDigit('1');
        calculator.addDigit('8');
        calculator.addDigit('0');
        await calculator.factorial();

        expect(calculator.errorMessage, isNotEmpty);
        expect(calculator.errorMessage, 'errFactorialTooLarge');
      });
    });

    group('Parentheses Tests', () {
      test('adds open parenthesis to expression', () {
        calculator.addOpenParenthesis();
        expect(calculator.expression, equals('('));
      });

      test('adds close parenthesis to expression', () {
        calculator.addDigit('5');
        calculator.addCloseParenthesis();
        expect(calculator.expression, equals('5)'));
      });

      test('calculates simple expression with parentheses', () {
        // Test (2 + 3) * 4
        calculator.addOpenParenthesis();
        calculator.addDigit('2');
        calculator.addOperator('+');
        calculator.addDigit('3');
        calculator.addCloseParenthesis();
        calculator.addOperator('×');
        calculator.addDigit('4');
        calculator.calculate();
        
        expect(calculator.display, equals('20'));
        expect(calculator.errorMessage, isEmpty);
      });

      test('calculates expression with power and parentheses', () {
        // Test (2 + 3) ^ 2
        calculator.addOpenParenthesis();
        calculator.addDigit('2');
        calculator.addOperator('+');
        calculator.addDigit('3');
        calculator.addCloseParenthesis();
        calculator.addOperator('^');
        calculator.addDigit('2');
        calculator.calculate();
        
        expect(calculator.display, equals('25'));
        expect(calculator.errorMessage, isEmpty);
      });
    });

    group('Power Operator Tests', () {
      test('calculates power with ^ operator', () {
        // Test 2^3 = 8
        calculator.addDigit('2');
        calculator.addOperator('^');
        calculator.addDigit('3');
        calculator.calculate();
        
        expect(calculator.display, equals('8'));
        expect(calculator.errorMessage, isEmpty);
      });

      test('calculates power with ^ operator - larger numbers', () {
        // Test 5^2 = 25
        calculator.addDigit('5');
        calculator.addOperator('^');
        calculator.addDigit('2');
        calculator.calculate();
        
        expect(calculator.display, equals('25'));
        expect(calculator.errorMessage, isEmpty);
      });
    });

    group('Combined Functions Tests', () {
      test('calculates simple expression with factorial', () async {
        // Test 4! + 2
        calculator.addDigit('4');
        await calculator.factorial();
        calculator.addOperator('+');
        calculator.addDigit('2');
        calculator.calculate();
        
        expect(calculator.display, equals('26')); // 24 + 2 = 26
        expect(calculator.errorMessage, isEmpty);
      });

      test('calculates simple expression with factorial and power', () async {
        // Test 3! ^ 2
        calculator.addDigit('3');
        await calculator.factorial();
        calculator.addOperator('^');
        calculator.addDigit('2');
        calculator.calculate();
        
        expect(calculator.display, equals('36')); // 6^2 = 36
        expect(calculator.errorMessage, isEmpty);
      });
    });
  });
}
