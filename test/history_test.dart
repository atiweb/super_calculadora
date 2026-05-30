import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/operation_entry.dart';
import 'package:super_calculadora/services/history_service.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Historia de Operaciones', () {
    setUp(() async {
      // Inicializar binding para tests
      TestWidgetsFlutterBinding.ensureInitialized();
      // Limpiar SharedPreferences antes de cada test
      SharedPreferences.setMockInitialValues({});
    });

    test('Agregar operación al historial', () async {
      final operation = OperationEntry(
        expression: '2 + 3',
        result: '5',
      );

      await HistoryService.addOperation(operation);
      final history = await HistoryService.getHistory();

      expect(history.length, 1);
      expect(history[0].expression, '2 + 3');
      expect(history[0].result, '5');
    });

    test('Limpiar historial', () async {
      // Agregar algunas operaciones
      await HistoryService.addOperation(
        OperationEntry(expression: '1 + 1', result: '2'),
      );
      await HistoryService.addOperation(
        OperationEntry(expression: '2 * 3', result: '6'),
      );

      // Verificar que se agregaron
      var history = await HistoryService.getHistory();
      expect(history.length, 2);

      // Limpiar historial
      await HistoryService.clearHistory();
      history = await HistoryService.getHistory();
      expect(history.length, 0);
    });

    test('Eliminar operación específica', () async {
      final operation1 = OperationEntry(expression: '1 + 1', result: '2');
      final operation2 = OperationEntry(expression: '2 * 3', result: '6');

      await HistoryService.addOperation(operation1);
      await HistoryService.addOperation(operation2);

      // Verificar que ambas se agregaron
      var history = await HistoryService.getHistory();
      expect(history.length, 2);

      // Eliminar la primera operación
      await HistoryService.removeOperation(operation1);
      history = await HistoryService.getHistory();
      
      expect(history.length, 1);
      expect(history[0].expression, '2 * 3');
      expect(history[0].result, '6');
    });

    test('Contador de operaciones', () async {
      expect(await HistoryService.getHistoryCount(), 0);

      await HistoryService.addOperation(
        OperationEntry(expression: '1 + 1', result: '2'),
      );
      expect(await HistoryService.getHistoryCount(), 1);

      await HistoryService.addOperation(
        OperationEntry(expression: '2 * 3', result: '6'),
      );
      expect(await HistoryService.getHistoryCount(), 2);
    });

    test('Integración con CalculatorService', () async {
      final calculator = CalculatorService();
      
      // Simular algunas operaciones
      calculator.addDigit('2');
      calculator.addOperator('+');
      calculator.addDigit('3');
      calculator.calculate();

      // Verificar que se guardó en el historial
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, '2 + 3');
      expect(history[0].result, '5');
    });

    test('Orden del historial (más reciente primero)', () async {
      await HistoryService.addOperation(
        OperationEntry(expression: '1 + 1', result: '2'),
      );
      await HistoryService.addOperation(
        OperationEntry(expression: '2 * 3', result: '6'),
      );
      await HistoryService.addOperation(
        OperationEntry(expression: '5 - 2', result: '3'),
      );

      final history = await HistoryService.getHistory();
      expect(history.length, 3);
      
      // La operación más reciente debe estar primero
      expect(history[0].expression, '5 - 2');
      expect(history[1].expression, '2 * 3');
      expect(history[2].expression, '1 + 1');
    });

    test('Serialización y deserialización', () {
      final operation = OperationEntry(
        expression: '2 ^ 3',
        result: '8',
      );

      final serialized = operation.toStorageString();
      expect(serialized, '2 ^ 3=8');

      final deserialized = OperationEntry.fromStorageString(serialized);
      expect(deserialized.expression, '2 ^ 3');
      expect(deserialized.result, '8');
    });

    test('Serialización con resultado que contiene "="', () {
      final operation = OperationEntry(
        expression: '2 + 3',
        result: '5 = 5.0',
      );

      final serialized = operation.toStorageString();
      expect(serialized, '2 + 3=5 = 5.0');

      final deserialized = OperationEntry.fromStorageString(serialized);
      expect(deserialized.expression, '2 + 3');
      expect(deserialized.result, '5 = 5.0');
    });

    test('Límite de historial', () async {
      // Agregar más operaciones que el límite
      for (int i = 0; i < 105; i++) {
        await HistoryService.addOperation(
          OperationEntry(expression: '$i + 1', result: '${i + 1}'),
        );
      }

      // Verificar que el historial se mantiene dentro del límite
      final history = await HistoryService.getHistory();
      expect(history.length, 100);
      
      // Las operaciones más recientes deben mantenerse
      expect(history[0].expression, '104 + 1');
      expect(history[99].expression, '5 + 1');
    });
  });
}
