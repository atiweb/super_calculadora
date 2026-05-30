import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'prime_utils.dart';
import 'big_decimal.dart';
import '../constants/numeric_precision.dart';

/// Clase para análisis avanzado de números
class NumberAnalysisService {
  /// Verifica si un número es primo (usa Miller-Rabin optimizado)
  /// Solo aplica a números enteros positivos > 1
  static bool isPrime(BigInt number) {
    // Convertir a parte entera del valor absoluto
    BigInt integerPart = number.abs();
    
    if (integerPart < BigInt.two) return false;
    if (integerPart == BigInt.two) return true;
    if (integerPart % BigInt.two == BigInt.zero) return false;
    
    // Usar el algoritmo optimizado de prime_utils.dart
    return isProbablyPrime(integerPart);
  }

  /// Verifica si un número es primo con información adicional sobre el procesamiento
  static Map<String, dynamic> isPrimeWithInfo(BigInt originalNumber) {
    BigInt integerPart = originalNumber.abs();
    
    Map<String, dynamic> result = {
      'originalNumber': originalNumber.toString(),
      'processedNumber': integerPart.toString(),
      'isPrime': false,
      'note': '',
    };
    
    // Agregar nota si el número fue modificado
    if (originalNumber != integerPart) {
      if (originalNumber < BigInt.zero) {
        result['note'] = 'Se usó el valor absoluto del número negativo';
      }
      // Nota: Para decimales, esto se manejaría en un nivel superior
    }
    
    // Verificar primalidad
    if (integerPart < BigInt.two) {
      result['isPrime'] = false;
      if (integerPart == BigInt.zero) {
        result['note'] = 'El cero no es primo';
      } else if (integerPart == BigInt.one) {
        result['note'] = 'El uno no es primo por definición';
      }
    } else {
      result['isPrime'] = isPrime(integerPart);
    }
    
    return result;
  }

  /// Encuentra el siguiente número primo (usa isolate para números grandes)
  /// Solo busca en números enteros positivos
  static Future<BigInt> nextPrimeAsync(BigInt number) async {
    BigInt integerPart = number.abs();
    if (integerPart < BigInt.two) return BigInt.two;
    
    // Para números grandes, usar el isolate optimizado
    if (integerPart > BigInt.from(1000000)) {
      String result = await findNextPrime(integerPart);
      return BigInt.parse(result);
    }
    
    // Para números pequeños, usar método directo
    return nextPrime(integerPart);
  }

  /// Encuentra el siguiente número primo (método síncrono para números pequeños)
  /// Solo busca en números enteros positivos
  static BigInt nextPrime(BigInt number) {
    BigInt integerPart = number.abs();
    if (integerPart < BigInt.two) return BigInt.two;
    
    BigInt candidate = integerPart + BigInt.one;
    if (candidate % BigInt.two == BigInt.zero) {
      candidate += BigInt.one;
    }
    
    while (!isPrime(candidate)) {
      candidate += BigInt.two;
    }
    
    return candidate;
  }

  /// Encuentra el número primo anterior (usa isolate para números grandes)
  /// Solo busca en números enteros positivos
  static Future<BigInt> previousPrimeAsync(BigInt number) async {
    BigInt integerPart = number.abs();
    if (integerPart <= BigInt.two) return BigInt.two;
    
    // Para números grandes, buscar de forma más eficiente
    if (integerPart > BigInt.from(1000000)) {
      BigInt candidate = integerPart - BigInt.one;
      if (candidate % BigInt.two == BigInt.zero) {
        candidate -= BigInt.one;
      }
      
      // Buscar en pasos más grandes para números muy grandes
      while (candidate > BigInt.two) {
        if (isProbablyPrime(candidate)) {
          return candidate;
        }
        candidate -= BigInt.two;
      }
      
      return BigInt.two;
    }
    
    // Para números pequeños, usar método directo
    return previousPrime(integerPart);
  }

