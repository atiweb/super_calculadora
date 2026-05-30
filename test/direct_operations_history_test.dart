import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/history_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Direct Operations History Tests', () {
    late CalculatorService calculator;

    setUp(() {
      // Inicializar binding para tests
      TestWidgetsFlutterBinding.ensureInitialized();
      // Configurar mock para SharedPreferences
      SharedPreferences.setMockInitialValues({});
      calculator = CalculatorService();
    });

    test('should add factorial operation to history', () async {
      // Limpiar historial
      await HistoryService.clearHistory();
      
      // Calcular factorial de 5
      calculator.addDigit('5');
      await calculator.factorial();
      
      // Verificar que se agregó al historial
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, '5!');
      expect(history[0].result, '120');
    });

    test('should add square root operation to history', () async {
      // Limpiar historial
      await HistoryService.clearHistory();
      
      // Calcular raíz cuadrada de 16
      calculator.addDigit('1');
      calculator.addDigit('6');
      await calculator.squareRoot();
      
      // Verificar que se agregó al historial
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, '√16');
      expect(history[0].result, '4');
    });

    test('should add cube root operation to history', () async {
      // Limpiar historial
      await HistoryService.clearHistory();
      
      // Calcular raíz cúbica de 27
      calculator.addDigit('2');
      calculator.addDigit('7');
      await calculator.cubeRoot();
      
      // Verificar que se agregó al historial
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, '∛27');
      expect(history[0].result, '3');
    });

    test('should add trigonometric operations to history', () async {
      // Limpiar historial
      await HistoryService.clearHistory();
      
      // Calcular seno de 30°
      calculator.addDigit('3');
      calculator.addDigit('0');
      await calculator.sin();
      
      // Verificar que se agregó al historial
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, 'sin(30°)');
      expect(history[0].result, '0.5');
    });

    test('should add logarithmic operations to history', () async {
      // Limpiar historial
      await HistoryService.clearHistory();
      
      // Calcular logaritmo natural de e
      calculator.addE();
      await calculator.ln();
      
      // Verificar que se agregó al historial
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, 'ln(2.718281828459045)');
      expect(history[0].result, '1');
    });

    test('should add exponential operations to history', () async {
      // Limpiar historial
      await HistoryService.clearHistory();
      
      // Calcular e^2
      calculator.addDigit('2');
      await calculator.exp();
      
      // Verificar que se agregó al historial
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, 'e^2');
      expect(history[0].result, '7.38905609893065');
    });

    test('should add power operations to history', () async {
      // Limpiar historial
      await HistoryService.clearHistory();
      
      // Calcular 2^3 usando función power
      calculator.addDigit('2');
      await calculator.power('3');
      
      // Verificar que se agregó al historial
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, '2^3');
      expect(history[0].result, '8');
    });

    test('should add binary conversion operations to history', () async {
      // Limpiar historial
      await HistoryService.clearHistory();
      
      // Convertir 10 a binario
      calculator.addDigit('1');
      calculator.addDigit('0');
      await calculator.toBinary();
      
      // Verificar que se agregó al historial
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, '10 → BIN');
      expect(history[0].result, '1010');
    });

    test('should add multiple direct operations to history', () async {
      // Limpiar historial
      await HistoryService.clearHistory();
      
      // Realizar múltiples operaciones directas
      calculator.addDigit('5');
      await calculator.factorial();
      
      calculator.clear();
      calculator.addDigit('1');
      calculator.addDigit('6');
      await calculator.squareRoot();
      
      calculator.clear();
      calculator.addDigit('9');
      calculator.addDigit('0');
      await calculator.sin();
      
      // Verificar que todas se agregaron al historial
      final history = await HistoryService.getHistory();
      expect(history.length, 3);
      
      // Verificar que están en orden (más reciente primero)
      expect(history[0].expression, 'sin(90°)');
      expect(history[0].result, '1');
      expect(history[1].expression, '√16');
      expect(history[1].result, '4');
      expect(history[2].expression, '5!');
      expect(history[2].result, '120');
    });

    test('should handle history limits for direct operations', () async {
      // Limpiar historial
      await HistoryService.clearHistory();
      
      // Agregar más de 100 operaciones directas
      for (int i = 0; i < 105; i++) {
        calculator.clear();
        calculator.addDigit('${i % 10}');
        await calculator.factorial();
      }
      
      // Verificar que el historial se mantiene dentro del límite
      final history = await HistoryService.getHistory();
      expect(history.length, 100);
    });
  });
}
