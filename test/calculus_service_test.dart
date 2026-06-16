import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculus_service.dart';

void main() {
  group('derivative', () {
    test("d/dx x^2 at 3 = 6", () {
      expect(CalculusService.derivative('x^2', 3), closeTo(6, 1e-4));
    });
    test("d/dx sin(x) at 0 = 1", () {
      expect(CalculusService.derivative('sin(x)', 0), closeTo(1, 1e-6));
    });
    test("d/dx x^3 at 2 = 12", () {
      expect(CalculusService.derivative('x^3', 2), closeTo(12, 1e-3));
    });
  });

  group('definite integral', () {
    test('∫ x^2 dx [0,1] = 1/3', () {
      expect(CalculusService.integral('x^2', 0, 1), closeTo(1 / 3, 1e-6));
    });
    test('∫ x dx [0,2] = 2', () {
      expect(CalculusService.integral('x', 0, 2), closeTo(2, 1e-9));
    });
    test('∫ sin(x) dx [0,pi] = 2', () {
      expect(CalculusService.integral('sin(x)', 0, math.pi), closeTo(2, 1e-6));
    });
  });

  group('limit', () {
    test('sin(x)/x at 0 = 1', () {
      expect(CalculusService.limit('sin(x)/x', 0), closeTo(1, 1e-4));
    });
    test('(x^2-1)/(x-1) at 1 = 2 (removable)', () {
      final l = CalculusService.limit('(x^2-1)/(x-1)', 1);
      expect(l, isNotNull);
      expect(l!, closeTo(2, 1e-4));
    });
  });

  test('invalid expression throws', () {
    expect(() => CalculusService.derivative('x +* 2', 1), throwsA(anything));
  });
}
