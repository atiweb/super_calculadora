import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/models/polynomial.dart';
import 'package:super_calculadora/services/polynomial_service.dart';

Fraction fi(int n) => Fraction.fromInt(n);
Polynomial poly(List<int> c) => Polynomial.fromInts(c);

void main() {
  group('construction & formatting', () {
    test('trims leading zeros', () => expect(poly([6, -5, 1, 0, 0]).degree, 2));
    test('toString x^2-5x+6', () => expect(poly([6, -5, 1]).toString(), 'x^2 - 5x + 6'));
    test('toString 2x^3-x+1', () => expect(poly([1, -1, 0, 2]).toString(), '2x^3 - x + 1'));
    test('zero polynomial', () => expect(Polynomial.zero.toString(), '0'));
    test('constant', () => expect(poly([7]).toString(), '7'));
  });

  group('parsing', () {
    test('x^2-5x+6', () => expect(PolynomialService.parse('x^2-5x+6'), poly([6, -5, 1])));
    test('2x^3 - x + 1', () => expect(PolynomialService.parse('2x^3 - x + 1'), poly([1, -1, 0, 2])));
    test('-x^2+4', () => expect(PolynomialService.parse('-x^2+4'), poly([4, 0, -1])));
    test('x', () => expect(PolynomialService.parse('x'), poly([0, 1])));
    test('fractional coeff 3/2 x - 1', () {
      final p = PolynomialService.parse('3/2x-1');
      expect(p.coefficient(1), Fraction(BigInt.from(3), BigInt.two));
      expect(p.coefficient(0), fi(-1));
    });
    test('combines like terms 2x+3x', () =>
        expect(PolynomialService.parse('2x+3x'), poly([0, 5])));
  });

  group('evaluation', () {
    test('(x^2-5x+6) at 2 = 0', () => expect(poly([6, -5, 1]).evaluate(fi(2)), Fraction.zero));
    test('(x^2-5x+6) at 3 = 0', () => expect(poly([6, -5, 1]).evaluate(fi(3)), Fraction.zero));
    test('(x^2-5x+6) at 0 = 6', () => expect(poly([6, -5, 1]).evaluate(fi(0)), fi(6)));
    test('(x^2-5x+6) at 1 = 2', () => expect(poly([6, -5, 1]).evaluate(fi(1)), fi(2)));
  });

  group('arithmetic', () {
    test('(x+1)+(x-1) = 2x', () => expect(poly([1, 1]) + poly([-1, 1]), poly([0, 2])));
    test('(x+1)(x-1) = x^2-1', () => expect(poly([1, 1]) * poly([-1, 1]), poly([-1, 0, 1])));
    test('(x+2)(x+3) = x^2+5x+6', () => expect(poly([2, 1]) * poly([3, 1]), poly([6, 5, 1])));
    test('derivative of x^3 = 3x^2', () => expect(poly([0, 0, 0, 1]).derivative(), poly([0, 0, 3])));
    test('derivative of x^2-5x+6 = 2x-5', () => expect(poly([6, -5, 1]).derivative(), poly([-5, 2])));
  });

  group('division', () {
    test('(x^2-5x+6) / (x-2) = x-3 r 0', () {
      final r = poly([6, -5, 1]).divMod(poly([-2, 1]));
      expect(r.quotient, poly([-3, 1]));
      expect(r.remainder.isZero, true);
    });
    test('(x^2+1) / (x-1) = x+1 r 2', () {
      final r = poly([1, 0, 1]).divMod(poly([-1, 1]));
      expect(r.quotient, poly([1, 1]));
      expect(r.remainder, poly([2]));
    });
    test('division by zero throws', () =>
        expect(() => poly([1, 1]).divMod(Polynomial.zero), throwsArgumentError));
  });

  group('gcd', () {
    test('gcd(x^2-1, x^2-2x+1) = x-1 (monic)', () {
      final g = PolynomialService.gcd(poly([-1, 0, 1]), poly([1, -2, 1]));
      expect(g, poly([-1, 1]));
    });
    test('gcd coprime = 1', () {
      final g = PolynomialService.gcd(poly([1, 1]), poly([2, 1]));
      expect(g, poly([1]));
    });
  });

  group('Vieta', () {
    test('x^2-5x+6: sum=5, product=6', () {
      final v = PolynomialService.vieta(poly([6, -5, 1]));
      expect(v.sumOfRoots, fi(5));
      expect(v.productOfRoots, fi(6));
    });
    test('2x^2-4x+2: sum=2, product=1', () {
      final v = PolynomialService.vieta(poly([2, -4, 2]));
      expect(v.sumOfRoots, fi(2));
      expect(v.productOfRoots, fi(1));
    });
    test('cubic x^3-6x^2+11x-6: sum=6, product=6', () {
      final v = PolynomialService.vieta(poly([-6, 11, -6, 1]));
      expect(v.sumOfRoots, fi(6));
      expect(v.productOfRoots, fi(6));
    });
  });

  group('discriminant', () {
    test('x^2-5x+6 → 1', () => expect(PolynomialService.discriminant(poly([6, -5, 1])), fi(1)));
    test('x^2+x+1 → -3', () => expect(PolynomialService.discriminant(poly([1, 1, 1])), fi(-3)));
    test('x^2-4x+4 → 0', () => expect(PolynomialService.discriminant(poly([4, -4, 1])), fi(0)));
    test('cubic x^3-6x^2+11x-6 → 4', () =>
        expect(PolynomialService.discriminant(poly([-6, 11, -6, 1])), fi(4)));
  });

  group('rational roots', () {
    test('x^2-5x+6 → {2,3}', () {
      final roots = PolynomialService.rationalRoots(poly([6, -5, 1]));
      expect(roots, [fi(2), fi(3)]);
    });
    test('2x^2-3x+1 → {1/2, 1}', () {
      final roots = PolynomialService.rationalRoots(poly([1, -3, 2]));
      expect(roots, [Fraction(BigInt.one, BigInt.two), fi(1)]);
    });
    test('x^2+1 → no rational roots', () {
      expect(PolynomialService.rationalRoots(poly([1, 0, 1]), ), isEmpty);
    });
    test('x^3-x = x(x-1)(x+1) → {-1,0,1}', () {
      final roots = PolynomialService.rationalRoots(poly([0, -1, 0, 1]));
      expect(roots, [fi(-1), fi(0), fi(1)]);
    });
  });

  group('solveQuadratic', () {
    test('x^2-5x+6 → rational {2,3}', () {
      final s = PolynomialService.solveQuadratic(fi(1), fi(-5), fi(6));
      expect(s.discriminant, fi(1));
      expect(s.nature, 'dos reales distintas');
      expect(s.rationalRoots, [fi(2), fi(3)]);
    });
    test('x^2-4x+4 → double root 2', () {
      final s = PolynomialService.solveQuadratic(fi(1), fi(-4), fi(4));
      expect(s.nature, 'una raíz doble');
      expect(s.rationalRoots, [fi(2)]);
    });
    test('x^2-2 → irrational, no rational roots', () {
      final s = PolynomialService.solveQuadratic(fi(1), fi(0), fi(-2));
      expect(s.nature, 'dos reales distintas');
      expect(s.rationalRoots, isEmpty);
      expect((s.realRoots[0] + 1.4142135).abs() < 1e-5, true);
    });
    test('x^2+x+1 → complex', () {
      final s = PolynomialService.solveQuadratic(fi(1), fi(1), fi(1));
      expect(s.nature, 'complejas conjugadas');
      expect(s.realRoots, isEmpty);
    });
    test('a=0 throws', () =>
        expect(() => PolynomialService.solveQuadratic(fi(0), fi(1), fi(1)), throwsArgumentError));
  });

  group('solveCubicReal', () {
    test('x^3-6x^2+11x-6 → {1,2,3}', () {
      final roots = PolynomialService.solveCubicReal(1, -6, 11, -6);
      expect(roots.length, 3);
      expect((roots[0] - 1).abs() < 1e-6, true);
      expect((roots[1] - 2).abs() < 1e-6, true);
      expect((roots[2] - 3).abs() < 1e-6, true);
    });
    test('x^3-1 → one real root 1', () {
      final roots = PolynomialService.solveCubicReal(1, 0, 0, -1);
      expect(roots.length, 1);
      expect((roots[0] - 1).abs() < 1e-6, true);
    });
    test('x^3-3x^2+3x-1 = (x-1)^3 → triple root 1', () {
      final roots = PolynomialService.solveCubicReal(1, -3, 3, -1);
      for (final r in roots) {
        expect((r - 1).abs() < 1e-5, true);
      }
    });
  });
}
