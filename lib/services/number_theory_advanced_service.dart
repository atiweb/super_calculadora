import '../models/calc_exception.dart';
import '../utils/app_locale.dart';
import '../models/fraction.dart';
import 'prime_utils.dart';
import 'special_functions_service.dart';

/// Advanced number theory functions for olympiad training:
/// modular roots, congruences, continued fractions, Pell's equation,
/// sums of squares, Frobenius number, etc.
class NumberTheoryAdvancedService {
  static final BigInt _zero = BigInt.zero;
  static final BigInt _one = BigInt.one;
  static final BigInt _two = BigInt.two;

  // ── Modular square root (Tonelli-Shanks) ─────────────────────────────────

  /// Returns r such that r² ≡ a (mod p), or `null` if a is not a quadratic residue.
  /// Requires p to be prime. The other root is p − r.
  ///
  /// Primality is enforced rather than assumed: with a composite modulus the
  /// non-residue search below may never terminate (mod 9, for instance, no z
  /// satisfies z^((p−1)/2) ≡ p−1), which froze the app permanently on a typo
  /// such as 9 instead of 7.
  static BigInt? sqrtMod(BigInt a, BigInt p) {
    if (p < _two || !isProbablyPrime(p)) {
      throw CalcException(CalcError.primeRequired, {'value': p.toString()});
    }

    a = a % p;
    if (a.isNegative) a += p;
    if (a == _zero) return _zero;
    if (p == _two) return a;

    // Euler's criterion: a must be a quadratic residue.
    if (SpecialFunctionsService.modPow(a, (p - _one) ~/ _two, p) != _one) {
      return null;
    }

    // Shortcut for p ≡ 3 (mod 4).
    if (p % BigInt.from(4) == BigInt.from(3)) {
      return SpecialFunctionsService.modPow(a, (p + _one) ~/ BigInt.from(4), p);
    }

    // General Tonelli-Shanks.
    BigInt q = p - _one;
    int s = 0;
    while (q.isEven) {
      q ~/= _two;
      s++;
    }

    // Find a non-residue z.
    BigInt z = _two;
    while (SpecialFunctionsService.modPow(z, (p - _one) ~/ _two, p) != p - _one) {
      z += _one;
    }

    BigInt m = BigInt.from(s);
    BigInt c = SpecialFunctionsService.modPow(z, q, p);
    BigInt t = SpecialFunctionsService.modPow(a, q, p);
    BigInt r = SpecialFunctionsService.modPow(a, (q + _one) ~/ _two, p);

    while (t != _one) {
      BigInt tt = t;
      int i = 0;
      while (tt != _one) {
        tt = (tt * tt) % p;
        i++;
        if (BigInt.from(i) == m) return null; // should not happen if it is a QR
      }
      final BigInt b =
          SpecialFunctionsService.modPow(c, _two.pow((m - BigInt.from(i) - _one).toInt()), p);
      m = BigInt.from(i);
      c = (b * b) % p;
      t = (t * c) % p;
      r = (r * b) % p;
    }
    return r;
  }

  // ── Linear congruence ────────────────────────────────────────────────────

  /// Solves a·x ≡ b (mod n). Returns all solutions in [0, n),
  /// or an empty list if there is no solution.
  static List<BigInt> solveLinearCongruence(BigInt a, BigInt b, BigInt n) {
    if (n <= _zero) throw CalcException(CalcError.modulusPositive);
    a = a % n;
    if (a.isNegative) a += n;
    b = b % n;
    if (b.isNegative) b += n;

    final BigInt g = _gcd(a, n);
    if (b % g != _zero) return []; // no solution

    // The solution count is exactly g. Materializing it unbounded meant that
    // a·x ≡ b (mod 10⁹) with a = 0 built a billion-element list (freeze/OOM),
    // and no one reads that many residues anyway.
    if (g > BigInt.from(10000)) {
      throw CalcException(CalcError.inputTooLarge, {'max': '10000'});
    }

    final BigInt aR = a ~/ g;
    final BigInt bR = b ~/ g;
    final BigInt nR = n ~/ g;
    BigInt x0;
    if (nR == _one) {
      // a ≡ 0 and b ≡ 0 (mod n): every x is a solution. Asking for the inverse
      // mod 1 threw ArgumentError (n must be > 1) instead of solving.
      x0 = _zero;
    } else {
      final BigInt? inv = SpecialFunctionsService.modularInverse(aR % nR, nR);
      if (inv == null) return [];
      x0 = (bR * inv) % nR;
      if (x0.isNegative) x0 += nR;
    }

    final List<BigInt> solutions = [];
    for (BigInt k = _zero; k < g; k += _one) {
      solutions.add((x0 + k * nR) % n);
    }
    solutions.sort();
    return solutions;
  }

