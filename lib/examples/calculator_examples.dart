import 'package:super_calculadora/services/big_decimal.dart';
import 'package:super_calculadora/services/number_analysis_service.dart';
import 'package:flutter/foundation.dart';

/// Usage examples for the Super Calculadora
class SuperCalculadoraExamples {
  
  /// Examples of operations with big numbers
  static void demonstrateBigNumbers() {
  debugPrint('=== SUPER CALCULADORA - EJEMPLOS DE NÚMEROS GRANDES ===\n');
    
    // Example 1: Very large number
    String largeNumber = '123456789012345678901234567890123456789012345678901234567890';
    BigDecimal big1 = BigDecimal.fromString(largeNumber);
  debugPrint('Número grande: $big1');
  debugPrint('Cuadrado: ${big1 * big1}');
  debugPrint('Representación binaria: ${big1.toBinary()}\n');
    
    // Example 2: Operations with decimals
    BigDecimal decimal1 = BigDecimal.fromString('123.456789012345678901234567890');
    BigDecimal decimal2 = BigDecimal.fromString('987.654321098765432109876543210');
  debugPrint('Decimal 1: $decimal1');
  debugPrint('Decimal 2: $decimal2');
  debugPrint('Suma: ${decimal1 + decimal2}');
  debugPrint('Multiplicación: ${decimal1 * decimal2}\n');
    
    // Example 3: Large powers
    BigDecimal base = BigDecimal.fromString('2');
    BigDecimal result = base.pow(100);
  debugPrint('2^100 = $result');
  debugPrint('Número de dígitos: ${result.toString().length}\n');
  }
  
  /// Number analysis examples
  static void demonstrateNumberAnalysis() {
  debugPrint('=== ANÁLISIS DE NÚMEROS ===\n');
    
    // Large prime numbers
    List<String> testNumbers = [
      '2147483647',  // Mersenne prime 2^31 - 1
      '1024',        // Power of 2
      '12321',       // Palindrome
      '144',         // Perfect square and Fibonacci
      '28',          // Perfect number
      '153',         // Narcissistic number
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
  
  /// Conversion examples
  static void demonstrateConversions() {
  debugPrint('=== CONVERSIONES ===\n');
    
    // Binary to decimal
    String binary = '1111111111111111111111111111111'; // 2^31 - 1
    BigInt fromBinary = BigInt.parse(binary, radix: 2);
  debugPrint('Binario: $binary');
  debugPrint('Decimal: $fromBinary');
  debugPrint('Hexadecimal: ${fromBinary.toRadixString(16).toUpperCase()}\n');
    
    // Decimal to other bases
    BigInt decimal = BigInt.parse('255');
  debugPrint('Decimal: $decimal');
  debugPrint('Binario: ${decimal.toRadixString(2)}');
  debugPrint('Octal: ${decimal.toRadixString(8)}');
  debugPrint('Hexadecimal: ${decimal.toRadixString(16).toUpperCase()}\n');
  }
  
  /// Factorization examples
  static void demonstrateFactorization() {
  debugPrint('=== FACTORIZACIÓN ===\n');
    
    List<String> numbers = [
      '60',         // 2^2 × 3 × 5
      '1024',       // 2^10
      '1000000',    // 2^6 × 5^6
      '97',         // Prime
      '2310',       // 2 × 3 × 5 × 7 × 11
    ];
    
    for (String numStr in numbers) {
      BigInt number = BigInt.parse(numStr);
      List<BigInt> factors = NumberAnalysisService.primeFactorization(number);
      
  debugPrint('Número: $numStr');
  debugPrint('Factores primos: ${factors.join(' × ')}');
      
      // Verify that the factorization is correct
      BigInt product = factors.fold(BigInt.one, (a, b) => a * b);
  debugPrint('Verificación: $product == $number : ${product == number}');
  debugPrint('---\n');
    }
  }
  
  /// Special numbers examples
  static void demonstrateSpecialNumbers() {
  debugPrint('=== NÚMEROS ESPECIALES ===\n');
    
    // Fibonacci numbers
  debugPrint('Primeros 20 números de Fibonacci:');
    List<BigInt> fibonacci = NumberAnalysisService.fibonacciSequence(BigInt.parse('10000'));
  debugPrint(fibonacci.take(20).map((f) => f.toString()).join(', '));
  debugPrint('');
    
    // Prime numbers
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
    
    // Perfect numbers (they are very scarce)
  debugPrint('Verificando números perfectos hasta 10000:');
    List<BigInt> perfect = [];
    
    for (int i = 1; i <= 10000; i++) {
      if (NumberAnalysisService.isPerfectNumber(BigInt.from(i))) {
        perfect.add(BigInt.from(i));
      }
    }
    
  debugPrint('Números perfectos encontrados: ${perfect.map((p) => p.toString()).join(', ')}');
  debugPrint('');
    
    // Palindromic numbers
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
  
  /// Performance examples with extremely large numbers
  static void demonstratePerformance() {
  debugPrint('=== RENDIMIENTO CON NÚMEROS EXTREMOS ===\n');
    
    // Number with 100 digits
    String huge = '1${'0' * 100}';
    BigInt hugeNumber = BigInt.parse(huge);
    
  debugPrint('Número con 101 dígitos: $hugeNumber');
  debugPrint('Cantidad de dígitos: ${hugeNumber.toString().length}');
    
    // Check whether it is a power of 10
    Map<String, dynamic> powerInfo = NumberAnalysisService.isPerfectPower(hugeNumber);
    if (powerInfo['isPower'] == true) {
  debugPrint('Es potencia perfecta: ${powerInfo['expression']}');
    }
    
  debugPrint('Representación en otras bases:');
  debugPrint('Binario (primeros 50 bits): ${hugeNumber.toRadixString(2).substring(0, 50)}...');
  debugPrint('Hexadecimal: ${hugeNumber.toRadixString(16).toUpperCase()}');
  debugPrint('');
    
    // Operations with big numbers
    BigInt result = hugeNumber * hugeNumber;
  debugPrint('Cuadrado del número (dígitos): ${result.toString().length}');
    
    BigInt factorial = BigInt.one;
    for (int i = 1; i <= 50; i++) {
      factorial *= BigInt.from(i);
    }
  debugPrint('50! tiene ${factorial.toString().length} dígitos');
  debugPrint('50! = ${factorial.toString().substring(0, 50)}...');
  }
  
  /// Run all examples
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
  // Run the examples if this file is executed directly
  SuperCalculadoraExamples.runAllExamples();
}