  /// Encuentra el número primo anterior (método síncrono para números pequeños)
  /// Solo busca en números enteros positivos
  static BigInt previousPrime(BigInt number) {
    BigInt integerPart = number.abs();
    if (integerPart <= BigInt.two) return BigInt.two;
    
    BigInt candidate = integerPart - BigInt.one;
    if (candidate % BigInt.two == BigInt.zero) {
      candidate -= BigInt.one;
    }
    
    while (candidate > BigInt.two && !isPrime(candidate)) {
      candidate -= BigInt.two;
    }
    
    return candidate;
  }

  /// Descomposición en factores primos (optimizada para números grandes)
  static List<BigInt> primeFactorization(BigInt number) {
    if (number < BigInt.two) return [];
    
    List<BigInt> factors = [];
    BigInt n = number;
    
    // Dividir por 2
    while (n % BigInt.two == BigInt.zero) {
      factors.add(BigInt.two);
      n ~/= BigInt.two;
    }
    
    // Dividir por números impares, pero con límite para números muy grandes
    BigInt divisor = BigInt.from(3);
    BigInt limit = _sqrt(n);
    
    // Para números muy grandes, limitar la búsqueda
    if (limit > BigInt.from(1000000)) {
      limit = BigInt.from(1000000);
    }
    
    while (divisor <= limit && divisor * divisor <= n) {
      while (n % divisor == BigInt.zero) {
        factors.add(divisor);
        n ~/= divisor;
      }
      divisor += BigInt.two;
      
      // Si ya encontramos muchos factores, parar
      if (factors.length > 50) {
        break;
      }
    }
    
    // Si n es un primo mayor que 2
    if (n > BigInt.two) {
      factors.add(n);
    }
    
    return factors;
  }

  /// Verifica si es una potencia perfecta
  static Map<String, dynamic> isPerfectPower(BigInt number) {
    if (number < BigInt.two) return {'isPower': false};

    for (int exponent = 2; exponent <= 64; exponent++) {
      BigInt root = _nthRoot(number, exponent);
      if (root.pow(exponent) == number) {
        return {
          'isPower': true,
          'base': root,
          'exponent': exponent,
          'expression': '$root${_intToSuperscript(exponent)}'
        };
      }
    }

    return {'isPower': false};
  }

  /// Convierte un entero a cadena de superíndices Unicode (ej. 10 → '¹⁰')
  static String _intToSuperscript(int n) {
    const Map<String, String> s = {
      '0': '⁰', '1': '¹', '2': '²', '3': '³', '4': '⁴',
      '5': '⁵', '6': '⁶', '7': '⁷', '8': '⁸', '9': '⁹',
    };
    return n.toString().split('').map((d) => s[d] ?? d).join('');
  }

  /// Verifica si es un número palindrómico
  static bool isPalindrome(BigInt number) {
    String str = number.toString();
    return str == str.split('').reversed.join('');
  }

  /// Verifica si es un número perfecto (optimizado para números grandes)
  static bool isPerfectNumber(BigInt number) {
    if (number < BigInt.two) return false;
    
    // Para números muy grandes, no calcular (es computacionalmente costoso)
    if (number.toString().length > 10) {
      return false; // Asumimos que no es perfecto para números muy grandes
    }
    
    BigInt sum = BigInt.one;
    BigInt limit = _sqrt(number);
    
    for (BigInt i = BigInt.two; i <= limit; i += BigInt.one) {
      if (number % i == BigInt.zero) {
        sum += i;
        if (i != number ~/ i) {
          sum += number ~/ i;
        }
      }
    }
    
    return sum == number;
  }

