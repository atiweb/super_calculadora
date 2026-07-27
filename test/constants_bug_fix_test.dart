import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/models/calculator_config.dart';
import 'dart:math' as math;

void main() {
  group('Constants Bug Fix Tests', () {
    late CalculatorService calculator;

    setUp(() {
      calculator = CalculatorService();
      calculator.setCalculatorType(CalculatorType.scientific);
    });

    test('should not duplicate Pi when pressed multiple times', () {
      String piValue = math.pi.toString();
      
      // First time - should show Pi
      calculator.addPi();
      expect(calculator.display, piValue);
      
      // Second time - should keep showing Pi (no duplication)
      calculator.addPi();
      expect(calculator.display, piValue);
      
      // Third time - should keep showing Pi
      calculator.addPi();
      expect(calculator.display, piValue);
    });

    test('should not duplicate e when pressed multiple times', () {
      String eValue = math.e.toString();
      
      // First time - should show e
      calculator.addE();
      expect(calculator.display, eValue);
      
      // Second time - should keep showing e (no duplication)
      calculator.addE();
      expect(calculator.display, eValue);
      
      // Third time - should keep showing e
      calculator.addE();
      expect(calculator.display, eValue);
    });

    test('should replace any number with Pi', () {
      // Start with a different number
      calculator.addDigit('1');
      calculator.addDigit('2');
      calculator.addDigit('3');
      expect(calculator.display, '123');
      
      // Press Pi - should replace completely
      calculator.addPi();
      expect(calculator.display, math.pi.toString());
    });

    test('should replace any number with e', () {
      // Start with a different number
      calculator.addDigit('4');
      calculator.addDigit('5');
      calculator.addDigit('6');
      expect(calculator.display, '456');
      
      // Press e - should replace completely
      calculator.addE();
      expect(calculator.display, math.e.toString());
    });

    test('should replace Pi with e and vice versa', () {
      String piValue = math.pi.toString();
      String eValue = math.e.toString();
      
      // Start with Pi
      calculator.addPi();
      expect(calculator.display, piValue);
      
      // Switch to e - should replace
      calculator.addE();
      expect(calculator.display, eValue);
      
      // Switch back to Pi - should replace
      calculator.addPi();
      expect(calculator.display, piValue);
    });

    test('should work correctly after operations', () {
      String piValue = math.pi.toString();
      
      // Perform an operation
      calculator.addDigit('2');
      calculator.addOperator('+');
      calculator.addDigit('3');
      calculator.calculate();
      expect(calculator.display, '5');
      
      // Press Pi - should replace the result
      calculator.addPi();
      expect(calculator.display, piValue);
    });

    test('should work correctly from zero state', () {
      String piValue = math.pi.toString();
      String eValue = math.e.toString();
      
      // Initial state (0)
      expect(calculator.display, '0');
      
      // Press Pi from 0
      calculator.addPi();
      expect(calculator.display, piValue);
      
      // Clear and try e from 0
      calculator.clear();
      expect(calculator.display, '0');
      
      calculator.addE();
      expect(calculator.display, eValue);
    });
  });
}
