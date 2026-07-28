import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/calc_exception.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/services/geometry_service.dart';

/// Covers the geometry functions that were previously unreachable from any
/// screen. Wiring them up turns their unguarded edge cases into real bugs, so
/// the guards are tested alongside the results.
void main() {
  BigInt bi(int n) => BigInt.from(n);

  group('cosineOfAngle', () {
    test('is exact for the 13-14-15 triangle', () {
      // cos A = (14² + 15² − 13²) / (2·14·15) = 252/420 = 3/5
      expect(GeometryService.cosineOfAngle(bi(13), bi(14), bi(15)),
          Fraction.parse('3/5'));
    });

    test('a right angle has cosine 0', () {
      // 3-4-5: the angle opposite 5 is right.
      expect(GeometryService.cosineOfAngle(bi(5), bi(3), bi(4)), Fraction.zero);
    });

    test('an obtuse angle has negative cosine', () {
      // 2-3-4: the angle opposite 4 is obtuse.
      expect(GeometryService.cosineOfAngle(bi(4), bi(2), bi(3)).isNegative,
          isTrue);
    });

    test('rejects a zero side instead of dividing by zero', () {
      expect(() => GeometryService.cosineOfAngle(bi(3), bi(0), bi(4)),
          throwsA(isA<CalcException>()
              .having((e) => e.code, 'code', CalcError.invalidTriangle)));
    });

    test('rejects lengths that cannot form a triangle', () {
      // 1-2-10 violates the triangle inequality; it used to return a
      // "cosine" far outside [-1, 1].
      expect(() => GeometryService.cosineOfAngle(bi(10), bi(1), bi(2)),
          throwsA(isA<CalcException>()
              .having((e) => e.code, 'code', CalcError.invalidTriangle)));
    });

    test('every cosine of a valid triangle lies in [-1, 1]', () {
      for (int a = 1; a <= 15; a++) {
        for (int b = a; b <= 15; b++) {
          for (int c = b; c <= 15; c++) {
            if (!GeometryService.isValidTriangle(bi(a), bi(b), bi(c))) continue;
            final cos =
                GeometryService.cosineOfAngle(bi(c), bi(a), bi(b)).toDouble();
            expect(cos, inInclusiveRange(-1.0, 1.0));
          }
        }
      }
    });
  });

  group('angleDegrees', () {
    test('the 3-4-5 triangle has a 90° angle', () {
      expect(GeometryService.angleDegrees(bi(5), bi(3), bi(4)),
          closeTo(90.0, 1e-9));
    });

    test('an equilateral triangle has 60° angles', () {
      expect(GeometryService.angleDegrees(bi(7), bi(7), bi(7)),
          closeTo(60.0, 1e-9));
    });

    test('the three angles add up to 180°', () {
      final total = GeometryService.angleDegrees(bi(13), bi(14), bi(15)) +
          GeometryService.angleDegrees(bi(14), bi(13), bi(15)) +
          GeometryService.angleDegrees(bi(15), bi(13), bi(14));
      expect(total, closeTo(180.0, 1e-9));
    });
  });

  group('sideFromLawOfSines', () {
    test('computes the side opposite the wanted angle', () {
      // 10/sin30° = 20, so the side opposite 90° is 20.
      expect(GeometryService.sideFromLawOfSines(10, 30, 90),
          closeTo(20.0, 1e-9));
      expect(GeometryService.sideFromLawOfSines(10, 30, 45),
          closeTo(20 * 0.7071067811865476, 1e-9));
    });

    test('rejects sin(0°) and sin(180°) instead of returning Infinity', () {
      // The unguarded division produced Infinity or NaN presented as a length.
      for (final bad in [0.0, 180.0, -30.0, 200.0]) {
        expect(
          () => GeometryService.sideFromLawOfSines(10, bad, 45),
          throwsA(isA<CalcException>()
              .having((e) => e.code, 'code', CalcError.invalidAngle)),
          reason: 'known angle $bad should be rejected',
        );
        expect(
          () => GeometryService.sideFromLawOfSines(10, 45, bad),
          throwsA(isA<CalcException>()
              .having((e) => e.code, 'code', CalcError.invalidAngle)),
          reason: 'wanted angle $bad should be rejected',
        );
      }
    });

    test('rejects angles that leave no room for a third', () {
      expect(
        () => GeometryService.sideFromLawOfSines(10, 120, 60),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.angleSumTooLarge)),
      );
    });

    test('rejects a non-positive side', () {
      expect(
        () => GeometryService.sideFromLawOfSines(0, 30, 45),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.needPositiveValue)),
      );
    });

    test('agrees with the law of cosines on a known triangle', () {
      // 13-14-15: the angle opposite 13 and the angle opposite 14.
      final angle13 = GeometryService.angleDegrees(bi(13), bi(14), bi(15));
      final angle14 = GeometryService.angleDegrees(bi(14), bi(13), bi(15));
      expect(GeometryService.sideFromLawOfSines(13, angle13, angle14),
          closeTo(14.0, 1e-6));
    });
  });

  group('allPythagoreanTriples', () {
    test('includes primitives and their multiples, sorted by hypotenuse', () {
      final list = GeometryService.allPythagoreanTriples(25);
      final asText = list.map((t) => '${t[0]},${t[1]},${t[2]}').toList();
      expect(asText, contains('3,4,5'));
      expect(asText, contains('6,8,10')); // multiple of 3-4-5
      expect(asText, contains('5,12,13'));
      expect(asText, contains('15,20,25'));
      // Sorted by hypotenuse.
      for (int i = 1; i < list.length; i++) {
        expect(list[i][2] >= list[i - 1][2], isTrue);
      }
      // Every entry really is a triple within the bound.
      for (final t in list) {
        expect(t[0] * t[0] + t[1] * t[1], t[2] * t[2]);
        expect(t[2] <= BigInt.from(25), isTrue);
      }
    });

    test('is bounded so it cannot lock up the UI', () {
      expect(
        () => GeometryService.allPythagoreanTriples(100000),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.inputTooLarge)),
      );
    });
  });

  group('heronianTriangles', () {
    test('finds the classic small Heronian triangles', () {
      final list = GeometryService.heronianTriangles(15);
      final asText = list.map((t) => t.toString()).toList();
      expect(asText, contains('(3, 4, 5)')); // area 6
      expect(asText, contains('(13, 14, 15)')); // area 84
      final t345 = list.firstWhere((t) => t.a == bi(3) && t.c == bi(5));
      expect(t345.area, bi(6));
      final t131415 = list.firstWhere((t) => t.a == bi(13));
      expect(t131415.area, bi(84));
    });

    test('every result really has integer sides, area and validity', () {
      for (final t in GeometryService.heronianTriangles(20)) {
        expect(GeometryService.isValidTriangle(t.a, t.b, t.c), isTrue);
        expect(t.a <= t.b && t.b <= t.c, isTrue);
        expect(t.area > BigInt.zero, isTrue);
        // 16·area² = (a+b+c)(−a+b+c)(a−b+c)(a+b−c)
        final s = t.a + t.b + t.c;
        final p = s *
            (-t.a + t.b + t.c) *
            (t.a - t.b + t.c) *
            (t.a + t.b - t.c);
        expect(BigInt.from(16) * t.area * t.area, p);
      }
    });

    test('is bounded: the search is cubic in the limit', () {
      expect(
        () => GeometryService.heronianTriangles(1000),
        throwsA(isA<CalcException>()
            .having((e) => e.code, 'code', CalcError.inputTooLarge)),
      );
    });

    test('toString stays language-neutral', () {
      // It used to embed the Spanish word "área", which would have leaked into
      // the English UI the moment this was displayed.
      expect(GeometryService.heronianTriangles(5).first.toString(),
          '(3, 4, 5)');
    });
  });
}
