import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/models/matrix.dart';

Fraction f(int n, [int d = 1]) => Fraction(BigInt.from(n), BigInt.from(d));
Matrix mi(List<List<int>> d) => Matrix.fromInts(d);

void main() {
  group('determinant', () {
    test('2x2', () {
      expect(mi([[1, 2], [3, 4]]).determinant(), f(-2));
    });
    test('3x3', () {
      expect(mi([[6, 1, 1], [4, -2, 5], [2, 8, 7]]).determinant(), f(-306));
    });
    test('identity = 1', () {
      expect(Matrix.identity(4).determinant(), f(1));
    });
    test('singular = 0', () {
      expect(mi([[1, 2], [2, 4]]).determinant(), f(0));
    });
  });

  group('inverse', () {
    test('2x2 exact fractions', () {
      final inv = mi([[4, 7], [2, 6]]).inverse()!;
      // 1/10 * [[6,-7],[-2,4]]
      expect(inv.at(0, 0), f(6, 10));
      expect(inv.at(0, 1), f(-7, 10));
      expect(inv.at(1, 0), f(-2, 10));
      expect(inv.at(1, 1), f(4, 10));
    });
    test('A * A^-1 = I', () {
      final a = mi([[2, 1, 1], [1, 3, 2], [1, 0, 0]]);
      final prod = a * a.inverse()!;
      final id = Matrix.identity(3);
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          expect(prod.at(i, j), id.at(i, j));
        }
      }
    });
    test('singular → null', () {
      expect(mi([[1, 2], [2, 4]]).inverse(), isNull);
    });
  });

  group('multiply / transpose', () {
    test('multiply', () {
      final p = mi([[1, 2], [3, 4]]) * mi([[5, 6], [7, 8]]);
      expect(p.at(0, 0), f(19));
      expect(p.at(0, 1), f(22));
      expect(p.at(1, 0), f(43));
      expect(p.at(1, 1), f(50));
    });
    test('transpose', () {
      final t = mi([[1, 2, 3], [4, 5, 6]]).transpose();
      expect(t.rowCount, 3);
      expect(t.colCount, 2);
      expect(t.at(2, 1), f(6));
    });
  });

  group('solve / rank', () {
    test('solve 3x3 (exact fractions)', () {
      // 2x+y+z=1, x+2y+z=1, x+y+2z=1 → 1/4 each
      final a = mi([[2, 1, 1], [1, 2, 1], [1, 1, 2]]);
      final x = a.solve([f(1), f(1), f(1)])!;
      expect(x, [f(1, 4), f(1, 4), f(1, 4)]);
    });
    test('solve singular → null', () {
      final a = mi([[1, 2], [2, 4]]);
      expect(a.solve([f(1), f(2)]), isNull);
    });
    test('rank of rank-2 3x3', () {
      expect(mi([[1, 2, 3], [2, 4, 6], [1, 0, 1]]).rank(), 2);
    });
    test('rank full', () {
      expect(mi([[1, 0], [0, 1]]).rank(), 2);
    });
  });
}
