import 'package:flutter/foundation.dart';
import 'prime_utils.dart';
import 'big_decimal.dart';
import '../constants/numeric_precision.dart';
import '../utils/app_locale.dart';

/// Class for advanced number analysis
class NumberAnalysisService {
  /// Checks whether a number is prime (uses optimized Miller-Rabin)
  /// Only applies to positive integers > 1
  static bool isPrime(BigInt number) {
    // Convert to the integer part of the absolute value
    BigInt integerPart = number.abs();
    
    if (integerPart < BigInt.two) return false;
    if (integerPart == BigInt.two) return true;
    if (integerPart % BigInt.two == BigInt.zero) return false;
    
    // Use the optimized algorithm from prime_utils.dart
    return isProbablyPrime(integerPart);
  }

  /// Checks whether a number is prime with additional processing information
  static Map<String, dynamic> isPrimeWithInfo(BigInt originalNumber) {
    BigInt integerPart = originalNumber.abs();
    
    Map<String, dynamic> result = {
      'originalNumber': originalNumber.toString(),
      'processedNumber': integerPart.toString(),
      'isPrime': false,
      'note': '',
    };
    
    // Add a note if the number was modified
    if (originalNumber != integerPart) {
      if (originalNumber < BigInt.zero) {
        result['note'] = trLocale('Se usó el valor absoluto del número negativo', 'Used the absolute value of the negative number');
      }
      // Note: For decimals, this would be handled at a higher level
    }
    
    // Check primality
    if (integerPart < BigInt.two) {
      result['isPrime'] = false;
      if (integerPart == BigInt.zero) {
        result['note'] = trLocale('El cero no es primo', 'Zero is not prime');
      } else if (integerPart == BigInt.one) {
        result['note'] = trLocale('El uno no es primo por definición', 'One is not prime by definition');
      }
    } else {
      result['isPrime'] = isPrime(integerPart);
    }
    
    return result;
  }

  /// Finds the next prime number (uses an isolate for large numbers)
  /// Only searches among positive integers
  static Future<BigInt> nextPrimeAsync(BigInt number) async {
    BigInt integerPart = number.abs();
    if (integerPart < BigInt.two) return BigInt.two;
    
    // For large numbers, use the optimized isolate
    if (integerPart > BigInt.from(1000000)) {
      String result = await findNextPrime(integerPart);
      return BigInt.parse(result);
    }
    
    // For small numbers, use the direct method
    return nextPrime(integerPart);
  }

  /// Finds the next prime number (synchronous method for small numbers)
  /// Only searches among positive integers
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

  /// Finds the previous prime number (uses an isolate for large numbers)
  /// Only searches among positive integers
  static Future<BigInt> previousPrimeAsync(BigInt number) async {
    BigInt integerPart = number.abs();
    if (integerPart <= BigInt.two) return BigInt.two;
    
    // For large numbers, search more efficiently
    if (integerPart > BigInt.from(1000000)) {
      BigInt candidate = integerPart - BigInt.one;
      if (candidate % BigInt.two == BigInt.zero) {
        candidate -= BigInt.one;
      }
      
      // Search in larger steps for very large numbers
      while (candidate > BigInt.two) {
        if (isProbablyPrime(candidate)) {
          return candidate;
        }
        candidate -= BigInt.two;
      }
      
      return BigInt.two;
    }
    
    // For small numbers, use the direct method
    return previousPrime(integerPart);
  }

  /// Finds the previous prime number (synchronous method for small numbers)
  /// Only searches among positive integers
  static BigInt previousPrime(BigInt number) {
    BigInt integerPart = number.abs();
    // ≤ 3: the previous one is 2 (with just `<= 2`, previousPrime(3) went
    // down to candidate 1 and returned it as "prime").
    if (integerPart <= BigInt.from(3)) return BigInt.two;

    BigInt candidate = integerPart - BigInt.one;
    if (candidate % BigInt.two == BigInt.zero) {
      candidate -= BigInt.one;
    }
    
    while (candidate > BigInt.two && !isPrime(candidate)) {
      candidate -= BigInt.two;
    }
    
    return candidate;
  }

