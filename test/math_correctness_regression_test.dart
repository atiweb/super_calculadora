import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/calc_exception.dart';
import 'package:super_calculadora/models/quiz_problem.dart';
import 'package:super_calculadora/services/calculus_service.dart';
import 'package:super_calculadora/services/polynomial_service.dart';
import 'package:super_calculadora/services/special_functions_service.dart';
import 'package:super_calculadora/services/steps_service.dart';

/// Regressions for the mathematically wrong answers found in the audit.
void main() {
  group('solveCubicReal keeps exact double roots', () {
    test('(x−1)²(x−14) reports both roots', () {
      // x³ − 16x² + 29x − 14. The absolute discriminant tolerance dropped x=1.
      final roots = PolynomialService.solveCubicReal(1, -16, 29, -14);
      expect(roots.length, 2);
      expect(roots[0], closeTo(1.0, 1e-6));
      expect(roots[1], closeTo(14.0, 1e-6));
    });

    test('every (x−a)²(x−b) with a,b ≤ 60 keeps its double root', () {
      // 1076 of these 3540 cases used to lose the double root entirely.
      int lost = 0;
      for (int a = 1; a <= 60; a++) {
        for (int b = 1; b <= 60; b++) {
          if (a == b) continue;
          // (x−a)²(x−b) = x³ −(2a+b)x² +(a²+2ab)x −a²b
          final roots = PolynomialService.solveCubicReal(
              1, -(2.0 * a + b), a * a + 2.0 * a * b, -(a * a * 1.0 * b));
          final hasDouble = roots.any((r) => (r - a).abs() < 1e-4);
          final hasSimple = roots.any((r) => (r - b).abs() < 1e-4);
          if (!hasDouble || !hasSimple) lost++;
        }
      }
      expect(lost, 0);
    });

    test('genuinely distinct and single-root cubics are unaffected', () {
      // (x−1)(x−2)(x−3)
      final three = PolynomialService.solveCubicReal(1, -6, 11, -6);
      expect(three.length, 3);
      expect(three[0], closeTo(1.0, 1e-6));
      expect(three[1], closeTo(2.0, 1e-6));
      expect(three[2], closeTo(3.0, 1e-6));

      // x³ + x + 1 has a single real root ≈ −0.6823
      final one = PolynomialService.solveCubicReal(1, 0, 1, 1);
      expect(one.length, 1);
      expect(one[0], closeTo(-0.6823278, 1e-6));
    });
  });

  group('Limits and derivatives report poles instead of huge numbers', () {
    test('lim 1/x² at 0 does not exist', () {
      // Both sides "agreed" at 1e12, so that was returned as the limit.
      expect(CalculusService.limit('1/x^2', 0), isNull);
    });

    test('lim 1/x at 0 does not exist (sides disagree)', () {
      expect(CalculusService.limit('1/x', 0), isNull);
    });

    test('ordinary limits still work', () {
      expect(CalculusService.limit('sin(x)/x', 0)!, closeTo(1.0, 1e-5));
      expect(CalculusService.limit('x^2+1', 2)!, closeTo(5.0, 1e-5));
      expect(CalculusService.limit('(x^2-1)/(x-1)', 1)!, closeTo(2.0, 1e-4));
    });

    test("f'(0) for 1/x is undefined, not 5e10", () {
      expect(CalculusService.isUsable(CalculusService.derivative('1/x', 0)),
          isFalse);
    });

    test('ordinary derivatives still work', () {
      expect(CalculusService.derivative('x^2', 3), closeTo(6.0, 1e-5));
      expect(CalculusService.derivative('sin(x)', 0), closeTo(1.0, 1e-5));
      expect(CalculusService.derivative('x^3-2*x', 2), closeTo(10.0, 1e-4));
      expect(CalculusService.derivative('1/x', 2), closeTo(-0.25, 1e-5));
    });
  });

  group('CRT validates its moduli', () {
    test('a zero modulus is a domain error, not a raw exception', () {
      expect(
        () => SpecialFunctionsService.chineseRemainderTheorem(
            [BigInt.two, BigInt.from(7)], [BigInt.from(5), BigInt.zero]),
        throwsArgumentError,
      );
    });

    test('crtSteps rejects zero and negative moduli', () {
      expect(
        () => StepsService.crtSteps(
            [BigInt.two, BigInt.from(3)], [BigInt.from(3), BigInt.zero]),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.moduliPositive)),
      );
      // Used to answer "x ≡ 5 (mod -15)", which is simply wrong.
      expect(
        () => StepsService.crtSteps(
            [BigInt.two, BigInt.from(3)], [BigInt.from(3), BigInt.from(-5)]),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.moduliPositive)),
      );
    });

    test('valid systems are unchanged', () {
      final r = SpecialFunctionsService.chineseRemainderTheorem(
          [BigInt.two, BigInt.from(3), BigInt.two],
          [BigInt.from(3), BigInt.from(5), BigInt.from(7)]);
      expect(r['solvable'], isTrue);
      expect(r['solution'], BigInt.from(23));
    });
  });

  group('Quiz answer checking', () {
    test('a decimal-formatted integer is accepted', () {
      const p = QuizProblem(topic: 't', prompt: 'p', answer: '6');
      // The numeric keyboard offers a '.', so "6.0" is a natural way to type 6.
      expect(p.isCorrect('6.0'), isTrue);
      expect(p.isCorrect('6,00'), isTrue);
      expect(p.isCorrect(' 6 '), isTrue);
      expect(p.isCorrect('06'), isTrue);
    });

    test('wrong answers are still wrong', () {
      const p = QuizProblem(topic: 't', prompt: 'p', answer: '6');
      expect(p.isCorrect('6.5'), isFalse);
      expect(p.isCorrect('7'), isFalse);
      expect(p.isCorrect('60'), isFalse);
      expect(p.isCorrect(''), isFalse);
    });

    test('negative answers work too', () {
      const p = QuizProblem(topic: 't', prompt: 'p', answer: '-3');
      expect(p.isCorrect('-3'), isTrue);
      expect(p.isCorrect('-3.0'), isTrue);
      expect(p.isCorrect('3'), isFalse);
    });
  });
}