  // ── Lucas' theorem ───────────────────────────────────────────────────────

  /// C(n, k) mod p for prime p, using Lucas' theorem.
  static BigInt lucasTheorem(BigInt n, BigInt k, BigInt p) {
    if (k.isNegative || k > n) return _zero;
    // Each digit's binomial costs O(p): p ≈ 10^9 ran for minutes.
    if (p > BigInt.from(1000000)) {
      throw CalcException(CalcError.inputTooLarge, {'max': '1000000'});
    }
    BigInt result = _one;
    while (n > _zero || k > _zero) {
      final BigInt ni = n % p;
      final BigInt ki = k % p;
      if (ki > ni) return _zero;
      result = (result * _binomMod(ni, ki, p)) % p;
      n ~/= p;
      k ~/= p;
    }
    return result;
  }

  static BigInt _binomMod(BigInt n, BigInt k, BigInt p) {
    if (k.isNegative || k > n) return _zero;
    if (k > n - k) k = n - k;
    BigInt num = _one;
    BigInt den = _one;
    for (BigInt i = _zero; i < k; i += _one) {
      num = (num * ((n - i) % p)) % p;
      den = (den * ((i + _one) % p)) % p;
    }
    final BigInt? inv = SpecialFunctionsService.modularInverse(den, p);
    if (inv == null) return _zero;
    return (num * inv) % p;
  }

  // ── Continued fractions ──────────────────────────────────────────────────

  /// Continued fraction of a rational p/q → [a0; a1, a2, ...].
  static List<BigInt> continuedFraction(BigInt p, BigInt q) {
    if (q == _zero) throw CalcException(CalcError.zeroDenominator);
    final List<BigInt> result = [];
    while (q != _zero) {
      final BigInt a = _floorDiv(p, q);
      result.add(a);
      final BigInt r = p - a * q;
      p = q;
      q = r;
    }
    return result;
  }

  /// (Periodic) continued fraction of √n: returns (a0, period).
  /// If n is a perfect square, the period is empty.
  static ({BigInt a0, List<BigInt> period}) continuedFractionSqrt(BigInt n) {
    if (n < _zero) throw CalcException(CalcError.nNonNegative);
    final BigInt a0 = _isqrt(n);
    if (a0 * a0 == n) return (a0: a0, period: <BigInt>[]);

    final List<BigInt> period = [];
    BigInt m = _zero, d = _one, a = a0;
    do {
      m = d * a - m;
      d = (n - m * m) ~/ d;
      a = (a0 + m) ~/ d;
      period.add(a);
    } while (a != _two * a0);
    return (a0: a0, period: period);
  }

  /// Convergents of a continued fraction [a0; a1, ...] as fractions.
  static List<Fraction> convergents(List<BigInt> cf) {
    final List<Fraction> result = [];
    BigInt hPrev = _one, h = cf.isEmpty ? _zero : cf[0];
    BigInt kPrev = _zero, k = _one;
    if (cf.isNotEmpty) result.add(Fraction(h, k));
    for (int i = 1; i < cf.length; i++) {
      final BigInt hNext = cf[i] * h + hPrev;
      final BigInt kNext = cf[i] * k + kPrev;
      hPrev = h;
      h = hNext;
      kPrev = k;
      k = kNext;
      result.add(Fraction(h, k));
    }
    return result;
  }

  // ── Pell's equation ──────────────────────────────────────────────────────

