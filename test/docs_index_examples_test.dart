// Tests that verify every concrete example published in docs/index.html.
// Each group corresponds to a section in the help page; each test case
// matches a bullet point or table row in the published documentation.
//
// Run with: flutter test test/docs_index_examples_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/special_functions_service.dart';
import 'package:super_calculadora/services/number_analysis_service.dart';
import 'package:super_calculadora/services/big_decimal.dart';

// ─── helpers ────────────────────────────────────────────────────────────────

BigInt bi(int n) => BigInt.from(n);
BigInt bis(String s) => BigInt.parse(s);
BigDecimal bd(String s) => BigDecimal.fromString(s);

bool approxEq(double a, double b, {double tol = 1e-9}) =>
    (a - b).abs() <= tol * (b.abs() + 1);

// ─── tests ──────────────────────────────────────────────────────────────────

void main() {
  // ══════════════════════════════════════════════════════════════════════════
  // NUMBER THEORY
  // ══════════════════════════════════════════════════════════════════════════

  group('φ(n) — Euler\'s Totient', () {
    test('φ(1) = 1', () => expect(SpecialFunctionsService.eulerPhi(bi(1)), bi(1)));
    test('φ(9) = 6', () => expect(SpecialFunctionsService.eulerPhi(bi(9)), bi(6)));
    test('φ(12) = 4', () => expect(SpecialFunctionsService.eulerPhi(bi(12)), bi(4)));
    test('φ(p) = p−1  [p=7]', () => expect(SpecialFunctionsService.eulerPhi(bi(7)), bi(6)));
    test('φ(p) = p−1  [p=13]', () => expect(SpecialFunctionsService.eulerPhi(bi(13)), bi(12)));
  });

  group('λ(n) — Carmichael', () {
    test('λ(8) = 2',  () => expect(SpecialFunctionsService.carmichaelLambda(bi(8)),  bi(2)));
    test('λ(15) = 4', () => expect(SpecialFunctionsService.carmichaelLambda(bi(15)), bi(4)));
    test('λ(p) = p−1  [p=7]',  () => expect(SpecialFunctionsService.carmichaelLambda(bi(7)),  bi(6)));
    test('λ(p) = p−1  [p=11]', () => expect(SpecialFunctionsService.carmichaelLambda(bi(11)), bi(10)));
    // λ(n) | φ(n) always
    test('λ(n) divides φ(n)  [n=60]', () {
      final l = SpecialFunctionsService.carmichaelLambda(bi(60));
      final p = SpecialFunctionsService.eulerPhi(bi(60));
      expect(p % l, bi(0));
    });
  });

  group('μ(n) — Möbius', () {
    test('μ(1)  = 1',  () => expect(SpecialFunctionsService.moebiusMu(bi(1)),  1));
    test('μ(6)  = 1',  () => expect(SpecialFunctionsService.moebiusMu(bi(6)),  1));
    test('μ(30) = −1', () => expect(SpecialFunctionsService.moebiusMu(bi(30)), -1));
    test('μ(12) = 0  (has 2²)', () => expect(SpecialFunctionsService.moebiusMu(bi(12)), 0));
  });

  group('λL(n) — Liouville  [λL = (−1)^Ω(n)]', () {
    test('λL(12) = −1  (Ω=3)', () => expect(SpecialFunctionsService.liouvilleFunction(bi(12)), -1));
    test('λL(36) = 1   (Ω=4)', () => expect(SpecialFunctionsService.liouvilleFunction(bi(36)),  1));
    test('λL(p) = −1 for prime  [p=7]', () => expect(SpecialFunctionsService.liouvilleFunction(bi(7)), -1));
  });

  group('ω(n) — Distinct prime factors', () {
    test('ω(12) = 2', () => expect(SpecialFunctionsService.smallOmega(bi(12)), 2));
    test('ω(30) = 3', () => expect(SpecialFunctionsService.smallOmega(bi(30)), 3));
    test('ω(8)  = 1  (p^k)', () => expect(SpecialFunctionsService.smallOmega(bi(8)),  1));
    test('ω(1)  = 0', () => expect(SpecialFunctionsService.smallOmega(bi(1)),  0));
  });

  group('Ω(n) — Prime factors with multiplicity', () {
    test('Ω(12) = 3', () => expect(SpecialFunctionsService.bigOmega(bi(12)), 3));
    test('Ω(72) = 5', () => expect(SpecialFunctionsService.bigOmega(bi(72)), 5));
    test('Ω(p)  = 1  [p=7]',  () => expect(SpecialFunctionsService.bigOmega(bi(7)),  1));
    test('Ω(p²) = 2  [p²=4]', () => expect(SpecialFunctionsService.bigOmega(bi(4)),  2));
  });

  group('σ₀(n) — Divisor count', () {
    test('σ₀(12) = 6', () => expect(SpecialFunctionsService.divisorCount(bi(12)), bi(6)));
    test('σ₀(p)  = 2  [p=7]',  () => expect(SpecialFunctionsService.divisorCount(bi(7)),  bi(2)));
    test('σ₀(p²) = 3  [p²=4]', () => expect(SpecialFunctionsService.divisorCount(bi(4)),  bi(3)));
  });

  group('σ(n) — Sum of divisors  [m=1]', () {
    // divisorSum(m=1, n) = σ(n)
    test('σ(6)  = 12  (perfect)', () {
      final s = SpecialFunctionsService.divisorSum(1, bi(6));
      expect(s.toString(), '12');
    });
    test('σ(12) = 28', () {
      final s = SpecialFunctionsService.divisorSum(1, bi(12));
      expect(s.toString(), '28');
    });
    test('σ(p)  = p+1  [p=7 → 8]', () {
      final s = SpecialFunctionsService.divisorSum(1, bi(7));
      expect(s.toString(), '8');
    });
    test('n is perfect ⟺ σ(n)=2n  [n=6]', () {
      final s = SpecialFunctionsService.divisorSum(1, bi(6));
      expect(s.toString(), (2 * 6).toString());
    });
  });

  group('sopfr(n) — Sum of primes with repetition', () {
    test('sopfr(12) = 7',  () => expect(SpecialFunctionsService.sopfr(bi(12)), bi(7)));
    test('sopfr(60) = 12', () => expect(SpecialFunctionsService.sopfr(bi(60)), bi(12)));
    test('sopfr(1)  = 0',  () => expect(SpecialFunctionsService.sopfr(bi(1)),  bi(0)));
  });

  group('sopf(n) — Sum of distinct primes', () {
    test('sopf(12) = 5',  () => expect(SpecialFunctionsService.sopf(bi(12)), bi(5)));
    test('sopf(60) = 10', () => expect(SpecialFunctionsService.sopf(bi(60)), bi(10)));
    test('sopf(1)  = 0',  () => expect(SpecialFunctionsService.sopf(bi(1)),  bi(0)));
  });

  group('rad(n) — Radical', () {
    test('rad(72)  = 6',  () => expect(SpecialFunctionsService.radical(bi(72)),  bi(6)));
    test('rad(480) = 30', () => expect(SpecialFunctionsService.radical(bi(480)), bi(30)));
    test('rad(p)   = p   [p=7]', () => expect(SpecialFunctionsService.radical(bi(7)),   bi(7)));
    test('rad(1)   = 1',  () => expect(SpecialFunctionsService.radical(bi(1)),   bi(1)));
  });

  group('n# — Primorial', () {
    test('5#  = 30',   () => expect(SpecialFunctionsService.primorial(5),  bi(30)));
    test('7#  = 210',  () => expect(SpecialFunctionsService.primorial(7),  bi(210)));
    test('11# = 2310', () => expect(SpecialFunctionsService.primorial(11), bi(2310)));
    test('1#  = 1  (no primes ≤ 1)', () => expect(SpecialFunctionsService.primorial(1), bi(1)));
  });

  group('π(n) — Prime counting function', () {
    test('π(10)       = 4',     () => expect(SpecialFunctionsService.primeCountingFunction(bi(10))['count'],     4));
    test('π(100)      = 25',    () => expect(SpecialFunctionsService.primeCountingFunction(bi(100))['count'],    25));
    test('π(1000000)  = 78498', () => expect(SpecialFunctionsService.primeCountingFunction(bi(1000000))['count'], 78498));
    test('π(10) exact flag', () => expect(SpecialFunctionsService.primeCountingFunction(bi(10))['exact'], true));
  });

  group('dr(n) — Digital root', () {
    test('dr(493) = 7', () => expect(SpecialFunctionsService.digitalRoot(bi(493)), 7));
    test('dr(999) = 9', () => expect(SpecialFunctionsService.digitalRoot(bi(999)), 9));
    test('dr(n) ≡ n mod 9  [n=12345]', () {
      final n = bi(12345);
      expect(SpecialFunctionsService.digitalRoot(n), (n % bi(9) == bi(0)) ? 9 : (n % bi(9)).toInt());
    });
  });

  group('⌊x⌋ / ⌈x⌉ — Floor and Ceiling', () {
    test('⌊3.7⌋  = 3',  () => expect(SpecialFunctionsService.floor(bd('3.7')),   bi(3)));
    test('⌈3.7⌉  = 4',  () => expect(SpecialFunctionsService.ceiling(bd('3.7')), bi(4)));
    test('⌊−2.3⌋ = −3', () => expect(SpecialFunctionsService.floor(bd('-2.3')),  bi(-3)));
    test('⌈−2.3⌉ = −2', () => expect(SpecialFunctionsService.ceiling(bd('-2.3')),bi(-2)));
    test('⌊5⌋ = ⌈5⌉ = 5', () {
      expect(SpecialFunctionsService.floor(bd('5')),    bi(5));
      expect(SpecialFunctionsService.ceiling(bd('5')),  bi(5));
    });
  });

  group('Vₚ(n) — p-adic Valuation', () {
    test('V₂(24) = 3', () => expect(SpecialFunctionsService.pAdicValuation(bi(24), bi(2)), 3));
    test('V₃(81) = 4', () => expect(SpecialFunctionsService.pAdicValuation(bi(81), bi(3)), 4));
    test('V₅(100) = 2', () => expect(SpecialFunctionsService.pAdicValuation(bi(100), bi(5)), 2));
    test('Vₚ(ab) = Vₚ(a)+Vₚ(b)  [V₂(4)=2, V₂(8)=3, V₂(32)=5]', () {
      final va = SpecialFunctionsService.pAdicValuation(bi(4), bi(2));
      final vb = SpecialFunctionsService.pAdicValuation(bi(8), bi(2));
      final vab = SpecialFunctionsService.pAdicValuation(bi(32), bi(2));
      expect(va + vb, vab);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // MODULAR ARITHMETIC
  // ══════════════════════════════════════════════════════════════════════════

  group('a mod b — Division remainder', () {
    test('17 mod 5 = 2',  () => expect(SpecialFunctionsService.mod(bi(17), bi(5)),  bi(2)));
    test('23 mod 7 = 2',  () => expect(SpecialFunctionsService.mod(bi(23), bi(7)),  bi(2)));
    test('−8 mod 3 = 1',  () => expect(SpecialFunctionsService.mod(bi(-8), bi(3)),  bi(1)));
  });

  group('a^b mod n — Modular exponentiation', () {
    test('2^100 mod 7 = 2', () => expect(SpecialFunctionsService.modPow(bi(2), bi(100), bi(7)), bi(2)));
    test('3^13  mod 11 = 5', () => expect(SpecialFunctionsService.modPow(bi(3), bi(13), bi(11)), bi(5)));
    test('modulus 1 → always 0', () => expect(SpecialFunctionsService.modPow(bi(5), bi(10), bi(1)), bi(0)));
  });

  group('a⁻¹ mod n — Modular inverse', () {
    test('3⁻¹ mod 7  = 5  [3×5=15≡1]', () => expect(SpecialFunctionsService.modularInverse(bi(3), bi(7)), bi(5)));
    test('5⁻¹ mod 11 = 9  [5×9=45≡1]', () => expect(SpecialFunctionsService.modularInverse(bi(5), bi(11)), bi(9)));
    test('no inverse when gcd(a,n)≠1  [2 mod 4]', () => expect(SpecialFunctionsService.modularInverse(bi(2), bi(4)), isNull));
  });

  group('ord_n(a) — Multiplicative order', () {
    test('ord₇(2) = 3', () => expect(SpecialFunctionsService.multiplicativeOrder(bi(2), bi(7)), bi(3)));
    test('ord₁₀(3) = 4', () => expect(SpecialFunctionsService.multiplicativeOrder(bi(3), bi(10)), bi(4)));
    test('order divides φ(n)  [ord₇(2)=3, φ(7)=6]', () {
      final ord = SpecialFunctionsService.multiplicativeOrder(bi(2), bi(7));
      final phi = SpecialFunctionsService.eulerPhi(bi(7));
      expect(phi % ord, bi(0));
    });
  });

  group('(a/p) — Legendre symbol', () {
    test('(2/7)  = 1   [3²≡2 mod 7]', () => expect(SpecialFunctionsService.legendreSymbol(bi(2), bi(7)),  1));
    test('(3/7)  = −1  [no QR]',       () => expect(SpecialFunctionsService.legendreSymbol(bi(3), bi(7)), -1));
    test('(5/5)  = 0   [p | a]',       () => expect(SpecialFunctionsService.legendreSymbol(bi(5), bi(5)),  0));
  });

  group('(a/n)ⱼ — Jacobi symbol', () {
    test('(2/15) = 1  [(2/3)(2/5)=(−1)(−1)]', () => expect(SpecialFunctionsService.jacobiSymbol(bi(2), bi(15)), 1));
    test('(a/1)  = 1  always',                () => expect(SpecialFunctionsService.jacobiSymbol(bi(5), bi(1)),   1));
    test('(0/n)  = 0  [n=7]',                 () => expect(SpecialFunctionsService.jacobiSymbol(bi(0), bi(7)),   0));
  });

  group('g — Primitive root', () {
    test('smallest primitive root mod 7  = 3', () => expect(SpecialFunctionsService.findPrimitiveRoot(bi(7)), bi(3)));
    test('smallest primitive root mod 11 = 2', () => expect(SpecialFunctionsService.findPrimitiveRoot(bi(11)), bi(2)));
    test('g is actually a primitive root  [g=3, n=7]', () {
      expect(SpecialFunctionsService.isPrimitiveRoot(bi(3), bi(7)), true);
    });
  });

  group('GCD — Greatest common divisor', () {
    test('GCD(12, 18)    = 6', () => expect(SpecialFunctionsService.gcd(bi(12), bi(18)), bi(6)));
    test('GCD(12, 18, 24) = 6', () => expect(
        SpecialFunctionsService.gcdMultiple([bi(12), bi(18), bi(24)]), bi(6)));
    test('GCD(a,b) × LCM(a,b) = a×b  [a=12, b=18]', () {
      final g = SpecialFunctionsService.gcd(bi(12), bi(18));
      final l = SpecialFunctionsService.lcm(bi(12), bi(18));
      expect(g * l, bi(12) * bi(18));
    });
  });

  group('LCM — Least common multiple', () {
    test('LCM(4, 6)    = 12',  () => expect(SpecialFunctionsService.lcm(bi(4), bi(6)),   bi(12)));
    test('LCM(3, 5, 7) = 105', () => expect(
        SpecialFunctionsService.lcmMultiple([bi(3), bi(5), bi(7)]), bi(105)));
  });

  group('Dioph — Linear Diophantine equation', () {
    test('3x + 5y = 1  is solvable', () {
      final r = SpecialFunctionsService.solveDiophantine(bi(3), bi(5), bi(1));
      expect(r['solvable'], true);
    });
    test('3x + 5y = 1  particular solution satisfies equation', () {
      final r = SpecialFunctionsService.solveDiophantine(bi(3), bi(5), bi(1));
      final x0 = r['x0'] as BigInt;
      final y0 = r['y0'] as BigInt;
      expect(bi(3) * x0 + bi(5) * y0, bi(1));
    });
    test('6x + 9y = 12  is solvable', () {
      final r = SpecialFunctionsService.solveDiophantine(bi(6), bi(9), bi(12));
      expect(r['solvable'], true);
      final x0 = r['x0'] as BigInt;
      final y0 = r['y0'] as BigInt;
      expect(bi(6) * x0 + bi(9) * y0, bi(12));
    });
    test('4x + 6y = 3  has no solution  (gcd=2 ∤ 3)', () {
      final r = SpecialFunctionsService.solveDiophantine(bi(4), bi(6), bi(3));
      expect(r['solvable'], false);
    });
  });

  group('CRT — Chinese Remainder Theorem', () {
    test('x≡2(mod 3), x≡3(mod 5) → x≡8(mod 15)', () {
      final r = SpecialFunctionsService.chineseRemainderTheorem(
          [bi(2), bi(3)], [bi(3), bi(5)]);
      expect(r['solvable'], true);
      expect(r['solution'], bi(8));
      expect(r['modulus'],  bi(15));
    });
    test('x≡1(mod 4), x≡2(mod 3) → x≡5(mod 12)', () {
      final r = SpecialFunctionsService.chineseRemainderTheorem(
          [bi(1), bi(2)], [bi(4), bi(3)]);
      expect(r['solvable'], true);
      expect(r['solution'], bi(5));
      expect(r['modulus'],  bi(12));
    });
    test('incompatible system returns solvable=false', () {
      // x≡1(mod 2), x≡2(mod 4) → incompatible
      final r = SpecialFunctionsService.chineseRemainderTheorem(
          [bi(1), bi(2)], [bi(2), bi(4)]);
      expect(r['solvable'], false);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // COMBINATORICS
  // ══════════════════════════════════════════════════════════════════════════

  group('n! — Factorial', () {
    test('5!  = 120',         () => expect(SpecialFunctionsService.factorial(5),  bi(120)));
    test('10! = 3628800',     () => expect(SpecialFunctionsService.factorial(10), bi(3628800)));
    test('0!  = 1',           () => expect(SpecialFunctionsService.factorial(0),  bi(1)));
    test('20! = 2432902008176640000', () =>
        expect(SpecialFunctionsService.factorial(20), bis('2432902008176640000')));
  });

  group('n!! — Double factorial', () {
    test('7!! = 105', () => expect(SpecialFunctionsService.doubleFactorial(7), bi(105)));
    test('8!! = 384', () => expect(SpecialFunctionsService.doubleFactorial(8), bi(384)));
    test('0!! = 1',   () => expect(SpecialFunctionsService.doubleFactorial(0), bi(1)));
    test('1!! = 1',   () => expect(SpecialFunctionsService.doubleFactorial(1), bi(1)));
  });

  group('C(n,k) — Combinations', () {
    test('C(5,2)  = 10',  () => expect(SpecialFunctionsService.combinations(5,  2), bi(10)));
    test('C(10,3) = 120', () => expect(SpecialFunctionsService.combinations(10, 3), bi(120)));
    test('C(n,0)  = 1  [n=7]', () => expect(SpecialFunctionsService.combinations(7, 0), bi(1)));
    test('C(n,n)  = 1  [n=7]', () => expect(SpecialFunctionsService.combinations(7, 7), bi(1)));
    test('C(n,k)  = C(n,n-k)  [C(10,3)=C(10,7)]', () =>
        expect(SpecialFunctionsService.combinations(10, 3),
               SpecialFunctionsService.combinations(10, 7)));
  });

  group('V(n,k) — Variations', () {
    test('V(5,2)  = 20',  () => expect(SpecialFunctionsService.variations(5,  2), bi(20)));
    test('V(10,3) = 720', () => expect(SpecialFunctionsService.variations(10, 3), bi(720)));
    test('V(n,0)  = 1  [n=7]', () => expect(SpecialFunctionsService.variations(7, 0), bi(1)));
  });

  group('Cat(n) — Catalan numbers', () {
    test('Cat(0) = 1',  () => expect(SpecialFunctionsService.catalanNumber(0), bi(1)));
    test('Cat(1) = 1',  () => expect(SpecialFunctionsService.catalanNumber(1), bi(1)));
    test('Cat(2) = 2',  () => expect(SpecialFunctionsService.catalanNumber(2), bi(2)));
    test('Cat(3) = 5',  () => expect(SpecialFunctionsService.catalanNumber(3), bi(5)));
    test('Cat(4) = 14', () => expect(SpecialFunctionsService.catalanNumber(4), bi(14)));
    test('Cat(5) = 42', () => expect(SpecialFunctionsService.catalanNumber(5), bi(42)));
  });

  group('D(n) — Derangements', () {
    test('D(3) = 2', () => expect(SpecialFunctionsService.derangement(3), bi(2)));
    test('D(4) = 9', () => expect(SpecialFunctionsService.derangement(4), bi(9)));
    test('D(0) = 1', () => expect(SpecialFunctionsService.derangement(0), bi(1)));
    test('D(1) = 0', () => expect(SpecialFunctionsService.derangement(1), bi(0)));
  });

  group('B(n) — Bell numbers', () {
    test('B(3) = 5',  () => expect(SpecialFunctionsService.bellNumber(3), bi(5)));
    test('B(4) = 15', () => expect(SpecialFunctionsService.bellNumber(4), bi(15)));
    test('B(5) = 52', () => expect(SpecialFunctionsService.bellNumber(5), bi(52)));
    test('B(0) = 1',  () => expect(SpecialFunctionsService.bellNumber(0), bi(1)));
    test('B(n) = Σ S₂(n,k)  [n=4]', () {
      BigInt sum = bi(0);
      for (int k = 0; k <= 4; k++) {
        sum += SpecialFunctionsService.stirlingSecond(4, k);
      }
      expect(sum, SpecialFunctionsService.bellNumber(4));
    });
  });

  group('p(n) — Integer partitions', () {
    test('p(4)  = 5',  () => expect(SpecialFunctionsService.partition(4),  bi(5)));
    test('p(10) = 42', () => expect(SpecialFunctionsService.partition(10), bi(42)));
    test('p(0)  = 1',  () => expect(SpecialFunctionsService.partition(0),  bi(1)));
    test('p(100) = 190569292', () =>
        expect(SpecialFunctionsService.partition(100), bis('190569292')));
  });

  group('S₂(n,k) — Stirling numbers 2nd kind', () {
    test('S₂(4,2) = 7',  () => expect(SpecialFunctionsService.stirlingSecond(4, 2), bi(7)));
    test('S₂(5,3) = 25', () => expect(SpecialFunctionsService.stirlingSecond(5, 3), bi(25)));
    test('S₂(n,1) = 1  [n=5]', () => expect(SpecialFunctionsService.stirlingSecond(5, 1), bi(1)));
    test('S₂(n,n) = 1  [n=5]', () => expect(SpecialFunctionsService.stirlingSecond(5, 5), bi(1)));
    test('S₂(n,0) = 0  [n>0]', () => expect(SpecialFunctionsService.stirlingSecond(5, 0), bi(0)));
  });

  group('s₁(n,k) — Stirling numbers 1st kind (unsigned)', () {
    test('s₁(4,2) = 11', () => expect(SpecialFunctionsService.stirlingFirst(4, 2), bi(11)));
    test('s₁(4,1) = 6',  () => expect(SpecialFunctionsService.stirlingFirst(4, 1), bi(6)));
    test('s₁(0,0) = 1',  () => expect(SpecialFunctionsService.stirlingFirst(0, 0), bi(1)));
    test('s₁(n,0) = 0  [n>0]', () => expect(SpecialFunctionsService.stirlingFirst(5, 0), bi(0)));
  });

  group('F(n) — Fibonacci (fast doubling)', () {
    test('F(0)  = 0',  () => expect(SpecialFunctionsService.fibonacci(0),  bi(0)));
    test('F(1)  = 1',  () => expect(SpecialFunctionsService.fibonacci(1),  bi(1)));
    test('F(10) = 55', () => expect(SpecialFunctionsService.fibonacci(10), bi(55)));
    test('F(50) = 12586269025', () =>
        expect(SpecialFunctionsService.fibonacci(50), bis('12586269025')));
    test('F(100) = 354224848179261915075', () =>
        expect(SpecialFunctionsService.fibonacci(100), bis('354224848179261915075')));
    test('GCD(F(m),F(n)) = F(GCD(m,n))  [m=6,n=10,GCD=2]', () {
      final fm = SpecialFunctionsService.fibonacci(6);   // F(6)=8
      final fn = SpecialFunctionsService.fibonacci(10);  // F(10)=55
      final fg = SpecialFunctionsService.fibonacci(2);   // F(2)=1
      expect(SpecialFunctionsService.gcd(fm, fn), fg);
    });
  });

  group('ΣdigB — Digit sum in base b', () {
    test('ΣdigB(255, 2)  = 8   [11111111₂]', () =>
        expect(SpecialFunctionsService.digitSumInBase(bi(255),  2), bi(8)));
    test('ΣdigB(100, 10) = 1',               () =>
        expect(SpecialFunctionsService.digitSumInBase(bi(100), 10), bi(1)));
    test('ΣdigB(100, 16) = 10  [64₁₆]',     () =>
        expect(SpecialFunctionsService.digitSumInBase(bi(100), 16), bi(10)));
  });

  // ══════════════════════════════════════════════════════════════════════════
  // STATISTICS
  // ══════════════════════════════════════════════════════════════════════════

  group('Arithmetic Mean', () {
    test('AM(3, 7)    = 5', () {
      final r = SpecialFunctionsService.arithmeticMean([bd('3'), bd('7')]);
      expect(approxEq(r.toDouble(), 5.0), true);
    });
    test('AM(2, 4, 6) = 4', () {
      final r = SpecialFunctionsService.arithmeticMean([bd('2'), bd('4'), bd('6')]);
      expect(approxEq(r.toDouble(), 4.0), true);
    });
  });

  group('Geometric Mean', () {
    test('GM(2, 8) = 4', () {
      final r = SpecialFunctionsService.geometricMean([bd('2'), bd('8')]);
      expect(approxEq(r.toDouble(), 4.0), true);
    });
  });

  group('Harmonic Mean', () {
    test('HM(2, 8) = 3.2', () {
      final r = SpecialFunctionsService.harmonicMean([bd('2'), bd('8')]);
      expect(approxEq(r.toDouble(), 3.2, tol: 1e-6), true);
    });
  });

  group('Quadratic Mean (RMS)', () {
    test('QM(3, 4) ≈ 3.535...', () {
      final r = SpecialFunctionsService.quadraticMean([bd('3'), bd('4')]);
      expect(approxEq(r.toDouble(), 3.5355339059327378, tol: 1e-6), true);
    });
  });

  group('min / max', () {
    test('min(3, 7, 1) = 1', () {
      final r = SpecialFunctionsService.minimum([bd('3'), bd('7'), bd('1')]);
      expect(approxEq(r.toDouble(), 1.0), true);
    });
    test('max(3, 7, 1) = 7', () {
      final r = SpecialFunctionsService.maximum([bd('3'), bd('7'), bd('1')]);
      expect(approxEq(r.toDouble(), 7.0), true);
    });
  });

  group('Mean inequality  HM ≤ GM ≤ AM ≤ QM', () {
    test('inequality holds for [2, 8]', () {
      final nums = [bd('2'), bd('8')];
      final hm = SpecialFunctionsService.harmonicMean(nums).toDouble();
      final gm = SpecialFunctionsService.geometricMean(nums).toDouble();
      final am = SpecialFunctionsService.arithmeticMean(nums).toDouble();
      final qm = SpecialFunctionsService.quadraticMean(nums).toDouble();
      expect(hm <= gm + 1e-4, true, reason: 'HM ≤ GM');
      expect(gm <= am + 1e-4, true, reason: 'GM ≤ AM');
      expect(am <= qm + 1e-4, true, reason: 'AM ≤ QM');
    });
    test('equality holds when all equal  [5, 5]', () {
      final nums = [bd('5'), bd('5')];
      final hm = SpecialFunctionsService.harmonicMean(nums).toDouble();
      final gm = SpecialFunctionsService.geometricMean(nums).toDouble();
      final am = SpecialFunctionsService.arithmeticMean(nums).toDouble();
      expect(approxEq(hm, 5.0), true);
      expect(approxEq(gm, 5.0), true);
      expect(approxEq(am, 5.0), true);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // PRIMALITY (Analysis Panel)
  // ══════════════════════════════════════════════════════════════════════════

  group('Primality — Miller-Rabin', () {
    test('2 is prime',  () => expect(NumberAnalysisService.isPrime(bi(2)),  true));
    test('7 is prime',  () => expect(NumberAnalysisService.isPrime(bi(7)),  true));
    test('1 is not prime', () => expect(NumberAnalysisService.isPrime(bi(1)), false));
    test('4 is not prime', () => expect(NumberAnalysisService.isPrime(bi(4)), false));
    test('large prime 3215031751', () =>
        expect(NumberAnalysisService.isPrime(bi(3215031751)), true));
    test('large composite 3215031752', () =>
        expect(NumberAnalysisService.isPrime(bi(3215031752)), false));
  });

  // ══════════════════════════════════════════════════════════════════════════
  // OLYMPIAD IDENTITIES (sanity checks for published formulas)
  // ══════════════════════════════════════════════════════════════════════════

  group('Olympiad identities', () {
    test('Σ φ(d) for d|n = n  [n=12]', () {
      final divisors = [1, 2, 3, 4, 6, 12];
      BigInt sum = bi(0);
      for (final d in divisors) {
        sum += SpecialFunctionsService.eulerPhi(bi(d));
      }
      expect(sum, bi(12));
    });
    test('Σ μ(d) for d|n = [n=1]  [n=12 → 0]', () {
      final divisors = [1, 2, 3, 4, 6, 12];
      int sum = 0;
      for (final d in divisors) {
        sum += SpecialFunctionsService.moebiusMu(bi(d));
      }
      expect(sum, 0); // n=12 ≠ 1
    });
    test('Σ μ(d) for d|n = 1  [n=1]', () {
      expect(SpecialFunctionsService.moebiusMu(bi(1)), 1);
    });
    test('Σ λL(d) for d|n = 1 if n is perfect square  [n=36]', () {
      // divisors of 36
      final divisors = [1,2,3,4,6,9,12,18,36];
      int sum = 0;
      for (final d in divisors) {
        sum += SpecialFunctionsService.liouvilleFunction(bi(d));
      }
      expect(sum, 1);
    });
    test('Fermat\'s little: a^(p−1) ≡ 1 (mod p)  [a=3, p=7]', () {
      final result = SpecialFunctionsService.modPow(bi(3), bi(6), bi(7));
      expect(result, bi(1));
    });
    test('Euler\'s theorem: a^φ(n) ≡ 1 (mod n)  [a=5, n=12]', () {
      final phi = SpecialFunctionsService.eulerPhi(bi(12));
      final result = SpecialFunctionsService.modPow(bi(5), phi, bi(12));
      expect(result, bi(1));
    });
  });
}
