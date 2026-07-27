import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/history_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Direct Operations History Tests', () {
    late CalculatorService calculator;

    setUp(() {
      // Initialize binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();
      // Set up mock for SharedPreferences
      SharedPreferences.setMockInitialValues({});
      calculator = CalculatorService();
    });

    test('should add factorial operation to history', () async {
      // Clear history
      await HistoryService.clearHistory();
      
      // Compute factorial of 5
      calculator.addDigit('5');
      await calculator.factorial();
      
      // Verify it was added to the history
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, '5!');
      expect(history[0].result, '120');
    });

    test('should add square root operation to history', () async {
      // Clear history
      await HistoryService.clearHistory();
      
      // Compute square root of 16
      calculator.addDigit('1');
      calculator.addDigit('6');
      await calculator.squareRoot();
      
      // Verify it was added to the history
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, '√16');
      expect(history[0].result, '4');
    });

    test('should add cube root operation to history', () async {
      // Clear history
      await HistoryService.clearHistory();
      
      // Compute cube root of 27
      calculator.addDigit('2');
      calculator.addDigit('7');
      await calculator.cubeRoot();
      
      // Verify it was added to the history
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, '∛27');
      expect(history[0].result, '3');
    });

    test('should add trigonometric operations to history', () async {
      // Clear history
      await HistoryService.clearHistory();
      
      // Compute sine of 30°
      calculator.addDigit('3');
      calculator.addDigit('0');
      await calculator.sin();
      
      // Verify it was added to the history
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, 'sin(30°)');
      expect(history[0].result, '0.5');
    });

    test('should add logarithmic operations to history', () async {
      // Clear history
      await HistoryService.clearHistory();
      
      // Compute natural logarithm of e
      calculator.addE();
      await calculator.ln();
      
      // Verify it was added to the history
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, 'ln(2.718281828459045)');
      expect(history[0].result, '1');
    });

    test('should add exponential operations to history', () async {
      // Clear history
      await HistoryService.clearHistory();
      
      // Compute e^2
      calculator.addDigit('2');
      await calculator.exp();
      
      // Verify it was added to the history
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, 'e^2');
      expect(history[0].result, '7.38905609893065');
    });

    test('should add power operations to history', () async {
      // Clear history
      await HistoryService.clearHistory();
      
      // Compute 2^3 using the power function
      calculator.addDigit('2');
      await calculator.power('3');
      
      // Verify it was added to the history
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, '2^3');
      expect(history[0].result, '8');
    });

    test('should add binary conversion operations to history', () async {
      // Clear history
      await HistoryService.clearHistory();
      
      // Convert 10 to binary
      calculator.addDigit('1');
      calculator.addDigit('0');
      await calculator.toBinary();
      
      // Verify it was added to the history
      final history = await HistoryService.getHistory();
      expect(history.length, 1);
      expect(history[0].expression, '10 → BIN');
      expect(history[0].result, '1010');
    });

    test('should add multiple direct operations to history', () async {
      // Clear history
      await HistoryService.clearHistory();
      
      // Perform multiple direct operations
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
      
      // Verify all of them were added to the history
      final history = await HistoryService.getHistory();
      expect(history.length, 3);
      
      // Verify they are in order (most recent first)
      expect(history[0].expression, 'sin(90°)');
      expect(history[0].result, '1');
      expect(history[1].expression, '√16');
      expect(history[1].result, '4');
      expect(history[2].expression, '5!');
      expect(history[2].result, '120');
    });

    test('should handle history limits for direct operations', () async {
      // Clear history
      await HistoryService.clearHistory();
      
      // Add more than 100 direct operations
      for (int i = 0; i < 105; i++) {
        calculator.clear();
        calculator.addDigit('${i % 10}');
        await calculator.factorial();
      }
      
      // Verify the history stays within the limit
      final history = await HistoryService.getHistory();
      expect(history.length, 100);
    });
  });
}