  /// Fundamental (minimal, x>0) solution of x² − D·y² = 1, for non-square D.
  static ({BigInt x, BigInt y}) solvePell(BigInt D) {
    if (D <= _zero) throw CalcException(CalcError.positiveDRequired);
    final BigInt a0 = _isqrt(D);
    if (a0 * a0 == D) {
      throw CalcException(CalcError.perfectSquareD);
    }

    BigInt m = _zero, d = _one, a = a0;
    BigInt hPrev = _one, h = a0;
    BigInt kPrev = _zero, k = _one;

    if (h * h - D * k * k == _one) return (x: h, y: k);

    while (true) {
      m = d * a - m;
      d = (D - m * m) ~/ d;
      a = (a0 + m) ~/ d;
      final BigInt hNext = a * h + hPrev;
      final BigInt kNext = a * k + kPrev;
      hPrev = h;
      h = hNext;
      kPrev = k;
      k = kNext;
      if (h * h - D * k * k == _one) return (x: h, y: k);
    }
  }

  // ── Sums of squares ──────────────────────────────────────────────────────

  /// Representation n = a² + b² with 0 ≤ a ≤ b, or `null` if none exists.
  ///
  /// Capped at 10^8 like [sumOfFourSquares]: the scan below is O(√n) and runs
  /// on the UI thread, so an unbounded n (this is called before the four-square
  /// guard could fire) meant hours or years of freeze.
  static ({BigInt a, BigInt b})? sumOfTwoSquares(BigInt n) {
    if (n < _zero) return null;
    if (n > BigInt.from(100000000)) {
      throw CalcException(CalcError.inputTooLarge, {'max': '100000000'});
    }
    if (n == _zero) return (a: _zero, b: _zero);
    BigInt a = _zero;
    while (a * a * _two <= n) {
      final BigInt rem = n - a * a;
      final BigInt b = _isqrt(rem);
      if (b * b == rem) return (a: a, b: b);
      a += _one;
    }
    return null;
  }

  /// Representation n = a² + b² + c² + d² (Lagrange's theorem, always exists).
  /// Limited to n ≤ 10^8 to avoid hangs on mobile devices.
  static ({BigInt a, BigInt b, BigInt c, BigInt d}) sumOfFourSquares(BigInt n) {
    if (n < _zero) throw CalcException(CalcError.nNonNegative);
    if (n > BigInt.from(100000000)) {
      throw CalcException(CalcError.inputTooLarge, {'max': '100000000'});
    }
    // Search from the largest squares down, skipping dead ends by theory
    // instead of by scanning: n − a² must avoid the form 4^k(8m+7) (Legendre:
    // exactly those are not sums of three squares), and n − a² − b² is a sum
    // of two squares iff every prime ≡ 3 (mod 4) has an even exponent. The
    // old ascending scan paid an O(√n) two-square search per (a, b) and spent
    // minutes on n = 99999999 (= 8m+7, so a = 0 never works).
    for (BigInt a = _isqrt(n); a >= _zero; a -= _one) {
      final BigInt rem = n - a * a;
      if (_isFourPowTimes8kPlus7(rem)) continue;
      for (BigInt b = _isqrt(rem); b >= _zero; b -= _one) {
        final BigInt rem2 = rem - b * b;
        if (!_isSumOfTwoSquares(rem2)) continue;
        final two = sumOfTwoSquares(rem2)!;
        final List<BigInt> parts = [a, b, two.a, two.b]..sort();
        return (a: parts[0], b: parts[1], c: parts[2], d: parts[3]);
      }
    }
    // Unreachable by Lagrange's theorem.
    throw StateError(trLocale('No se encontró representación (no debería ocurrir)', 'No representation found (should not happen)', pt: 'Nenhuma representação encontrada (não deveria ocorrer)', fr: 'Aucune représentation trouvée (ne devrait pas arriver)', id: 'Representasi tidak ditemukan (seharusnya tidak terjadi)', vi: 'Không tìm được biểu diễn (lẽ ra không xảy ra)', ru: 'Представление не найдено (такого быть не должно)', it: 'Nessuna rappresentazione trovata (non dovrebbe accadere)'));
  }

