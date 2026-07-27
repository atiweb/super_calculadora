import '../services/number_analysis_service.dart';
import 'package:flutter/foundation.dart';

/// Digit sum examples for big numbers
class DigitSumExamples {
  /// Tests the digit sum for different number sizes
  static void testDigitSum() {
  debugPrint('=== Pruebas de Suma de Dígitos ===');
    
    // Small number
    BigInt small = BigInt.from(123456789);
  debugPrint('Número pequeño: $small');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(small)}');
  debugPrint('Verificación manual: 1+2+3+4+5+6+7+8+9 = 45');
  debugPrint('');
    
    // Medium number (50 digits)
    BigInt medium = BigInt.parse('12345678901234567890123456789012345678901234567890');
  debugPrint('Número mediano (50 dígitos): ${medium.toString().substring(0, 20)}...');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(medium)}');
  debugPrint('');
    
    // Large number (100 digits)
    String largeNumStr = '1' * 100; // 100 ones
    BigInt large = BigInt.parse(largeNumStr);
  debugPrint('Número grande (100 dígitos): ${large.toString().substring(0, 20)}...');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(large)}');
  debugPrint('Verificación: 100 × 1 = 100');
  debugPrint('');
    
    // Extremely large number (1000 digits)
    String extremeNumStr = '9' * 1000; // 1000 nines
    BigInt extreme = BigInt.parse(extremeNumStr);
  debugPrint('Número extremadamente grande (1000 dígitos): ${extreme.toString().substring(0, 20)}...');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(extreme)}');
  debugPrint('Verificación: 1000 × 9 = 9000');
  debugPrint('');
    
    // Number with a mixed pattern (500 digits)
    String patternNumStr = '123456789' * 55 + '12345'; // Repeated pattern
    BigInt pattern = BigInt.parse(patternNumStr);
  debugPrint('Número con patrón (500 dígitos): ${pattern.toString().substring(0, 20)}...');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(pattern)}');
  debugPrint('Verificación: 55 × (1+2+3+4+5+6+7+8+9) + (1+2+3+4+5) = 55 × 45 + 15 = 2475 + 15 = 2490');
  debugPrint('');
    
    // Giant number (10000 digits)
    String giantNumStr = '2' * 10000; // 10000 twos
    BigInt giant = BigInt.parse(giantNumStr);
  debugPrint('Número gigante (10000 dígitos): ${giant.toString().substring(0, 20)}...');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(giant)}');
  debugPrint('Verificación: 10000 × 2 = 20000');
  debugPrint('');
    
  debugPrint('=== Todas las pruebas completadas ===');
  }
  
  /// Tests the efficiency of the digit sum
  static void testDigitSumPerformance() {
  debugPrint('=== Pruebas de Rendimiento de Suma de Dígitos ===');
    
    List<int> sizes = [100, 1000, 5000, 10000, 50000];
    
    for (int size in sizes) {
      String numStr = '1' * size;
      BigInt number = BigInt.parse(numStr);
      
      Stopwatch stopwatch = Stopwatch()..start();
      int sum = NumberAnalysisService.digitSum(number);
      stopwatch.stop();
      
  debugPrint('Tamaño: $size dígitos');
  debugPrint('Suma: $sum (esperado: $size)');
  debugPrint('Tiempo: ${stopwatch.elapsedMicroseconds} μs');
  debugPrint('');
    }
  }
  
  /// Tests special cases
  static void testSpecialCases() {
  debugPrint('=== Casos Especiales ===');
    
    // Zero
    BigInt zero = BigInt.zero;
  debugPrint('Cero: ${NumberAnalysisService.digitSum(zero)}');
    
    // Negative number
    BigInt negative = BigInt.from(-12345);
  debugPrint('Negativo (-12345): ${NumberAnalysisService.digitSum(negative)}');
    
    // Single-digit number
    BigInt single = BigInt.from(7);
  debugPrint('Un dígito (7): ${NumberAnalysisService.digitSum(single)}');
    
    // Very large number that overflows if not handled properly
    BigInt veryLarge = BigInt.parse('9' * 100000);
  debugPrint('Muy grande (100000 dígitos): ${NumberAnalysisService.digitSum(veryLarge)}');
  debugPrint('Verificación: 100000 × 9 = 900000');
  }
  
  /// Runs all the tests
  static void runAllTests() {
  testDigitSum();
  debugPrint('');
  testDigitSumPerformance();
  debugPrint('');
  testSpecialCases();
  }
}

/// Extension for easy access to the digit sum
extension BigIntDigitSum on BigInt {
  int get digitSum => NumberAnalysisService.digitSum(this);
}
