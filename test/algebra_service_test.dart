// Multivariate polynomial algebra: parsing, expansion, factoring,
// substitution and identities.
//
// Run with: flutter test test/algebra_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/calc_exception.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/models/multi_polynomial.dart';
import 'package:super_calculadora/services/algebra_service.dart';
import 'package:super_calculadora/services/polynomial_service.dart';

MultiPolynomial p(String s) => AlgebraService.parse(s);

Fraction f(int n, [int d = 1]) => Fraction(BigInt.from(n), BigInt.from(d));

void main() {
  group('expansion', () {
    // Terms come out in graded lexicographic order (higher degree first, then
    // the higher exponent on the earlier variable), the usual CAS convention.
    test('(a+b+c)² has the six expected terms', () {
      expect(p('(a+b+c)^2').toString(), 'a² + 2ab + 2ac + b² + 2bc + c²');
      expect(AlgebraService.areEquivalent(
          '(a+b+c)^2', 'a^2+b^2+c^2+2ab+2bc+2ca'), true);
    });

    test('(a+b)³ keeps the binomial order', () {
      expect(p('(a+b)^3').toString(), 'a³ + 3a²b + 3ab² + b³');
    });

    test('(a+b)(a−b) = a²−b²', () {
      expect(p('(a+b)(a-b)').toString(), 'a² - b²');
    });

    test('(x+1)(x+2) = x²+3x+2', () {
      expect(p('(x+1)(x+2)').toString(), 'x² + 3x + 2');
    });

    test('like terms collapse to zero', () {
      expect(p('(a+b)^2 - a^2 - 2ab - b^2').isZero, true);
      expect(p('a - a').toString(), '0');
    });

    test('Unicode superscripts are the same as ^', () {
      expect(p('(a+b+c)²'), p('(a+b+c)^2'));
      expect(p('a²b³'), p('a^2*b^3'));
      expect(p('(a+b)¹⁰'), p('(a+b)^10'));
    });

    test('implicit multiplication', () {
      expect(p('2ab').toString(), '2ab');
      expect(p('3(x+1)').toString(), '3x + 3');
      expect(p('2a(b+c)').toString(), '2ab + 2ac');
      expect(p('x^2y').toString(), 'x²y'); // (x²)·y, not x^(2y)
      expect(p('2^3a').toString(), '8a'); // (2³)·a
    });

    test('operator aliases and spacing', () {
      expect(p('a·b'), p('a*b'));
      expect(p('a − b'), p('a-b'));
      expect(p('2 ** 3'), p('8'));
      expect(p('[a+b](a-b)'), p('a^2-b^2'));
    });

    test('variables may carry a numeric subscript', () {
      expect(p('(x1+x2)^2').toString(), 'x1² + 2x1x2 + x2²');
    });

    test('unary minus binds looser than the exponent', () {
      expect(p('-a^2').toString(), '-a²');
      expect(p('(-a)^2').toString(), 'a²');
      expect(p('-(a+b)').toString(), '-a - b');
    });

    test('rational coefficients stay exact', () {
      expect(p('x/2 + x/3').toString(), '(5/6)x');
      expect(p('(1/2)a + (1/2)a').toString(), 'a');
      expect(p('0.25x').toString(), '(1/4)x');
    });

    test('exact division by a monomial', () {
      expect(p('(a^2b + ab^2)/(ab)').toString(), 'a + b');
      expect(p('(6a^2 + 3a)/3').toString(), '2a² + a');
    });

    test('anything to the zero power is 1', () {
      expect(p('(a+b)^0').toString(), '1');
    });

    test('a printed result parses back to the same polynomial', () {
      for (final source in [
        '(a+b+c)^3',
        'x/2 - 3y^2 + 1',
        '-(2/3)a^2b + 7',
        '(x1+x2+x3)^2',
      ]) {
        final MultiPolynomial q = p(source);
        expect(p(q.toString()), q, reason: source);
      }
    });
  });

  group('invalid input', () {
    test('empty expression', () {
      expect(() => p('   '), throwsA(isA<CalcException>()));
    });

    test('unbalanced parentheses', () {
      expect(() => p('(a+b'), throwsA(isA<CalcException>()));
      expect(() => p('a+b)'), throwsA(isA<CalcException>()));
    });

    test('incomplete expression', () {
      expect(() => p('2a +'), throwsA(isA<CalcException>()));
    });

    test('unknown symbol', () {
      expect(() => p('a # b'), throwsA(isA<CalcException>()));
    });

    test('negative and symbolic exponents are not polynomials', () {
      expect(() => p('a^-1'), throwsA(isA<CalcException>()));
      expect(() => p('a^b'), throwsA(isA<CalcException>()));
      expect(() => p('a^(1/2)'), throwsA(isA<CalcException>()));
    });

    test('inexact division is rejected', () {
      expect(() => p('a/b'), throwsA(isA<CalcException>()));
      expect(() => p('a/(b+c)'), throwsA(isA<CalcException>()));
      expect(() => p('1/0'), throwsA(isA<CalcException>()));
    });

    test('an explosive expansion is refused, not attempted', () {
      expect(() => p('(a+b+c+d+e+f+g+h)^40'),
          throwsA(isA<CalcException>()));
    });

    test('an oversized expansion reports the term limit it hit', () {
      try {
        p('(a+b+c+d+e)^20');
        fail('expected a refusal');
      } on CalcException catch (e) {
        expect(e.code, CalcError.expansionTooLarge);
        expect(e.arg('max'), '${MultiPolynomial.maxTerms}');
      }
    });
  });

  // These inputs stayed under every per-operation guard and were computed in
  // full, freezing the UI isolate for seconds to minutes.
  group('cost guards (regression)', () {
    test('a single slow expansion is refused', () {
      // Only 1001 terms, so maxTerms/maxProducts never fire — it took 3 s.
      expect(() => p('(a+b)^1000'), throwsA(isA<CalcException>()));
    });

    test('a chain of individually-legal expansions is refused', () {
      // 50 copies of (a+b)^1000 took 164 s before the whole-computation budget.
      final sw = Stopwatch()..start();
      expect(() => p(List.filled(50, '(a+b)^1000').join('+')),
          throwsA(isA<CalcException>()));
      expect(sw.elapsed.inSeconds, lessThan(5));
    });

    test('ordinary expansions still fit in the budget', () {
      expect(p('(a+b+c)^30').termCount, 496);
      expect(p('(a+b+c+d)^10').termCount, 286);
      expect(p('(x1+x2+x3+x4)^12').termCount, 455);
      expect(p('(1+x)^100').termCount, 101);
    });

    test('a refused computation does not poison the next one', () {
      expect(() => p('(a+b)^1000'), throwsA(isA<CalcException>()));
      expect(p('(a+b)^3').toString(), 'a³ + 3a²b + 3ab² + b³');
    });

    test('the budget does not leak across computations', () {
      // Each call opens its own budget; a leak would starve the later ones.
      for (int i = 0; i < 40; i++) {
        expect(p('(a+b+c)^10').termCount, 66, reason: 'call $i');
      }
    });

    test('substitution through the service is bounded too', () {
      final q = p('x^900');
      expect(
          () => AlgebraService.substitute(q, {'x': p('a+b')}),
          throwsA(isA<CalcException>()));
    });
  });

  // A malformed decimal used to split into two number literals that implicit
  // multiplication then combined, silently returning a wrong answer.
  group('malformed numbers (regression)', () {
    test('a thousands separator is an error, not a silent zero', () {
      expect(() => p('1.000.000'), throwsA(isA<CalcException>())); // was 0
    });

    test('repeated decimal points are rejected', () {
      expect(() => p('2.5.3'), throwsA(isA<CalcException>())); // was 3/4
      expect(() => p('2..3'), throwsA(isA<CalcException>())); // was 3/5
    });

    test('two numbers side by side are a typo, not a product', () {
      expect(() => p('2 3'), throwsA(isA<CalcException>())); // was 6
    });

    test('legitimate implicit products are unaffected', () {
      expect(p('2x 3y').toString(), '6xy');
      expect(p('(x+1)2').toString(), '2x + 2');
      expect(p('2(x+1)').toString(), '2x + 2');
      expect(p('.5a').toString(), '(1/2)a');
      expect(p('3/4 a').toString(), '(3/4)a');
      expect(p('2.5').toString(), '5/2');
    });
  });

  // Typing a multivariate expression into the univariate "Analyze polynomial"
  // tool answered `Invalid term: "(a"` — the fragment its split on '+' had
  // produced — which said nothing about the actual problem.
  group('univariate tool rejects multivariate input clearly', () {
    test('parentheses and other variables point at the Algebra tools', () {
      for (final input in ['(a+b+c)^2', 'a+b', '(x+1)(x+2)', '2ab']) {
        expect(
            () => PolynomialService.parse(input),
            throwsA(isA<CalcException>().having(
                (e) => e.code, 'code', CalcError.singleVariableOnly)),
            reason: input);
      }
    });

    test('genuine single-variable polynomials still parse', () {
      expect(PolynomialService.parse('x^2-5x+6').degree, 2);
      expect(PolynomialService.parse('3/2x-1').degree, 1);
      expect(PolynomialService.parse('-x+1').degree, 1);
    });
  });

  group('properties', () {
    test('degree, terms and variables', () {
      final q = p('(a+b+c)^2');
      expect(q.degree, 2);
      expect(q.termCount, 6);
      expect(q.variables, ['a', 'b', 'c']);
      expect(q.degreeIn('a'), 2);
      expect(q.isHomogeneous, true);
      expect(p('a^2 + a').isHomogeneous, false);
      expect(p('0').degree, -1);
    });

    test('symmetry', () {
      expect(AlgebraService.isSymmetric(p('(a+b+c)^2')), true);
      expect(AlgebraService.isSymmetric(p('a^2+b^2+c^2+ab+bc+ca')), true);
      expect(AlgebraService.isSymmetric(p('a^2+b')), false);
      expect(AlgebraService.isSymmetric(p('a^2b+b^2c+c^2a')), false);
    });

    test('coefficient extraction', () {
      expect(AlgebraService.coefficientOf(p('(a+b+c)^3'), 'a^2b'), f(3));
      expect(AlgebraService.coefficientOf(p('(1+x)^10'), 'x^5'), f(252));
      expect(AlgebraService.coefficientOf(p('(a+b+c)^3'), 'abc'), f(6));
      expect(AlgebraService.coefficientOf(p('(a+b)^2'), 'c'), Fraction.zero);
    });

    test('multinomial theorem: coefficients of (a+b+c)^n add up to 3^n', () {
      for (int n = 1; n <= 8; n++) {
        final q = p('(a+b+c)^$n');
        final Fraction total = q.evaluate({
          'a': Fraction.one,
          'b': Fraction.one,
          'c': Fraction.one,
        });
        expect(total, f(1) * Fraction.fromBigInt(BigInt.from(3).pow(n)),
            reason: 'n = $n');
      }
    });
  });

  group('identities', () {
    test('equivalent expressions are recognised', () {
      expect(AlgebraService.areEquivalent('(a+b)^2', 'a^2+2ab+b^2'), true);
      expect(AlgebraService.areEquivalent('(a+b+c)^2',
          'a^2+b^2+c^2+2ab+2bc+2ca'), true);
      expect(AlgebraService.areEquivalent('(a+b)^2', 'a^2+b^2'), false);
    });

    test('the difference pinpoints the mismatch', () {
      expect(AlgebraService.difference('(a+b)^2', 'a^2+b^2').toString(), '2ab');
    });

    test('notable products expand correctly', () {
      final list = AlgebraService.notableProducts(p('x'), p('2y'));
      final Map<String, String> byFormula = {
        for (final n in list) n.formula: n.value.toString()
      };
      expect(byFormula['(A+B)²'], 'x² + 4xy + 4y²');
      expect(byFormula['(A+B)(A−B)'], 'x² - 4y²');
      expect(byFormula['(A+B)(A²−AB+B²)'], 'x³ + 8y³');
      expect(byFormula['(A−B)(A²+AB+B²)'], 'x³ - 8y³');
    });
  });

  group('common factor', () {
    test('monomial and integer content', () {
      expect(AlgebraService.commonFactor(p('2a^2b+4ab^2')).toString(),
          '2ab(a + 2b)');
      expect(AlgebraService.commonFactor(p('x^2+x')).toString(), 'x(x + 1)');
    });

    test('a leading minus moves outside', () {
      expect(AlgebraService.commonFactor(p('-2x-4')).toString(), '-2(x + 2)');
    });

    test('fractional content clears the denominators', () {
      expect(AlgebraService.commonFactor(p('x/2 + y/3')).toString(),
          '(1/6)(3x + 2y)');
    });

    test('nothing to factor', () {
      final cf = AlgebraService.commonFactor(p('x+y'));
      expect(cf.isTrivial, true);
      expect(cf.toString(), 'x + y');
      expect(AlgebraService.commonFactor(p('3a^2')).toString(), '3a²');
    });

    test('the factorisation multiplies back to the original', () {
      for (final source in ['2a^2b+4ab^2', '-2x-4', 'x/2 + y/3', 'x^2+x']) {
        final MultiPolynomial q = p(source);
        final cf = AlgebraService.commonFactor(q);
        expect(cf.factor * cf.cofactor, q, reason: source);
      }
    });
  });

  group('evaluation and substitution', () {
    test('exact numeric evaluation', () {
      expect(p('(a+b)^2').evaluate({'a': f(3), 'b': f(4)}), f(49));
      expect(p('a/2').evaluate({'a': f(1, 3)}), f(1, 6));
    });

    test('a missing value is reported', () {
      expect(() => p('a+b').evaluate({'a': f(1)}),
          throwsA(isA<CalcException>()));
    });

    test('numeric substitution may be partial', () {
      final q = p('(a+b+c)^2').substitute({
        'a': MultiPolynomial.constant(f(1)),
        'b': MultiPolynomial.constant(f(2)),
      });
      expect(q.toString(), 'c² + 6c + 9');
    });

    test('symbolic substitution', () {
      expect(p('a^2').substitute({'a': p('x+1')}).toString(), 'x² + 2x + 1');
    });

    test('substitution is simultaneous, so variables can be swapped', () {
      final q = p('a^2+2b').substitute({
        'a': MultiPolynomial.variable('b'),
        'b': MultiPolynomial.variable('a'),
      });
      expect(q.toString(), 'b² + 2a');
    });

    test('assignments parse into values or expressions', () {
      final map = AlgebraService.parseAssignments('a=1, b=2/3, c = x+1');
      expect(map['a'], p('1'));
      expect(map['b']!.constantValue, f(2, 3));
      expect(map['c'], p('x+1'));
      expect(() => AlgebraService.parseAssignments('a'),
          throwsA(isA<CalcException>()));
      expect(() => AlgebraService.parseAssignments('a+b=1'),
          throwsA(isA<CalcException>()));
    });
  });

  group('calculus on several variables', () {
    test('partial derivatives', () {
      expect(p('(a+b)^2').derivative('a').toString(), '2a + 2b');
      expect(p('x^3y^2').derivative('y').toString(), '2x³y');
      expect(p('x^2+y').derivative('z').toString(), '0');
    });

    test("Euler's identity for a homogeneous polynomial", () {
      // For f homogeneous of degree n:  Σ xᵢ·∂f/∂xᵢ = n·f
      final f0 = p('(a+b+c)^3');
      MultiPolynomial sum = MultiPolynomial.zero;
      for (final v in f0.variables) {
        sum = sum + MultiPolynomial.variable(v) * f0.derivative(v);
      }
      expect(sum, f0.scale(f(3)));
    });
  });
}