  /// n = 4^k(8m+7): the numbers that are not a sum of three squares.
  static bool _isFourPowTimes8kPlus7(BigInt n) {
    if (n <= _zero) return false;
    while (n % BigInt.from(4) == _zero) {
      n ~/= BigInt.from(4);
    }
    return n % BigInt.from(8) == BigInt.from(7);
  }

  /// Sum of two squares iff each prime ≡ 3 (mod 4) has an even exponent.
  static bool _isSumOfTwoSquares(BigInt n) {
    if (n <= _one) return n >= _zero;
    for (final e in factorize(n).entries) {
      if (e.key % BigInt.from(4) == BigInt.from(3) && e.value.isOdd) {
        return false;
      }
    }
    return true;
  }

  // ── Frobenius number ─────────────────────────────────────────────────────

  /// Frobenius number (largest integer not representable as a non-negative
  /// combination of the denominations). Requires gcd = 1 and values ≥ 1.
  /// Returns `null` if gcd ≠ 1 (infinitely many non-representable).
  static BigInt? frobeniusNumber(List<int> coins) {
    final filtered = coins.where((c) => c > 0).toSet().toList()..sort();
    if (filtered.isEmpty) throw CalcException(CalcError.needPositiveValue);
    if (filtered.contains(1)) return BigInt.from(-1); // everything is representable

    // gcd of all of them must be 1.
    int g = filtered.first;
    for (final c in filtered) {
      g = _gcdInt(g, c);
    }
    if (g != 1) return null;

    // Two coprime values: Sylvester's formula ab − a − b, exact at any size
    // (the residue table below needed an array of a entries: 6 s for
    // a ≈ 10^6, and far longer for 10^9).
    if (filtered.length == 2) {
      final BigInt a = BigInt.from(filtered[0]);
      final BigInt b = BigInt.from(filtered[1]);
      return a * b - a - b;
    }

    // "Round-Robin" / Dijkstra algorithm over residues mod a1.
    final int a1 = filtered.first;
    if (a1 > 100000) {
      throw CalcException(CalcError.inputTooLarge, {'max': '100000'});
    }
    const int inf = -1;
    final List<int> dist = List.filled(a1, inf);
    dist[0] = 0;
    // Bellman-Ford-style relaxation until it stabilizes.
    bool changed = true;
    while (changed) {
      changed = false;
      for (int r = 0; r < a1; r++) {
        if (dist[r] == inf) continue;
        for (final c in filtered.skip(1)) {
          final int nr = (r + c) % a1;
          final int nd = dist[r] + c;
          if (dist[nr] == inf || nd < dist[nr]) {
            dist[nr] = nd;
            changed = true;
          }
        }
      }
    }

    int maxDist = 0;
    for (final d in dist) {
      if (d > maxDist) maxDist = d;
    }
    return BigInt.from(maxDist - a1);
  }

  // ── Lucas numbers ────────────────────────────────────────────────────────

  /// n-th Lucas number: L(0)=2, L(1)=1, L(n)=L(n-1)+L(n-2).
  static BigInt lucasNumber(int n) {
    if (n < 0) throw CalcException(CalcError.nNonNegative);
    if (n == 0) return _two;
    if (n == 1) return _one;
    // L(n) = F(n−1) + F(n+1) with fast-doubling Fibonacci: O(log n) steps
    // (the linear loop took over 15 s for n = 10^6).
    final (fn, fn1) = _fibPair(n); // F(n), F(n+1)
    return _two * fn1 - fn;
  }

  /// (F(n), F(n+1)) by fast doubling.
  static (BigInt, BigInt) _fibPair(int n) {
    if (n == 0) return (_zero, _one);
    final (a, b) = _fibPair(n >> 1); // F(k), F(k+1), k = n ~/ 2
    final BigInt c = a * (_two * b - a); // F(2k)
    final BigInt d = a * a + b * b; // F(2k+1)
    return n.isEven ? (c, d) : (d, c + d);
  }

