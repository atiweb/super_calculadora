import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/calc_exception.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/models/point.dart';
import 'package:super_calculadora/services/combinatorics_extra_service.dart';
import 'package:super_calculadora/services/geometry_service.dart';
import 'package:super_calculadora/services/linear_system_service.dart';
import 'package:super_calculadora/services/number_theory_advanced_service.dart';
import 'package:super_calculadora/services/polynomial_service.dart';
import 'package:super_calculadora/services/statistics_service.dart';
import 'package:super_calculadora/services/steps_service.dart';

Fraction f(int n, [int d = 1]) => Fraction(BigInt.from(n), BigInt.from(d));
Point pt(int x, int y) => Point.ints(x, y);

void main() {
  group("Pick's theorem", () {
    test('5×4 rectangle: A=20, B=18, I=12', () {
      final r = GeometryService.pickAnalysis(
          [pt(0, 0), pt(5, 0), pt(5, 4), pt(0, 4)]);
      expect(r.area, f(20));
      expect(r.boundary, BigInt.from(18));
      expect(r.interior, BigInt.from(12));
    });

    test('right triangle (0,0),(4,0),(0,3): A=6, B=12 (gcd edge), I=1', () {
      final r =
          GeometryService.pickAnalysis([pt(0, 0), pt(4, 0), pt(0, 3)]);
      expect(r.area, f(6));
      // edges: 4 + gcd(4,3)=1 + 3 = 8... boundary = 4+1+3 = 8
      expect(r.boundary, BigInt.from(8));
      // I = 6 - 8/2 + 1 = 3
      expect(r.interior, BigInt.from(3));
    });

    test('non-integer vertices throw', () {
      expect(
          () => GeometryService.pickAnalysis([
                Point(Fraction.parse('1/2'), Fraction.zero),
                pt(3, 0),
                pt(0, 3),
              ]),
          throwsA(isA<CalcException>().having((e) => e.code, 'code',
              CalcError.integerCoordinatesRequired)));
    });

    test('Pick identity holds: A = I + B/2 − 1', () {
      final r = GeometryService.pickAnalysis(
          [pt(0, 0), pt(7, 2), pt(5, 6), pt(1, 5)]);
      final lhs = r.area;
      final rhs = Fraction.fromBigInt(r.interior) +
          Fraction(r.boundary, BigInt.two) -
          Fraction.one;
      expect(lhs, rhs);
    });
  });

  group('Triangle centers', () {
    test('3-4-5 right triangle: circumcenter at hypotenuse midpoint', () {
      // Right angle at A=(0,0); hypotenuse BC from (4,0) to (0,3).
      final r = GeometryService.triangleCenters(pt(0, 0), pt(4, 0), pt(0, 3));
      expect(r.circumcenter, Point(f(2), f(3, 2)));
      // centroid
      expect(r.centroid, Point(f(4, 3), f(1)));
      // orthocenter of a right triangle is the right-angle vertex
      expect(r.orthocenter, pt(0, 0));
    });

    test('Euler identity H = 3G − 2O', () {
      final r = GeometryService.triangleCenters(pt(1, 1), pt(7, 2), pt(3, 6));
      final three = f(3), two = f(2);
      expect(r.orthocenter.x, three * r.centroid.x - two * r.circumcenter.x);
      expect(r.orthocenter.y, three * r.centroid.y - two * r.circumcenter.y);
    });

    test('equilateral-ish symmetric: incenter near centroid', () {
      final r = GeometryService.triangleCenters(pt(0, 0), pt(4, 0), pt(2, 3));
      // isosceles: all centers on x = 2
      expect(r.centroid.x, f(2));
      expect(r.circumcenter.x, f(2));
      expect(r.orthocenter.x, f(2));
      expect(r.incenterX, closeTo(2.0, 1e-9));
    });

    test('collinear points throw', () {
      expect(
          () => GeometryService.triangleCenters(pt(0, 0), pt(1, 1), pt(2, 2)),
          throwsA(isA<CalcException>()
              .having((e) => e.code, 'code', CalcError.collinearPoints)));
    });
  });

  group('LinearSystemService (Cramer)', () {
    test('2×2: 2x+y=5, x−y=1 → x=2, y=1', () {
      final sol = LinearSystemService.solveCramer([
        [f(2), f(1), f(5)],
        [f(1), f(-1), f(1)],
      ]);
      expect(sol, [f(2), f(1)]);
    });

    test('3×3 integer solution', () {
      // x+y+z=6, 2x−y=0, x−z=−2  →  x=1, y=2, z=3
      final sol = LinearSystemService.solveCramer([
        [f(1), f(1), f(1), f(6)],
        [f(2), f(-1), f(0), f(0)],
        [f(1), f(0), f(-1), f(-2)],
      ]);
      expect(sol, [f(1), f(2), f(3)]);
    });

    test('3×3 fractional solution', () {
      // 2x+y+z=1, x+2y+z=1, x+y+2z=1  →  x=y=z=1/4
      final sol = LinearSystemService.solveCramer([
        [f(2), f(1), f(1), f(1)],
        [f(1), f(2), f(1), f(1)],
        [f(1), f(1), f(2), f(1)],
      ]);
      expect(sol, [f(1, 4), f(1, 4), f(1, 4)]);
    });

    test('singular system returns null', () {
      final sol = LinearSystemService.solveCramer([
        [f(1), f(2), f(3)],
        [f(2), f(4), f(6)],
      ]);
      expect(sol, isNull);
    });

    test('wrong dimensions throw', () {
      expect(
          () => LinearSystemService.solveCramer([
                [f(1), f(2)],
                [f(3), f(4), f(5)],
              ]),
          throwsA(isA<CalcException>()
              .having((e) => e.code, 'code', CalcError.invalidSystem)));
    });
  });

  group('StatisticsService', () {
    test('descriptive of 2,4,4,5,7', () {
      final r = StatisticsService.descriptive(
          [f(2), f(4), f(4), f(5), f(7)]);
      expect(r.count, 5);
      expect(r.mean, f(22, 5));
      expect(r.median, f(4));
      expect(r.modes, [f(4)]);
      expect(r.min, f(2));
      expect(r.max, f(7));
      expect(r.range, f(5));
      // varianza poblacional: ((2-4.4)²+(4-4.4)²·2+(5-4.4)²+(7-4.4)²)/5
      // = (5.76+0.16+0.16+0.36+6.76)/5 = 13.2/5 = 66/25
      expect(r.variancePopulation, f(66, 25));
      expect(r.varianceSample, f(66, 20));
    });

    test('even count: median averages middle two', () {
      final r = StatisticsService.descriptive([f(1), f(3), f(5), f(7)]);
      expect(r.median, f(4));
    });

    test('no repeated values → no mode', () {
      final r = StatisticsService.descriptive([f(1), f(2), f(3)]);
      expect(r.modes, isEmpty);
    });

    test('means chain QM ≥ AM ≥ GM ≥ HM for 1,2,4', () {
      final r = StatisticsService.means([f(1), f(2), f(4)]);
      expect(r.arithmetic, f(7, 3));
      expect(r.harmonic, f(12, 7));
      expect(r.geometric, closeTo(2.0, 1e-9)); // ∛8 = 2
      expect(r.quadratic >= r.arithmetic.toDouble(), isTrue);
      expect(r.arithmetic.toDouble() >= r.geometric, isTrue);
      expect(r.geometric >= r.harmonic.toDouble(), isTrue);
    });

    test('non-positive value in means throws', () {
      expect(() => StatisticsService.means([f(1), f(0)]),
          throwsA(isA<CalcException>()));
    });
  });

  group('Ruffini steps', () {
    test('x³−6x²+11x−6 ÷ (x−1): quotient x²−5x+6, remainder 0', () {
      final p = PolynomialService.parse('x^3-6x^2+11x-6');
      final r = StepsService.ruffiniSteps(p, f(1));
      expect(r.result, contains('x^2 - 5x + 6'));
      expect(r.result, contains('remainder 0'));
    });

    test('non-root: remainder = p(c) (remainder theorem)', () {
      final p = PolynomialService.parse('x^2+1');
      final r = StepsService.ruffiniSteps(p, f(2));
      expect(r.result, contains('remainder 5'));
    });

    test('fractional c works', () {
      final p = PolynomialService.parse('2x^2-x'); // roots 0 and 1/2
      final r = StepsService.ruffiniSteps(p, f(1, 2));
      expect(r.result, contains('remainder 0'));
    });

    test('constant polynomial throws', () {
      final p = PolynomialService.parse('5');
      expect(() => StepsService.ruffiniSteps(p, f(1)),
          throwsA(isA<CalcException>()));
    });

    test('spanish output', () {
      final p = PolynomialService.parse('x^2-1');
      final r = StepsService.ruffiniSteps(p, f(1), spanish: true);
      expect(r.result, contains('resto 0'));
      expect(r.steps.last, contains('es raíz'));
    });
  });

  group('Cubic solver clamp regression', () {
    test('three real roots near acos boundary do not produce NaN', () {
      // x³ − 3x = 0 → raíces −√3, 0, √3 (caso trigonométrico, q = 0)
      final roots = PolynomialService.solveCubicReal(1, 0, -3, 0);
      expect(roots.length, 3);
      for (final r in roots) {
        expect(r.isNaN, isFalse);
      }
    });
  });

  group('pascalTriangleMod', () {
    test('mod 2 row 4 = [1,0,0,0,1]', () {
      final rows = CombinatoricsExtraService.pascalTriangleMod(4, 2);
      expect(rows.length, 5);
      expect(rows[4], [1, 0, 0, 0, 1]);
    });

    test('matches pascalRow mod m (row 10, m=7)', () {
      final rows = CombinatoricsExtraService.pascalTriangleMod(10, 7);
      final exact = CombinatoricsExtraService.pascalRow(10)
          .map((v) => (v % BigInt.from(7)).toInt())
          .toList();
      expect(rows[10], exact);
    });

    test('row p of mod p is [1,0,…,0,1] (Lucas)', () {
      final rows = CombinatoricsExtraService.pascalTriangleMod(7, 7);
      expect(rows[7].first, 1);
      expect(rows[7].last, 1);
      expect(rows[7].sublist(1, 7), everyElement(0));
    });

    test('m < 2 throws', () {
      expect(() => CombinatoricsExtraService.pascalTriangleMod(5, 1),
          throwsA(isA<CalcException>()));
    });
  });

  group('sieveOfEratosthenes', () {
    test('primes up to 30', () {
      final flags = NumberTheoryAdvancedService.sieveOfEratosthenes(30);
      final primes = <int>[];
      for (int v = 0; v <= 30; v++) {
        if (flags[v]) primes.add(v);
      }
      expect(primes, [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]);
    });

    test('0 and 1 are not prime', () {
      final flags = NumberTheoryAdvancedService.sieveOfEratosthenes(1);
      expect(flags[0], isFalse);
      expect(flags[1], isFalse);
    });

    test('π(100) = 25', () {
      final flags = NumberTheoryAdvancedService.sieveOfEratosthenes(100);
      expect(flags.where((f) => f).length, 25);
    });
  });

  group('heronAreaApprox validation regression', () {
    test('invalid triangle returns NaN instead of garbage', () {
      expect(GeometryService.heronAreaApprox(1, 1, 5).isNaN, isTrue);
      expect(GeometryService.heronAreaApprox(-1, 2, 2).isNaN, isTrue);
      expect(GeometryService.heronAreaApprox(0, 0, 0).isNaN, isTrue);
    });

    test('valid triangle still works', () {
      expect(GeometryService.heronAreaApprox(3, 4, 5), closeTo(6.0, 1e-12));
    });
  });
}
