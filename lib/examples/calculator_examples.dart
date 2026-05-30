import 'package:super_calculadora/services/big_decimal.dart';
import 'package:super_calculadora/services/number_analysis_service.dart';
import 'package:flutter/foundation.dart';

/// Ejemplos de uso de la Super Calculadora
class SuperCalculadoraExamples {
  
  /// Ejemplos de operaciones con números grandes
  static void demonstrateBigNumbers() {
  debugPrint('=== SUPER CALCULADORA - EJEMPLOS DE NÚMEROS GRANDES ===\n');
    
    // Ejemplo 1: Número muy grande
    String largeNumber = '123456789012345678901234567890123456789012345678901234567890';
    BigDecimal big1 = BigDecimal.fromString(largeNumber);
  debugPrint('Número grande: $big1');
  debugPrint('Cuadrado: ${big1 * big1}');
  debugPrint('Representación binaria: ${big1.toBinary()}\n');
    
    // Ejemplo 2: Operaciones con decimales
    BigDecimal decimal1 = BigDecimal.fromString('123.456789012345678901234567890');
    BigDecimal decimal2 = BigDecimal.fromString('987.654321098765432109876543210');
  debugPrint('Decimal 1: $decimal1');
  debugPrint('Decimal 2: $decimal2');
  debugPrint('Suma: ${decimal1 + decimal2}');
  debugPrint('Multiplicación: ${decimal1 * decimal2}\n');
    
    // Ejemplo 3: Potencias grandes
    BigDecimal base = BigDecimal.fromString('2');
    BigDecimal result = base.pow(100);
  debugPrint('2^100 = $result');
  debugPrint('Número de dígitos: ${result.toString().length}\n');
  }
  
  /// Ejemplos de análisis de números
  static void demonstrateNumberAnalysis() {
  debugPrint('=== ANÁLISIS DE NÚMEROS ===\n');
    
    // Números primos grandes
    List<String> testNumbers = [
      '2147483647',  // Primo de Mersenne 2^31 - 1
      '1024',        // Potencia de 2
      '12321',       // Palíndromo
      '144',         // Cuadrado perfecto y Fibonacci
      '28',          // Número perfecto
      '153',         // Número narcisista
    ];
    
    for (String numStr in testNumbers) {
      BigInt number = BigInt.parse(numStr);
      Map<String, dynamic> analysis = NumberAnalysisService.completeAnalysis(number);
      
  debugPrint('Número: $numStr');
  debugPrint('Es primo: ${analysis['isPrime']}');
  debugPrint('Es palíndromo: ${analysis['isPalindrome']}');
  debugPrint('Es perfecto: ${analysis['isPerfect']}');
  debugPrint('Es Fibonacci: ${analysis['isFibonacci']}');
  debugPrint('Factores primos: ${analysis['primeFactors']}');
  debugPrint('Binario: ${analysis['binary']}');
  debugPrint('Hexadecimal: ${analysis['hexadecimal']}');
      
      if (analysis['perfectPower']['isPower'] == true) {
  debugPrint('Es potencia perfecta: ${analysis['perfectPower']['expression']}');
      }
      
  debugPrint('---\n');
    }
  }
  
  /// Ejemplos de conversiones
  static void demonstrateConversions() {
  debugPrint('=== CONVERSIONES ===\n');
    
    // Binario a decimal
    String binary = '1111111111111111111111111111111'; // 2^31 - 1
    BigInt fromBinary = BigInt.parse(binary, radix: 2);
  debugPrint('Binario: $binary');
  debugPrint('Decimal: $fromBinary');
  debugPrint('Hexadecimal: ${fromBinary.toRadixString(16).toUpperCase()}\n');
    
    // Decimal a otras bases
    BigInt decimal = BigInt.parse('255');
  debugPrint('Decimal: $decimal');
  debugPrint('Binario: ${decimal.toRadixString(2)}');
  debugPrint('Octal: ${decimal.toRadixString(8)}');
  debugPrint('Hexadecimal: ${decimal.toRadixString(16).toUpperCase()}\n');
  }
  
