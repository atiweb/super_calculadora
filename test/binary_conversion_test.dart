import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CalculatorService Binary Conversion Tests', () {
    late CalculatorService calculator;

    setUp(() {
      // Inicializar binding para tests
      TestWidgetsFlutterBinding.ensureInitialized();
      // Configurar mock para SharedPreferences
      SharedPreferences.setMockInitialValues({});
      
      calculator = CalculatorService();
    });

    test('should handle invalid binary conversion gracefully', () {
      // Test case 1: Number 8 (not a valid binary number)
      calculator.addDigit('8');
      expect(calculator.display, '8');
      
      // Try to convert from binary - should show error
      calculator.fromBinary();
      
      expect(calculator.hasError, true);
      expect(calculator.errorMessage, 'errInvalidBinary');
      expect(calculator.display, 'Error');
    });

    test('should handle valid binary conversion', () {
      // Test case 2: Number 101 (valid binary number)
      calculator.clear();
      calculator.addDigit('1');
      calculator.addDigit('0');
      calculator.addDigit('1');
      expect(calculator.display, '101');
      
      // Try to convert from binary - should work
      calculator.fromBinary();
      
      expect(calculator.hasError, false);
      expect(calculator.display, '5'); // 101 in binary = 5 in decimal
    });

    test('should handle edge cases', () {
      // Test case 3: Number with invalid characters
      calculator.clear();
      calculator.addDigit('1');
      calculator.addDigit('2'); // Invalid for binary
      calculator.addDigit('3'); // Invalid for binary
      calculator.fromBinary();
      expect(calculator.hasError, true);
      expect(calculator.errorMessage, 'errInvalidBinary');
      
      // Test case 4: Only zeros and ones (valid binary)
      calculator.clear();
      calculator.addDigit('1');
      calculator.addDigit('1');
      calculator.addDigit('0');
      calculator.fromBinary();
      expect(calculator.hasError, false);
      expect(calculator.display, '6'); // 110 in binary = 6 in decimal
    });

    test('should handle decimal to binary conversion', () {
      // Test case 5: Convert decimal to binary
      calculator.clear();
      calculator.addDigit('8');
      calculator.toBinary();
      
      expect(calculator.hasError, false);
      expect(calculator.display, '1000'); // 8 in decimal = 1000 in binary
    });

    test('should detect binary numbers correctly', () {
      // Test binary number detection
      calculator.clear();
      calculator.addDigit('1');
      calculator.addDigit('0');
      calculator.addDigit('1');
      expect(calculator.isBinaryNumber, true);
      expect(calculator.conversionButtonText, 'DEC');
      
      // Test decimal number detection
      calculator.clear();
      calculator.addDigit('8');
      expect(calculator.isBinaryNumber, false);
      expect(calculator.conversionButtonText, 'BIN');
    });

    test('should toggle between binary and decimal conversions', () {
      // Test conversion from decimal to binary
      calculator.clear();
      calculator.addDigit('8');
      expect(calculator.isBinaryNumber, false);
      
      calculator.toggleBinaryDecimal();
      expect(calculator.hasError, false);
      expect(calculator.display, '1000'); // 8 in decimal = 1000 in binary
      expect(calculator.isBinaryNumber, true);
      
      // Test conversion from binary back to decimal
      calculator.toggleBinaryDecimal();
      expect(calculator.hasError, false);
      expect(calculator.display, '8'); // 1000 in binary = 8 in decimal
      expect(calculator.isBinaryNumber, false);
    });
  });
}
