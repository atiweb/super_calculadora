import '../services/number_analysis_service.dart';
import 'package:flutter/foundation.dart';

/// Ejemplos de suma de dígitos para números grandes
class DigitSumExamples {
  /// Prueba la suma de dígitos para diferentes tamaños de números
  static void testDigitSum() {
  debugPrint('=== Pruebas de Suma de Dígitos ===');
    
    // Número pequeño
    BigInt small = BigInt.from(123456789);
  debugPrint('Número pequeño: $small');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(small)}');
  debugPrint('Verificación manual: 1+2+3+4+5+6+7+8+9 = 45');
  debugPrint('');
    
    // Número mediano (50 dígitos)
    BigInt medium = BigInt.parse('12345678901234567890123456789012345678901234567890');
  debugPrint('Número mediano (50 dígitos): ${medium.toString().substring(0, 20)}...');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(medium)}');
  debugPrint('');
    
    // Número grande (100 dígitos)
    String largeNumStr = '1' * 100; // 100 unos
    BigInt large = BigInt.parse(largeNumStr);
  debugPrint('Número grande (100 dígitos): ${large.toString().substring(0, 20)}...');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(large)}');
  debugPrint('Verificación: 100 × 1 = 100');
  debugPrint('');
    
    // Número extremadamente grande (1000 dígitos)
    String extremeNumStr = '9' * 1000; // 1000 nueves
    BigInt extreme = BigInt.parse(extremeNumStr);
  debugPrint('Número extremadamente grande (1000 dígitos): ${extreme.toString().substring(0, 20)}...');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(extreme)}');
  debugPrint('Verificación: 1000 × 9 = 9000');
  debugPrint('');
    
    // Número con patrón mixto (500 dígitos)
    String patternNumStr = '123456789' * 55 + '12345'; // Patrón repetido
    BigInt pattern = BigInt.parse(patternNumStr);
  debugPrint('Número con patrón (500 dígitos): ${pattern.toString().substring(0, 20)}...');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(pattern)}');
  debugPrint('Verificación: 55 × (1+2+3+4+5+6+7+8+9) + (1+2+3+4+5) = 55 × 45 + 15 = 2475 + 15 = 2490');
  debugPrint('');
    
    // Número gigante (10000 dígitos)
    String giantNumStr = '2' * 10000; // 10000 doses
    BigInt giant = BigInt.parse(giantNumStr);
  debugPrint('Número gigante (10000 dígitos): ${giant.toString().substring(0, 20)}...');
  debugPrint('Suma de dígitos: ${NumberAnalysisService.digitSum(giant)}');
  debugPrint('Verificación: 10000 × 2 = 20000');
  debugPrint('');
    
  debugPrint('=== Todas las pruebas completadas ===');
  }
  
  /// Prueba la eficiencia de la suma de dígitos
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
  
  /// Prueba casos especiales
  static void testSpecialCases() {
  debugPrint('=== Casos Especiales ===');
    
    // Cero
    BigInt zero = BigInt.zero;
  debugPrint('Cero: ${NumberAnalysisService.digitSum(zero)}');
    
    // Número negativo
    BigInt negative = BigInt.from(-12345);
  debugPrint('Negativo (-12345): ${NumberAnalysisService.digitSum(negative)}');
    
    // Número con un solo dígito
    BigInt single = BigInt.from(7);
  debugPrint('Un dígito (7): ${NumberAnalysisService.digitSum(single)}');
    
    // Número muy grande que resulta en overflow si no se maneja bien
    BigInt veryLarge = BigInt.parse('9' * 100000);
  debugPrint('Muy grande (100000 dígitos): ${NumberAnalysisService.digitSum(veryLarge)}');
  debugPrint('Verificación: 100000 × 9 = 900000');
  }
  
  /// Ejecuta todas las pruebas
  static void runAllTests() {
  testDigitSum();
  debugPrint('');
  testDigitSumPerformance();
  debugPrint('');
  testSpecialCases();
  }
}

/// Extensión para acceder fácilmente a la suma de dígitos
extension BigIntDigitSum on BigInt {
  int get digitSum => NumberAnalysisService.digitSum(this);
}
