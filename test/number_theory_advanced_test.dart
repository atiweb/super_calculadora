import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/services/number_theory_advanced_service.dart';

BigInt bi(int n) => BigInt.from(n);
typedef S = NumberTheoryAdvancedService;

void main() {
  group('sqrtMod (Tonelli-Shanks)', () {
    test('√2 mod 7 = 3 or 4', () {
      final r = S.sqrtMod(bi(2), bi(7))!;
      expect((r * r) % bi(7), bi(2));
    });
    test('√2 mod 7 specific value 4 (then 3 is p-r)', () {
      final r = S.sqrtMod(bi(2), bi(7))!;
      expect(r == bi(3) || r == bi(4), true);
    });
    test('non-residue: √3 mod 7 = null', () => expect(S.sqrtMod(bi(3), bi(7)), isNull));
    test('√10 mod 13', () {
      final r = S.sqrtMod(bi(10), bi(13))!;
      expect((r * r) % bi(13), bi(10));
    });
    test('large prime p ≡ 1 mod 4: √2 mod 17', () {
      final r = S.sqrtMod(bi(2), bi(17))!;
      expect((r * r) % bi(17), bi(2));
    });
    test('a ≡ 0', () => expect(S.sqrtMod(bi(0), bi(7)), bi(0)));
  });

  group('solveLinearCongruence', () {
    test('3x ≡ 6 (mod 9) → {2,5,8}', () {
      expect(S.solveLinearCongruence(bi(3), bi(6), bi(9)), [bi(2), bi(5), bi(8)]);
    });
    test('2x ≡ 1 (mod 4) → no solution', () {
      expect(S.solveLinearCongruence(bi(2), bi(1), bi(4)), isEmpty);
    });
    test('5x ≡ 3 (mod 7) → {2}', () {
      expect(S.solveLinearCongruence(bi(5), bi(3), bi(7)), [bi(2)]);
    });
    test('all solutions actually satisfy the congruence', () {
      for (final x in S.solveLinearCongruence(bi(6), bi(8), bi(14))) {
        expect((bi(6) * x) % bi(14), bi(8) % bi(14));
      }
    });
  });

  group('Lucas theorem C(n,k) mod p', () {
    test('C(10,3) mod 7 = 120 mod 7 = 1', () =>
        expect(S.lucasTheorem(bi(10), bi(3), bi(7)), bi(1)));
    test('C(1000,500) mod 13', () {
      // sanity: result in [0,13)
      final r = S.lucasTheorem(bi(1000), bi(500), bi(13));
      expect(r >= bi(0) && r < bi(13), true);
    });
    test('C(6,2) mod 5 = 15 mod 5 = 0', () =>
        expect(S.lucasTheorem(bi(6), bi(2), bi(5)), bi(0)));
    test('k>n → 0', () => expect(S.lucasTheorem(bi(3), bi(5), bi(7)), bi(0)));
  });

  group('continued fractions', () {
    test('CF of 415/93 = [4;2,6,7]', () =>
        expect(S.continuedFraction(bi(415), bi(93)), [bi(4), bi(2), bi(6), bi(7)]));
    test('CF of √2 = [1; (2)]', () {
      final r = S.continuedFractionSqrt(bi(2));
      expect(r.a0, bi(1));
      expect(r.period, [bi(2)]);
    });
    test('CF of √7 = [2; (1,1,1,4)]', () {
      final r = S.continuedFractionSqrt(bi(7));
      expect(r.a0, bi(2));
      expect(r.period, [bi(1), bi(1), bi(1), bi(4)]);
    });
    test('CF of perfect square √9 → empty period', () {
      final r = S.continuedFractionSqrt(bi(9));
      expect(r.a0, bi(3));
      expect(r.period, isEmpty);
    });
    test('convergents of [4;2,6,7] last = 415/93', () {
      final c = S.convergents([bi(4), bi(2), bi(6), bi(7)]);
      expect(c.last, Fraction(bi(415), bi(93)));
    });
  });

  group('Pell equation x² - D y² = 1', () {
    test('D=2 → (3,2)', () {
      final s = S.solvePell(bi(2));
      expect(s.x, bi(3));
      expect(s.y, bi(2));
    });
    test('D=3 → (2,1)', () {
      final s = S.solvePell(bi(3));
      expect(s.x, bi(2));
      expect(s.y, bi(1));
    });
    test('D=61 → (1766319049, 226153980)', () {
      final s = S.solvePell(bi(61));
      expect(s.x, BigInt.parse('1766319049'));
      expect(s.y, BigInt.parse('226153980'));
    });
    test('solution satisfies the equation', () {
      final s = S.solvePell(bi(7));
      expect(s.x * s.x - bi(7) * s.y * s.y, bi(1));
    });
    test('perfect square D throws', () =>
        expect(() => S.solvePell(bi(9)), throwsArgumentError));
  });

  group('sum of two squares', () {
    test('5 = 1² + 2²', () {
      final r = S.sumOfTwoSquares(bi(5))!;
      expect(r.a * r.a + r.b * r.b, bi(5));
    });
    test('25 = 3² + 4²', () {
      final r = S.sumOfTwoSquares(bi(25))!;
      expect(r.a * r.a + r.b * r.b, bi(25));
    });
    test('3 → null (no representation)', () => expect(S.sumOfTwoSquares(bi(3)), isNull));
    test('7 → null', () => expect(S.sumOfTwoSquares(bi(7)), isNull));
  });

  group('sum of four squares (Lagrange)', () {
    test('7 = a²+b²+c²+d²', () {
      final r = S.sumOfFourSquares(bi(7));
      expect(r.a * r.a + r.b * r.b + r.c * r.c + r.d * r.d, bi(7));
    });
    test('310 works', () {
      final r = S.sumOfFourSquares(bi(310));
      expect(r.a * r.a + r.b * r.b + r.c * r.c + r.d * r.d, bi(310));
    });
    test('0 = 0+0+0+0', () {
      final r = S.sumOfFourSquares(bi(0));
      expect(r.a, bi(0));
    });
  });

  group('Frobenius number', () {
    test('coins {3,5} → 7', () => expect(S.frobeniusNumber([3, 5]), bi(7)));
    test('coins {6,9,20} → 43 (McNugget)', () => expect(S.frobeniusNumber([6, 9, 20]), bi(43)));
    test('coins {4,6} → null (gcd 2)', () => expect(S.frobeniusNumber([4, 6]), isNull));
    test('contains 1 → -1', () => expect(S.frobeniusNumber([1, 5]), bi(-1)));
  });

  group('Lucas numbers', () {
    test('L(0)=2', () => expect(S.lucasNumber(0), bi(2)));
    test('L(1)=1', () => expect(S.lucasNumber(1), bi(1)));
    test('L(5)=11', () => expect(S.lucasNumber(5), bi(11)));
    test('L(10)=123', () => expect(S.lucasNumber(10), bi(123)));
  });

  group('discrete log (BSGS)', () {
    test('2^x ≡ 3 (mod 5) → x=3', () => expect(S.discreteLog(bi(2), bi(3), bi(5)), bi(3)));
    test('3^x ≡ 13 (mod 17) → verify', () {
      final x = S.discreteLog(bi(3), bi(13), bi(17));
      expect(x, isNotNull);
      expect((bi(3).modPow(x!, bi(17))), bi(13));
    });
    test('2^x ≡ 1 (mod 7) → x=0', () => expect(S.discreteLog(bi(2), bi(1), bi(7)), bi(0)));
  });
}
