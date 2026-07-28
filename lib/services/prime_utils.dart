import 'dart:isolate';

/// Entry point for the isolate
void nextPrimeIsolate(Map<String, dynamic> message) {
  final SendPort sendPort = message['sendPort'];
  final BigInt start = message['start'];

  BigInt candidate = start + BigInt.one;
  while (!isProbablyPrime(candidate)) {
    candidate += BigInt.one;
  }

  sendPort.send(candidate.toString());
}

/// The first 12 prime bases. With this set of witnesses, the Miller–Rabin
/// test is DETERMINISTIC (no false positives) for every n less than
/// 3.317 × 10^24. Above that bound it remains an extraordinarily reliable
/// probabilistic test (error prob. < 4^-12 per composite).
///
/// Note: the previous version used only {2,3,5,7}, with which 3215031751
/// (= 151·751·28351) —a strong pseudoprime to those four bases— was
/// wrongly classified as prime.
const List<int> _millerRabinBases = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37];

/// Miller–Rabin primality test.
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

  return true;
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

/// Non-trivial divisor of an odd composite (Pollard-rho, Floyd cycle
/// detection), retrying with a different constant when it degenerates.
BigInt _pollardRho(BigInt n) {
  BigInt c = BigInt.one;
  while (true) {
    BigInt x = BigInt.two;
    BigInt y = BigInt.two;
    BigInt d = BigInt.one;
    while (d == BigInt.one) {
      x = (x * x + c) % n;
      y = (y * y + c) % n;
      y = (y * y + c) % n;
      d = _gcd((x - y).abs(), n);
    }
    if (d != n) return d;
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

/// Spawns the isolate and returns the next prime
Future<String> findNextPrime(BigInt number) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(
    nextPrimeIsolate,
    {
      'sendPort': receivePort.sendPort,
      'start': number,
    },
  );

  return await receivePort.first;
}
