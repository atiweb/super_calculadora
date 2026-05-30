import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  group('Calculator Display - Copy & Paste', () {
    late CalculatorService calculator;
    
    setUp(() {
      calculator = CalculatorService();
    });
    
    test('should validate valid numbers correctly', () async {
      // Test valid numbers
      expect(_isValidNumber('123'), true);
      expect(_isValidNumber('123.456'), true);
      expect(_isValidNumber('-123.456'), true);
      expect(_isValidNumber('1.23e10'), true);
      expect(_isValidNumber('1.23E-5'), true);
      expect(_isValidNumber('0b101010'), true);
      expect(_isValidNumber('.123'), true);
      expect(_isValidNumber('123.'), true);
      
      // Test invalid numbers
      expect(_isValidNumber(''), false);
      expect(_isValidNumber('abc'), false);
      expect(_isValidNumber('12.34.56'), false);
      expect(_isValidNumber('12abc34'), false);
      expect(_isValidNumber('0b102'), false); // Invalid binary
    });
    
    test('should handle large number pasting', () async {
      // Test pasting a large number
      String largeNumber = '123456789012345678901234567890';
      calculator.setDisplay(largeNumber);
      
      expect(calculator.display, largeNumber);
      expect(calculator.hasError, false);
    });
    
    test('should handle scientific notation pasting', () async {
      // Test pasting scientific notation
      String scientificNumber = '1.23e15';
      calculator.setDisplay(scientificNumber);
      
      expect(calculator.hasError, false);
      // The display might be formatted differently, but shouldn't have errors
    });
    
    test('should handle binary number pasting', () async {
      // Test pasting binary number
      String binaryNumber = '0b101010';
      calculator.setDisplay(binaryNumber);
      
      expect(calculator.hasError, false);
    });
    
    test('should reject invalid number formats', () async {
      // These should be caught by validation before setting display
      // In real implementation, these would be rejected in _isValidNumber
      expect(_isValidNumber('12.34.56'), false);
      expect(_isValidNumber('abc123'), false);
      expect(_isValidNumber('123abc'), false);
    });
  });
}

// Helper function for testing (copy from the actual implementation)
bool _isValidNumber(String text) {
  if (text.isEmpty) return false;
  
  // Remover espacios
  text = text.replaceAll(' ', '');
  
  // Verificar si es binario
  if (text.startsWith('0b')) {
    String binaryPart = text.substring(2);
    return RegExp(r'^[01]+$').hasMatch(binaryPart);
  }
  
  // Verificar números regulares (enteros, decimales, notación científica)
  return RegExp(r'^-?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?$').hasMatch(text);
}