  // ── Discrete logarithm ───────────────────────────────────────────────────

  /// Smallest x ≥ 0 with g^x ≡ h (mod n), via baby-step giant-step, or `null`.
  static BigInt? discreteLog(BigInt g, BigInt h, BigInt n) {
    if (n <= _one) throw CalcException(CalcError.nGreaterThanOne);
    g = g % n;
    if (g.isNegative) g += n;
    h = h % n;
    if (h.isNegative) h += n;
    // The baby-step table has √n entries (and the non-invertible walk can
    // reach n): beyond 10^12 that is minutes and gigabytes.
    if (n > BigInt.from(10).pow(12)) {
      throw CalcException(CalcError.inputTooLarge, {'max': '10^12'});
    }

    // g not invertible: divide out d = gcd(g, n) while it is > 1. Each round
    // settles one small x directly and leaves k·g^(x−add) ≡ h' (mod n'),
    // with g invertible mod n'. The old fallback walked the powers one by
    // one until they repeated: linear in the period, 2 s for n ≈ 2·10⁷ and
    // hours (and a set of 10¹¹ entries) near the 10¹² bound.
    BigInt k = _one % n;
    BigInt add = _zero;
    while (true) {
      final BigInt d = g.gcd(n);
      if (d == _one) break;
      if (h == k) return add;
      if (h % d != _zero) return null;
      h ~/= d;
      n ~/= d;
      add += _one;
      k = (k * (g ~/ d)) % n;
      g %= n;
    }
    if (n == _one) return add; // everything is ≡ 0 (mod 1)

    // Baby-step giant-step for k·g^y ≡ h (mod n), y ≥ 0, x = y + add.
    // Baby steps keep the LARGEST j for each value h·g^j, so the first
    // giant step p that hits gives the smallest y = p·m − j.
    final BigInt m = _isqrt(n) + _one;
    final Map<BigInt, BigInt> baby = {};
    BigInt cur = h % n;
    for (BigInt j = _zero; j <= m; j += _one) {
      baby[cur] = j;
      cur = (cur * g) % n;
    }
    final BigInt gm = SpecialFunctionsService.modPow(g, m, n);
    cur = k;
    for (BigInt p = _one; p <= m; p += _one) {
      cur = (cur * gm) % n;
      final BigInt? j = baby[cur];
      if (j != null) return p * m - j + add;
    }
    return null;
  }

  // ── Sieve of Eratosthenes ────────────────────────────────────────────────

  /// Sieve of Eratosthenes: `flags[i]` indicates whether i is prime, for i in [0, n].
  static List<bool> sieveOfEratosthenes(int n) {
    if (n < 0) throw CalcException(CalcError.nNonNegative);
    final flags = List<bool>.filled(n + 1, true);
    if (n >= 0) flags[0] = false;
    if (n >= 1) flags[1] = false;
    for (int p = 2; p * p <= n; p++) {
      if (!flags[p]) continue;
      for (int q = p * p; q <= n; q += p) {
        flags[q] = false;
      }
    }
    return flags;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static BigInt _gcd(BigInt a, BigInt b) {
    a = a.abs();
    b = b.abs();
    while (b != _zero) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  static int _gcdInt(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  static BigInt _floorDiv(BigInt a, BigInt b) {
    if (b.isNegative) {
      a = -a;
      b = -b;
    }
    final BigInt q = a ~/ b;
    if (a.isNegative && a % b != _zero) return q - _one;
    return q;
  }

  static BigInt _isqrt(BigInt n) {
    if (n < _zero) throw ArgumentError(trLocale('Raíz de número negativo', 'Root of a negative number', pt: 'Raiz de número negativo', fr: "Racine d'un nombre négatif", id: 'Akar dari bilangan negatif', vi: 'Căn của số âm', ru: 'Корень из отрицательного числа', it: 'Radice di un numero negativo'));
    if (n < _two) return n;
    BigInt x = n;
    BigInt y = (x + _one) >> 1;
    while (y < x) {
      x = y;
      y = (x + n ~/ x) >> 1;
    }
    return x;
  }
}
