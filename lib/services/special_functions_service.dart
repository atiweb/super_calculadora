import 'dart:math' as math;
import '../utils/app_locale.dart';
import 'package:super_calculadora/services/big_decimal.dart';
import 'prime_utils.dart';

/// Service for special mathematical functions
class SpecialFunctionsService {
  
  /// Euler's φ function - counts integers coprime with n
  static BigInt eulerPhi(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError(trLocale('φ(n) solo está definido para n > 0', 'φ(n) is only defined for n > 0', pt: 'φ(n) só está definido para n > 0', fr: "φ(n) n'est défini que pour n > 0", id: 'φ(n) hanya terdefinisi untuk n > 0', vi: 'φ(n) chỉ xác định khi n > 0', ru: 'φ(n) определена только при n > 0', it: 'φ(n) è definita solo per n > 0'));
    }
    
    if (n == BigInt.one) return BigInt.one;

    // φ(n) = n · ∏(1 − 1/p) over the distinct primes of n.
    BigInt result = n;
    for (final p in factorize(n).keys) {
      result = result - result ~/ p;
    }

    return result;
  }
  
  /// Primorial - product of all primes ≤ n
  static BigInt primorial(int n) {
    if (n < 2) return BigInt.one;

    // The sieve allocates n+1 booleans, so an unbounded n exhausted memory.
    if (n > 10000000) {
      throw ArgumentError(trLocale('n demasiado grande para el primorial (máx 10000000)',
          'n too large for the primorial (max 10000000)', pt: 'n grande demais para o primorial (máx 10000000)', fr: 'n trop grand pour la primorielle (max 10000000)', id: 'n terlalu besar untuk primorial (maks. 10000000)', vi: 'n quá lớn cho nguyên tố giai thừa (tối đa 10000000)', ru: 'n слишком велико для праймориала (макс. 10000000)', it: 'n troppo grande per il primoriale (max 10000000)'));
    }

    BigInt result = BigInt.one;
    List<bool> isPrime = List.filled(n + 1, true);
    isPrime[0] = isPrime[1] = false;
    
    // Sieve of Eratosthenes
    for (int i = 2; i * i <= n; i++) {
      if (isPrime[i]) {
        for (int j = i * i; j <= n; j += i) {
          isPrime[j] = false;
        }
      }
    }
    
    // Multiply all the primes
    for (int i = 2; i <= n; i++) {
      if (isPrime[i]) {
        result *= BigInt.from(i);
      }
    }
    
    return result;
  }
  
  /// σ₀(n) - number of divisors
  static BigInt divisorCount(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError(trLocale('σ₀(n) solo está definido para n > 0', 'σ₀(n) is only defined for n > 0', pt: 'σ₀(n) só está definido para n > 0', fr: "σ₀(n) n'est défini que pour n > 0", id: 'σ₀(n) hanya terdefinisi untuk n > 0', vi: 'σ₀(n) chỉ xác định khi n > 0', ru: 'σ₀(n) определена только при n > 0', it: 'σ₀(n) è definita solo per n > 0'));
    }
    
    // σ₀(n) = ∏(eᵢ + 1) over the exponents of the factorization.
    BigInt count = BigInt.one;
    for (final e in factorize(n).values) {
      count *= BigInt.from(e + 1);
    }

    return count;
  }
  
  /// σ(m,n) - sum of divisors raised to the power m
  static BigDecimal divisorSum(int m, BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError(trLocale('σ(m,n) solo está definido para n > 0', 'σ(m,n) is only defined for n > 0', pt: 'σ(m,n) só está definido para n > 0', fr: "σ(m,n) n'est défini que pour n > 0", id: 'σ(m,n) hanya terdefinisi untuk n > 0', vi: 'σ(m,n) chỉ xác định khi n > 0', ru: 'σ(m,n) определена только при n > 0', it: 'σ(m,n) è definita solo per n > 0'));
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
  
  /// Gets all the divisors of n.
  ///
  /// Built from the factorization instead of scanning up to √n, so a large
  /// prime resolves instantly. Throws when the divisor count is too large to
  /// materialize, which would otherwise exhaust memory.
  static List<BigInt> _getDivisors(BigInt n) {
    final List<BigInt>? divisors = divisorsOf(n);
    if (divisors == null) {
      throw ArgumentError(trLocale(
          'n tiene demasiados divisores para enumerarlos',
          'n has too many divisors to enumerate', pt: 'n tem divisores demais para enumerá-los', fr: 'n a trop de diviseurs pour les énumérer', id: 'n punya terlalu banyak pembagi untuk didaftar', vi: 'n có quá nhiều ước để liệt kê', ru: 'У n слишком много делителей, чтобы их перечислить', it: 'n ha troppi divisori per elencarli'));
    }
    return divisors;
  }
  
  /// GCD of two numbers using the Euclidean algorithm
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
  
  /// GCD of multiple numbers
  static BigInt gcdMultiple(List<BigInt> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError(trLocale('La lista no puede estar vacía', 'The list cannot be empty', pt: 'A lista não pode estar vazia', fr: 'La liste ne peut pas être vide', id: 'Daftarnya tidak boleh kosong', vi: 'Danh sách không được rỗng', ru: 'Список не может быть пустым', it: 'La lista non può essere vuota'));
    }
    
    BigInt result = numbers[0].abs();
    for (int i = 1; i < numbers.length; i++) {
      result = gcd(result, numbers[i]);
    }
    
    return result;
  }
  
  /// LCM of two numbers
  static BigInt lcm(BigInt a, BigInt b) {
    if (a == BigInt.zero || b == BigInt.zero) {
      return BigInt.zero;
    }
    
    return (a.abs() * b.abs()) ~/ gcd(a, b);
  }
  
  /// LCM of multiple numbers
  static BigInt lcmMultiple(List<BigInt> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError(trLocale('La lista no puede estar vacía', 'The list cannot be empty', pt: 'A lista não pode estar vazia', fr: 'La liste ne peut pas être vide', id: 'Daftarnya tidak boleh kosong', vi: 'Danh sách không được rỗng', ru: 'Список не может быть пустым', it: 'La lista non può essere vuota'));
    }
    
    BigInt result = numbers[0].abs();
    for (int i = 1; i < numbers.length; i++) {
      result = lcm(result, numbers[i]);
    }
    
    return result;
  }
  
  /// Floor function
  static BigInt floor(BigDecimal x) {
    // For negative numbers with a fractional part, the floor is one less
    // than the integer part (e.g. floor(-2.3) = -3, not -2).
    if (x.isNegative && x.fractionalPart != BigInt.zero) {
      return x.integerPart - BigInt.one;
    }
    return x.integerPart;
  }
  
  /// Ceiling function
  static BigInt ceiling(BigDecimal x) {
    if (x.fractionalPart == BigInt.zero) {
      return x.integerPart;
    } else if (x.isNegative) {
      return x.integerPart;
    } else {
      return x.integerPart + BigInt.one;
    }
  }
  
  /// Möbius μ function
  static int moebiusMu(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError(trLocale('μ(n) solo está definido para n > 0', 'μ(n) is only defined for n > 0', pt: 'μ(n) só está definido para n > 0', fr: "μ(n) n'est défini que pour n > 0", id: 'μ(n) hanya terdefinisi untuk n > 0', vi: 'μ(n) chỉ xác định khi n > 0', ru: 'μ(n) определена только при n > 0', it: 'μ(n) è definita solo per n > 0'));
    }
    
    if (n == BigInt.one) return 1;

    final Map<BigInt, int> f = factorize(n);
    // μ(n) = 0 if any prime is repeated; otherwise (−1)^(number of primes).
    for (final e in f.values) {
      if (e > 1) return 0;
    }

    return f.length % 2 == 0 ? 1 : -1;
  }
  
  /// Division remainder (mod): least NON-NEGATIVE residue in [0, |b|).
  ///
  /// Dart's `%` operator already returns a non-negative remainder, but with
  /// the divisor's sign when it is negative; we use `|b|` so that the
  /// result is always non-negative regardless of the sign of `b`
  /// (e.g. mod(7, -3) = 1, not -2).
  static BigInt mod(BigInt a, BigInt b) {
    if (b == BigInt.zero) {
      throw ArgumentError(trLocale('División por cero', 'Division by zero', pt: 'Divisão por zero', fr: 'Division par zéro', id: 'Pembagian dengan nol', vi: 'Chia cho 0', ru: 'Деление на ноль', it: 'Divisione per zero'));
    }
    return a % b.abs();
  }
  
  /// p-adic valuation - highest power of p that divides n
  static int pAdicValuation(BigInt n, BigInt p) {
    if (n == BigInt.zero) {
      throw ArgumentError(trLocale('La valuación p-ádica de 0 es infinita', 'The p-adic valuation of 0 is infinite', pt: 'A valuação p-ádica de 0 é infinita', fr: 'La valuation p-adique de 0 est infinie', id: 'Valuasi p-adik dari 0 adalah tak hingga', vi: 'Định giá p-adic của 0 là vô hạn', ru: 'p-адическое нормирование нуля бесконечно', it: 'La valutazione p-adica di 0 è infinita'));
    }
    if (p <= BigInt.one) {
      throw ArgumentError(trLocale('p debe ser un primo > 1', 'p must be a prime > 1', pt: 'p deve ser um primo > 1', fr: 'p doit être un nombre premier > 1', id: 'p harus bilangan prima > 1', vi: 'p phải là số nguyên tố > 1', ru: 'p должно быть простым > 1', it: 'p deve essere un primo > 1'));
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
    
    // Optimization: C(n,k) = C(n,n-k)
    if (k > n - k) k = n - k;
    
    BigInt result = BigInt.one;
    for (int i = 0; i < k; i++) {
      result = result * BigInt.from(n - i) ~/ BigInt.from(i + 1);
    }
    
    return result;
  }
  
  /// Variations V(n,k) = n!/(n-k)!
  static BigInt variations(int n, int k) {
    if (k > n || k < 0) return BigInt.zero;
    if (k == 0) return BigInt.one;
    
    BigInt result = BigInt.one;
    for (int i = 0; i < k; i++) {
      result *= BigInt.from(n - i);
    }
    
    return result;
  }
  
  /// Arithmetic mean
  static BigDecimal arithmeticMean(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError(trLocale('La lista no puede estar vacía', 'The list cannot be empty', pt: 'A lista não pode estar vazia', fr: 'La liste ne peut pas être vide', id: 'Daftarnya tidak boleh kosong', vi: 'Danh sách không được rỗng', ru: 'Список не может быть пустым', it: 'La lista non può essere vuota'));
    }
    
    BigDecimal sum = BigDecimal.zero;
    for (BigDecimal num in numbers) {
      sum += num;
    }
    
    return sum / BigDecimal.fromString(numbers.length.toString());
  }
  
  /// Geometric mean
  static BigDecimal geometricMean(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError(trLocale('La lista no puede estar vacía', 'The list cannot be empty', pt: 'A lista não pode estar vazia', fr: 'La liste ne peut pas être vide', id: 'Daftarnya tidak boleh kosong', vi: 'Danh sách không được rỗng', ru: 'Список не может быть пустым', it: 'La lista non può essere vuota'));
    }
    
    // Verify that all numbers are positive
    for (BigDecimal num in numbers) {
      if (num.isNegative || num.isZero) {
        throw ArgumentError(trLocale('Todos los números deben ser positivos para la media geométrica', 'All numbers must be positive for the geometric mean', pt: 'Todos os números devem ser positivos para a média geométrica', fr: 'Tous les nombres doivent être positifs pour la moyenne géométrique', id: 'Semua bilangan harus positif untuk rata-rata ukur', vi: 'Trung bình nhân đòi hỏi mọi số đều dương', ru: 'Для среднего геометрического все числа должны быть положительными', it: 'Tutti i numeri devono essere positivi per la media geometrica'));
      }
    }
    
    // Compute using logarithms to avoid overflow
    double logSum = 0;
    for (BigDecimal num in numbers) {
      logSum += math.log(num.toDouble());
    }
    
    double result = math.exp(logSum / numbers.length);
    return BigDecimal.fromDouble(result);
  }
  
  /// Harmonic mean
  static BigDecimal harmonicMean(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError(trLocale('La lista no puede estar vacía', 'The list cannot be empty', pt: 'A lista não pode estar vazia', fr: 'La liste ne peut pas être vide', id: 'Daftarnya tidak boleh kosong', vi: 'Danh sách không được rỗng', ru: 'Список не может быть пустым', it: 'La lista non può essere vuota'));
    }
    
    BigDecimal reciprocalSum = BigDecimal.zero;
    for (BigDecimal num in numbers) {
      if (num.isZero) {
        throw ArgumentError(trLocale('No se puede calcular la media armónica con ceros', 'Cannot compute the harmonic mean with zeros', pt: 'Não é possível calcular a média harmônica com zeros', fr: 'Impossible de calculer la moyenne harmonique avec des zéros', id: 'Rata-rata harmonik tidak dapat dihitung bila ada nol', vi: 'Không thể tính trung bình điều hoà khi có số 0', ru: 'Среднее гармоническое с нулями вычислить нельзя', it: 'Non è possibile calcolare la media armonica con degli zeri'));
      }
      reciprocalSum += BigDecimal.one / num;
    }
    
    return BigDecimal.fromString(numbers.length.toString()) / reciprocalSum;
  }
  
  /// Quadratic mean (RMS)
  static BigDecimal quadraticMean(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError(trLocale('La lista no puede estar vacía', 'The list cannot be empty', pt: 'A lista não pode estar vazia', fr: 'La liste ne peut pas être vide', id: 'Daftarnya tidak boleh kosong', vi: 'Danh sách không được rỗng', ru: 'Список не может быть пустым', it: 'La lista non può essere vuota'));
    }
    
    BigDecimal sumOfSquares = BigDecimal.zero;
    for (BigDecimal num in numbers) {
      sumOfSquares += num * num;
    }
    
    BigDecimal mean = sumOfSquares / BigDecimal.fromString(numbers.length.toString());
    return mean.sqrt();
  }
  
  /// Modular inverse using the extended Euclidean algorithm
  static BigInt? modularInverse(BigInt a, BigInt n) {
    if (n <= BigInt.one) {
      throw ArgumentError(trLocale('n debe ser > 1', 'n must be > 1', pt: 'n deve ser > 1', fr: 'n doit être > 1', id: 'n harus > 1', vi: 'n phải > 1', ru: 'n должно быть > 1', it: 'n deve essere > 1'));
    }
    
    a = mod(a, n);
    if (gcd(a, n) != BigInt.one) {
      return null; // No inverse exists if gcd(a,n) ≠ 1
    }
    
    // Extended Euclidean algorithm
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
      return null; // a is not invertible
    }
    
    if (t.isNegative) {
      t += n;
    }
    
    return t;
  }
  
  /// Radical (product of distinct prime factors) - ABC function
  static BigInt radical(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError(trLocale('rad(n) solo está definido para n > 0', 'rad(n) is only defined for n > 0', pt: 'rad(n) só está definido para n > 0', fr: "rad(n) n'est défini que pour n > 0", id: 'rad(n) hanya terdefinisi untuk n > 0', vi: 'rad(n) chỉ xác định khi n > 0', ru: 'rad(n) определена только при n > 0', it: 'rad(n) è definita solo per n > 0'));
    }
    
    if (n == BigInt.one) return BigInt.one;

    // rad(n) = product of the distinct primes dividing n.
    BigInt result = BigInt.one;
    for (final p in factorize(n).keys) {
      result *= p;
    }

    return result;
  }

  /// Finds the minimum in a list of numbers
  static BigDecimal minimum(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError(trLocale('La lista no puede estar vacía', 'The list cannot be empty', pt: 'A lista não pode estar vazia', fr: 'La liste ne peut pas être vide', id: 'Daftarnya tidak boleh kosong', vi: 'Danh sách không được rỗng', ru: 'Список не может быть пустым', it: 'La lista non può essere vuota'));
    }
    
    BigDecimal min = numbers[0];
    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] < min) {
        min = numbers[i];
      }
    }
    
    return min;
  }
  
  /// Finds the maximum in a list of numbers
  static BigDecimal maximum(List<BigDecimal> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError(trLocale('La lista no puede estar vacía', 'The list cannot be empty', pt: 'A lista não pode estar vazia', fr: 'La liste ne peut pas être vide', id: 'Daftarnya tidak boleh kosong', vi: 'Danh sách không được rỗng', ru: 'Список не может быть пустым', it: 'La lista non può essere vuota'));
    }

    BigDecimal max = numbers[0];
    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] > max) {
        max = numbers[i];
      }
    }

    return max;
  }

  /// ω(n) - Number of distinct prime factors (small omega)
  /// ω(12) = 2 because 12 = 2² × 3 (distinct prime factors: 2, 3)
  /// ω(1) = 0
  static int smallOmega(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError(trLocale('ω(n) solo está definido para n > 0', 'ω(n) is only defined for n > 0', pt: 'ω(n) só está definido para n > 0', fr: "ω(n) n'est défini que pour n > 0", id: 'ω(n) hanya terdefinisi untuk n > 0', vi: 'ω(n) chỉ xác định khi n > 0', ru: 'ω(n) определена только при n > 0', it: 'ω(n) è definita solo per n > 0'));
    }

    if (n == BigInt.one) return 0;

    // ω(n) = how many distinct primes divide n.
    return factorize(n).length;
  }

  /// Ω(n) - Number of prime factors with multiplicity (big omega)
  /// Ω(12) = 3 because 12 = 2 × 2 × 3 (three prime factors in total)
  /// Ω(1) = 0
  static int bigOmega(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError(trLocale('Ω(n) solo está definido para n > 0', 'Ω(n) is only defined for n > 0', pt: 'Ω(n) só está definido para n > 0', fr: "Ω(n) n'est défini que pour n > 0", id: 'Ω(n) hanya terdefinisi untuk n > 0', vi: 'Ω(n) chỉ xác định khi n > 0', ru: 'Ω(n) определена только при n > 0', it: 'Ω(n) è definita solo per n > 0'));
    }

    if (n == BigInt.one) return 0;

    // Ω(n) = primes counted with multiplicity = sum of the exponents.
    int count = 0;
    for (final e in factorize(n).values) {
      count += e;
    }

    return count;
  }

  /// λ(n) - Carmichael function (reduced totient)
  /// λ(n) is the smallest positive integer m such that a^m ≡ 1 (mod n)
  /// for every a coprime with n.
  /// Definition:
  ///   λ(1) = 1
  ///   λ(2) = 1, λ(4) = 2
  ///   λ(2^k) = 2^(k-2) for k ≥ 3
  ///   λ(p^k) = φ(p^k) = p^(k-1)(p-1) for odd prime p
  ///   λ(p₁^a₁ × p₂^a₂ × ... ) = lcm(λ(p₁^a₁), λ(p₂^a₂), ...)
  static BigInt carmichaelLambda(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError(trLocale('λ(n) solo está definido para n > 0', 'λ(n) is only defined for n > 0', pt: 'λ(n) só está definido para n > 0', fr: "λ(n) n'est défini que pour n > 0", id: 'λ(n) hanya terdefinisi untuk n > 0', vi: 'λ(n) chỉ xác định khi n > 0', ru: 'λ(n) определена только при n > 0', it: 'λ(n) è definita solo per n > 0'));
    }

    if (n == BigInt.one) return BigInt.one;

    // Factor n into prime powers
    final Map<BigInt, int> primeFactors = factorize(n);

    // Compute λ for each prime power and then the lcm
    BigInt result = BigInt.one;

    primeFactors.forEach((p, k) {
      BigInt lambdaPk;

      if (p == BigInt.two) {
        if (k == 1) {
          lambdaPk = BigInt.one;
        } else if (k == 2) {
          lambdaPk = BigInt.two;
        } else {
          // λ(2^k) = 2^(k-2) for k ≥ 3
          lambdaPk = BigInt.two.pow(k - 2);
        }
      } else {
        // λ(p^k) = φ(p^k) = p^(k-1) * (p - 1) for odd prime p
        lambdaPk = p.pow(k - 1) * (p - BigInt.one);
      }

      result = lcm(result, lambdaPk);
    });

    return result;
  }

  /// sopfr(n) - Sum of prime factors with repetition
  /// sopfr(12) = 2 + 2 + 3 = 7 because 12 = 2² × 3
  /// sopfr(1) = 0
  static BigInt sopfr(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError(trLocale('sopfr(n) solo está definido para n > 0', 'sopfr(n) is only defined for n > 0', pt: 'sopfr(n) só está definido para n > 0', fr: "sopfr(n) n'est défini que pour n > 0", id: 'sopfr(n) hanya terdefinisi untuk n > 0', vi: 'sopfr(n) chỉ xác định khi n > 0', ru: 'sopfr(n) определена только при n > 0', it: 'sopfr(n) è definita solo per n > 0'));
    }

    if (n == BigInt.one) return BigInt.zero;

    // sopfr counts each prime as many times as it appears.
    BigInt sum = BigInt.zero;
    factorize(n).forEach((p, e) => sum += p * BigInt.from(e));

    return sum;
  }

  /// sopf(n) - Sum of distinct prime factors (without repetition)
  /// sopf(12) = 2 + 3 = 5 because 12 = 2² × 3
  /// sopf(1) = 0
  static BigInt sopf(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError(trLocale('sopf(n) solo está definido para n > 0', 'sopf(n) is only defined for n > 0', pt: 'sopf(n) só está definido para n > 0', fr: "sopf(n) n'est défini que pour n > 0", id: 'sopf(n) hanya terdefinisi untuk n > 0', vi: 'sopf(n) chỉ xác định khi n > 0', ru: 'sopf(n) определена только при n > 0', it: 'sopf(n) è definita solo per n > 0'));
    }

    if (n == BigInt.one) return BigInt.zero;

    // sopf counts each distinct prime once.
    BigInt sum = BigInt.zero;
    for (final p in factorize(n).keys) {
      sum += p;
    }

    return sum;
  }

  // ====================================================================
  // NEW FUNCTIONS FOR OLYMPIADS
  // ====================================================================

  /// Modular exponentiation: a^b mod n using repeated squaring
  /// Efficient even for huge exponents
  static BigInt modPow(BigInt base, BigInt exponent, BigInt modulus) {
    if (modulus <= BigInt.zero) {
      throw ArgumentError(trLocale('El módulo debe ser > 0', 'The modulus must be > 0', pt: 'O módulo deve ser > 0', fr: 'Le module doit être > 0', id: 'Modulus harus > 0', vi: 'Modulo phải > 0', ru: 'Модуль должен быть > 0', it: 'Il modulo deve essere > 0'));
    }
    if (modulus == BigInt.one) return BigInt.zero;
    if (exponent < BigInt.zero) {
      // a^(-b) mod n = (a^(-1))^b mod n
      BigInt? inv = modularInverse(base, modulus);
      if (inv == null) {
        throw ArgumentError(trLocale('No existe inverso modular, no se puede calcular exponente negativo', 'No modular inverse exists; cannot compute a negative exponent', pt: 'Não existe inverso modular; não é possível calcular expoente negativo', fr: 'Aucun inverse modulaire : impossible de calculer un exposant négatif', id: 'Tidak ada invers modular: eksponen negatif tidak dapat dihitung', vi: 'Không tồn tại nghịch đảo modulo: không tính được số mũ âm', ru: 'Обратного по модулю не существует: отрицательный показатель вычислить нельзя', it: "Non esiste l'inverso modulare: impossibile calcolare un esponente negativo"));
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

  /// Multiplicative order: smallest k > 0 such that a^k ≡ 1 (mod n)
  /// Requires gcd(a, n) = 1
  static BigInt multiplicativeOrder(BigInt a, BigInt n) {
    if (n <= BigInt.one) {
      throw ArgumentError(trLocale('n debe ser > 1', 'n must be > 1', pt: 'n deve ser > 1', fr: 'n doit être > 1', id: 'n harus > 1', vi: 'n phải > 1', ru: 'n должно быть > 1', it: 'n deve essere > 1'));
    }
    if (gcd(a, n) != BigInt.one) {
      throw ArgumentError(trLocale('gcd(a, n) debe ser 1 para que exista el orden', 'gcd(a, n) must be 1 for the order to exist', pt: 'mdc(a, n) deve ser 1 para que a ordem exista', fr: "pgcd(a, n) doit valoir 1 pour que l'ordre existe", id: 'Agar ordenya ada, FPB(a, n) harus bernilai 1', vi: 'Cấp chỉ tồn tại khi ƯCLN(a, n) = 1', ru: 'Чтобы порядок существовал, НОД(a, n) должен равняться 1', it: "MCD(a, n) deve valere 1 perché l'ordine esista"));
    }

    a = a % n;
    if (a < BigInt.zero) a += n;

    // The order divides φ(n), so we search among the divisors of φ(n)
    BigInt phi = eulerPhi(n);
    List<BigInt> divisors = _getDivisors(phi);
    divisors.sort();

    for (BigInt d in divisors) {
      if (modPow(a, d, n) == BigInt.one) {
        return d;
      }
    }

    return phi; // Always divides φ(n)
  }

  /// Checks whether g is a primitive root mod n
  /// g is a primitive root if ord_n(g) = φ(n)
  static bool isPrimitiveRoot(BigInt g, BigInt n) {
    if (n <= BigInt.one) return false;
    if (gcd(g, n) != BigInt.one) return false;

    BigInt phi = eulerPhi(n);
    // Verify that g^(φ(n)/p) ≢ 1 (mod n) for each prime p dividing φ(n)
    final Iterable<BigInt> primeFactorsOfPhi = factorize(phi).keys;

    for (BigInt p in primeFactorsOfPhi) {
      if (modPow(g, phi ~/ p, n) == BigInt.one) {
        return false;
      }
    }

    return true;
  }

  /// Finds the smallest primitive root mod n (if it exists)
  /// Only exists for n = 1, 2, 4, p^k, 2p^k (p odd prime)
  static BigInt? findPrimitiveRoot(BigInt n) {
    if (n <= BigInt.one) return null;
    if (n == BigInt.two) return BigInt.one;

    for (BigInt g = BigInt.two; g < n; g += BigInt.one) {
      if (gcd(g, n) != BigInt.one) continue;
      if (isPrimitiveRoot(g, n)) {
        return g;
      }
      // Limit the search for very large numbers
      if (g > BigInt.from(10000)) return null;
    }

    return null;
  }

  /// Legendre symbol (a/p) for odd prime p
  /// Returns 1 if a is a quadratic residue mod p, -1 if not, 0 if p|a
  static int legendreSymbol(BigInt a, BigInt p) {
    if (p <= BigInt.two) {
      throw ArgumentError(trLocale('p debe ser un primo impar > 2', 'p must be an odd prime > 2', pt: 'p deve ser um primo ímpar > 2', fr: 'p doit être un nombre premier impair > 2', id: 'p harus bilangan prima ganjil > 2', vi: 'p phải là số nguyên tố lẻ > 2', ru: 'p должно быть нечётным простым > 2', it: 'p deve essere un primo dispari > 2'));
    }

    a = a % p;
    if (a < BigInt.zero) a += p;
    if (a == BigInt.zero) return 0;

    // Euler's criterion: (a/p) ≡ a^((p-1)/2) (mod p)
    BigInt result = modPow(a, (p - BigInt.one) ~/ BigInt.two, p);
    if (result == BigInt.one) return 1;
    if (result == p - BigInt.one) return -1;
    return 0;
  }

  /// Jacobi symbol (a/n), generalization of the Legendre symbol
  /// n must be a positive odd number
  static int jacobiSymbol(BigInt a, BigInt n) {
    if (n <= BigInt.zero || n.isEven) {
      throw ArgumentError(trLocale('n debe ser impar positivo', 'n must be a positive odd number', pt: 'n deve ser ímpar positivo', fr: 'n doit être impair et positif', id: 'n harus ganjil dan positif', vi: 'n phải là số lẻ dương', ru: 'n должно быть нечётным положительным', it: 'n deve essere dispari e positivo'));
    }
    if (n == BigInt.one) return 1;

    a = a % n;
    if (a < BigInt.zero) a += n;

    int result = 1;

    while (a != BigInt.zero) {
      // Extract factors of 2
      while (a.isEven) {
        a >>= 1;
        BigInt nMod8 = n % BigInt.from(8);
        if (nMod8 == BigInt.from(3) || nMod8 == BigInt.from(5)) {
          result = -result;
        }
      }

      // Quadratic reciprocity
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

  /// Solves the linear Diophantine equation ax + by = c
  /// Returns {solvable, x0, y0, dx, dy} where the general solution is
  /// x = x0 + dx*t, y = y0 + dy*t for every integer t
  static Map<String, dynamic> solveDiophantine(BigInt a, BigInt b, BigInt c) {
    if (a == BigInt.zero && b == BigInt.zero) {
      return {
        'solvable': c == BigInt.zero,
        'note': c == BigInt.zero
            ? trLocale('Infinitas soluciones (0x + 0y = 0)',
                'Infinitely many solutions (0x + 0y = 0)', pt: 'Infinitas soluções (0x + 0y = 0)', fr: 'Une infinité de solutions (0x + 0y = 0)', id: 'Tak hingga banyak solusi (0x + 0y = 0)', vi: 'Vô số nghiệm (0x + 0y = 0)', ru: 'Бесконечно много решений (0x + 0y = 0)', it: 'Infinite soluzioni (0x + 0y = 0)')
            : trLocale('Sin solución (0x + 0y ≠ $c)',
                'No solution (0x + 0y ≠ $c)', pt: 'Sem solução (0x + 0y ≠ $c)', fr: 'Aucune solution (0x + 0y ≠ $c)', id: 'Tidak ada solusi (0x + 0y ≠ $c)', vi: 'Vô nghiệm (0x + 0y ≠ $c)', ru: 'Решений нет (0x + 0y ≠ $c)', it: 'Nessuna soluzione (0x + 0y ≠ $c)'),
      };
    }

    BigInt g = gcd(a, b);
    if (c % g != BigInt.zero) {
      return {
        'solvable': false,
        'note': trLocale('Sin solución: gcd($a,$b) = $g no divide a $c',
            'No solution: gcd($a,$b) = $g does not divide $c', pt: 'Sem solução: mdc($a,$b) = $g não divide $c', fr: 'Aucune solution : pgcd($a,$b) = $g ne divise pas $c', id: 'Tidak ada solusi: FPB($a,$b) = $g tidak membagi $c', vi: 'Vô nghiệm: ƯCLN($a,$b) = $g không chia hết $c', ru: 'Решений нет: НОД($a,$b) = $g не делит $c', it: 'Nessuna soluzione: MCD($a,$b) = $g non divide $c'),
      };
    }

    // Reduce: (a/g)x + (b/g)y = c/g
    BigInt aReduced = a ~/ g;
    BigInt bReduced = b ~/ g;
    BigInt cReduced = c ~/ g;

    // Solve using extended Euclid for aReduced*x + bReduced*y = 1
    List<BigInt> ext = _extendedGcd(aReduced.abs(), bReduced.abs());
    BigInt x0 = ext[1] * cReduced;
    BigInt y0 = ext[2] * cReduced;

    // Adjust signs
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

  /// Extended Euclidean algorithm: returns [gcd, x, y] such that ax + by = gcd
  static List<BigInt> _extendedGcd(BigInt a, BigInt b) {
    if (b == BigInt.zero) {
      return [a, BigInt.one, BigInt.zero];
    }
    List<BigInt> result = _extendedGcd(b, a % b);
    return [result[0], result[2], result[1] - (a ~/ b) * result[2]];
  }

  /// Chinese Remainder Theorem
  /// Solves the system: x ≡ a₁ (mod m₁), x ≡ a₂ (mod m₂), ...
  /// remainders = [a₁, a₂, ...], moduli = [m₁, m₂, ...]
  static Map<String, dynamic> chineseRemainderTheorem(
      List<BigInt> remainders, List<BigInt> moduli) {
    if (remainders.length != moduli.length || remainders.isEmpty) {
      throw ArgumentError(trLocale('Las listas deben tener el mismo tamaño y no estar vacías', 'The lists must have the same size and not be empty', pt: 'As listas devem ter o mesmo tamanho e não estar vazias', fr: 'Les listes doivent avoir la même taille et ne pas être vides', id: 'Kedua daftar harus sama panjang dan tidak kosong', vi: 'Hai danh sách phải cùng độ dài và không rỗng', ru: 'Списки должны быть одинаковой длины и непустыми', it: 'Le liste devono avere la stessa dimensione e non essere vuote'));
    }
    // A zero modulus made lcm and (m2 ~/ g) zero further down, surfacing as a
    // raw IntegerDivisionByZeroException in the UI; a negative one silently
    // produced a wrong congruence.
    if (moduli.any((m) => m <= BigInt.zero)) {
      throw ArgumentError(trLocale('Los módulos deben ser positivos',
          'The moduli must be positive', pt: 'Os módulos devem ser positivos', fr: 'Les modules doivent être positifs', id: 'Modulusnya harus positif', vi: 'Các modulo phải dương', ru: 'Модули должны быть положительными', it: 'I moduli devono essere positivi'));
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
          'note': trLocale('Sin solución: sistema incompatible',
              'No solution: incompatible system', pt: 'Sem solução: sistema incompatível', fr: 'Aucune solution : système incompatible', id: 'Tidak ada solusi: sistem tidak konsisten', vi: 'Vô nghiệm: hệ không tương thích', ru: 'Решений нет: система несовместна', it: 'Nessuna soluzione: sistema incompatibile'),
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
      throw ArgumentError(trLocale('El factorial no está definido para negativos', 'Factorial is not defined for negative numbers', pt: 'O fatorial não está definido para negativos', fr: "La factorielle n'est pas définie pour les nombres négatifs", id: 'Faktorial tidak terdefinisi untuk bilangan negatif', vi: 'Giai thừa không xác định với số âm', ru: 'Факториал не определён для отрицательных чисел', it: 'Il fattoriale non è definito per i numeri negativi'));
    }
    if (n <= 1) return BigInt.one;

    BigInt result = BigInt.one;
    for (int i = 2; i <= n; i++) {
      result *= BigInt.from(i);
    }

    return result;
  }

  /// Double factorial n!!
  /// n!! = n × (n-2) × (n-4) × ... × (2 o 1)
  static BigInt doubleFactorial(int n) {
    if (n < 0) {
      throw ArgumentError(trLocale('El doble factorial no está definido para negativos', 'Double factorial is not defined for negative numbers', pt: 'O fatorial duplo não está definido para negativos', fr: "La double factorielle n'est pas définie pour les nombres négatifs", id: 'Faktorial ganda tidak terdefinisi untuk bilangan negatif', vi: 'Giai thừa kép không xác định với số âm', ru: 'Двойной факториал не определён для отрицательных чисел', it: 'Il semifattoriale non è definito per i numeri negativi'));
    }
    if (n <= 1) return BigInt.one;

    BigInt result = BigInt.one;
    for (int i = n; i >= 1; i -= 2) {
      result *= BigInt.from(i);
    }

    return result;
  }

  /// n-th Fibonacci number using matrix exponentiation
  /// F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2)
  static BigInt fibonacci(int n) {
    if (n < 0) {
      throw ArgumentError(trLocale('n debe ser ≥ 0', 'n must be ≥ 0', pt: 'n deve ser ≥ 0', fr: 'n doit être ≥ 0', id: 'n harus ≥ 0', vi: 'n phải ≥ 0', ru: 'n должно быть ≥ 0', it: 'n deve essere ≥ 0'));
    }
    if (n == 0) return BigInt.zero;
    if (n <= 2) return BigInt.one;

    // Fast doubling method: O(log n)
    return _fibFast(n)[0];
  }

  /// Fast Fibonacci using doubling identities
  /// Returns [F(n), F(n+1)]
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

  /// n-th Catalan number: C_n = C(2n,n)/(n+1)
  static BigInt catalanNumber(int n) {
    if (n < 0) {
      throw ArgumentError(trLocale('n debe ser ≥ 0', 'n must be ≥ 0', pt: 'n deve ser ≥ 0', fr: 'n doit être ≥ 0', id: 'n harus ≥ 0', vi: 'n phải ≥ 0', ru: 'n должно быть ≥ 0', it: 'n deve essere ≥ 0'));
    }

    return combinations(2 * n, n) ~/ BigInt.from(n + 1);
  }

  /// Derangements D(n): permutations with no fixed points
  /// D(n) = n! × Σ(-1)^k/k! for k=0..n
  /// D(n) = (n-1)(D(n-1) + D(n-2))
  static BigInt derangement(int n) {
    if (n < 0) {
      throw ArgumentError(trLocale('n debe ser ≥ 0', 'n must be ≥ 0', pt: 'n deve ser ≥ 0', fr: 'n doit être ≥ 0', id: 'n harus ≥ 0', vi: 'n phải ≥ 0', ru: 'n должно быть ≥ 0', it: 'n deve essere ≥ 0'));
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

  /// Partitions p(n): number of ways to write n as a sum of positive integers
  /// Uses dynamic programming
  static BigInt partition(int n) {
    if (n < 0) return BigInt.zero;
    if (n == 0) return BigInt.one;

    // Limit to avoid memory issues
    if (n > 10000) {
      throw ArgumentError(trLocale('n demasiado grande para calcular particiones (máx 10000)', 'n too large to compute partitions (max 10000)', pt: 'n grande demais para calcular partições (máx 10000)', fr: 'n trop grand pour calculer les partitions (max 10000)', id: 'n terlalu besar untuk menghitung partisi (maks. 10000)', vi: 'n quá lớn để tính phân hoạch (tối đa 10000)', ru: 'n слишком велико для вычисления разбиений (макс. 10000)', it: 'n troppo grande per calcolare le partizioni (max 10000)'));
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

  /// Stirling numbers of the second kind S(n,k)
  /// Number of ways to partition a set of n elements into k non-empty subsets
  static BigInt stirlingSecond(int n, int k) {
    if (k < 0 || k > n) return BigInt.zero;
    if (k == 0 && n == 0) return BigInt.one;
    if (k == 0 || n == 0) return BigInt.zero;
    if (k == 1 || k == n) return BigInt.one;

    // Formula: S(n,k) = (1/k!) × Σ (-1)^j × C(k,j) × (k-j)^n
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

  /// Stirling numbers of the first kind (unsigned) |s(n,k)|
  /// Number of permutations of n with exactly k cycles
  static BigInt stirlingFirst(int n, int k) {
    if (k < 0 || k > n) return BigInt.zero;
    if (k == 0 && n == 0) return BigInt.one;
    if (k == 0 || n == 0) return BigInt.zero;

    // Use the recurrence: |s(n,k)| = (n-1)|s(n-1,k)| + |s(n-1,k-1)|
    // DP table
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

  /// Bell numbers B(n): total number of partitions of a set of n elements
  static BigInt bellNumber(int n) {
    if (n < 0) {
      throw ArgumentError(trLocale('n debe ser ≥ 0', 'n must be ≥ 0', pt: 'n deve ser ≥ 0', fr: 'n doit être ≥ 0', id: 'n harus ≥ 0', vi: 'n phải ≥ 0', ru: 'n должно быть ≥ 0', it: 'n deve essere ≥ 0'));
    }
    if (n == 0) return BigInt.one;

    // B(n) = Σ S(n,k) for k=0..n
    BigInt sum = BigInt.zero;
    for (int k = 0; k <= n; k++) {
      sum += stirlingSecond(n, k);
    }
    return sum;
  }

  /// Digital root: apply digit sum iteratively until a single digit remains
  static int digitalRoot(BigInt n) {
    n = n.abs();
    if (n == BigInt.zero) return 0;

    // Direct formula: dr(n) = 1 + (n-1) mod 9
    BigInt nine = BigInt.from(9);
    BigInt result = BigInt.one + ((n - BigInt.one) % nine);
    return result.toInt();
  }

  /// Digit sum in base b
  static BigInt digitSumInBase(BigInt n, int base) {
    if (base < 2) {
      throw ArgumentError(trLocale('La base debe ser ≥ 2', 'The base must be ≥ 2', pt: 'A base deve ser ≥ 2', fr: 'La base doit être ≥ 2', id: 'Basisnya harus ≥ 2', vi: 'Cơ số phải ≥ 2', ru: 'Основание должно быть ≥ 2', it: 'La base deve essere ≥ 2'));
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

  /// Checks whether n is an abundant number: σ(1,n) > 2n
  static bool isAbundant(BigInt n) {
    if (n <= BigInt.one) return false;
    BigInt sigma = BigInt.zero;
    for (BigInt d in _getDivisors(n)) {
      sigma += d;
    }
    return sigma > BigInt.two * n;
  }

  /// Checks whether n is a deficient number: σ(1,n) < 2n
  static bool isDeficient(BigInt n) {
    if (n <= BigInt.one) return true;
    BigInt sigma = BigInt.zero;
    for (BigInt d in _getDivisors(n)) {
      sigma += d;
    }
    return sigma < BigInt.two * n;
  }

  /// Checks whether n is squarefree: μ(n) ≠ 0
  static bool isSquareFree(BigInt n) {
    if (n <= BigInt.zero) return false;
    if (n == BigInt.one) return true;

    // Squarefree ⟺ no prime appears with exponent ≥ 2.
    return factorize(n).values.every((e) => e == 1);
  }

  /// Checks whether n is a powerful number: p²|n for every prime p dividing n
  static bool isPowerful(BigInt n) {
    if (n <= BigInt.one) return n == BigInt.one;

    // Powerful ⟺ every prime appears with exponent ≥ 2.
    return factorize(n).values.every((e) => e >= 2);
  }

  /// Checks whether n is a Harshad number: n divisible by its digit sum
  static bool isHarshad(BigInt n) {
    if (n <= BigInt.zero) return false;
    String digits = n.toString();
    int digitSum = 0;
    for (int i = 0; i < digits.length; i++) {
      digitSum += int.parse(digits[i]);
    }
    return n % BigInt.from(digitSum) == BigInt.zero;
  }

  /// Checks whether n is a semiprime: n = p × q (product of exactly two primes)
  static bool isSemiprime(BigInt n) {
    if (n < BigInt.from(4)) return false;
    return bigOmega(n) == 2;
  }

  /// Approximate π(n) - prime-counting function
  /// For small n (≤ 1000000) computes exactly with a sieve,
  /// for large n uses Li(x) as an approximation
  static Map<String, dynamic> primeCountingFunction(BigInt n) {
    if (n < BigInt.two) {
      return {'count': 0, 'exact': true};
    }

    // For small numbers, use a sieve
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

    // For large numbers, approximation with Li(x).
    //
    // ln(n) is derived from the digit count instead of double.parse(n), which
    // overflows to Infinity beyond ~1.8e308 and made li.round() throw for any
    // 309-digit input — precisely the sizes this app is built for.
    final double lnX = _naturalLog(n);
    final double liOverX = 1 / lnX * (1 + 1 / lnX + 2 / (lnX * lnX));

    // count ≈ n · liOverX, kept in BigInt so the magnitude never overflows.
    final BigInt count = (BigInt.from((liOverX * 1e18).round()) * n) ~/
        BigInt.from(10).pow(18);
    return {'count': count, 'exact': false, 'approx': true};
  }

  /// ln(n) for arbitrarily large [n], via its decimal digits:
  /// ln(n) = ln(mantissa) + (digits − 1)·ln(10).
  static double _naturalLog(BigInt n) {
    final String digits = n.toString();
    final double mantissa = double.parse(
        '${digits[0]}.${digits.length > 1 ? digits.substring(1, math.min(17, digits.length)) : '0'}');
    return math.log(mantissa) + (digits.length - 1) * math.ln10;
  }

  /// Liouville function λ_L(n) (different from Carmichael's)
  /// λ_L(n) = (-1)^Ω(n)
  static int liouvilleFunction(BigInt n) {
    if (n <= BigInt.zero) {
      throw ArgumentError(trLocale('λ_L(n) solo está definido para n > 0', 'λ_L(n) is only defined for n > 0', pt: 'λ_L(n) só está definido para n > 0', fr: "λ_L(n) n'est défini que pour n > 0", id: 'λ_L(n) hanya terdefinisi untuk n > 0', vi: 'λ_L(n) chỉ xác định khi n > 0', ru: 'λ_L(n) определена только при n > 0', it: 'λ_L(n) è definita solo per n > 0'));
    }
    return bigOmega(n) % 2 == 0 ? 1 : -1;
  }

  /// Modular exponentiation for solving congruences: a^b mod n
  /// Friendlier wrapper
  static BigInt powerMod(BigInt a, BigInt b, BigInt n) {
    return modPow(a, b, n);
  }
}
