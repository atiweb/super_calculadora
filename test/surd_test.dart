import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/models/surd.dart';
import 'package:super_calculadora/services/surd_service.dart';

BigInt bi(int n) => BigInt.from(n);
Fraction fr(int n, int d) => Fraction(BigInt.from(n), BigInt.from(d));

void main() {
  group('Surd simplification (√)', () {
    test('√72 = 6√2', () => expect(Surd.sqrt(bi(72)).toString(), '6√2'));
    test('√12 = 2√3', () => expect(Surd.sqrt(bi(12)).toString(), '2√3'));
    test('√2 stays √2', () => expect(Surd.sqrt(bi(2)).toString(), '√2'));
    test('√16 = 4 (perfect square → rational)', () {
      final s = Surd.sqrt(bi(16));
      expect(s.toString(), '4');
      expect(s.isRational, true);
    });
    test('√1 = 1', () => expect(Surd.sqrt(bi(1)).toString(), '1'));
    test('√0 = 0', () => expect(Surd.sqrt(bi(0)).toString(), '0'));
    test('√480 = 4√30', () => expect(Surd.sqrt(bi(480)).toString(), '4√30'));
    test('negative radicand throws', () =>
        expect(() => Surd.sqrt(bi(-4)), throwsArgumentError));
  });

  group('Surd with fractional coefficient', () {
    test('(1/2)√12 = √3', () => expect(Surd(fr(1, 2), bi(12)).toString(), '√3'));
    test('(1/3)√2 stays', () => expect(Surd(fr(1, 3), bi(2)).toString(), '√2/3'));
    test('(2/3)√18 = 2√2', () => expect(Surd(fr(2, 3), bi(18)).toString(), '2√2'));
    test('-√2 formatting', () => expect(Surd(-Fraction.one, bi(2)).toString(), '-√2'));
  });

  group('Surd value & multiplication', () {
    test('√72 ≈ 8.485', () => expect((Surd.sqrt(bi(72)).toDouble() - 8.485281).abs() < 1e-5, true));
    test('√2 · √3 = √6', () => expect((Surd.sqrt(bi(2)) * Surd.sqrt(bi(3))).toString(), '√6'));
    test('√2 · √2 = 2', () => expect((Surd.sqrt(bi(2)) * Surd.sqrt(bi(2))).toString(), '2'));
    test('2√3 · √3 = 6', () => expect((Surd(Fraction.fromInt(2), bi(3)) * Surd.sqrt(bi(3))).toString(), '6'));
    test('0 · √5 = 0', () => expect((Surd.fromFraction(Fraction.zero) * Surd.sqrt(bi(5))).isZero, true));
  });

  group('simplifySqrt record', () {
    test('√72 → (6, 2)', () {
      final r = SurdService.simplifySqrt(bi(72));
      expect(r.coefficient, bi(6));
      expect(r.radicand, bi(2));
    });
  });

  group('simplifyNthRoot', () {
    test('³√54 = 3·³√2', () {
      final r = SurdService.simplifyNthRoot(bi(54), 3);
      expect(r.coefficient, bi(3));
      expect(r.radicand, bi(2));
    });
    test('³√27 = 3 (perfect cube)', () {
      final r = SurdService.simplifyNthRoot(bi(27), 3);
      expect(r.coefficient, bi(3));
      expect(r.radicand, bi(1));
    });
    test('⁴√32 = 2·⁴√2', () {
      final r = SurdService.simplifyNthRoot(bi(32), 4);
      expect(r.coefficient, bi(2));
      expect(r.radicand, bi(2));
    });
    test('³√-54 = -3·³√2 (odd index, negative)', () {
      final r = SurdService.simplifyNthRoot(bi(-54), 3);
      expect(r.coefficient, bi(-3));
      expect(r.radicand, bi(2));
    });
    test('even root of negative throws', () =>
        expect(() => SurdService.simplifyNthRoot(bi(-16), 2), throwsArgumentError));
    test('index < 2 throws', () =>
        expect(() => SurdService.simplifyNthRoot(bi(8), 1), throwsArgumentError));
  });

  group('rationalization', () {
    test('1/√2 = √2/2', () {
      final s = SurdService.rationalizeOverSqrt(Fraction.one, bi(2));
      expect(s.toString(), '√2/2');
    });
    test('3/√3 = √3', () {
      final s = SurdService.rationalizeOverSqrt(Fraction.fromInt(3), bi(3));
      expect(s.toString(), '√3');
    });
    test('1/(1+√2) = -1 + √2', () {
      // 1/(1+√2) = (1-√2)/(1-2) = (1-√2)/(-1) = -1 + √2
      final r = SurdService.rationalizeOverBinomial(Fraction.one, Fraction.one, bi(2));
      expect(r.rational, Fraction.fromInt(-1));
      expect(r.surd.toString(), '√2');
      // numeric sanity
      expect((r.rational.toDouble() + r.surd.toDouble() - 1 / (1 + 1.4142135)).abs() < 1e-5, true);
    });
    test('binomial with c²=d throws', () =>
        expect(() => SurdService.rationalizeOverBinomial(Fraction.one, Fraction.fromInt(2), bi(4)),
            throwsArgumentError));
  });
}
