import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  group('Calculator Service - Large Numbers', () {
    late CalculatorService calculator;
    
    setUp(() {
      calculator = CalculatorService();
    });
    
    test('should handle large number addition correctly', () async {
      // Test: 16648485438543854355 + 1 = 16648485438543854356
      calculator.setDisplay('16648485438543854355');
      calculator.addOperator('+');
      calculator.addDigit('1');
      calculator.calculate();
      
      expect(calculator.hasError, false);
      expect(calculator.display, '16648485438543854356');
    });
    
    test('should handle very large number addition correctly', () async {
      // Test: 12345678901234567890123456789 + 1 = 12345678901234567890123456790
      calculator.setDisplay('12345678901234567890123456789');
      calculator.addOperator('+');
      calculator.addDigit('1');
      calculator.calculate();
      
      expect(calculator.hasError, false);
      expect(calculator.display, '12345678901234567890123456790');
    });
    
    test('should handle large number subtraction correctly', () async {
      // Test: 16648485438543854355 - 1 = 16648485438543854354
      calculator.setDisplay('16648485438543854355');
      calculator.addOperator('-');
      calculator.addDigit('1');
      calculator.calculate();
      
      expect(calculator.hasError, false);
      expect(calculator.display, '16648485438543854354');
    });
    
    test('should handle large number multiplication correctly', () async {
      // Test: 123456789012345 * 2 = 246913578024690
      calculator.setDisplay('123456789012345');
      calculator.addOperator('×');
      calculator.addDigit('2');
      calculator.calculate();
      
      expect(calculator.hasError, false);
      expect(calculator.display, '246913578024690');
    });
    
    test('should handle large number division correctly', () async {
      // Test: 246913578024690 / 2 = 123456789012345
      calculator.setDisplay('246913578024690');
      calculator.addOperator('÷');
      calculator.addDigit('2');
      calculator.calculate();
      
      expect(calculator.hasError, false);
      expect(calculator.display, '123456789012345');
    });
    
    test('should not lose precision with 22+ digit numbers', () async {
      // Test: 1234567890123456789012345 + 1 = 1234567890123456789012346
      calculator.setDisplay('1234567890123456789012345');
      calculator.addOperator('+');
      calculator.addDigit('1');
      calculator.calculate();
      
      expect(calculator.hasError, false);
      expect(calculator.display, '1234567890123456789012346');
    });
    
    test('should handle edge case with very large number', () async {
      // Test: 999999999999999999999999999999999999999999999999999999999999999999999999 + 1
      String largeNumber = '999999999999999999999999999999999999999999999999999999999999999999999999';
      String expectedResult = '1000000000000000000000000000000000000000000000000000000000000000000000000';
      
      calculator.setDisplay(largeNumber);
      calculator.addOperator('+');
      calculator.addDigit('1');
      calculator.calculate();
      
      expect(calculator.hasError, false);
      expect(calculator.display, expectedResult);
    });
  });
}
