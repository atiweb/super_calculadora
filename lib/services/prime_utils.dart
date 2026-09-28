import 'package:flutter/foundation.dart' show compute;

/// Entry point for the isolate: the first prime after [start].
String nextPrimeIsolate(BigInt start) {
  BigInt candidate = start + BigInt.one;
  while (!isProbablyPrime(candidate)) {
    candidate += BigInt.one;
  }
  return candidate.toString();
}

/// The first 13 prime bases. With them Miller–Rabin is DETERMINISTIC (no
/// false positives) for every n < ψ₁₃ = 3317044064679887385961981
/// (OEIS A014233). The first 12 only reach ψ₁₂ = 318665857834031151167461,
/// which is itself composite (399165290221 × 798330580441) and was reported
/// prime before base 41 was added.
///
/// Note: an older version used only {2,3,5,7}, with which 3215031751
/// (= 151·751·28351) —a strong pseudoprime to those four bases— was
/// wrongly classified as prime.
const List<int> _millerRabinBases = [
  2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41,
];

/// ψ₁₃: below it the bases above are a proof; at or above it
/// [isProbablyPrime] adds a strong Lucas test (Baillie–PSW).
final BigInt _deterministicBound = BigInt.parse('3317044064679887385961981');

/// Primality test: Miller–Rabin with [_millerRabinBases] (a proof below
/// ψ₁₃), plus a strong Lucas test above it — together the Baillie–PSW test,
/// for which no composite that passes is known.
///
/// [k] is kept for signature compatibility but no longer limits the number of
/// witnesses: the bases from [_millerRabinBases] are always used.
bool isProbablyPrime(BigInt n, {int k = 10}) {
  if (n < BigInt.two) return false;

  // Quick sieve by the prime bases: also handles the case n == base.
  for (final p in _millerRabinBases) {
    final bp = BigInt.from(p);
    if (n == bp) return true;
    if (n % bp == BigInt.zero) return false;
  }
  // Here n > 37 and not divisible by any base, so every base < n-1.

  BigInt d = n - BigInt.one;
  int s = 0;
  while (d.isEven) {
    d ~/= BigInt.two;
    s += 1;
  }

  final BigInt nMinus1 = n - BigInt.one;
  for (final p in _millerRabinBases) {
    BigInt x = BigInt.from(p).modPow(d, n);
    if (x == BigInt.one || x == nMinus1) continue;

    bool probablePrime = false;
    for (int r = 1; r < s; r++) {
      x = x.modPow(BigInt.two, n);
      if (x == nMinus1) {
        probablePrime = true;
        break;
      }
    }
    if (!probablePrime) return false; // witness of compositeness
  }

  if (n < _deterministicBound) return true;
  return isStrongLucasProbablePrime(n);
}

/// Jacobi symbol (a/n) for odd n > 0.
int _jacobi(BigInt a, BigInt n) {
  a = a % n;
  int result = 1;
  final BigInt three = BigInt.from(3);
  final BigInt four = BigInt.from(4);
  final BigInt five = BigInt.from(5);
  final BigInt eight = BigInt.from(8);
  while (a != BigInt.zero) {
    while (a.isEven) {
      a = a >> 1;
      final BigInt r = n % eight;
      if (r == three || r == five) result = -result;
    }
    final BigInt t = a;
    a = n;
    n = t;
    if (a % four == three && n % four == three) result = -result;
    a = a % n;
  }
  return n == BigInt.one ? result : 0;
}

