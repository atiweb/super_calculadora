import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/complex.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/services/combinatorics_extra_service.dart';
import 'package:super_calculadora/services/sequence_service.dart';

BigInt bi(int n) => BigInt.from(n);

void main() {
  group('Complex arithmetic', () {
    test('(1+2i)+(3+4i) = 4+6i', () =>
        expect(const Complex(1, 2) + const Complex(3, 4), const Complex(4, 6)));
    test('(1+2i)(3+4i) = -5+10i', () {
      final r = const Complex(1, 2) * const Complex(3, 4);
      expect(r.approxEquals(const Complex(-5, 10)), true);
    });
    test('(1+2i)/(1+i) = 3/2 + 1/2 i', () {
      final r = const Complex(1, 2) / const Complex(1, 1);
      expect(r.approxEquals(const Complex(1.5, 0.5)), true);
    });
    test('conjugate', () => expect(const Complex(3, -4).conjugate(), const Complex(3, 4)));
    test('modulus of 3+4i = 5', () => expect(const Complex(3, 4).modulus, 5));
  });

  group('De Moivre & roots', () {
    test('i^2 = -1', () => expect(Complex.i.pow(2).approxEquals(const Complex(-1, 0)), true));
    test('i^4 = 1', () => expect(Complex.i.pow(4).approxEquals(Complex.one), true));
    test('(1+i)^8 = 16', () =>
        expect(const Complex(1, 1).pow(8).approxEquals(const Complex(16, 0)), true));
    test('cube roots of unity sum to 0', () {
      final roots = Complex.rootsOfUnity(3);
      final sum = roots.reduce((a, b) => a + b);
      expect(sum.approxEquals(Complex.zero), true);
    });
    test('rootsOfUnity(n) each has modulus 1', () {
      for (final r in Complex.rootsOfUnity(6)) {
        expect((r.modulus - 1).abs() < 1e-9, true);
      }
    });
    test('nthRoots: each root^n returns the original', () {
      final z = const Complex(3, 4);
      for (final r in z.nthRoots(3)) {
        expect(r.pow(3).approxEquals(z, 1e-6), true);
      }
    });
  });

  group('Pascal triangle', () {
    test('row 0 = [1]', () => expect(CombinatoricsExtraService.pascalRow(0), [bi(1)]));
    test('row 4 = [1,4,6,4,1]', () =>
        expect(CombinatoricsExtraService.pascalRow(4), [bi(1), bi(4), bi(6), bi(4), bi(1)]));
    test('row 6 = [1,6,15,20,15,6,1]', () => expect(
        CombinatoricsExtraService.pascalRow(6),
        [bi(1), bi(6), bi(15), bi(20), bi(15), bi(6), bi(1)]));
    test('row sums to 2^n', () {
      final row = CombinatoricsExtraService.pascalRow(10);
      final sum = row.reduce((a, b) => a + b);
      expect(sum, bi(1024));
    });
    test('triangle has n+1 rows', () =>
        expect(CombinatoricsExtraService.pascalTriangle(5).length, 6));
  });

  group('multinomial', () {
    test('multinomial(2,1) = 3', () =>
        expect(CombinatoricsExtraService.multinomial([2, 1]), bi(3)));
    test('multinomial(1,1,1) = 6', () =>
        expect(CombinatoricsExtraService.multinomial([1, 1, 1]), bi(6)));
    test('multinomial(2,2) = 6 (= C(4,2))', () =>
        expect(CombinatoricsExtraService.multinomial([2, 2]), bi(6)));
    test('MISSISSIPPI = 11!/(1!4!4!2!) = 34650', () =>
        expect(CombinatoricsExtraService.multinomial([1, 4, 4, 2]), bi(34650)));
  });

  group('linear recurrence', () {
    test('Fibonacci', () {
      final terms = SequenceService.linearRecurrenceInts([1, 1], [0, 1], 10);
      expect(terms.map((f) => f.toString()).toList(),
          ['0', '1', '1', '2', '3', '5', '8', '13', '21', '34']);
    });
    test('Lucas', () {
      final terms = SequenceService.linearRecurrenceInts([1, 1], [2, 1], 7);
      expect(terms.map((f) => f.toString()).toList(),
          ['2', '1', '3', '4', '7', '11', '18']);
    });
    test('Pell aₙ = 2aₙ₋₁ + aₙ₋₂', () {
      final terms = SequenceService.linearRecurrenceInts([2, 1], [0, 1], 6);
      expect(terms.map((f) => f.toString()).toList(),
          ['0', '1', '2', '5', '12', '29']);
    });
    test('rational recurrence', () {
      // aₙ = (1/2)aₙ₋₁, a₀ = 1 → 1, 1/2, 1/4, 1/8
      final terms = SequenceService.linearRecurrence(
        [Fraction(BigInt.one, BigInt.two)],
        [Fraction.one],
        4,
      );
      expect(terms.map((f) => f.toString()).toList(), ['1', '1/2', '1/4', '1/8']);
    });
    test('wrong initial count throws', () =>
        expect(() => SequenceService.linearRecurrenceInts([1, 1], [0], 5), throwsArgumentError));
  });
}
