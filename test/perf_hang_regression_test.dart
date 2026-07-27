import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/calc_exception.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/models/surd.dart';
import 'package:super_calculadora/services/number_theory_advanced_service.dart';
import 'package:super_calculadora/services/prime_utils.dart';
import 'package:super_calculadora/services/special_functions_service.dart';
import 'package:super_calculadora/services/surd_service.dart';

/// Regressions for the UI-thread freezes found in the audit.
///
/// Every case below used unbounded O(√n) trial division (or an unbounded
/// search) and took minutes-to-years on inputs a user can type. The timeouts
/// are what make these tests meaningful: they fail if the O(√n) behaviour
/// comes back, even though the returned values would still be correct.
void main() {
  // 15-digit prime: ~26 s per call with trial division.
  final BigInt p15 = BigInt.parse('999999999999989');
  // 19-digit prime: hours with trial division.
  final BigInt p19 = BigInt.parse('9999999999999999961');

  group('Factorization-backed functions answer instantly on large primes', () {
    test('eulerPhi(p) = p - 1', () {
      expect(SpecialFunctionsService.eulerPhi(p15), p15 - BigInt.one);
      expect(SpecialFunctionsService.eulerPhi(p19), p19 - BigInt.one);
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('divisorCount(p) = 2', () {
      expect(SpecialFunctionsService.divisorCount(p15), BigInt.two);
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('moebiusMu(p) = -1', () {
      expect(SpecialFunctionsService.moebiusMu(p15), -1);
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('radical(p) = p', () {
      expect(SpecialFunctionsService.radical(p15), p15);
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('smallOmega / bigOmega of a prime = 1', () {
      expect(SpecialFunctionsService.smallOmega(p15), 1);
      expect(SpecialFunctionsService.bigOmega(p15), 1);
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('carmichaelLambda(p) = p - 1', () {
      expect(SpecialFunctionsService.carmichaelLambda(p15), p15 - BigInt.one);
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('sopfr / sopf of a prime = p', () {
      expect(SpecialFunctionsService.sopfr(p15), p15);
      expect(SpecialFunctionsService.sopf(p15), p15);
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('isSquareFree(p) is true, isPowerful(p) is false', () {
      expect(SpecialFunctionsService.isSquareFree(p15), isTrue);
      expect(SpecialFunctionsService.isPowerful(p15), isFalse);
    }, timeout: const Timeout(Duration(seconds: 10)));
  });

  group('Factorization stays correct on composites', () {
    test('factorize handles repeated and large factors', () {
      // 2^3 · 3^2 · 5 · 999999999999989
      final BigInt n = BigInt.from(360) * p15;
      expect(factorize(n), {
        BigInt.two: 3,
        BigInt.from(3): 2,
        BigInt.from(5): 1,
        p15: 1,
      });
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('semiprime of two 10-digit primes splits correctly', () {
      final BigInt a = BigInt.parse('9999999967');
      final BigInt b = BigInt.parse('9999999943');
      expect(factorize(a * b), {a: 1, b: 1});
    }, timeout: const Timeout(Duration(seconds: 20)));

    test('classic small values are unchanged', () {
      expect(SpecialFunctionsService.eulerPhi(BigInt.from(36)), BigInt.from(12));
      expect(SpecialFunctionsService.divisorCount(BigInt.from(36)), BigInt.from(9));
      expect(SpecialFunctionsService.moebiusMu(BigInt.from(30)), -1);
      expect(SpecialFunctionsService.moebiusMu(BigInt.from(12)), 0);
      expect(SpecialFunctionsService.radical(BigInt.from(72)), BigInt.from(6));
      expect(SpecialFunctionsService.sopfr(BigInt.from(12)), BigInt.from(7));
      expect(SpecialFunctionsService.sopf(BigInt.from(12)), BigInt.from(5));
      expect(SpecialFunctionsService.carmichaelLambda(BigInt.from(8)), BigInt.two);
      expect(SpecialFunctionsService.smallOmega(BigInt.from(12)), 2);
      expect(SpecialFunctionsService.bigOmega(BigInt.from(12)), 3);
      expect(SpecialFunctionsService.isSquareFree(BigInt.from(30)), isTrue);
      expect(SpecialFunctionsService.isSquareFree(BigInt.from(12)), isFalse);
      expect(SpecialFunctionsService.isPowerful(BigInt.from(72)), isTrue);
      expect(SpecialFunctionsService.isPowerful(BigInt.from(12)), isFalse);
    });
  });

  group('sqrtMod rejects composite moduli instead of looping forever', () {
    test('sqrtMod(1, 9) throws primeRequired rather than hanging', () {
      // The non-residue search never terminated for p = 9: no z satisfies
      // z^4 ≡ 8 (mod 9), so the app froze unrecoverably on this typo.
      expect(
        () => NumberTheoryAdvancedService.sqrtMod(BigInt.one, BigInt.from(9)),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.primeRequired)),
      );
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('sqrtMod still solves for prime moduli', () {
      // p ≡ 1 (mod 4) exercises the full Tonelli-Shanks path.
      final BigInt r = NumberTheoryAdvancedService.sqrtMod(
          BigInt.from(2), BigInt.from(17))!;
      expect((r * r) % BigInt.from(17), BigInt.two);

      // p ≡ 3 (mod 4) shortcut.
      final BigInt r2 = NumberTheoryAdvancedService.sqrtMod(
          BigInt.from(2), BigInt.from(7))!;
      expect((r2 * r2) % BigInt.from(7), BigInt.two);

      // Non-residue still reports null.
      expect(NumberTheoryAdvancedService.sqrtMod(BigInt.from(3), BigInt.from(7)),
          isNull);
    }, timeout: const Timeout(Duration(seconds: 10)));
  });

  group('Bounded searches', () {
    test('sumOfTwoSquares refuses oversized input instead of scanning for hours',
        () {
      expect(
        () => NumberTheoryAdvancedService.sumOfTwoSquares(
            BigInt.parse('1000000000000000000000000003')),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.inputTooLarge)),
      );
      // Within the cap it still works: 25 = 3² + 4².
      final r = NumberTheoryAdvancedService.sumOfTwoSquares(BigInt.from(25))!;
      expect(r.a * r.a + r.b * r.b, BigInt.from(25));
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('solveLinearCongruence caps the solution set', () {
      // 0·x ≡ 0 (mod 10^9) has 10^9 solutions; materializing them was an OOM.
      expect(
        () => NumberTheoryAdvancedService.solveLinearCongruence(
            BigInt.zero, BigInt.zero, BigInt.from(1000000000)),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.inputTooLarge)),
      );
      // Ordinary systems are unaffected: 3x ≡ 6 (mod 9) → x ∈ {2, 5, 8}.
      expect(
        NumberTheoryAdvancedService.solveLinearCongruence(
            BigInt.from(3), BigInt.from(6), BigInt.from(9)),
        [BigInt.from(2), BigInt.from(5), BigInt.from(8)],
      );
    }, timeout: const Timeout(Duration(seconds: 10)));
  });

  group('Radical simplification', () {
    test('√(large prime) simplifies without the O(√n) walk', () {
      final Surd s = Surd.sqrt(p19);
      expect(s.radicand, p19);
      expect(s.coefficient, Fraction.one);
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('square extraction is still correct', () {
      final Surd s = Surd.sqrt(BigInt.from(72));
      expect(s.coefficient, Fraction.fromBigInt(BigInt.from(6)));
      expect(s.radicand, BigInt.two);

      // 4·(large prime)² → the whole square comes out.
      final Surd big = Surd.sqrt(BigInt.from(4) * p15 * p15);
      expect(big.coefficient, Fraction.fromBigInt(BigInt.two * p15));
      expect(big.radicand, BigInt.one);
    }, timeout: const Timeout(Duration(seconds: 15)));

    test('nth root extraction is still correct', () {
      // ∛(8·5³·7) = 10·∛7
      final r = SurdService.simplifyNthRoot(BigInt.from(8 * 125 * 7), 3);
      expect(r.coefficient, BigInt.from(10));
      expect(r.radicand, BigInt.from(7));
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('a/(c+√d) with c² = d and c > 0 is a plain rational, not an error', () {
      // 1/(2 + √4) = 1/4. This used to throw binomialVanishes.
      final r = SurdService.rationalizeOverBinomial(
          Fraction.one, Fraction.fromBigInt(BigInt.two), BigInt.from(4));
      expect(r.rational, Fraction.parse('1/4'));
      expect(r.surd.coefficient.isZero, isTrue);
    });

    test('a/(c+√d) still rejects the genuinely vanishing case c = -√d', () {
      expect(
        () => SurdService.rationalizeOverBinomial(Fraction.one,
            Fraction.fromBigInt(BigInt.from(-2)), BigInt.from(4)),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.binomialVanishes)),
      );
    });
  });

  group('primeCountingFunction survives huge inputs', () {
    test('π(10^320) returns an estimate instead of throwing', () {
      // double.parse overflowed to Infinity here and li.round() threw.
      final r = SpecialFunctionsService.primeCountingFunction(
          BigInt.from(10).pow(320));
      expect(r['exact'], isFalse);
      expect(BigInt.parse(r['count'].toString()) > BigInt.zero, isTrue);
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('exact sieve path is unchanged', () {
      expect(SpecialFunctionsService.primeCountingFunction(BigInt.from(100)),
          {'count': 25, 'exact': true});
    });

    test('approximation is in the right ballpark for 10^20', () {
      // π(10^20) ≈ 2.22819×10^18; Li-based estimate should be within 1%.
      final r = SpecialFunctionsService.primeCountingFunction(
          BigInt.from(10).pow(20));
      final double got = double.parse(r['count'].toString());
      expect((got - 2.2282e18).abs() / 2.2282e18, lessThan(0.01));
    });
  });
}