  /// Obtiene todos los divisores (optimizado para números grandes)
  static List<BigInt> getDivisors(BigInt number) {
    if (number <= BigInt.zero) return [];
    
    List<BigInt> divisors = [];
    BigInt limit = _sqrt(number);
    
    // Para números muy grandes, limitar la búsqueda de divisores
    if (limit > BigInt.from(100000)) {
      limit = BigInt.from(100000);
    }
    
    for (BigInt i = BigInt.one; i <= limit; i += BigInt.one) {
      if (number % i == BigInt.zero) {
        divisors.add(i);
        if (i != number ~/ i) {
          divisors.add(number ~/ i);
        }
      }
      
      // Si ya encontramos muchos divisores, parar
      if (divisors.length > 100) {
        break;
      }
    }
    
    divisors.sort((a, b) => a.compareTo(b));
    return divisors;
  }

  /// Calcula el MCD (Máximo Común Divisor)
  static BigInt gcd(BigInt a, BigInt b) {
    a = a.abs();
    b = b.abs();
    while (b != BigInt.zero) {
      BigInt temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  /// Calcula el MCM (Mínimo Común Múltiplo)
  static BigInt lcm(BigInt a, BigInt b) {
    if (a == BigInt.zero || b == BigInt.zero) return BigInt.zero;
    return (a * b).abs() ~/ gcd(a, b);
  }

  /// Verifica si es un número de Fibonacci (optimizado para números grandes)
  static bool isFibonacci(BigInt number) {
    if (number < BigInt.zero) return false;
    if (number == BigInt.zero || number == BigInt.one) return true;
    
    // Usar la propiedad: n es Fibonacci si y solo si 5n²+4 o 5n²-4 es un cuadrado perfecto
    BigInt fiveNSquare = BigInt.from(5) * number * number;
    return _isPerfectSquare(fiveNSquare + BigInt.from(4)) ||
           _isPerfectSquare(fiveNSquare - BigInt.from(4));
  }

  /// Genera la secuencia de Fibonacci hasta el número dado
  static List<BigInt> fibonacciSequence(BigInt limit) {
    List<BigInt> sequence = [BigInt.zero, BigInt.one];
    
    while (true) {
      BigInt next = sequence[sequence.length - 1] + sequence[sequence.length - 2];
      if (next > limit) break;
      sequence.add(next);
    }
    
    return sequence;
  }

  /// Verifica si es un número triangular (optimizado para números grandes)
  static bool isTriangular(BigInt number) {
    if (number < BigInt.zero) return false;
    if (number == BigInt.zero) return true;
    
    // Formula: n es triangular si (8n + 1) es un cuadrado perfecto
    BigInt value = BigInt.from(8) * number + BigInt.one;
    if (!_isPerfectSquare(value)) return false;

    // Calcular raíz cuadrada y verificar que sea impar
    BigInt sqrtValue = _sqrtBigInt(value);
    return ((sqrtValue - BigInt.one) % BigInt.from(2)) == BigInt.zero;
  }

  /// Análisis completo de un número (versión síncrona - usa el asíncrono internamente)
  static Map<String, dynamic> completeAnalysis(BigInt number) {
    // Para mantener compatibilidad, llamar a la versión asíncrona pero de forma síncrona
    // Esto no es ideal pero mantiene la API existente
    int digits = number.toString().length;
    
    if (digits <= 20) {
      // Para números pequeños/medianos, usar método síncrono directo
      return _completeAnalysisSync(number);
    } else {
      // Para números grandes, devolver análisis básico inmediatamente
      return _completeAnalysisBasic(number);
    }
  }

  /// Análisis síncrono para números pequeños/medianos
  static Map<String, dynamic> _completeAnalysisSync(BigInt number) {
    Map<String, dynamic> analysis = {};
    
    try {
      // Propiedades básicas
      analysis['value'] = number.toString();
      analysis['isZero'] = number == BigInt.zero;
      analysis['isPositive'] = number > BigInt.zero;
      analysis['isNegative'] = number < BigInt.zero;
      analysis['isEven'] = number % BigInt.two == BigInt.zero;
      analysis['isOdd'] = number % BigInt.two != BigInt.zero;
      
      // Longitud y dígitos
      analysis['digitCount'] = number.toString().replaceAll('-', '').length;
      analysis['digitSum'] = _digitSum(number);
      
      // Representaciones
      analysis['binary'] = number.toRadixString(2);
      analysis['octal'] = number.toRadixString(8);
      analysis['hexadecimal'] = number.toRadixString(16).toUpperCase();
      
      // Análisis numérico
      if (number > BigInt.zero) {
        int digits = number.toString().length;
        
        analysis['isPrime'] = isPrime(number);
        analysis['isPalindrome'] = isPalindrome(number);
        analysis['perfectPower'] = isPerfectPower(number);
        analysis['isFibonacci'] = isFibonacci(number);
        analysis['isTriangular'] = isTriangular(number);
        
        // Verificar si es cuadrado perfecto y cubo perfecto
        analysis['isPerfectSquare'] = isPerfectSquare(number);
        analysis['isPerfectCube'] = isPerfectCube(number);
        
        if (digits <= 15) {
          // Análisis completo para números pequeños
          analysis['nextPrime'] = nextPrime(number).toString();
          analysis['previousPrime'] = previousPrime(number).toString();
          analysis['primeFactors'] = primeFactorization(number).map((f) => f.toString()).toList();
          analysis['divisors'] = getDivisors(number).map((d) => d.toString()).toList();
          analysis['isPerfect'] = isPerfectNumber(number);
        } else {
          // Análisis limitado para números medianos
          if (analysis['isPrime'] == true) {
            analysis['nextPrime'] = nextPrime(number).toString();
            analysis['previousPrime'] = previousPrime(number).toString();
            analysis['primeFactors'] = [number.toString()];
          } else {
            analysis['nextPrime'] = 'No es primo';
            analysis['previousPrime'] = 'No es primo';
            
            try {
              List<BigInt> factors = primeFactorization(number);
              if (factors.length <= 20) {
                analysis['primeFactors'] = factors.map((f) => f.toString()).toList();
              } else {
                analysis['primeFactors'] = ['Demasiados factores'];
              }
            } catch (e) {
              analysis['primeFactors'] = ['Factorización muy compleja'];
            }
          }
          
          analysis['isPerfect'] = false; // No calcular para números medianos
        }
      }
      
      // Operaciones matemáticas básicas
      try {
        if (number.toString().length <= 30) {
          analysis['square'] = (number * number).toString();
          analysis['cube'] = (number * number * number).toString();
        }
        
        if (number > BigInt.zero && number.toString().length <= 20) {
          // Mostrar raíces con decimales razonables para el panel
          try {
            final sqrtVal = BigDecimal.fromBigInt(number)
                .sqrt()
                .withPrecision(NumericPrecision.decimals)
                .toString();
            analysis['squareRoot'] = sqrtVal;
          } catch (_) {
            // Respaldo: al menos devolver la raíz entera
            analysis['squareRoot'] = _sqrt(number).toString();
          }

          try {
            final cbrtVal = BigDecimal.fromBigInt(number)
                .cbrt()
                .withPrecision(NumericPrecision.decimals)
                .toString();
            analysis['cubeRoot'] = cbrtVal;
          } catch (_) {
            // Respaldo: raíz cúbica entera aproximada
            analysis['cubeRoot'] = _nthRoot(number, 3).toString();
          }
        }
      } catch (e) {
        analysis['square'] = 'Error en cálculo';
        analysis['cube'] = 'Error en cálculo';
      }
      
    } catch (e) {
      analysis['error'] = 'Error en análisis: ${e.toString()}';
      analysis['value'] = number.toString();
      analysis['digitCount'] = number.toString().replaceAll('-', '').length;
    }
    
    return analysis;
  }

  /// Análisis básico para números muy grandes
  static Map<String, dynamic> _completeAnalysisBasic(BigInt number) {
    Map<String, dynamic> analysis = {};
    
    try {
      String numberStr = number.toString();
      int digitCount = numberStr.replaceAll('-', '').length;
      
      // Propiedades básicas (siempre calculables)
      analysis['value'] = numberStr;
      analysis['isZero'] = number == BigInt.zero;
      analysis['isPositive'] = number > BigInt.zero;
      analysis['isNegative'] = number < BigInt.zero;
      analysis['isEven'] = number % BigInt.two == BigInt.zero;
      analysis['isOdd'] = number % BigInt.two != BigInt.zero;
      
      // Longitud y dígitos
      analysis['digitCount'] = digitCount;
      
      // Suma de dígitos - siempre calculable, incluso para números muy grandes
      analysis['digitSum'] = _digitSum(number);
      
      // Representaciones (solo para números no extremadamente grandes)
      if (digitCount <= 100) {
        try {
          analysis['binary'] = number.toRadixString(2);
          analysis['octal'] = number.toRadixString(8);
          analysis['hexadecimal'] = number.toRadixString(16).toUpperCase();
        } catch (e) {
          analysis['binary'] = 'No calculado (muy grande)';
          analysis['octal'] = 'No calculado (muy grande)';
          analysis['hexadecimal'] = 'No calculado (muy grande)';
        }
      } else {
        analysis['binary'] = 'No calculado (número extremadamente grande)';
        analysis['octal'] = 'No calculado (número extremadamente grande)';
        analysis['hexadecimal'] = 'No calculado (número extremadamente grande)';
      }
      
      // Análisis limitado para números muy grandes
      if (number > BigInt.zero) {
        // Estas propiedades son eficientes incluso para números muy grandes
        try {
          analysis['isPrime'] = isPrime(number);
        } catch (e) {
          analysis['isPrime'] = false;
          analysis['primeNote'] = 'Error en verificación de primalidad';
        }
        
        try {
          analysis['isPalindrome'] = isPalindrome(number);
        } catch (e) {
          analysis['isPalindrome'] = false;
        }
        
        // Para números extremadamente grandes, no calcular estas propiedades
        if (digitCount <= 200) {
          analysis['isFibonacci'] = isFibonacci(number);
          analysis['isTriangular'] = isTriangular(number);
          
          // Verificar si es cuadrado perfecto y cubo perfecto
          analysis['isPerfectSquare'] = isPerfectSquare(number);
          analysis['isPerfectCube'] = isPerfectCube(number);
        } else {
          analysis['isFibonacci'] = false;
          analysis['isTriangular'] = false;
          analysis['largeNumberNote'] = 'Algunas propiedades no calculadas debido al tamaño extremo';
        }
        
        // Propiedades que no se calculan para números muy grandes
        analysis['perfectPower'] = {'isPower': false, 'reason': 'Número muy grande'};
        analysis['primeFactors'] = ['No calculado (número muy grande)'];
        analysis['divisors'] = ['No calculado (número muy grande)'];
        analysis['isPerfect'] = false;
        
        // Los primos se calcularán de forma asíncrona en el CalculatorService
        analysis['nextPrime'] = 'Calculando...';
        analysis['previousPrime'] = 'Calculando...';
        
        // Operaciones matemáticas básicas
        if (digitCount <= 50) {
          try {
            analysis['square'] = (number * number).toString();
          } catch (e) {
            analysis['square'] = 'Error en cálculo';
          }
          
          try {
            analysis['cube'] = (number * number * number).toString();
          } catch (e) {
            analysis['cube'] = 'Error en cálculo';
          }
        } else {
          analysis['square'] = 'No calculado (resultado muy grande)';
          analysis['cube'] = 'No calculado (resultado muy grande)';
        }
        
        // Raíces no se calculan para números muy grandes
        analysis['squareRoot'] = 'No calculado (número muy grande)';
        analysis['cubeRoot'] = 'No calculado (número muy grande)';
      }
      
    } catch (e) {
      // En caso de error, devolver información básica
      analysis['error'] = 'Error en análisis: ${e.toString()}';
      analysis['value'] = number.toString();
      analysis['digitCount'] = number.toString().replaceAll('-', '').length;
      analysis['isZero'] = number == BigInt.zero;
      analysis['isPositive'] = number > BigInt.zero;
      analysis['isNegative'] = number < BigInt.zero;
      analysis['isEven'] = number % BigInt.two == BigInt.zero;
      analysis['isOdd'] = number % BigInt.two != BigInt.zero;
      analysis['errorNote'] = 'Se produjo un error durante el análisis. Mostrando información básica.';
    }
    
    return analysis;
  }

  /// Verifica si un número es un cuadrado perfecto
  static bool isPerfectSquare(BigInt number) {
    if (number < BigInt.zero) return false;
    if (number == BigInt.zero || number == BigInt.one) return true;
    
    try {
      // Para números grandes, usar búsqueda binaria
      if (number.toString().length > 15) {
        return _isPerfectSquareBinarySearch(number);
      }
      
      // Para números pequeños, usar método directo
      BigInt sqrt = _integerSquareRoot(number);
      return sqrt * sqrt == number;
    } catch (e) {
      return false;
    }
  }

  /// Verifica si un número es un cubo perfecto
  static bool isPerfectCube(BigInt number) {
    if (number < BigInt.zero) {
      // Los números negativos pueden ser cubos perfectos de números negativos
      BigInt absNumber = number.abs();
      return isPerfectCube(absNumber);
    }
    if (number == BigInt.zero || number == BigInt.one) return true;
    
    try {
      // Para números grandes, usar búsqueda binaria
      if (number.toString().length > 15) {
        return _isPerfectCubeBinarySearch(number);
      }
      
      // Para números pequeños, usar método directo
      BigInt cubeRoot = _integerCubeRoot(number);
      return cubeRoot * cubeRoot * cubeRoot == number;
    } catch (e) {
      return false;
    }
  }

  /// Calcula la raíz cuadrada entera usando el método de Newton
  static BigInt _integerSquareRoot(BigInt number) {
    if (number < BigInt.zero) throw ArgumentError('Square root of negative number');
    if (number == BigInt.zero) return BigInt.zero;
    if (number == BigInt.one) return BigInt.one;
    
    BigInt x = number;
    BigInt y = (x + BigInt.one) ~/ BigInt.two;
    
    while (y < x) {
      x = y;
      y = (x + number ~/ x) ~/ BigInt.two;
    }
    
    return x;
  }

  /// Calcula la raíz cúbica entera usando búsqueda binaria
  static BigInt _integerCubeRoot(BigInt number) {
    if (number < BigInt.zero) throw ArgumentError('Cube root of negative number');
    if (number == BigInt.zero) return BigInt.zero;
    if (number == BigInt.one) return BigInt.one;
    
    BigInt low = BigInt.zero;
    BigInt high = number;
    
    while (low <= high) {
      BigInt mid = (low + high) ~/ BigInt.two;
      BigInt cube = mid * mid * mid;
      
      if (cube == number) {
        return mid;
      } else if (cube < number) {
        low = mid + BigInt.one;
      } else {
        high = mid - BigInt.one;
      }
    }
    
    return high;
  }

  /// Verifica si un número grande es cuadrado perfecto usando búsqueda binaria
  static bool _isPerfectSquareBinarySearch(BigInt number) {
    BigInt low = BigInt.zero;
    BigInt high = number;
    
    // Optimización: reducir el rango de búsqueda
    if (number > BigInt.from(1000000)) {
      // Para números muy grandes, empezar con una estimación mejor
      int digits = number.toString().length;
      int sqrtDigits = (digits + 1) ~/ 2;
      high = BigInt.parse('1${'0' * sqrtDigits}');
    }
    
    while (low <= high) {
      BigInt mid = (low + high) ~/ BigInt.two;
      BigInt square = mid * mid;
      
      if (square == number) {
        return true;
      } else if (square < number) {
        low = mid + BigInt.one;
      } else {
        high = mid - BigInt.one;
      }
    }
    
    return false;
  }

  /// Verifica si un número grande es cubo perfecto usando búsqueda binaria
  static bool _isPerfectCubeBinarySearch(BigInt number) {
    BigInt low = BigInt.zero;
    BigInt high = number;
    
    // Optimización: reducir el rango de búsqueda
    if (number > BigInt.from(1000000)) {
      // Para números muy grandes, empezar con una estimación mejor
      int digits = number.toString().length;
      int cubeRootDigits = (digits + 2) ~/ 3;
      high = BigInt.parse('1${'0' * cubeRootDigits}');
    }
    
    while (low <= high) {
      BigInt mid = (low + high) ~/ BigInt.two;
      BigInt cube = mid * mid * mid;
      
      if (cube == number) {
        return true;
      } else if (cube < number) {
        low = mid + BigInt.one;
      } else {
        high = mid - BigInt.one;
      }
    }
    
    return false;
  }

  /// Verifica si un número es cuadrado perfecto de forma asíncrona (para números muy grandes)
  static Future<bool> isPerfectSquareAsync(BigInt number) async {
    if (number < BigInt.zero) return false;
    if (number == BigInt.zero || number == BigInt.one) return true;
    
    // Para números extremadamente grandes, usar compute para evitar bloquear la UI
    if (number.toString().length > 1000) {
      return await compute(_isPerfectSquareInIsolate, number.toString());
    }
    
    return isPerfectSquare(number);
  }

  /// Verifica si un número es cubo perfecto de forma asíncrona (para números muy grandes)
  static Future<bool> isPerfectCubeAsync(BigInt number) async {
    if (number < BigInt.zero) {
      BigInt absNumber = number.abs();
      return await isPerfectCubeAsync(absNumber);
    }
    if (number == BigInt.zero || number == BigInt.one) return true;
    
    // Para números extremadamente grandes, usar compute para evitar bloquear la UI
    if (number.toString().length > 1000) {
      return await compute(_isPerfectCubeInIsolate, number.toString());
    }
    
    return isPerfectCube(number);
  }

  /// Función para ejecutar en isolate - cuadrado perfecto
  static bool _isPerfectSquareInIsolate(String numberStr) {
    try {
      BigInt number = BigInt.parse(numberStr);
      return isPerfectSquare(number);
    } catch (e) {
      return false;
    }
  }

  /// Función para ejecutar en isolate - cubo perfecto
  static bool _isPerfectCubeInIsolate(String numberStr) {
    try {
      BigInt number = BigInt.parse(numberStr);
      return isPerfectCube(number);
    } catch (e) {
      return false;
    }
  }

  /// Calcula la suma de los dígitos de un número (método público)
  static int digitSum(BigInt number) {
    return _digitSum(number);
  }

  /// Calcula la suma de los dígitos de forma asíncrona (para números extremadamente grandes)
  static Future<int> digitSumAsync(BigInt number) async {
    String numStr = number.toString().replaceAll('-', '');
    
    // Si el número es muy grande, usar isolate
    if (numStr.length > 50000) {
      return await compute(_digitSumInIsolate, numStr);
    } else {
      // Para números más pequeños, usar método directo
      return _digitSum(number);
    }
  }

  /// Función para calcular suma de dígitos en isolate
  static int _digitSumInIsolate(String numStr) {
    int sum = 0;
    for (int i = 0; i < numStr.length; i++) {
      sum += int.parse(numStr[i]);
    }
    return sum;
  }

  /// Verifica si un número es un cuadrado perfecto (optimizado para números grandes)
  static bool _isPerfectSquare(BigInt n) {
    if (n < BigInt.zero) return false;
    if (n == BigInt.zero || n == BigInt.one) return true;
    
    BigInt low = BigInt.zero;
    BigInt high = n;

    while (low <= high) {
      BigInt mid = (low + high) >> 1;
      BigInt square = mid * mid;
      if (square == n) return true;
      if (square < n) {
        low = mid + BigInt.one;
      } else {
        high = mid - BigInt.one;
      }
    }
    return false;
  }

  /// Calcula la raíz cuadrada de un BigInt (optimizado para números grandes)
  static BigInt _sqrtBigInt(BigInt n) {
    if (n < BigInt.zero) throw ArgumentError('Raíz cuadrada de número negativo');
    if (n == BigInt.zero || n == BigInt.one) return n;
    
    BigInt low = BigInt.zero;
    BigInt high = n;
    
    while (low <= high) {
      BigInt mid = (low + high) >> 1;
      BigInt midSquared = mid * mid;
      if (midSquared == n) return mid;
      if (midSquared < n) {
        low = mid + BigInt.one;
      } else {
        high = mid - BigInt.one;
      }
    }
    return high;
  }

  /// Potencia segura que evita overflow
  static BigInt _safePow(BigInt base, int exponent) {
    if (exponent == 0) return BigInt.one;
    if (exponent == 1) return base;
    
    BigInt result = BigInt.one;
    BigInt currentBase = base;
    
    while (exponent > 0) {
      if (exponent % 2 == 1) {
        result *= currentBase;
      }
      currentBase *= currentBase;
      exponent ~/= 2;
      
      // Si el resultado se vuelve muy grande, parar
      if (result.toString().length > 1000) {
        break;
      }
    }
    
    return result;
  }

  static BigInt _sqrt(BigInt number) {
    if (number < BigInt.zero) throw ArgumentError('Raíz cuadrada de número negativo');
    if (number == BigInt.zero) return BigInt.zero;
    if (number == BigInt.one) return BigInt.one;
    
    BigInt x = number;
    BigInt y = (x + BigInt.one) ~/ BigInt.two;
    
    while (y < x) {
      x = y;
      y = (x + number ~/ x) ~/ BigInt.two;
    }
    
    return x;
  }

  static BigInt _nthRoot(BigInt number, int n) {
    if (number < BigInt.zero && n % 2 == 0) {
      throw ArgumentError('Raíz par de número negativo');
    }
    
    if (number == BigInt.zero) return BigInt.zero;
    if (number == BigInt.one) return BigInt.one;
    if (n == 1) return number;
    
    // Para números muy grandes, usar aproximación logarítmica
    if (number.toString().length > 100) {
      // Aproximación usando logaritmos
      double logValue = number.toString().length * math.log(10) / n;
      double approx = math.exp(logValue);
      return BigInt.from(approx.floor());
    }
    
    BigInt x = number;
    BigInt nBig = BigInt.from(n);
    BigInt nMinus1 = BigInt.from(n - 1);
    
    int maxIterations = 100; // Limitar iteraciones para evitar bucles infinitos
    int iteration = 0;
    
    while (iteration < maxIterations) {
      BigInt y = (nMinus1 * x + number ~/ _safePow(x, n - 1)) ~/ nBig;
      if (y >= x) break;
      x = y;
      iteration++;
    }
    
    return x;
  }

  /// Calcula la suma de los dígitos de un número (optimizado para números grandes)
  static int _digitSum(BigInt number) {
    String numStr = number.toString().replaceAll('-', '');
    
    // Para números muy grandes, usar un enfoque más eficiente
    if (numStr.length > 10000) {
      // Procesar en chunks para evitar problemas de memoria
      int sum = 0;
      const int chunkSize = 1000;
      
      for (int i = 0; i < numStr.length; i += chunkSize) {
        int endIndex = (i + chunkSize < numStr.length) ? i + chunkSize : numStr.length;
        String chunk = numStr.substring(i, endIndex);
        
        for (int j = 0; j < chunk.length; j++) {
          sum += int.parse(chunk[j]);
        }
      }
      
      return sum;
    } else {
      // Para números más pequeños, usar el método directo
      return numStr.split('').map(int.parse).reduce((a, b) => a + b);
    }
  }
}
