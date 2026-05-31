import 'dart:math' as math;
import 'package:super_calculadora/services/big_decimal.dart';

/// Servicio para funciones matemáticas especiales
class SpecialFunctionsService {
  
  /// Función φ de Euler - cuenta enteros coprimos con n
  static BigInt eulerPhi(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError('φ(n) solo está definido para n > 0');
    }
    
    if (n == BigInt.one) return BigInt.one;
    
    BigInt result = n;
    BigInt temp = n;
    
    // Encontrar todos los factores primos y aplicar la fórmula
    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      if (temp % i == BigInt.zero) {
        // i es un factor primo
        while (temp % i == BigInt.zero) {
          temp ~/= i;
        }
        result = result - result ~/ i;
      }
    }
    
    // Si temp > 1, entonces es un factor primo
    if (temp > BigInt.one) {
      result = result - result ~/ temp;
    }
    
    return result;
  }
  
  /// Primorial - producto de todos los primos ≤ n
  static BigInt primorial(int n) {
    if (n < 2) return BigInt.one;
    
    BigInt result = BigInt.one;
    List<bool> isPrime = List.filled(n + 1, true);
    isPrime[0] = isPrime[1] = false;
    
    // Criba de Eratóstenes
    for (int i = 2; i * i <= n; i++) {
      if (isPrime[i]) {
        for (int j = i * i; j <= n; j += i) {
          isPrime[j] = false;
        }
      }
    }
    
    // Multiplicar todos los primos
    for (int i = 2; i <= n; i++) {
      if (isPrime[i]) {
        result *= BigInt.from(i);
      }
    }
    
    return result;
  }
  
  /// σ₀(n) - cantidad de divisores
  static BigInt divisorCount(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError('σ₀(n) solo está definido para n > 0');
    }
    
    BigInt count = BigInt.one;
    BigInt temp = n;
    
    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      BigInt exponent = BigInt.zero;
      while (temp % i == BigInt.zero) {
        temp ~/= i;
        exponent += BigInt.one;
      }
      if (exponent > BigInt.zero) {
        count *= (exponent + BigInt.one);
      }
    }
    
    if (temp > BigInt.one) {
      count *= BigInt.two; // temp es primo con exponente 1
    }
    
    return count;
  }
  
  /// σ(m,n) - suma de divisores elevados a la potencia m
  static BigDecimal divisorSum(int m, BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError('σ(m,n) solo está definido para n > 0');
    }
    
    List<BigInt> divisors = _getDivisors(n);
    BigDecimal sum = BigDecimal.zero;
    
    for (BigInt divisor in divisors) {
      if (m == 0) {
        sum += BigDecimal.one;
      } else if (m == 1) {
        sum += BigDecimal.fromString(divisor.toString());
      } else {
        BigDecimal base = BigDecimal.fromString(divisor.toString());
        sum += base.pow(m);
      }
    }
    
    return sum;
  }
  
  /// Obtiene todos los divisores de n
  static List<BigInt> _getDivisors(BigInt n) {
    List<BigInt> divisors = [];
    
    for (BigInt i = BigInt.one; i * i <= n; i += BigInt.one) {
      if (n % i == BigInt.zero) {
        divisors.add(i);
        if (i != n ~/ i) {
          divisors.add(n ~/ i);
        }
      }
    }
    
    divisors.sort();
    return divisors;
  }
  
  /// MCD de dos números usando algoritmo de Euclides
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
  
  /// MCD de múltiples números
  static BigInt gcdMultiple(List<BigInt> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError('La lista no puede estar vacía');
    }
    
    BigInt result = numbers[0].abs();
    for (int i = 1; i < numbers.length; i++) {
      result = gcd(result, numbers[i]);
    }
    
    return result;
  }
  
  /// MCM de dos números
  static BigInt lcm(BigInt a, BigInt b) {
    if (a == BigInt.zero || b == BigInt.zero) {
      return BigInt.zero;
    }
    
    return (a.abs() * b.abs()) ~/ gcd(a, b);
  }
  
  /// MCM de múltiples números
  static BigInt lcmMultiple(List<BigInt> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError('La lista no puede estar vacía');
    }
    
    BigInt result = numbers[0].abs();
    for (int i = 1; i < numbers.length; i++) {
      result = lcm(result, numbers[i]);
    }
    
    return result;
  }
  
  /// Función piso
  static BigInt floor(BigDecimal x) {
    // For negative numbers with a fractional part, the floor is one less
    // than the integer part (e.g. floor(-2.3) = -3, not -2).
    if (x.isNegative && x.fractionalPart != BigInt.zero) {
      return x.integerPart - BigInt.one;
    }
    return x.integerPart;
  }
  
  /// Función techo
  static BigInt ceiling(BigDecimal x) {
    if (x.fractionalPart == BigInt.zero) {
      return x.integerPart;
    } else if (x.isNegative) {
      return x.integerPart;
    } else {
      return x.integerPart + BigInt.one;
    }
  }
  
  /// Función μ de Möbius
  static int moebiusMu(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError('μ(n) solo está definido para n > 0');
    }
    
    if (n == BigInt.one) return 1;
    
    int primeFactorCount = 0;
    BigInt temp = n;
    
    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      int exponent = 0;
      while (temp % i == BigInt.zero) {
        temp ~/= i;
        exponent++;
      }
      
      if (exponent > 1) {
        return 0; // n tiene un factor cuadrado
      } else if (exponent == 1) {
        primeFactorCount++;
      }
    }
    
    if (temp > BigInt.one) {
      primeFactorCount++; // temp es primo
    }
    
    return primeFactorCount % 2 == 0 ? 1 : -1;
  }
  
  /// Resto de división (mod)
  static BigInt mod(BigInt a, BigInt b) {
    if (b == BigInt.zero) {
      throw ArgumentError('División por cero');
    }
    
    BigInt result = a % b;
    if (result.isNegative && b > BigInt.zero) {
      result += b;
    } else if (result > BigInt.zero && b.isNegative) {
      result += b;
    }
    
    return result;
  }
  
  /// Valuación p-ádica - máxima potencia de p que divide a n
  static int pAdicValuation(BigInt n, BigInt p) {
    if (n == BigInt.zero) {
      throw ArgumentError('La valuación p-ádica de 0 es infinita');
    }
    if (p <= BigInt.one) {
      throw ArgumentError('p debe ser un primo > 1');
    }
    
    n = n.abs();
    int valuation = 0;
    
    while (n % p == BigInt.zero) {
      n ~/= p;
      valuation++;
    }
    
    return valuation;
  }
  
  /// Combinaciones C(n,k) = n!/(k!(n-k)!)
  static BigInt combinations(int n, int k) {
    if (k > n || k < 0) return BigInt.zero;
    if (k == 0 || k == n) return BigInt.one;
    
    // Optimización: C(n,k) = C(n,n-k)
    if (k > n - k) k = n - k;
    
    BigInt result = BigInt.one;
    for (int i = 0; i < k; i++) {
      result = result * BigInt.from(n - i) ~/ BigInt.from(i + 1);
    }
    
    return result;
  }
  
  /// Variaciones V(n,k) = n!/(n-k)!
  static BigInt variations(int n, int k) {
    if (k > n || k < 0) return BigInt.zero;
    if (k == 0) return BigInt.one;
    
    BigInt result = BigInt.one;
    for (int i = 0; i < k; i++) {
      result *= BigInt.from(n - i);
    }
    
    return result;
  }
  
  /// Media aritmética
  static BigDecimal arithmeticMean(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError('La lista no puede estar vacía');
    }
    
    BigDecimal sum = BigDecimal.zero;
    for (BigDecimal num in numbers) {
      sum += num;
    }
    
    return sum / BigDecimal.fromString(numbers.length.toString());
  }
  
  /// Media geométrica
  static BigDecimal geometricMean(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError('La lista no puede estar vacía');
    }
    
    // Verificar que todos los números sean positivos
    for (BigDecimal num in numbers) {
      if (num.isNegative || num.isZero) {
        throw ArgumentError('Todos los números deben ser positivos para la media geométrica');
      }
    }
    
    // Calcular usando logaritmos para evitar overflow
    double logSum = 0;
    for (BigDecimal num in numbers) {
      logSum += math.log(num.toDouble());
    }
    
    double result = math.exp(logSum / numbers.length);
    return BigDecimal.fromDouble(result);
  }
  
  /// Media armónica
  static BigDecimal harmonicMean(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError('La lista no puede estar vacía');
    }
    
    BigDecimal reciprocalSum = BigDecimal.zero;
    for (BigDecimal num in numbers) {
      if (num.isZero) {
        throw ArgumentError('No se puede calcular la media armónica con ceros');
      }
      reciprocalSum += BigDecimal.one / num;
    }
    
    return BigDecimal.fromString(numbers.length.toString()) / reciprocalSum;
  }
  
  /// Media cuadrática (RMS)
  static BigDecimal quadraticMean(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError('La lista no puede estar vacía');
    }
    
    BigDecimal sumOfSquares = BigDecimal.zero;
    for (BigDecimal num in numbers) {
      sumOfSquares += num * num;
    }
    
    BigDecimal mean = sumOfSquares / BigDecimal.fromString(numbers.length.toString());
    return mean.sqrt();
  }
  
  /// Inverso modular usando algoritmo extendido de Euclides
  static BigInt? modularInverse(BigInt a, BigInt n) {
    if (n <= BigInt.one) {
      throw ArgumentError('n debe ser > 1');
    }
    
    a = mod(a, n);
    if (gcd(a, n) != BigInt.one) {
      return null; // No existe inverso si gcd(a,n) ≠ 1
    }
    
    // Algoritmo extendido de Euclides
    BigInt t = BigInt.zero, newT = BigInt.one;
    BigInt r = n, newR = a;
    
    while (newR != BigInt.zero) {
      BigInt quotient = r ~/ newR;
      
      BigInt tempT = t;
      t = newT;
      newT = tempT - quotient * newT;
      
      BigInt tempR = r;
      r = newR;
      newR = tempR - quotient * newR;
    }
    
    if (r > BigInt.one) {
      return null; // a no es invertible
    }
    
    if (t.isNegative) {
      t += n;
    }
    
    return t;
  }
  
  /// Radical (producto de factores primos distintos) - función ABC
  static BigInt radical(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError('rad(n) solo está definido para n > 0');
    }
    
    if (n == BigInt.one) return BigInt.one;
    
    BigInt result = BigInt.one;
    BigInt temp = n;
    
    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      if (temp % i == BigInt.zero) {
        result *= i;
        while (temp % i == BigInt.zero) {
          temp ~/= i;
        }
      }
    }
    
    if (temp > BigInt.one) {
      result *= temp;
    }
    
    return result;
  }
  
  /// Encuentra el mínimo en una lista de números
  static BigDecimal minimum(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError('La lista no puede estar vacía');
    }
    
    BigDecimal min = numbers[0];
    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] < min) {
        min = numbers[i];
      }
    }
    
    return min;
  }
  
  /// Encuentra el máximo en una lista de números
  static BigDecimal maximum(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError('La lista no puede estar vacía');
    }

    BigDecimal max = numbers[0];
    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] > max) {
        max = numbers[i];
      }
    }

    return max;
  }

  /// ω(n) - Número de factores primos distintos (small omega)
  /// ω(12) = 2 porque 12 = 2² × 3 (factores primos distintos: 2, 3)
  /// ω(1) = 0
  static int smallOmega(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError('ω(n) solo está definido para n > 0');
    }

    if (n == BigInt.one) return 0;

    int count = 0;
    BigInt temp = n;

    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      if (temp % i == BigInt.zero) {
        count++;
        while (temp % i == BigInt.zero) {
          temp ~/= i;
        }
      }
    }

    if (temp > BigInt.one) {
      count++;
    }

    return count;
  }

  /// Ω(n) - Número de factores primos con multiplicidad (big omega)
  /// Ω(12) = 3 porque 12 = 2 × 2 × 3 (tres factores primos en total)
  /// Ω(1) = 0
  static int bigOmega(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError('Ω(n) solo está definido para n > 0');
    }

    if (n == BigInt.one) return 0;

    int count = 0;
    BigInt temp = n;

    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      while (temp % i == BigInt.zero) {
        count++;
        temp ~/= i;
      }
    }

    if (temp > BigInt.one) {
      count++;
    }

    return count;
  }

  /// λ(n) - Función de Carmichael (totiente reducido)
  /// λ(n) es el menor entero positivo m tal que a^m ≡ 1 (mod n)
  /// para todo a coprimo con n.
  /// Definición:
  ///   λ(1) = 1
  ///   λ(2) = 1, λ(4) = 2
  ///   λ(2^k) = 2^(k-2) para k ≥ 3
  ///   λ(p^k) = φ(p^k) = p^(k-1)(p-1) para p primo impar
  ///   λ(p₁^a₁ × p₂^a₂ × ... ) = mcm(λ(p₁^a₁), λ(p₂^a₂), ...)
  static BigInt carmichaelLambda(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError('λ(n) solo está definido para n > 0');
    }

    if (n == BigInt.one) return BigInt.one;

    // Factorizar n en potencias de primos
    BigInt temp = n;
    List<List<BigInt>> primeFactors = []; // pares [primo, exponente]

    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      if (temp % i == BigInt.zero) {
        BigInt exp = BigInt.zero;
        while (temp % i == BigInt.zero) {
          exp += BigInt.one;
          temp ~/= i;
        }
        primeFactors.add([i, exp]);
      }
    }
    if (temp > BigInt.one) {
      primeFactors.add([temp, BigInt.one]);
    }

    // Calcular λ para cada potencia de primo y luego el mcm
    BigInt result = BigInt.one;

    for (List<BigInt> factor in primeFactors) {
      BigInt p = factor[0];
      BigInt k = factor[1];
      BigInt lambdaPk;

      if (p == BigInt.two) {
        if (k == BigInt.one) {
          lambdaPk = BigInt.one;
        } else if (k == BigInt.two) {
          lambdaPk = BigInt.two;
        } else {
          // λ(2^k) = 2^(k-2) para k ≥ 3
          lambdaPk = BigInt.two.pow((k - BigInt.two).toInt());
        }
      } else {
        // λ(p^k) = φ(p^k) = p^(k-1) * (p - 1) para p primo impar
        lambdaPk = p.pow((k - BigInt.one).toInt()) * (p - BigInt.one);
      }

      result = lcm(result, lambdaPk);
    }

    return result;
  }

  /// sopfr(n) - Suma de factores primos con repetición
  /// sopfr(12) = 2 + 2 + 3 = 7 porque 12 = 2² × 3
  /// sopfr(1) = 0
  static BigInt sopfr(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError('sopfr(n) solo está definido para n > 0');
    }

    if (n == BigInt.one) return BigInt.zero;

    BigInt sum = BigInt.zero;
    BigInt temp = n;

    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      while (temp % i == BigInt.zero) {
        sum += i;
        temp ~/= i;
      }
    }

    if (temp > BigInt.one) {
      sum += temp;
    }

    return sum;
  }

  /// sopf(n) - Suma de factores primos distintos (sin repetición)
  /// sopf(12) = 2 + 3 = 5 porque 12 = 2² × 3
  /// sopf(1) = 0
  static BigInt sopf(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError('sopf(n) solo está definido para n > 0');
    }

    if (n == BigInt.one) return BigInt.zero;

    BigInt sum = BigInt.zero;
    BigInt temp = n;

    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      if (temp % i == BigInt.zero) {
        sum += i;
        while (temp % i == BigInt.zero) {
          temp ~/= i;
        }
      }
    }

    if (temp > BigInt.one) {
      sum += temp;
    }

    return sum;
  }

  // ====================================================================
  // FUNCIONES NUEVAS PARA OLIMPIADAS
  // ====================================================================

  /// Exponenciación modular: a^b mod n usando cuadratura repetida
  /// Eficiente incluso para exponentes enormes
  static BigInt modPow(BigInt base, BigInt exponent, BigInt modulus) {
    if (modulus <= BigInt.zero) {
      throw ArgumentError('El módulo debe ser > 0');
    }
    if (modulus == BigInt.one) return BigInt.zero;
    if (exponent < BigInt.zero) {
      // a^(-b) mod n = (a^(-1))^b mod n
      BigInt? inv = modularInverse(base, modulus);
      if (inv == null) {
        throw ArgumentError('No existe inverso modular, no se puede calcular exponente negativo');
      }
      base = inv;
      exponent = -exponent;
    }

    BigInt result = BigInt.one;
    base = base % modulus;
    if (base < BigInt.zero) base += modulus;

    while (exponent > BigInt.zero) {
      if (exponent.isOdd) {
        result = (result * base) % modulus;
      }
      exponent >>= 1;
      base = (base * base) % modulus;
    }

    return result;
  }

  /// Orden multiplicativo: menor k > 0 tal que a^k ≡ 1 (mod n)
  /// Requiere que gcd(a, n) = 1
  static BigInt multiplicativeOrder(BigInt a, BigInt n) {
    if (n <= BigInt.one) {
      throw ArgumentError('n debe ser > 1');
    }
    if (gcd(a, n) != BigInt.one) {
      throw ArgumentError('gcd(a, n) debe ser 1 para que exista el orden');
    }

    a = a % n;
    if (a < BigInt.zero) a += n;

    // El orden divide a φ(n), así que buscamos divisores de φ(n)
    BigInt phi = eulerPhi(n);
    List<BigInt> divisors = _getDivisors(phi);
    divisors.sort();

    for (BigInt d in divisors) {
      if (modPow(a, d, n) == BigInt.one) {
        return d;
      }
    }

    return phi; // Siempre divide a φ(n)
  }

  /// Verifica si g es raíz primitiva mod n
  /// g es raíz primitiva si ord_n(g) = φ(n)
  static bool isPrimitiveRoot(BigInt g, BigInt n) {
    if (n <= BigInt.one) return false;
    if (gcd(g, n) != BigInt.one) return false;

    BigInt phi = eulerPhi(n);
    // Verificar que g^(φ(n)/p) ≢ 1 (mod n) para cada primo p que divide a φ(n)
    BigInt temp = phi;
    List<BigInt> primeFactorsOfPhi = [];

    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      if (temp % i == BigInt.zero) {
        primeFactorsOfPhi.add(i);
        while (temp % i == BigInt.zero) {
          temp ~/= i;
        }
      }
    }
    if (temp > BigInt.one) {
      primeFactorsOfPhi.add(temp);
    }

    for (BigInt p in primeFactorsOfPhi) {
      if (modPow(g, phi ~/ p, n) == BigInt.one) {
        return false;
      }
    }

    return true;
  }

  /// Encuentra la menor raíz primitiva mod n (si existe)
  /// Solo existe para n = 1, 2, 4, p^k, 2p^k (p primo impar)
  static BigInt? findPrimitiveRoot(BigInt n) {
    if (n <= BigInt.one) return null;
    if (n == BigInt.two) return BigInt.one;

    for (BigInt g = BigInt.two; g < n; g += BigInt.one) {
      if (gcd(g, n) != BigInt.one) continue;
      if (isPrimitiveRoot(g, n)) {
        return g;
      }
      // Limitar búsqueda para números muy grandes
      if (g > BigInt.from(10000)) return null;
    }

    return null;
  }

  /// Símbolo de Legendre (a/p) para p primo impar
  /// Retorna 1 si a es residuo cuadrático mod p, -1 si no, 0 si p|a
  static int legendreSymbol(BigInt a, BigInt p) {
    if (p <= BigInt.two) {
      throw ArgumentError('p debe ser un primo impar > 2');
    }

    a = a % p;
    if (a < BigInt.zero) a += p;
    if (a == BigInt.zero) return 0;

    // Criterio de Euler: (a/p) ≡ a^((p-1)/2) (mod p)
    BigInt result = modPow(a, (p - BigInt.one) ~/ BigInt.two, p);
    if (result == BigInt.one) return 1;
    if (result == p - BigInt.one) return -1;
    return 0;
  }

  /// Símbolo de Jacobi (a/n) generalización del de Legendre
  /// n debe ser impar positivo
  static int jacobiSymbol(BigInt a, BigInt n) {
    if (n <= BigInt.zero || n.isEven) {
      throw ArgumentError('n debe ser impar positivo');
    }
    if (n == BigInt.one) return 1;

    a = a % n;
    if (a < BigInt.zero) a += n;

    int result = 1;

    while (a != BigInt.zero) {
      // Extraer factores de 2
      while (a.isEven) {
        a >>= 1;
        BigInt nMod8 = n % BigInt.from(8);
        if (nMod8 == BigInt.from(3) || nMod8 == BigInt.from(5)) {
          result = -result;
        }
      }

      // Reciprocidad cuadrática
      BigInt temp = a;
      a = n;
      n = temp;

      if (a % BigInt.from(4) == BigInt.from(3) &&
          n % BigInt.from(4) == BigInt.from(3)) {
        result = -result;
      }

      a = a % n;
    }

    return n == BigInt.one ? result : 0;
  }

  /// Resuelve ecuación diofántica lineal ax + by = c
  /// Retorna {solvable, x0, y0, dx, dy} donde la solución general es
  /// x = x0 + dx*t, y = y0 + dy*t para todo entero t
  static Map<String, dynamic> solveDiophantine(BigInt a, BigInt b, BigInt c) {
    if (a == BigInt.zero && b == BigInt.zero) {
      return {
        'solvable': c == BigInt.zero,
        'note': c == BigInt.zero
            ? 'Infinitas soluciones (0x + 0y = 0)'
            : 'Sin solución (0x + 0y ≠ $c)',
      };
    }

    BigInt g = gcd(a, b);
    if (c % g != BigInt.zero) {
      return {
        'solvable': false,
        'note': 'Sin solución: gcd($a,$b) = $g no divide a $c',
      };
    }

    // Reducir: (a/g)x + (b/g)y = c/g
    BigInt aReduced = a ~/ g;
    BigInt bReduced = b ~/ g;
    BigInt cReduced = c ~/ g;

    // Resolver usando Euclides extendido para aReduced*x + bReduced*y = 1
    List<BigInt> ext = _extendedGcd(aReduced.abs(), bReduced.abs());
    BigInt x0 = ext[1] * cReduced;
    BigInt y0 = ext[2] * cReduced;

    // Ajustar signos
    if (aReduced < BigInt.zero) x0 = -x0;
    if (bReduced < BigInt.zero) y0 = -y0;

    return {
      'solvable': true,
      'x0': x0,
      'y0': y0,
      'dx': bReduced,  // x = x0 + (b/g)*t
      'dy': -aReduced, // y = y0 - (a/g)*t
      'gcd': g,
      'note': 'x = $x0 + ${bReduced}t, y = $y0 + ${-aReduced}t',
    };
  }

  /// Algoritmo extendido de Euclides: retorna [gcd, x, y] tal que ax + by = gcd
  static List<BigInt> _extendedGcd(BigInt a, BigInt b) {
    if (b == BigInt.zero) {
      return [a, BigInt.one, BigInt.zero];
    }
    List<BigInt> result = _extendedGcd(b, a % b);
    return [result[0], result[2], result[1] - (a ~/ b) * result[2]];
  }

  /// Teorema Chino del Residuo
  /// Resuelve sistema: x ≡ a₁ (mod m₁), x ≡ a₂ (mod m₂), ...
  /// remainders = [a₁, a₂, ...], moduli = [m₁, m₂, ...]
  static Map<String, dynamic> chineseRemainderTheorem(
      List<BigInt> remainders, List<BigInt> moduli) {
    if (remainders.length != moduli.length || remainders.isEmpty) {
      throw ArgumentError('Las listas deben tener el mismo tamaño y no estar vacías');
    }

    BigInt currentA = remainders[0];
    BigInt currentM = moduli[0];

    for (int i = 1; i < remainders.length; i++) {
      BigInt a2 = remainders[i];
      BigInt m2 = moduli[i];

      BigInt g = gcd(currentM, m2);
      if ((a2 - currentA) % g != BigInt.zero) {
        return {
          'solvable': false,
          'note': 'Sin solución: sistema incompatible',
        };
      }

      BigInt lcmVal = lcm(currentM, m2);
      List<BigInt> ext = _extendedGcd(currentM, m2);
      BigInt diff = a2 - currentA;
      BigInt t = (diff ~/ g) * ext[1] % (m2 ~/ g);

      currentA = currentA + currentM * t;
      currentA = currentA % lcmVal;
      if (currentA < BigInt.zero) currentA += lcmVal;
      currentM = lcmVal;
    }

    return {
      'solvable': true,
      'solution': currentA,
      'modulus': currentM,
      'note': 'x ≡ $currentA (mod $currentM)',
    };
  }

  /// Factorial n!
  static BigInt factorial(int n) {
    if (n < 0) {
      throw ArgumentError('El factorial no está definido para negativos');
    }
    if (n <= 1) return BigInt.one;

    BigInt result = BigInt.one;
    for (int i = 2; i <= n; i++) {
      result *= BigInt.from(i);
    }

    return result;
  }

  /// Doble factorial n!!
  /// n!! = n × (n-2) × (n-4) × ... × (2 o 1)
  static BigInt doubleFactorial(int n) {
    if (n < 0) {
      throw ArgumentError('El doble factorial no está definido para negativos');
    }
    if (n <= 1) return BigInt.one;

    BigInt result = BigInt.one;
    for (int i = n; i >= 1; i -= 2) {
      result *= BigInt.from(i);
    }

    return result;
  }

  /// n-ésimo número de Fibonacci usando exponenciación de matrices
  /// F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2)
  static BigInt fibonacci(int n) {
    if (n < 0) {
      throw ArgumentError('n debe ser ≥ 0');
    }
    if (n == 0) return BigInt.zero;
    if (n <= 2) return BigInt.one;

    // Método de duplicación rápida: O(log n)
    return _fibFast(n)[0];
  }

  /// Fibonacci rápido usando identidades de duplicación
  /// Retorna [F(n), F(n+1)]
  static List<BigInt> _fibFast(int n) {
    if (n == 0) return [BigInt.zero, BigInt.one];

    List<BigInt> prev = _fibFast(n >> 1);
    BigInt a = prev[0]; // F(n/2)
    BigInt b = prev[1]; // F(n/2 + 1)

    // F(2k) = F(k)[2F(k+1) - F(k)]
    BigInt c = a * (BigInt.two * b - a);
    // F(2k+1) = F(k)² + F(k+1)²
    BigInt d = a * a + b * b;

    if (n.isEven) {
      return [c, d];
    } else {
      return [d, c + d];
    }
  }

  /// n-ésimo número de Catalan: C_n = C(2n,n)/(n+1)
  static BigInt catalanNumber(int n) {
    if (n < 0) {
      throw ArgumentError('n debe ser ≥ 0');
    }

    return combinations(2 * n, n) ~/ BigInt.from(n + 1);
  }

  /// Derangements D(n): permutaciones sin puntos fijos
  /// D(n) = n! × Σ(-1)^k/k! para k=0..n
  /// D(n) = (n-1)(D(n-1) + D(n-2))
  static BigInt derangement(int n) {
    if (n < 0) {
      throw ArgumentError('n debe ser ≥ 0');
    }
    if (n == 0) return BigInt.one;
    if (n == 1) return BigInt.zero;

    BigInt prev2 = BigInt.one;  // D(0)
    BigInt prev1 = BigInt.zero; // D(1)

    for (int i = 2; i <= n; i++) {
      BigInt current = BigInt.from(i - 1) * (prev1 + prev2);
      prev2 = prev1;
      prev1 = current;
    }

    return prev1;
  }

  /// Particiones p(n): número de formas de escribir n como suma de positivos
  /// Usa programación dinámica
  static BigInt partition(int n) {
    if (n < 0) return BigInt.zero;
    if (n == 0) return BigInt.one;

    // Limitar para evitar problemas de memoria
    if (n > 10000) {
      throw ArgumentError('n demasiado grande para calcular particiones (máx 10000)');
    }

    List<BigInt> dp = List.filled(n + 1, BigInt.zero);
    dp[0] = BigInt.one;

    for (int k = 1; k <= n; k++) {
      for (int i = k; i <= n; i++) {
        dp[i] += dp[i - k];
      }
    }

    return dp[n];
  }

  /// Números de Stirling de segunda especie S(n,k)
  /// Número de formas de particionar un conjunto de n elementos en k subconjuntos no vacíos
  static BigInt stirlingSecond(int n, int k) {
    if (k < 0 || k > n) return BigInt.zero;
    if (k == 0 && n == 0) return BigInt.one;
    if (k == 0 || n == 0) return BigInt.zero;
    if (k == 1 || k == n) return BigInt.one;

    // Fórmula: S(n,k) = (1/k!) × Σ (-1)^j × C(k,j) × (k-j)^n
    BigInt sum = BigInt.zero;
    for (int j = 0; j <= k; j++) {
      BigInt term = combinations(k, j) * BigInt.from(k - j).pow(n);
      if (j.isEven) {
        sum += term;
      } else {
        sum -= term;
      }
    }

    return sum ~/ factorial(k);
  }

  /// Números de Stirling de primera especie (sin signo) |s(n,k)|
  /// Número de permutaciones de n con exactamente k ciclos
  static BigInt stirlingFirst(int n, int k) {
    if (k < 0 || k > n) return BigInt.zero;
    if (k == 0 && n == 0) return BigInt.one;
    if (k == 0 || n == 0) return BigInt.zero;

    // Usar recurrencia: |s(n,k)| = (n-1)|s(n-1,k)| + |s(n-1,k-1)|
    // Tabla DP
    List<List<BigInt>> dp = List.generate(
      n + 1,
      (_) => List.filled(k + 1, BigInt.zero),
    );
    dp[0][0] = BigInt.one;

    for (int i = 1; i <= n; i++) {
      for (int j = 1; j <= math.min(i, k); j++) {
        dp[i][j] = BigInt.from(i - 1) * dp[i - 1][j] + dp[i - 1][j - 1];
      }
    }

    return dp[n][k];
  }

  /// Números de Bell B(n): número total de particiones de un conjunto de n elementos
  static BigInt bellNumber(int n) {
    if (n < 0) {
      throw ArgumentError('n debe ser ≥ 0');
    }
    if (n == 0) return BigInt.one;

    // B(n) = Σ S(n,k) para k=0..n
    BigInt sum = BigInt.zero;
    for (int k = 0; k <= n; k++) {
      sum += stirlingSecond(n, k);
    }
    return sum;
  }

  /// Raíz digital: aplicar suma de dígitos iterativamente hasta obtener un solo dígito
  static int digitalRoot(BigInt n) {
    n = n.abs();
    if (n == BigInt.zero) return 0;

    // Fórmula directa: dr(n) = 1 + (n-1) mod 9
    BigInt nine = BigInt.from(9);
    BigInt result = BigInt.one + ((n - BigInt.one) % nine);
    return result.toInt();
  }

  /// Suma de dígitos en base b
  static BigInt digitSumInBase(BigInt n, int base) {
    if (base < 2) {
      throw ArgumentError('La base debe ser ≥ 2');
    }

    n = n.abs();
    if (n == BigInt.zero) return BigInt.zero;

    BigInt sum = BigInt.zero;
    BigInt b = BigInt.from(base);

    while (n > BigInt.zero) {
      sum += n % b;
      n ~/= b;
    }

    return sum;
  }

  /// Verifica si n es número abundante: σ(1,n) > 2n
  static bool isAbundant(BigInt n) {
    if (n <= BigInt.one) return false;
    BigInt sigma = BigInt.zero;
    for (BigInt d in _getDivisors(n)) {
      sigma += d;
    }
    return sigma > BigInt.two * n;
  }

  /// Verifica si n es número deficiente: σ(1,n) < 2n
  static bool isDeficient(BigInt n) {
    if (n <= BigInt.one) return true;
    BigInt sigma = BigInt.zero;
    for (BigInt d in _getDivisors(n)) {
      sigma += d;
    }
    return sigma < BigInt.two * n;
  }

  /// Verifica si n es libre de cuadrados (squarefree): μ(n) ≠ 0
  static bool isSquareFree(BigInt n) {
    if (n <= BigInt.zero) return false;
    if (n == BigInt.one) return true;

    BigInt temp = n;
    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      if (temp % i == BigInt.zero) {
        temp ~/= i;
        if (temp % i == BigInt.zero) return false; // i² divide a n
        // seguir buscando otros factores
      }
    }
    return true;
  }

  /// Verifica si n es número poderoso (powerful): p²|n para todo p primo que divide a n
  static bool isPowerful(BigInt n) {
    if (n <= BigInt.one) return n == BigInt.one;

    BigInt temp = n;
    for (BigInt i = BigInt.two; i * i <= temp; i += BigInt.one) {
      if (temp % i == BigInt.zero) {
        int exp = 0;
        while (temp % i == BigInt.zero) {
          temp ~/= i;
          exp++;
        }
        if (exp < 2) return false;
      }
    }
    // Si queda un primo restante con exponente 1, no es poderoso
    return temp == BigInt.one;
  }

  /// Verifica si n es número de Harshad: n divisible por su suma de dígitos
  static bool isHarshad(BigInt n) {
    if (n <= BigInt.zero) return false;
    String digits = n.toString();
    int digitSum = 0;
    for (int i = 0; i < digits.length; i++) {
      digitSum += int.parse(digits[i]);
    }
    return n % BigInt.from(digitSum) == BigInt.zero;
  }

  /// Verifica si n es semiprimo: n = p × q (producto de exactamente dos primos)
  static bool isSemiprime(BigInt n) {
    if (n < BigInt.from(4)) return false;
    return bigOmega(n) == 2;
  }

  /// π(n) aproximado - función contadora de primos
  /// Para n pequeño (≤ 1000000) calcula exacto con criba,
  /// para n grande usa Li(x) como aproximación
  static Map<String, dynamic> primeCountingFunction(BigInt n) {
    if (n < BigInt.two) {
      return {'count': 0, 'exact': true};
    }

    // Para números pequeños, usar criba
    if (n <= BigInt.from(1000000)) {
      int nInt = n.toInt();
      List<bool> sieve = List.filled(nInt + 1, true);
      sieve[0] = sieve[1] = false;
      for (int i = 2; i * i <= nInt; i++) {
        if (sieve[i]) {
          for (int j = i * i; j <= nInt; j += i) {
            sieve[j] = false;
          }
        }
      }
      int count = sieve.where((x) => x).length;
      return {'count': count, 'exact': true};
    }

    // Para números grandes, aproximación con Li(x)
    double x = double.parse(n.toString());
    double li = x / math.log(x) * (1 + 1 / math.log(x) + 2 / (math.log(x) * math.log(x)));
    return {'count': li.round(), 'exact': false, 'approx': true};
  }

  /// Función de Liouville λ_L(n) (distinta de Carmichael)
  /// λ_L(n) = (-1)^Ω(n)
  static int liouvilleFunction(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError('λ_L(n) solo está definido para n > 0');
    }
    return bigOmega(n) % 2 == 0 ? 1 : -1;
  }

  /// Exponenciación modular para resolver congruencias: a^b mod n
  /// Wrapper más amigable
  static BigInt powerMod(BigInt a, BigInt b, BigInt n) {
    return modPow(a, b, n);
  }
}