  /// Prime factorization, complete and correct.
  ///
  /// Trial division up to 10⁵ and, for the composite remainder, Pollard-rho.
  /// The previous version stopped at 10⁶ and added the composite remainder as
  /// if it were prime: 1000036000099 (= 1000003 × 1000033) was reported as its
  /// own "prime factor" while isPrime said it was composite.
  static List<BigInt> primeFactorization(BigInt number) {
    if (number < BigInt.two) return [];

    List<BigInt> factors = [];
    BigInt n = number;

    // Divide by 2
    while (n % BigInt.two == BigInt.zero) {
      factors.add(BigInt.two);
      n ~/= BigInt.two;
    }

    // Trial division by small odd numbers (cheap and removes most factors)
    BigInt divisor = BigInt.from(3);
    final BigInt trialLimit = BigInt.from(100000);
    while (divisor <= trialLimit && divisor * divisor <= n) {
      while (n % divisor == BigInt.zero) {
        factors.add(divisor);
        n ~/= divisor;
      }
      divisor += BigInt.two;
    }

    // Remainder: prime → add; composite → factor with Pollard-rho
    if (n > BigInt.one) {
      _factorCompletely(n, factors);
    }

    factors.sort((a, b) => a.compareTo(b));
    return factors;
  }

  /// Factors [n] (odd, with no factors ≤ 10⁵) recursively into [factors].
  static void _factorCompletely(BigInt n, List<BigInt> factors) {
    if (n == BigInt.one) return;
    if (isPrime(n)) {
      factors.add(n);
      return;
    }
    final BigInt d = _pollardRho(n);
    _factorCompletely(d, factors);
    _factorCompletely(n ~/ d, factors);
  }

  /// Finds a non-trivial divisor of an odd composite via
  /// Pollard-rho (Floyd), retrying with another constant if it degenerates.
  static BigInt _pollardRho(BigInt n) {
    BigInt c = BigInt.one;
    while (true) {
      BigInt x = BigInt.two;
      BigInt y = BigInt.two;
      BigInt d = BigInt.one;
      while (d == BigInt.one) {
        x = (x * x + c) % n;
        y = (y * y + c) % n;
        y = (y * y + c) % n;
        d = gcd((x - y).abs(), n);
      }
      if (d != n) return d;
      c += BigInt.one;
    }
  }

