import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/fraction.dart';

Fraction f(int n, int d) => Fraction(BigInt.from(n), BigInt.from(d));

void main() {
  group('construction & reduction', () {
    test('reduces to lowest terms', () {
      expect(f(2, 4).toString(), '1/2');
      expect(f(6, 3).toString(), '2');
      expect(f(100, 80).toString(), '5/4');
    });
    test('sign moved to numerator', () {
      expect(f(1, -2).toString(), '-1/2');
      expect(f(-1, -2).toString(), '1/2');
      expect(f(-3, 6).toString(), '-1/2');
    });
    test('zero is canonical 0/1', () {
      expect(f(0, 5).toString(), '0');
      expect(f(0, 5), Fraction.zero);
    });
    test('integer detection', () {
      expect(f(6, 3).isInteger, true);
      expect(f(1, 2).isInteger, false);
    });
    test('denominator zero throws', () {
      expect(() => Fraction(BigInt.one, BigInt.zero), throwsArgumentError);
    });
  });

  group('parsing', () {
    test('parse fraction', () => expect(Fraction.parse('3/4').toString(), '3/4'));
    test('parse negative fraction', () => expect(Fraction.parse('-6/8').toString(), '-3/4'));
    test('parse integer', () => expect(Fraction.parse('5').toString(), '5'));
    test('parse decimal', () => expect(Fraction.parse('0.25').toString(), '1/4'));
    test('fromDecimalString', () => expect(Fraction.fromDecimalString('-3.14').toString(), '-157/50'));
    test('fromDecimalString 0.1', () => expect(Fraction.fromDecimalString('0.1').toString(), '1/10'));
  });

  group('arithmetic', () {
    test('1/2 + 1/3 = 5/6', () => expect((f(1, 2) + f(1, 3)).toString(), '5/6'));
    test('1/2 - 1/3 = 1/6', () => expect((f(1, 2) - f(1, 3)).toString(), '1/6'));
    test('2/3 * 3/4 = 1/2', () => expect((f(2, 3) * f(3, 4)).toString(), '1/2'));
    test('2/3 / 4/9 = 3/2', () => expect((f(2, 3) / f(4, 9)).toString(), '3/2'));
    test('negation', () => expect((-f(3, 7)).toString(), '-3/7'));
    test('abs', () => expect(f(-3, 7).abs().toString(), '3/7'));
    test('reciprocal', () => expect(f(3, 7).reciprocal().toString(), '7/3'));
    test('division by zero throws', () => expect(() => f(1, 2) / Fraction.zero, throwsArgumentError));
    test('reciprocal of zero throws', () => expect(() => Fraction.zero.reciprocal(), throwsArgumentError));
  });

  group('power', () {
    test('(2/3)^3 = 8/27', () => expect(f(2, 3).pow(3).toString(), '8/27'));
    test('(2/3)^0 = 1', () => expect(f(2, 3).pow(0).toString(), '1'));
    test('(2/3)^-2 = 9/4', () => expect(f(2, 3).pow(-2).toString(), '9/4'));
    test('0^-1 throws', () => expect(() => Fraction.zero.pow(-1), throwsArgumentError));
  });

  group('comparison', () {
    test('1/3 < 1/2', () => expect(f(1, 3) < f(1, 2), true));
    test('2/4 == 1/2', () => expect(f(2, 4) == f(1, 2), true));
    test('-1/2 < 1/3', () => expect(f(-1, 2) < f(1, 3), true));
    test('3/2 >= 1', () => expect(f(3, 2) >= Fraction.one, true));
    test('equal fractions share hashCode', () =>
        expect(f(2, 4).hashCode, f(1, 2).hashCode));
  });

  group('rounding', () {
    test('floor', () {
      expect(f(7, 3).floor(), BigInt.from(2));
      expect(f(-7, 3).floor(), BigInt.from(-3));
      expect(f(6, 3).floor(), BigInt.from(2));
    });
    test('ceil', () {
      expect(f(7, 3).ceil(), BigInt.from(3));
      expect(f(-7, 3).ceil(), BigInt.from(-2));
      expect(f(6, 3).ceil(), BigInt.from(2));
    });
    test('round (half up)', () {
      expect(f(7, 3).round(), BigInt.from(2)); // 2.33 → 2
      expect(f(5, 3).round(), BigInt.from(2)); // 1.66 → 2
      expect(f(1, 2).round(), BigInt.from(1)); // 0.5 → 1
      expect(f(-1, 2).round(), BigInt.zero);   // -0.5 → 0 (half up)
    });
    test('truncate toward zero', () {
      expect(f(7, 3).truncate(), BigInt.from(2));
      expect(f(-7, 3).truncate(), BigInt.from(-2));
    });
  });

  group('formatting', () {
    test('toMixedString positive', () => expect(f(7, 3).toMixedString(), '2 1/3'));
    test('toMixedString negative', () => expect(f(-7, 3).toMixedString(), '-2 1/3'));
    test('toMixedString proper fraction', () => expect(f(1, 3).toMixedString(), '1/3'));
    test('toMixedString integer', () => expect(f(6, 3).toMixedString(), '2'));
    test('toDouble', () => expect(f(1, 4).toDouble(), 0.25));
  });

  group('mediant', () {
    test('1/2 mediant 1/3 = 2/5', () => expect(f(1, 2).mediant(f(1, 3)).toString(), '2/5'));
    test('0/1 mediant 1/1 = 1/2', () =>
        expect(Fraction.zero.mediant(Fraction.one).toString(), '1/2'));
  });
}