  /// Ejemplos de factorización
  static void demonstrateFactorization() {
  debugPrint('=== FACTORIZACIÓN ===\n');
    
    List<String> numbers = [
      '60',         // 2^2 × 3 × 5
      '1024',       // 2^10
      '1000000',    // 2^6 × 5^6
      '97',         // Primo
      '2310',       // 2 × 3 × 5 × 7 × 11
    ];
    
    for (String numStr in numbers) {
      BigInt number = BigInt.parse(numStr);
      List<BigInt> factors = NumberAnalysisService.primeFactorization(number);
      
  debugPrint('Número: $numStr');
  debugPrint('Factores primos: ${factors.join(' × ')}');
      
      // Verificar que la factorización es correcta
      BigInt product = factors.fold(BigInt.one, (a, b) => a * b);
  debugPrint('Verificación: $product == $number : ${product == number}');
  debugPrint('---\n');
    }
  }
  
  /// Ejemplos de números especiales
  static void demonstrateSpecialNumbers() {
  debugPrint('=== NÚMEROS ESPECIALES ===\n');
    
    // Números de Fibonacci
  debugPrint('Primeros 20 números de Fibonacci:');
    List<BigInt> fibonacci = NumberAnalysisService.fibonacciSequence(BigInt.parse('10000'));
  debugPrint(fibonacci.take(20).map((f) => f.toString()).join(', '));
  debugPrint('');
    
    // Números primos
  debugPrint('Primeros 10 números primos:');
    List<BigInt> primes = [];
    BigInt current = BigInt.two;
    
    while (primes.length < 10) {
      if (NumberAnalysisService.isPrime(current)) {
        primes.add(current);
      }
      current += BigInt.one;
    }
    
  debugPrint(primes.map((p) => p.toString()).join(', '));
  debugPrint('');
    
    // Números perfectos (son muy escasos)
  debugPrint('Verificando números perfectos hasta 10000:');
    List<BigInt> perfect = [];
    
    for (int i = 1; i <= 10000; i++) {
      if (NumberAnalysisService.isPerfectNumber(BigInt.from(i))) {
        perfect.add(BigInt.from(i));
      }
    }
    
  debugPrint('Números perfectos encontrados: ${perfect.map((p) => p.toString()).join(', ')}');
  debugPrint('');
    
    // Números palindrómicos
  debugPrint('Números palindrómicos de 3 dígitos:');
    List<BigInt> palindromes = [];
    
    for (int i = 100; i < 1000; i++) {
      if (NumberAnalysisService.isPalindrome(BigInt.from(i))) {
        palindromes.add(BigInt.from(i));
      }
    }
    
  debugPrint('Primeros 10: ${palindromes.take(10).map((p) => p.toString()).join(', ')}');
  debugPrint('');
  }
  
  /// Ejemplos de rendimiento con números extremadamente grandes
  static void demonstratePerformance() {
  debugPrint('=== RENDIMIENTO CON NÚMEROS EXTREMOS ===\n');
    
    // Número con 100 dígitos
    String huge = '1${'0' * 100}';
    BigInt hugeNumber = BigInt.parse(huge);
    
  debugPrint('Número con 101 dígitos: $hugeNumber');
  debugPrint('Cantidad de dígitos: ${hugeNumber.toString().length}');
    
    // Verificar si es potencia de 10
    Map<String, dynamic> powerInfo = NumberAnalysisService.isPerfectPower(hugeNumber);
    if (powerInfo['isPower'] == true) {
  debugPrint('Es potencia perfecta: ${powerInfo['expression']}');
    }
    
  debugPrint('Representación en otras bases:');
  debugPrint('Binario (primeros 50 bits): ${hugeNumber.toRadixString(2).substring(0, 50)}...');
  debugPrint('Hexadecimal: ${hugeNumber.toRadixString(16).toUpperCase()}');
  debugPrint('');
    
    // Operaciones con números grandes
    BigInt result = hugeNumber * hugeNumber;
  debugPrint('Cuadrado del número (dígitos): ${result.toString().length}');
    
    BigInt factorial = BigInt.one;
    for (int i = 1; i <= 50; i++) {
      factorial *= BigInt.from(i);
    }
  debugPrint('50! tiene ${factorial.toString().length} dígitos');
  debugPrint('50! = ${factorial.toString().substring(0, 50)}...');
  }
  
  /// Ejecutar todos los ejemplos
  static void runAllExamples() {
    demonstrateBigNumbers();
    demonstrateNumberAnalysis();
    demonstrateConversions();
    demonstrateFactorization();
    demonstrateSpecialNumbers();
    demonstratePerformance();
    
  debugPrint('\n=== FIN DE EJEMPLOS ===');
  debugPrint('¡Prueba estos números en la Super Calculadora!');
  }
}

void main() {
  // Ejecutar ejemplos si se ejecuta este archivo directamente
  SuperCalculadoraExamples.runAllExamples();
}
