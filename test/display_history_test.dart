import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Display con Historial', () {
    setUp(() async {
      // Limpiar SharedPreferences antes de cada test
      SharedPreferences.setMockInitialValues({});
    });

    test('Mostrar última operación en display', () async {
      final calculator = CalculatorService();
      
      // Verificar que inicialmente no hay última operación
      expect(calculator.lastOperation, isNull);
      
      // Realizar una operación
      calculator.addDigit('2');
      calculator.addOperator('+');
      calculator.addDigit('3');
      calculator.calculate();
      
      // Verificar que ahora hay una última operación
      expect(calculator.lastOperation, isNotNull);
      expect(calculator.lastOperation!.expression, '2 + 3');
      expect(calculator.lastOperation!.result, '5');
      
      // Limpiar y realizar otra operación
      calculator.clear();
      calculator.addDigit('4');
      calculator.addOperator('×');
      calculator.addDigit('5');
      calculator.calculate();
      
      // Verificar que la última operación cambió
      expect(calculator.lastOperation!.expression, '4 × 5');
      expect(calculator.lastOperation!.result, '20');
    });

    test('Historial vacío no tiene última operación', () async {
      final calculator = CalculatorService();
      
      // Limpiar historial
      await calculator.clearHistory();
      
      // Verificar que no hay última operación
      expect(calculator.lastOperation, isNull);
    });

    test('Múltiples operaciones mantienen orden correcto', () async {
      final calculator = CalculatorService();
      
      // Realizar varias operaciones
      calculator.addDigit('1');
      calculator.addOperator('+');
      calculator.addDigit('1');
      calculator.calculate();
      
      calculator.clear();
      calculator.addDigit('3');
      calculator.addOperator('×');
      calculator.addDigit('4');
      calculator.calculate();
      
      calculator.clear();
      calculator.addDigit('10');
      calculator.addOperator('÷');
      calculator.addDigit('2');
      calculator.calculate();
      
      // La última operación debe ser la más reciente
      expect(calculator.lastOperation!.expression, '10 ÷ 2');
      expect(calculator.lastOperation!.result, '5');
      
      // Verificar que el historial tiene las 3 operaciones
      expect(calculator.history.length, 3);
      
      // Las operaciones deben estar en orden inverso (más reciente primero)
      expect(calculator.history[0].expression, '10 ÷ 2');
      expect(calculator.history[1].expression, '3 × 4');
      expect(calculator.history[2].expression, '1 + 1');
    });

    test('Operación con resultado largo', () async {
      final calculator = CalculatorService();
      
      // Simular operación factorial (resultado largo)
      calculator.addDigit('10');
      await calculator.factorial();
      
      // El resultado debería estar en el historial pero truncado para display
      // Nota: El factorial se aplica directamente al display, no genera historial automáticamente
      // así que necesitamos simular una operación que genere historial
      
      calculator.clear();
      calculator.addDigit('999999999');
      calculator.addOperator('+');
      calculator.addDigit('1');
      calculator.calculate();
      
      expect(calculator.lastOperation, isNotNull);
      expect(calculator.lastOperation!.expression, '999999999 + 1');
      expect(calculator.lastOperation!.result, '1000000000');
    });
  });
}
