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
      
      // Primera vez - debería mostrar Pi
      calculator.addPi();
      expect(calculator.display, piValue);
      
      // Segunda vez - debería seguir mostrando Pi (no duplicar)
      calculator.addPi();
      expect(calculator.display, piValue);
      
      // Tercera vez - debería seguir mostrando Pi
      calculator.addPi();
      expect(calculator.display, piValue);
    });

    test('should not duplicate e when pressed multiple times', () {
      String eValue = math.e.toString();
      
      // Primera vez - debería mostrar e
      calculator.addE();
      expect(calculator.display, eValue);
      
      // Segunda vez - debería seguir mostrando e (no duplicar)
      calculator.addE();
      expect(calculator.display, eValue);
      
      // Tercera vez - debería seguir mostrando e
      calculator.addE();
      expect(calculator.display, eValue);
    });

    test('should replace any number with Pi', () {
      // Comenzar con un número diferente
      calculator.addDigit('1');
      calculator.addDigit('2');
      calculator.addDigit('3');
      expect(calculator.display, '123');
      
      // Presionar Pi - debería reemplazar completamente
      calculator.addPi();
      expect(calculator.display, math.pi.toString());
    });

    test('should replace any number with e', () {
      // Comenzar con un número diferente
      calculator.addDigit('4');
      calculator.addDigit('5');
      calculator.addDigit('6');
      expect(calculator.display, '456');
      
      // Presionar e - debería reemplazar completamente
      calculator.addE();
      expect(calculator.display, math.e.toString());
    });

    test('should replace Pi with e and vice versa', () {
      String piValue = math.pi.toString();
      String eValue = math.e.toString();
      
      // Comenzar con Pi
      calculator.addPi();
      expect(calculator.display, piValue);
      
      // Cambiar a e - debería reemplazar
      calculator.addE();
      expect(calculator.display, eValue);
      
      // Cambiar de vuelta a Pi - debería reemplazar
      calculator.addPi();
      expect(calculator.display, piValue);
    });

    test('should work correctly after operations', () {
      String piValue = math.pi.toString();
      
      // Hacer una operación
      calculator.addDigit('2');
      calculator.addOperator('+');
      calculator.addDigit('3');
      calculator.calculate();
      expect(calculator.display, '5');
      
      // Presionar Pi - debería reemplazar el resultado
      calculator.addPi();
      expect(calculator.display, piValue);
    });

    test('should work correctly from zero state', () {
      String piValue = math.pi.toString();
      String eValue = math.e.toString();
      
      // Estado inicial (0)
      expect(calculator.display, '0');
      
      // Presionar Pi desde 0
      calculator.addPi();
      expect(calculator.display, piValue);
      
      // Clear y probar e desde 0
      calculator.clear();
      expect(calculator.display, '0');
      
      calculator.addE();
      expect(calculator.display, eValue);
    });
  });
}