  /// Checks whether it is a perfect power
  static Map<String, dynamic> isPerfectPower(BigInt number) {
    if (number < BigInt.two) return {'isPower': false};

    // Up to bitLength, not a fixed 64: the largest possible exponent is
    // log2(n) (base 2), so capping at 64 misclassified 2^67 as "not a power".
    for (int exponent = 2; exponent <= number.bitLength; exponent++) {
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

  /// Converts an integer to a Unicode superscript string (e.g. 10 → '¹⁰')
  static String _intToSuperscript(int n) {
    const Map<String, String> s = {
      '0': '⁰', '1': '¹', '2': '²', '3': '³', '4': '⁴',
      '5': '⁵', '6': '⁶', '7': '⁷', '8': '⁸', '9': '⁹',
    };
    return n.toString().split('').map((d) => s[d] ?? d).join('');
  }

  /// Checks whether it is a palindromic number
  static bool isPalindrome(BigInt number) {
    String str = number.toString();
    return str == str.split('').reversed.join('');
  }

  /// Checks whether it is a perfect number.
  ///
  /// Uses the Euclid–Euler theorem: every even perfect number has the form
  /// 2^(a)·(2^(a+1) − 1) where 2^(a+1) − 1 is prime (a Mersenne prime). This
  /// allows an exact and instantaneous check even for huge perfect
  /// numbers. No odd perfect numbers are known (it has been proven that,
  /// if any exist, they exceed 10^1500), so for odd numbers an exact
  /// verification is done only when the number is small, and `false` is
  /// returned otherwise.
  static bool isPerfectNumber(BigInt number) {
    if (number < BigInt.from(6)) return false; // the smallest perfect number is 6

    if (number.isEven) {
      // number = 2^a · m with m odd (a ≥ 1). It is perfect ⟺ m = 2^(a+1) − 1
      // and m is prime.
      int a = 0;
      BigInt m = number;
      while (m.isEven) {
        m >>= 1;
        a++;
      }
      final BigInt mersenne = (BigInt.one << (a + 1)) - BigInt.one;
      return m == mersenne && isPrime(m);
    }

    // Odd: no perfect one is known. Exact verification only for
    // manageable numbers; for the rest we return `false` (correct per the
    // known lower bound of 10^1500), avoiding a prohibitive computation.
    if (number > BigInt.from(100000000)) return false;
    BigInt sum = BigInt.one;
    final BigInt limit = _sqrt(number);
    for (BigInt i = BigInt.from(3); i <= limit; i += BigInt.two) {
      if (number % i == BigInt.zero) {
        sum += i;
        final BigInt q = number ~/ i;
        if (q != i) sum += q;
      }
    }
    return sum == number;
  }

  /// Gets all divisors, generated from the (complete) prime
  /// factorization. The previous sweep stopped at 10⁵, so a semiprime
  /// with large factors was "missing" its non-trivial divisors.
  static List<BigInt> getDivisors(BigInt number) {
    if (number <= BigInt.zero) return [];
    if (number == BigInt.one) return [BigInt.one];

    // Group prime factors: p → exponent
    final Map<BigInt, int> powers = {};
    for (final BigInt f in primeFactorization(number)) {
      powers[f] = (powers[f] ?? 0) + 1;
    }

    List<BigInt> divisors = [BigInt.one];
    powers.forEach((p, e) {
      final List<BigInt> extended = [];
      BigInt pk = BigInt.one;
      for (int k = 0; k <= e; k++) {
        for (final BigInt d in divisors) {
          extended.add(d * pk);
        }
        pk *= p;
      }
      divisors = extended;
    });

    divisors.sort((a, b) => a.compareTo(b));
    return divisors;
  }

  /// Computes the GCD (Greatest Common Divisor)
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

  /// Computes the LCM (Least Common Multiple)
  static BigInt lcm(BigInt a, BigInt b) {
    if (a == BigInt.zero || b == BigInt.zero) return BigInt.zero;
    return (a * b).abs() ~/ gcd(a, b);
  }

  /// Checks whether it is a Fibonacci number (optimized for large numbers)
  static bool isFibonacci(BigInt number) {
    if (number < BigInt.zero) return false;
    if (number == BigInt.zero || number == BigInt.one) return true;
    
    // Use the property: n is Fibonacci if and only if 5n²+4 or 5n²-4 is a perfect square
    BigInt fiveNSquare = BigInt.from(5) * number * number;
    return _isPerfectSquare(fiveNSquare + BigInt.from(4)) ||
           _isPerfectSquare(fiveNSquare - BigInt.from(4));
  }

  /// Generates the Fibonacci sequence up to the given number
  static List<BigInt> fibonacciSequence(BigInt limit) {
    // The seeds were exempt from the limit, so a limit below 1 still returned
    // [0, 1] — elements greater than the bound the caller asked for.
    if (limit < BigInt.zero) return [];
    if (limit < BigInt.one) return [BigInt.zero];

    List<BigInt> sequence = [BigInt.zero, BigInt.one];

    while (true) {
      BigInt next = sequence[sequence.length - 1] + sequence[sequence.length - 2];
      if (next > limit) break;
      sequence.add(next);
    }
    
    return sequence;
  }

  /// Checks whether it is a triangular number (optimized for large numbers)
  static bool isTriangular(BigInt number) {
    if (number < BigInt.zero) return false;
    if (number == BigInt.zero) return true;
    
    // Formula: n is triangular if (8n + 1) is a perfect square
    BigInt value = BigInt.from(8) * number + BigInt.one;
    if (!_isPerfectSquare(value)) return false;

    // Compute the square root and verify it is odd
    BigInt sqrtValue = _sqrtBigInt(value);
    return ((sqrtValue - BigInt.one) % BigInt.from(2)) == BigInt.zero;
  }

  /// Complete analysis of a number (synchronous version - uses the async one internally)
  static Map<String, dynamic> completeAnalysis(BigInt number) {
    // To keep compatibility, call the asynchronous version but in a synchronous way
    // This is not ideal but keeps the existing API
    int digits = number.toString().length;
    
    if (digits <= 20) {
      // For small/medium numbers, use the direct synchronous method
      return _completeAnalysisSync(number);
    } else {
      // For large numbers, return a basic analysis immediately
      return _completeAnalysisBasic(number);
    }
  }

  /// Synchronous analysis for small/medium numbers
  static Map<String, dynamic> _completeAnalysisSync(BigInt number) {
    Map<String, dynamic> analysis = {};
    
    try {
      // Basic properties
      analysis['value'] = number.toString();
      analysis['isZero'] = number == BigInt.zero;
      analysis['isPositive'] = number > BigInt.zero;
      analysis['isNegative'] = number < BigInt.zero;
      analysis['isEven'] = number % BigInt.two == BigInt.zero;
      analysis['isOdd'] = number % BigInt.two != BigInt.zero;
      
      // Length and digits
      analysis['digitCount'] = number.toString().replaceAll('-', '').length;
      analysis['digitSum'] = _digitSum(number);
      
      // Representations
      analysis['binary'] = number.toRadixString(2);
      analysis['octal'] = number.toRadixString(8);
      analysis['hexadecimal'] = number.toRadixString(16).toUpperCase();
      
      // Numerical analysis
      if (number > BigInt.zero) {
        int digits = number.toString().length;
        
        analysis['isPrime'] = isPrime(number);
        analysis['isPalindrome'] = isPalindrome(number);
        analysis['perfectPower'] = isPerfectPower(number);
        analysis['isFibonacci'] = isFibonacci(number);
        analysis['isTriangular'] = isTriangular(number);
        
        // Check for perfect square and perfect cube
        analysis['isPerfectSquare'] = isPerfectSquare(number);
        analysis['isPerfectCube'] = isPerfectCube(number);
        
        if (digits <= 15) {
          // Complete analysis for small numbers
          analysis['nextPrime'] = nextPrime(number).toString();
          analysis['previousPrime'] = previousPrime(number).toString();
          analysis['primeFactors'] = primeFactorization(number).map((f) => f.toString()).toList();
          // Bound the displayed list: a highly composite number can
          // have tens of thousands of divisors.
          final List<BigInt> divisors = getDivisors(number);
          if (divisors.length <= 100) {
            analysis['divisors'] = divisors.map((d) => d.toString()).toList();
          } else {
            analysis['divisors'] = [
              ...divisors.take(100).map((d) => d.toString()),
              trLocale('… y ${divisors.length - 100} más',
                  '… and ${divisors.length - 100} more'),
            ];
          }
          analysis['isPerfect'] = isPerfectNumber(number);
        } else {
          // Limited analysis for medium numbers
          if (analysis['isPrime'] == true) {
            analysis['nextPrime'] = nextPrime(number).toString();
            analysis['previousPrime'] = previousPrime(number).toString();
            analysis['primeFactors'] = [number.toString()];
          } else {
            analysis['nextPrime'] = trLocale('No es primo', 'Not prime');
            analysis['previousPrime'] = trLocale('No es primo', 'Not prime');
            
            try {
              List<BigInt> factors = primeFactorization(number);
              if (factors.length <= 20) {
                analysis['primeFactors'] = factors.map((f) => f.toString()).toList();
              } else {
                analysis['primeFactors'] = [trLocale('Demasiados factores', 'Too many factors')];
              }
            } catch (e) {
              analysis['primeFactors'] = [
                trLocale('Factorización muy compleja', 'Factorization too complex')
              ];
            }
          }
          
          analysis['isPerfect'] = false; // Do not compute for medium numbers
        }
      }
      
      // Basic mathematical operations
      try {
        if (number.toString().length <= 30) {
          analysis['square'] = (number * number).toString();
          analysis['cube'] = (number * number * number).toString();
        }
        
        if (number > BigInt.zero && number.toString().length <= 20) {
          // Show roots with reasonable decimals for the panel
          try {
            final sqrtVal = BigDecimal.fromBigInt(number)
                .sqrt()
                .withPrecision(NumericPrecision.decimals)
                .toString();
            analysis['squareRoot'] = sqrtVal;
          } catch (_) {
            // Fallback: at least return the integer root
            analysis['squareRoot'] = _sqrt(number).toString();
          }

          try {
            final cbrtVal = BigDecimal.fromBigInt(number)
                .cbrt()
                .withPrecision(NumericPrecision.decimals)
                .toString();
            analysis['cubeRoot'] = cbrtVal;
          } catch (_) {
            // Fallback: approximate integer cube root
            analysis['cubeRoot'] = _nthRoot(number, 3).toString();
          }
        }
      } catch (e) {
        analysis['square'] = trLocale('Error en cálculo', 'Calculation error');
        analysis['cube'] = trLocale('Error en cálculo', 'Calculation error');
      }
      
    } catch (e) {
      analysis['error'] = trLocale('Error en análisis: ${e.toString()}', 'Analysis error: ${e.toString()}');
      analysis['value'] = number.toString();
      analysis['digitCount'] = number.toString().replaceAll('-', '').length;
    }
    
    return analysis;
  }

  /// Basic analysis for very large numbers
  static Map<String, dynamic> _completeAnalysisBasic(BigInt number) {
    Map<String, dynamic> analysis = {};
    
    try {
      String numberStr = number.toString();
      int digitCount = numberStr.replaceAll('-', '').length;
      
      // Basic properties (always computable)
      analysis['value'] = numberStr;
      analysis['isZero'] = number == BigInt.zero;
      analysis['isPositive'] = number > BigInt.zero;
      analysis['isNegative'] = number < BigInt.zero;
      analysis['isEven'] = number % BigInt.two == BigInt.zero;
      analysis['isOdd'] = number % BigInt.two != BigInt.zero;
      
      // Length and digits
      analysis['digitCount'] = digitCount;
      
      // Digit sum - always computable, even for very large numbers
      analysis['digitSum'] = _digitSum(number);
      
      // Representations (only for numbers that are not extremely large)
      if (digitCount <= 100) {
        try {
          analysis['binary'] = number.toRadixString(2);
          analysis['octal'] = number.toRadixString(8);
          analysis['hexadecimal'] = number.toRadixString(16).toUpperCase();
        } catch (e) {
          analysis['binary'] = trLocale('No calculado (muy grande)', 'Not computed (too large)');
          analysis['octal'] = trLocale('No calculado (muy grande)', 'Not computed (too large)');
          analysis['hexadecimal'] = trLocale('No calculado (muy grande)', 'Not computed (too large)');
        }
      } else {
        analysis['binary'] = trLocale('No calculado (número extremadamente grande)', 'Not computed (extremely large number)');
        analysis['octal'] = trLocale('No calculado (número extremadamente grande)', 'Not computed (extremely large number)');
        analysis['hexadecimal'] = trLocale('No calculado (número extremadamente grande)', 'Not computed (extremely large number)');
      }
      
      // Limited analysis for very large numbers
      if (number > BigInt.zero) {
        // These properties are efficient even for very large numbers
        try {
          analysis['isPrime'] = isPrime(number);
        } catch (e) {
          analysis['isPrime'] = false;
          analysis['primeNote'] = trLocale('Error en verificación de primalidad', 'Primality check error');
        }
        
        try {
          analysis['isPalindrome'] = isPalindrome(number);
        } catch (e) {
          analysis['isPalindrome'] = false;
        }
        
        // For extremely large numbers, do not compute these properties
        if (digitCount <= 200) {
          analysis['isFibonacci'] = isFibonacci(number);
          analysis['isTriangular'] = isTriangular(number);
          
          // Check for perfect square and perfect cube
          analysis['isPerfectSquare'] = isPerfectSquare(number);
          analysis['isPerfectCube'] = isPerfectCube(number);
        } else {
          analysis['isFibonacci'] = false;
          analysis['isTriangular'] = false;
          analysis['largeNumberNote'] = trLocale('Algunas propiedades no calculadas debido al tamaño extremo', 'Some properties not computed due to extreme size');
        }
        
        // Properties not computed for very large numbers
        analysis['perfectPower'] = {'isPower': false, 'reason': trLocale('Número muy grande', 'Very large number')};
        analysis['primeFactors'] = [trLocale('No calculado (número muy grande)', 'Not computed (very large number)')];
        analysis['divisors'] = [trLocale('No calculado (número muy grande)', 'Not computed (very large number)')];
        analysis['isPerfect'] = false;
        
        // Primes will be computed asynchronously in the CalculatorService
        analysis['nextPrime'] = trLocale('Calculando...', 'Calculating...');
        analysis['previousPrime'] = trLocale('Calculando...', 'Calculating...');
        
        // Basic mathematical operations
        if (digitCount <= 50) {
          try {
            analysis['square'] = (number * number).toString();
          } catch (e) {
            analysis['square'] = trLocale('Error en cálculo', 'Calculation error');
          }
          
          try {
            analysis['cube'] = (number * number * number).toString();
          } catch (e) {
            analysis['cube'] = trLocale('Error en cálculo', 'Calculation error');
          }
        } else {
          analysis['square'] = trLocale('No calculado (resultado muy grande)', 'Not computed (result too large)');
          analysis['cube'] = trLocale('No calculado (resultado muy grande)', 'Not computed (result too large)');
        }
        
        // Roots are not computed for very large numbers
        analysis['squareRoot'] = trLocale('No calculado (número muy grande)', 'Not computed (very large number)');
        analysis['cubeRoot'] = trLocale('No calculado (número muy grande)', 'Not computed (very large number)');
      }
      
    } catch (e) {
      // In case of error, return basic information
      analysis['error'] = trLocale('Error en análisis: ${e.toString()}', 'Analysis error: ${e.toString()}');
      analysis['value'] = number.toString();
      analysis['digitCount'] = number.toString().replaceAll('-', '').length;
      analysis['isZero'] = number == BigInt.zero;
      analysis['isPositive'] = number > BigInt.zero;
      analysis['isNegative'] = number < BigInt.zero;
      analysis['isEven'] = number % BigInt.two == BigInt.zero;
      analysis['isOdd'] = number % BigInt.two != BigInt.zero;
      analysis['errorNote'] = trLocale(
          'Se produjo un error durante el análisis. Mostrando información básica.',
          'An error occurred during analysis. Showing basic information.');
    }
    
    return analysis;
  }

  /// Checks whether a number is a perfect square
  static bool isPerfectSquare(BigInt number) {
    if (number < BigInt.zero) return false;
    if (number == BigInt.zero || number == BigInt.one) return true;
    
    try {
      // For large numbers, use binary search
      if (number.toString().length > 15) {
        return _isPerfectSquareBinarySearch(number);
      }
      
      // For small numbers, use the direct method
      BigInt sqrt = _integerSquareRoot(number);
      return sqrt * sqrt == number;
    } catch (e) {
      return false;
    }
  }

  /// Checks whether a number is a perfect cube
  static bool isPerfectCube(BigInt number) {
    if (number < BigInt.zero) {
      // Negative numbers can be perfect cubes of negative numbers
      BigInt absNumber = number.abs();
      return isPerfectCube(absNumber);
    }
    if (number == BigInt.zero || number == BigInt.one) return true;
    
    try {
      // For large numbers, use binary search
      if (number.toString().length > 15) {
        return _isPerfectCubeBinarySearch(number);
      }
      
      // For small numbers, use the direct method
      BigInt cubeRoot = _integerCubeRoot(number);
      return cubeRoot * cubeRoot * cubeRoot == number;
    } catch (e) {
      return false;
    }
  }

  /// Computes the integer square root using Newton's method
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

  /// Computes the integer cube root using binary search
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

  /// Checks whether a large number is a perfect square using binary search
  static bool _isPerfectSquareBinarySearch(BigInt number) {
    BigInt low = BigInt.zero;
    BigInt high = number;
    
    // Optimization: reduce the search range
    if (number > BigInt.from(1000000)) {
      // For very large numbers, start with a better estimate
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

  /// Checks whether a large number is a perfect cube using binary search
  static bool _isPerfectCubeBinarySearch(BigInt number) {
    BigInt low = BigInt.zero;
    BigInt high = number;
    
    // Optimization: reduce the search range
    if (number > BigInt.from(1000000)) {
      // For very large numbers, start with a better estimate
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

  /// Checks whether a number is a perfect square asynchronously (for very large numbers)
  static Future<bool> isPerfectSquareAsync(BigInt number) async {
    if (number < BigInt.zero) return false;
    if (number == BigInt.zero || number == BigInt.one) return true;
    
    // For extremely large numbers, use compute to avoid blocking the UI
    if (number.toString().length > 1000) {
      return await compute(_isPerfectSquareInIsolate, number.toString());
    }
    
    return isPerfectSquare(number);
  }

  /// Checks whether a number is a perfect cube asynchronously (for very large numbers)
  static Future<bool> isPerfectCubeAsync(BigInt number) async {
    if (number < BigInt.zero) {
      BigInt absNumber = number.abs();
      return await isPerfectCubeAsync(absNumber);
    }
    if (number == BigInt.zero || number == BigInt.one) return true;
    
    // For extremely large numbers, use compute to avoid blocking the UI
    if (number.toString().length > 1000) {
      return await compute(_isPerfectCubeInIsolate, number.toString());
    }
    
    return isPerfectCube(number);
  }

  /// Function to run in an isolate - perfect square
  static bool _isPerfectSquareInIsolate(String numberStr) {
    try {
      BigInt number = BigInt.parse(numberStr);
      return isPerfectSquare(number);
    } catch (e) {
      return false;
    }
  }

  /// Function to run in an isolate - perfect cube
  static bool _isPerfectCubeInIsolate(String numberStr) {
    try {
      BigInt number = BigInt.parse(numberStr);
      return isPerfectCube(number);
    } catch (e) {
      return false;
    }
  }

  /// Computes the digit sum of a number (public method)
  static int digitSum(BigInt number) {
    return _digitSum(number);
  }

  /// Computes the digit sum asynchronously (for extremely large numbers)
  static Future<int> digitSumAsync(BigInt number) async {
    String numStr = number.toString().replaceAll('-', '');
    
    // If the number is very large, use an isolate
    if (numStr.length > 50000) {
      return await compute(_digitSumInIsolate, numStr);
    } else {
      // For smaller numbers, use the direct method
      return _digitSum(number);
    }
  }

  /// Function to compute the digit sum in an isolate
  static int _digitSumInIsolate(String numStr) {
    int sum = 0;
    for (int i = 0; i < numStr.length; i++) {
      sum += int.parse(numStr[i]);
    }
    return sum;
  }

  /// Checks whether a number is a perfect square (optimized for large numbers)
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

  /// Computes the square root of a BigInt (optimized for large numbers)
  static BigInt _sqrtBigInt(BigInt n) {
    if (n < BigInt.zero) throw ArgumentError(trLocale('Raíz cuadrada de número negativo', 'Square root of a negative number'));
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

  static BigInt _sqrt(BigInt number) {
    if (number < BigInt.zero) throw ArgumentError(trLocale('Raíz cuadrada de número negativo', 'Square root of a negative number'));
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

  /// Exact integer n-th root: returns ⌊|number|^(1/n)⌋ (with the proper
  /// sign) via binary search. It is exact for a BigInt of any
  /// size, with no approximations, which allows detecting large perfect
  /// powers correctly.
  static BigInt _nthRoot(BigInt number, int n) {
    if (n < 1) throw ArgumentError(trLocale('El índice de la raíz debe ser ≥ 1', 'The root index must be ≥ 1'));
    if (number < BigInt.zero && n.isEven) {
      throw ArgumentError(trLocale('Raíz par de número negativo', 'Even root of a negative number'));
    }
    if (number == BigInt.zero) return BigInt.zero;
    if (n == 1) return number;

    final bool negative = number < BigInt.zero;
    final BigInt magnitude = number.abs();
    if (magnitude == BigInt.one) return negative ? -BigInt.one : BigInt.one;

    // Upper bound: double `hi` until hi^n exceeds `magnitude`.
    BigInt lo = BigInt.one;
    BigInt hi = BigInt.two;
    while (hi.pow(n) <= magnitude) {
      hi <<= 1;
    }

    // Binary search for ⌊magnitude^(1/n)⌋ in the interval (lo, hi].
    while (lo < hi) {
      final BigInt mid = (lo + hi + BigInt.one) >> 1;
      if (mid.pow(n) <= magnitude) {
        lo = mid;
      } else {
        hi = mid - BigInt.one;
      }
    }
    return negative ? -lo : lo;
  }

  /// Computes the digit sum of a number (optimized for large numbers)
  static int _digitSum(BigInt number) {
    String numStr = number.toString().replaceAll('-', '');
    
    // For very large numbers, use a more efficient approach
    if (numStr.length > 10000) {
      // Process in chunks to avoid memory issues
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
      // For smaller numbers, use the direct method
      return numStr.split('').map(int.parse).reduce((a, b) => a + b);
    }
  }
}