/// Strong Lucas probable-prime test with Selfridge's parameters (method A:
/// the first D in 5, −7, 9, −11, … with Jacobi(D/n) = −1; P = 1,
/// Q = (1 − D)/4). For odd n > 2 that is not a perfect square.
bool isStrongLucasProbablePrime(BigInt n) {
  if (n == BigInt.two) return true;
  if (n < BigInt.two || n.isEven) return false;
  // A square has no D with Jacobi −1, and the search below would not end.
  final BigInt root = _iroot(n, 2);
  if (root * root == n) return false;

  int dAbs = 5;
  int sign = 1;
  BigInt d;
  while (true) {
    d = BigInt.from(dAbs * sign);
    final int j = _jacobi(d, n);
    if (j == -1) break;
    if (j == 0 && BigInt.from(dAbs) != n) return false; // shares a factor
    dAbs += 2;
    sign = -sign;
  }
  final BigInt q = (BigInt.one - d) ~/ BigInt.from(4);

  // n + 1 = dOdd · 2^s
  BigInt dOdd = n + BigInt.one;
  int s = 0;
  while (dOdd.isEven) {
    dOdd = dOdd >> 1;
    s++;
  }

  BigInt half(BigInt x) {
    x = x % n;
    return (x.isOdd ? x + n : x) >> 1;
  }

  // U_1 = 1, V_1 = P = 1, Q^1; then binary ladder over the bits of dOdd.
  BigInt u = BigInt.one;
  BigInt v = BigInt.one;
  BigInt qk = q % n;
  for (int bit = dOdd.bitLength - 2; bit >= 0; bit--) {
    u = (u * v) % n;
    v = (v * v - BigInt.two * qk) % n;
    qk = (qk * qk) % n;
    if ((dOdd >> bit).isOdd) {
      final BigInt nu = half(u + v); // (P·U + V)/2 with P = 1
      final BigInt nv = half(d * u + v); // (D·U + P·V)/2
      u = nu;
      v = nv;
      qk = (qk * q) % n;
    }
  }
  if (u == BigInt.zero || v == BigInt.zero) return true;
  for (int r = 1; r < s; r++) {
    v = (v * v - BigInt.two * qk) % n;
    qk = (qk * qk) % n;
    if (v == BigInt.zero) return true;
  }
  return false;
}

/// Complete prime factorization of [n] as a `{prime: exponent}` map.
///
/// Trial division by small factors (up to 10⁵) and Pollard-rho for whatever
/// remains, so the cost tracks the size of the SMALLEST factor rather than √n.
/// Plain trial division needs ~√n steps, which for a 20-digit prime is hours
/// and for a 30-digit prime is years; this returns in milliseconds.
///
/// Returns an empty map for n < 2.
Map<BigInt, int> factorize(BigInt n) {
  final Map<BigInt, int> factors = {};
  if (n < BigInt.two) return factors;

  BigInt m = n;
  void add(BigInt p) => factors[p] = (factors[p] ?? 0) + 1;

  while (m % BigInt.two == BigInt.zero) {
    add(BigInt.two);
    m ~/= BigInt.two;
  }

  final BigInt trialLimit = BigInt.from(100000);
  for (BigInt d = BigInt.from(3); d <= trialLimit && d * d <= m; d += BigInt.two) {
    while (m % d == BigInt.zero) {
      add(d);
      m ~/= d;
    }
  }

  if (m > BigInt.one) _factorLarge(m, add);
  return factors;
}

/// Splits [n] (odd, free of factors ≤ 10⁵) into primes via Pollard-rho.
void _factorLarge(BigInt n, void Function(BigInt) add) {
  if (n == BigInt.one) return;
  if (isProbablyPrime(n)) {
    add(n);
    return;
  }

  // Perfect powers first. Pollard-rho costs ~√p in the smallest factor, so a
  // square of a 15-digit prime (√(4p²), an ordinary radical to simplify) took
  // about five minutes; an integer k-th root settles it in a few operations.
  final ({BigInt base, int exp})? power = _asPerfectPower(n);
  if (power != null) {
    final List<BigInt> baseFactors = [];
    _factorLarge(power.base, baseFactors.add);
    for (final p in baseFactors) {
      for (int i = 0; i < power.exp; i++) {
        add(p);
      }
    }
    return;
  }

  final BigInt d = _pollardRho(n);
  _factorLarge(d, add);
  _factorLarge(n ~/ d, add);
}

