import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/models/calculator_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

void main() {
  group('Scientific Calculator Tests', () {
    late CalculatorService calculator;

    setUp(() {
      // Inicializar binding para tests
      TestWidgetsFlutterBinding.ensureInitialized();
      // Configurar mock para SharedPreferences
      SharedPreferences.setMockInitialValues({});
      
      calculator = CalculatorService();
      calculator.setCalculatorType(CalculatorType.scientific);
    });

    test('should calculate trigonometric functions in degrees', () async {
      // Test sin(30°) = 0.5
      calculator.addDigit('3');
      calculator.addDigit('0');
      await calculator.sin();
      expect(double.parse(calculator.display), closeTo(0.5, 0.0001));

      // Test cos(60°) = 0.5
      calculator.clear();
      calculator.addDigit('6');
      calculator.addDigit('0');
      await calculator.cos();
      expect(double.parse(calculator.display), closeTo(0.5, 0.0001));

      // Test tan(45°) = 1
      calculator.clear();
      calculator.addDigit('4');
      calculator.addDigit('5');
      await calculator.tan();
      expect(double.parse(calculator.display), closeTo(1.0, 0.0001));
    });

    test('should calculate trigonometric functions in radians', () async {
      calculator.toggleAngleMode(); // Switch to radians
      expect(calculator.isRadianMode, true);

      // Test sin(π/2) = 1
      calculator.addPi();
      calculator.addOperator('/');
      calculator.addDigit('2');
      calculator.calculate();
      await calculator.sin();
      expect(double.parse(calculator.display), closeTo(1.0, 0.0001));
    });

    test('should calculate logarithmic functions', () async {
      // Test ln(e) = 1
      calculator.addE();
      await calculator.ln();
      expect(double.parse(calculator.display), closeTo(1.0, 0.0001));

      // Test log(100) = 2
      calculator.clear();
      calculator.addDigit('1');
      calculator.addDigit('0');
      calculator.addDigit('0');
      await calculator.log();
      expect(double.parse(calculator.display), closeTo(2.0, 0.0001));
    });

    test('should calculate exponential functions', () async {
      // Test e^1 = e
      calculator.addDigit('1');
      await calculator.exp();
      expect(double.parse(calculator.display), closeTo(math.e, 0.0001));

      // Test 10^2 = 100
      calculator.clear();
      calculator.addDigit('2');
      await calculator.pow10();
      expect(double.parse(calculator.display), closeTo(100.0, 0.0001));
    });

    test('should calculate factorial', () async {
      // Test 5! = 120
      calculator.addDigit('5');
      await calculator.factorial();
      expect(calculator.display, '120');

      // Test 0! = 1
      calculator.clear();
      calculator.addDigit('0');
      await calculator.factorial();
      expect(calculator.display, '1');
    });

    test('should handle domain errors correctly', () async {
      // Test arcsin(2) - should error
      calculator.addDigit('2');
      await calculator.asin();
      expect(calculator.hasError, true);
      expect(calculator.errorMessage, 'errAsinDomain');

      // Test ln(0) - should error
      calculator.clear();
      calculator.addDigit('0');
      await calculator.ln();
      expect(calculator.hasError, true);
      expect(calculator.errorMessage, 'errLnDomain');

      // Test factorial(-1) - should error
      calculator.clear();
      calculator.addDigit('-');
      calculator.addDigit('1');
      await calculator.factorial();
      expect(calculator.hasError, true);
      expect(calculator.errorMessage, 'errFactorialNonNeg');
    });

    test('should add constants correctly', () {
      calculator.addPi();
      expect(double.parse(calculator.display), closeTo(math.pi, 0.0001));

      calculator.clear();
      calculator.addE();
      expect(double.parse(calculator.display), closeTo(math.e, 0.0001));
    });

    test('should switch between calculator types', () {
      expect(calculator.calculatorType, CalculatorType.scientific);

      calculator.setCalculatorType(CalculatorType.standard);
      expect(calculator.calculatorType, CalculatorType.standard);
    });

    test('should toggle angle mode', () {
      expect(calculator.isRadianMode, false);
      expect(calculator.angleMode, 'DEG');

      calculator.toggleAngleMode();
      expect(calculator.isRadianMode, true);
      expect(calculator.angleMode, 'RAD');
    });
  });
}
