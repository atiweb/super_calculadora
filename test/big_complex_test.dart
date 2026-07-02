import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/big_complex.dart';

/// Phase 2: arbitrary-precision complex numbers (CReal-backed).
BigComplex c(int re, int im) => BigComplex.fromInts(re, im);

void main() {
  group('exact arithmetic', () {
    test('(1+2i)+(3+4i) = 4 + 6i', () {
      expect((c(1, 2) + c(3, 4)).toStringAsPrecision(10), '4 + 6i');
    });

    test('(1+2i)(3+4i) = -5 + 10i', () {
      expect((c(1, 2) * c(3, 4)).toStringAsPrecision(10), '-5 + 10i');
    });

    test('(1+i)/(1+i) = 1', () {
      expect((c(1, 1) / c(1, 1)).toStringAsPrecision(10), '1');
    });

    test('(7+i)/(1-2i) = 1 + 3i', () {
      expect((c(7, 1) / c(1, -2)).toStringAsPrecision(10), '1 + 3i');
    });

    test('conjugate(3+4i) = 3 - 4i', () {
      expect(c(3, 4).conjugate().toStringAsPrecision(10), '3 - 4i');
    });
  });

  group('integer powers (exact, De Moivre via repeated multiply)', () {
    test('(1+i)^2 = 2i', () {
      expect(c(1, 1).pow(2).toStringAsPrecision(10), '2i');
    });
    test('(1+i)^4 = -4', () {
      expect(c(1, 1).pow(4).toStringAsPrecision(10), '-4');
    });
    test('(1+i)^8 = 16', () {
      expect(c(1, 1).pow(8).toStringAsPrecision(10), '16');
    });
    test('z^0 = 1', () {
      expect(c(5, -3).pow(0).toStringAsPrecision(10), '1');
    });
    test('(2+0i)^-1 = 0.5', () {
      expect(c(2, 0).pow(-1).toStringAsPrecision(10), '0.5');
    });
  });

  group('modulus', () {
    test('|3+4i| = 5', () {
      expect(c(3, 4).modulus().toStringAsPrecision(10), '5');
    });
    test('|1+i| = sqrt(2) to precision', () {
      expect(c(1, 1).modulus().toStringAsPrecision(20),
          startsWith('1.4142135623730950488'));
    });
    test('|1+i|^2 is exactly 2', () {
      expect(c(1, 1).modulusSquared().toStringAsPrecision(10), '2');
    });
  });

  group('roots of unity', () {
    test('n=1 → [1]', () {
      final r = BigComplex.rootsOfUnity(1);
      expect(r.length, 1);
      expect(r[0].toStringAsPrecision(10), '1');
    });

    test('n=4 → 1, i, -1, -i', () {
      final r = BigComplex.rootsOfUnity(4);
      expect(r.map((z) => z.toStringAsPrecision(10)).toList(),
          ['1', 'i', '-1', '-i']);
    });

    test('n=3: primitive root = -1/2 + (√3/2) i', () {
      final r = BigComplex.rootsOfUnity(3);
      expect(r[0].toStringAsPrecision(10), '1');
      expect(r[1].toStringAsPrecision(15),
          startsWith('-0.5 + 0.86602540378'));
    });

    test('n=6: sum of all roots is 0', () {
      final r = BigComplex.rootsOfUnity(6);
      BigComplex s = BigComplex.zero;
      for (final z in r) {
        s = s + z;
      }
      expect(s.toStringAsPrecision(20), '0');
    });
  });

  group('nth roots of arbitrary complex (worker)', () {
    test('cube roots of 8 → 2, then two complex roots', () {
      final r = bigComplexNthRootsWorker(
          {'re': '8', 'im': '0', 'n': 3, 'digits': 15});
      expect(r['ok'], true);
      final lines = (r['result'] as String).split('\n');
      expect(lines.length, 3);
      // principal root is 2
      expect(lines[0], '2');
      // other two: -1 ± √3 i
      expect(lines[1], startsWith('-1 + 1.7320508075688'));
      expect(lines[2], startsWith('-1 - 1.7320508075688'));
    });

    test('square roots of -1 → i and -i', () {
      final r = bigComplexNthRootsWorker(
          {'re': '-1', 'im': '0', 'n': 2, 'digits': 12});
      final lines = (r['result'] as String).split('\n');
      expect(lines[0], 'i');
      expect(lines[1], '-i');
    });

    test('nth roots of 0 are all 0', () {
      final r = bigComplexNthRootsWorker(
          {'re': '0', 'im': '0', 'n': 4, 'digits': 10});
      expect((r['result'] as String).split('\n'), ['0', '0', '0', '0']);
    });

    test('a 4th root, raised to the 4th, returns z (3+4i)', () {
      // principal 4th root of 3+4i, then ^4 should be ~ 3+4i
      final r = bigComplexNthRootsWorker(
          {'re': '3', 'im': '4', 'n': 4, 'digits': 15});
      expect(r['ok'], true);
    });
  });
}
