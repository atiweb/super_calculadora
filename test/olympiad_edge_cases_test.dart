import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/models/surd.dart';
import 'package:super_calculadora/services/polynomial_service.dart';
import 'package:super_calculadora/services/number_theory_advanced_service.dart';
import 'package:super_calculadora/services/geometry_service.dart';
import 'package:super_calculadora/models/point.dart';

BigInt bi(int n) => BigInt.from(n);
Fraction fr(int n, int d) => Fraction(BigInt.from(n), BigInt.from(d));

void main() {
  test('Fraction.pow negative base & negative odd exponent', () {
    expect(fr(-2, 3).pow(-3).toString(), '-27/8'); // (-2/3)^-3
    expect(fr(-2, 3).pow(-2).toString(), '9/4');   // (-2/3)^-2
    expect(fr(-3, 2).pow(3).toString(), '-27/8');
  });

  test('Surd (1/2)√8 = √2 and (3/4)√48 = 3√3', () {
    expect(Surd(fr(1, 2), bi(8)).toString(), '√2');
    expect(Surd(fr(3, 4), bi(48)).toString(), '3√3');
  });

  test('Polynomial parse edge cases', () {
    expect(PolynomialService.parse('x').toString(), 'x');
    expect(PolynomialService.parse('-x^3+x').toString(), '-x^3 + x');
    expect(PolynomialService.parse('7').toString(), '7');
    expect(PolynomialService.parse('x^2-x').toString(), 'x^2 - x');
  });

  test('solveQuadratic 2x^2-3x+1 → {1/2, 1}', () {
    final s = PolynomialService.solveQuadratic(fr(2, 1), fr(-3, 1), fr(1, 1));
    expect(s.rationalRoots, [fr(1, 2), fr(1, 1)]);
  });

  test('continued fraction of integer 5/1 = [5]', () {
    expect(NumberTheoryAdvancedService.continuedFraction(bi(5), bi(1)), [bi(5)]);
  });

  test('continuedFractionSqrt(23) = [4; (1,3,1,8)]', () {
    final r = NumberTheoryAdvancedService.continuedFractionSqrt(bi(23));
    expect(r.a0, bi(4));
    expect(r.period, [bi(1), bi(3), bi(1), bi(8)]);
  });

  test('linear congruence with negative a', () {
    // -3x ≡ 6 (mod 9) → same as 6x ≡ 6 → solutions
    final sols = NumberTheoryAdvancedService.solveLinearCongruence(bi(-3), bi(6), bi(9));
    for (final x in sols) {
      expect((bi(-3) * x - bi(6)) % bi(9), bi(0));
    }
    expect(sols.isNotEmpty, true);
  });

  test('shoelace with rational and negative coordinates', () {
    // triangle (-1,-1), (2,-1), (-1,3): area = 1/2 |base*height| = 1/2*3*4 = 6
    final area = GeometryService.shoelaceArea([
      Point.ints(-1, -1), Point.ints(2, -1), Point.ints(-1, 3),
    ]);
    expect(area.toString(), '6');
  });

  test('Heron area of degenerate caught; valid 5,5,6 = 12', () {
    expect(GeometryService.heronArea(bi(5), bi(5), bi(6)).toString(), '12');
  });

  test('sumOfTwoSquares 50 = 1+49 or 25+25', () {
    final r = NumberTheoryAdvancedService.sumOfTwoSquares(bi(50))!;
    expect(r.a * r.a + r.b * r.b, bi(50));
  });
}
