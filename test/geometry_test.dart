import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/fraction.dart';
import 'package:super_calculadora/models/point.dart';
import 'package:super_calculadora/services/geometry_service.dart';

BigInt bi(int n) => BigInt.from(n);

void main() {
  group('triangle validity & type', () {
    test('3,4,5 is valid', () => expect(GeometryService.isValidTriangle(bi(3), bi(4), bi(5)), true));
    test('1,2,3 is degenerate (invalid)', () => expect(GeometryService.isValidTriangle(bi(1), bi(2), bi(3)), false));
    test('3,4,5 → escaleno, rectángulo', () {
      final t = GeometryService.triangleType(bi(3), bi(4), bi(5));
      expect(t.bySides, 'escaleno');
      expect(t.byAngles, 'rectángulo');
    });
    test('5,5,5 → equilátero, acutángulo', () {
      final t = GeometryService.triangleType(bi(5), bi(5), bi(5));
      expect(t.bySides, 'equilátero');
      expect(t.byAngles, 'acutángulo');
    });
    test('2,2,3 → isósceles, obtusángulo', () {
      final t = GeometryService.triangleType(bi(2), bi(2), bi(3));
      expect(t.bySides, 'isósceles');
      expect(t.byAngles, 'obtusángulo');
    });
  });

  group('Heron area (exact)', () {
    test('3,4,5 → 6', () => expect(GeometryService.heronArea(bi(3), bi(4), bi(5)).toString(), '6'));
    test('2,3,4 → 3√15/4', () => expect(GeometryService.heronArea(bi(2), bi(3), bi(4)).toString(), '3√15/4'));
    test('13,14,15 → 84', () => expect(GeometryService.heronArea(bi(13), bi(14), bi(15)).toString(), '84'));
    test('approx matches', () {
      final a = GeometryService.heronArea(bi(2), bi(3), bi(4)).toDouble();
      expect((a - GeometryService.heronAreaApprox(2, 3, 4)).abs() < 1e-9, true);
    });
    test('invalid triangle throws', () =>
        expect(() => GeometryService.heronArea(bi(1), bi(2), bi(3)), throwsArgumentError));
  });

  group('Heronian', () {
    test('3,4,5 is Heronian', () => expect(GeometryService.isHeronian(bi(3), bi(4), bi(5)), true));
    test('13,14,15 is Heronian', () => expect(GeometryService.isHeronian(bi(13), bi(14), bi(15)), true));
    test('2,3,4 is not Heronian', () => expect(GeometryService.isHeronian(bi(2), bi(3), bi(4)), false));
    test('list up to side 5 includes (3,4,5)', () {
      final list = GeometryService.heronianTriangles(5);
      final has345 = list.any((t) => t.a == bi(3) && t.b == bi(4) && t.c == bi(5) && t.area == bi(6));
      expect(has345, true);
    });
  });

  group('radii (exact)', () {
    test('R of 3,4,5 = 5/2', () => expect(GeometryService.circumradius(bi(3), bi(4), bi(5)).toString(), '5/2'));
    test('r of 3,4,5 = 1', () => expect(GeometryService.inradius(bi(3), bi(4), bi(5)).toString(), '1'));
    test('r of 13,14,15 = 4', () => expect(GeometryService.inradius(bi(13), bi(14), bi(15)).toString(), '4'));
    test('R of 13,14,15 = 65/8', () => expect(GeometryService.circumradius(bi(13), bi(14), bi(15)).toString(), '65/8'));
  });

  group('law of cosines (exact cosine)', () {
    test('right angle opposite 5 → cos 0', () =>
        expect(GeometryService.cosineOfAngle(bi(5), bi(3), bi(4)), Fraction.zero));
    test('equilateral cos = 1/2', () =>
        expect(GeometryService.cosineOfAngle(bi(5), bi(5), bi(5)).toString(), '1/2'));
    test('angle opposite 5 in 3,4,5 ≈ 90°', () =>
        expect((GeometryService.angleDegrees(bi(5), bi(3), bi(4)) - 90).abs() < 1e-9, true));
    test('equilateral angle ≈ 60°', () =>
        expect((GeometryService.angleDegrees(bi(5), bi(5), bi(5)) - 60).abs() < 1e-9, true));
  });

  group('law of sines', () {
    test('isósceles-like check', () {
      // triángulo con un lado 10 opuesto a 30°, buscar lado opuesto a 90°
      final s = GeometryService.sideFromLawOfSines(10, 30, 90);
      expect((s - 20).abs() < 1e-9, true); // 10/sin30 = 20 = lado/sin90
    });
  });

  group('shoelace area (exact)', () {
    test('unit square = 1', () {
      final area = GeometryService.shoelaceArea([
        Point.ints(0, 0), Point.ints(1, 0), Point.ints(1, 1), Point.ints(0, 1),
      ]);
      expect(area.toString(), '1');
    });
    test('triangle (0,0)(4,0)(0,3) = 6', () {
      final area = GeometryService.shoelaceArea([
        Point.ints(0, 0), Point.ints(4, 0), Point.ints(0, 3),
      ]);
      expect(area.toString(), '6');
    });
    test('clockwise order gives same (absolute) area', () {
      final area = GeometryService.shoelaceArea([
        Point.ints(0, 0), Point.ints(0, 3), Point.ints(4, 0),
      ]);
      expect(area.toString(), '6');
    });
    test('rational coordinates exact: triangle area 1/2', () {
      final area = GeometryService.shoelaceArea([
        Point(Fraction.zero, Fraction.zero),
        Point(Fraction.one, Fraction.zero),
        Point(Fraction.zero, Fraction.one),
      ]);
      expect(area.toString(), '1/2');
    });
    test('fewer than 3 vertices throws', () =>
        expect(() => GeometryService.shoelaceArea([Point.ints(0, 0), Point.ints(1, 1)]),
            throwsArgumentError));
  });

  group('Pythagorean triples', () {
    test('primitives up to 30 hypotenuse', () {
      final list = GeometryService.primitivePythagoreanTriples(30);
      final asStr = list.map((t) => '${t[0]},${t[1]},${t[2]}').toList();
      expect(asStr.contains('3,4,5'), true);
      expect(asStr.contains('5,12,13'), true);
      expect(asStr.contains('8,15,17'), true);
      expect(asStr.contains('20,21,29'), true);
      // 6,8,10 is NOT primitive
      expect(asStr.contains('6,8,10'), false);
    });
    test('all triples include non-primitive 6,8,10', () {
      final list = GeometryService.allPythagoreanTriples(15);
      final asStr = list.map((t) => '${t[0]},${t[1]},${t[2]}').toList();
      expect(asStr.contains('3,4,5'), true);
      expect(asStr.contains('6,8,10'), true);
      expect(asStr.contains('9,12,15'), true);
    });
    test('all triples satisfy a²+b²=c²', () {
      for (final t in GeometryService.allPythagoreanTriples(50)) {
        expect(t[0] * t[0] + t[1] * t[1], t[2] * t[2]);
      }
    });
  });

  group('Point distance', () {
    test('distanceSquared exact', () =>
        expect(Point.ints(0, 0).distanceSquaredTo(Point.ints(3, 4)).toString(), '25'));
    test('distance', () =>
        expect((Point.ints(0, 0).distanceTo(Point.ints(3, 4)) - 5).abs() < 1e-12, true));
  });
}
