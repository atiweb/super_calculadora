import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/calc_exception.dart';
import 'package:super_calculadora/models/complex.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/services/big_decimal.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/calculus_service.dart';
import 'package:super_calculadora/services/number_analysis_service.dart';
import 'package:super_calculadora/services/number_theory_advanced_service.dart';
import 'package:super_calculadora/services/polynomial_service.dart';

/// Regresiones de la cacería de bugs (2026-07): cada grupo cubre un defecto
/// que producía resultados silenciosamente incorrectos o crashes.
void main() {
  group('BigDecimal.fromString', () {
    test('expande notación científica en vez de degradar a 0', () {
      expect(BigDecimal.fromString('1e+25').toString(),
          '10000000000000000000000000');
      expect(BigDecimal.fromString('3.16e+21').toString(),
          '3160000000000000000000');
      expect(BigDecimal.fromString('1e-7').toString(), '0.0000001');
      expect(BigDecimal.fromString('-2.5e3').toString(), '-2500');
    });

    test('rechaza texto no numérico en vez de devolver 0', () {
      expect(() => BigDecimal.fromString('Error'), throwsFormatException);
      expect(() => BigDecimal.fromString('Infinity'), throwsFormatException);
      expect(() => BigDecimal.fromString('.'), throwsFormatException);
    });
  });

  group('BigDecimal raíces exactas', () {
    test('sqrt de potencias de 10 grandes (antes devolvía 0 o 3)', () {
      expect(BigDecimal.fromString('1${'0' * 44}').sqrt().toString(),
          '1${'0' * 22}');
      expect(BigDecimal.fromString('1${'0' * 40}').sqrt().toString(),
          '1${'0' * 20}');
      expect(BigDecimal.fromInt(144).sqrt().toString(), '12');
      expect(BigDecimal.fromString('2.25').sqrt().toString(), '1.5');
    });

    test('cbrt exacta para cubos grandes (antes ruido de double)', () {
      expect(BigDecimal.fromString('1${'0' * 63}').cbrt().toString(),
          '1${'0' * 21}');
      expect(BigDecimal.fromInt(-27).cbrt().toString(), '-3');
    });
  });

  group('Evaluador BigDecimal multi-operador', () {
    final calc = CalculatorService();

    test('respeta precedencia y varios operadores', () {
      expect(calc.evaluateCompleteExpression('2^68+1'),
          '295147905179352825857');
      expect(calc.evaluateCompleteExpression('2^68×2'),
          '590295810358705651712');
      expect(calc.evaluateCompleteExpression('12345678901+2×3'),
          '12345678907');
      expect(calc.evaluateCompleteExpression('12345678901-1-1'),
          '12345678899');
    });

    test('división con cero a la izquierda no es división por cero', () {
      expect(calc.evaluateCompleteExpression('8÷02'), '4');
      expect(calc.evaluateCompleteExpression('8÷0'), 'err:errExprDivZero');
    });

    test('la e científica no se sustituye por la constante de Euler', () {
      // 2e3 ya no debe convertirse en 2·2.718…·3 (≈22.72); si el parser no
      // soporta la notación, debe dar error, nunca un valor incorrecto.
      final String r = calc.evaluateCompleteExpression('2e3+1');
      expect(r == '2001' || r.startsWith('err:'), isTrue, reason: r);
    });
  });

  group('previousPrime', () {
    test('previousPrime(3) es 2, no 1', () {
      expect(NumberAnalysisService.previousPrime(BigInt.from(3)),
          BigInt.two);
      expect(NumberAnalysisService.previousPrime(BigInt.from(5)),
          BigInt.from(3));
    });
  });

  group('Factorización completa', () {
    test('semiprimo con factores > 10⁶ se factoriza de verdad', () {
      final factors =
          NumberAnalysisService.primeFactorization(BigInt.parse('1000036000099'));
      expect(factors.map((f) => f.toString()).toList(),
          ['1000003', '1000033']);
    });

    test('getDivisors devuelve los divisores no triviales del semiprimo', () {
      final divisors =
          NumberAnalysisService.getDivisors(BigInt.parse('1000036000099'));
      expect(divisors.map((d) => d.toString()).toList(),
          ['1', '1000003', '1000033', '1000036000099']);
    });
  });

  group('Teoría de números avanzada', () {
    test('5x ≡ 5 (mod 5): todas las clases son solución (antes crash)', () {
      final sols = NumberTheoryAdvancedService.solveLinearCongruence(
          BigInt.from(5), BigInt.from(5), BigInt.from(5));
      expect(sols, List.generate(5, BigInt.from));
    });

    test('discreteLog encuentra x < m aunque g no sea invertible', () {
      expect(
          NumberTheoryAdvancedService.discreteLog(
              BigInt.two, BigInt.from(4), BigInt.from(8)),
          BigInt.two);
    });
  });

  group('Complex.pow', () {
    test('0^(-1) lanza división por cero en vez de Infinity/NaN', () {
      expect(() => Complex.zero.pow(-1), throwsA(isA<CalcException>()));
    });
  });

  group('Parsers estrictos', () {
    test('polinomio con signo suelto es inválido, no constante ±1', () {
      expect(() => PolynomialService.parse('3--2'),
          throwsA(isA<CalcException>()));
      expect(() => PolynomialService.parse('5-'),
          throwsA(isA<CalcException>()));
      // Los signos pegados a x siguen funcionando
      expect(PolynomialService.parse('-x+1').toString(), isNotEmpty);
    });

    test('Fraction rechaza signos incrustados y "."', () {
      expect(() => Fraction.parse('5.-5'), throwsA(isA<CalcException>()));
      expect(() => Fraction.parse('--5.0'), throwsA(isA<CalcException>()));
      expect(() => Fraction.parse('.'), throwsA(isA<CalcException>()));
      expect(Fraction.parse('-3.25').toString(), '-13/4');
    });
  });

  group('CalculusService.integral', () {
    test('n inválido se corrige en vez de devolver NaN o un valor erróneo', () {
      expect(CalculusService.integral('x', 0, 1, n: -3), closeTo(0.5, 1e-9));
      expect(CalculusService.integral('x', 0, 1, n: 0), closeTo(0.5, 1e-9));
    });
  });
}