/// Writes [n] as base^exp with exp ≥ 2 when possible (smallest such base).
({BigInt base, int exp})? _asPerfectPower(BigInt n) {
  for (int k = 2; k <= n.bitLength; k++) {
    final BigInt r = _iroot(n, k);
    if (r < BigInt.two) break;
    if (r.pow(k) == n) return (base: r, exp: k);
  }
  return null;
}

/// Integer k-th root (floor) via Newton's method.
BigInt _iroot(BigInt n, int k) {
  if (n < BigInt.two) return n;
  final BigInt kb = BigInt.from(k);
  BigInt x = BigInt.one << ((n.bitLength + k - 1) ~/ k);
  while (true) {
    final BigInt y = ((kb - BigInt.one) * x + n ~/ x.pow(k - 1)) ~/ kb;
    if (y >= x) return x;
    x = y;
  }
}

/// Non-trivial divisor of an odd composite: Pollard-rho with Brent's cycle
/// detection and the gcd taken once per batch of [batch] products instead of
/// once per step (Floyd with a gcd per step took 35 s on a 12×15-digit
/// semiprime). Retries with a different constant when it degenerates.
BigInt _pollardRho(BigInt n) {
  const int batch = 128;
  BigInt c = BigInt.one;
  while (true) {
    BigInt f(BigInt v) => (v * v + c) % n;
    BigInt y = BigInt.two;
    BigInt x = y;
    BigInt ys = y;
    BigInt q = BigInt.one;
    BigInt g = BigInt.one;
    int r = 1;
    do {
      x = y;
      for (int i = 0; i < r; i++) {
        y = f(y);
      }
      int k = 0;
      while (k < r && g == BigInt.one) {
        ys = y;
        final int steps = r - k < batch ? r - k : batch;
        for (int i = 0; i < steps; i++) {
          y = f(y);
          q = (q * (x - y).abs()) % n;
        }
        g = _gcd(q, n);
        k += batch;
      }
      r *= 2;
    } while (g == BigInt.one);
    if (g == n) {
      // The batch overshot: replay it one step at a time.
      do {
        ys = f(ys);
        g = _gcd((x - ys).abs(), n);
      } while (g == BigInt.one);
    }
    if (g != n) return g;
    c += BigInt.one;
  }
}

BigInt _gcd(BigInt a, BigInt b) {
  while (b != BigInt.zero) {
    final BigInt t = b;
    b = a % b;
    a = t;
  }
  return a;
}

/// All divisors of [n], sorted ascending, built from its factorization.
///
/// Returns `null` when the divisor count would exceed [limit]; callers should
/// then fall back to reporting the count instead of the full list, since a
/// highly composite number can have millions of divisors.
List<BigInt>? divisorsOf(BigInt n, {int limit = 100000}) {
  if (n <= BigInt.zero) return const [];
  final Map<BigInt, int> f = factorize(n);

  int count = 1;
  for (final e in f.values) {
    count *= e + 1;
    if (count > limit) return null;
  }

  List<BigInt> divisors = [BigInt.one];
  f.forEach((p, e) {
    final List<BigInt> expanded = [];
    BigInt power = BigInt.one;
    for (int i = 0; i <= e; i++) {
      for (final d in divisors) {
        expanded.add(d * power);
      }
      power *= p;
    }
    divisors = expanded;
  });

  divisors.sort();
  return divisors;
}

/// The next prime, searched in an isolate. `compute` rather than
/// `Isolate.spawn`: the web build has no isolates, so ReceivePort threw
/// "Unsupported operation" and the analysis panel showed "calculation error"
/// for the neighbouring primes of every number past 10 digits.
Future<String> findNextPrime(BigInt number) =>
    compute(nextPrimeIsolate, number);
