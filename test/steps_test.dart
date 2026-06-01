import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/steps_service.dart';

BigInt bi(int n) => BigInt.from(n);

void main() {
  group('euclidSteps', () {
    test('gcd(48,18) = 6', () {
      final r = StepsService.euclidSteps(bi(48), bi(18));
      expect(r.result, '6');
      expect(r.steps, isNotEmpty);
      expect(r.steps.any((s) => s.contains('48 = 2 · 18 + 12')), true);
    });
    test('Bézout identity holds', () {
      final r = StepsService.euclidSteps(bi(240), bi(46));
      // result is the gcd
      expect(r.result, '2');
      // a step states the Bézout identity
      expect(r.steps.any((s) => s.contains('Bézout')), true);
    });
    test('gcd(a,0) = a', () {
      final r = StepsService.euclidSteps(bi(7), bi(0));
      expect(r.result, '7');
    });
    test('coprime gcd = 1', () {
      final r = StepsService.euclidSteps(bi(17), bi(5));
      expect(r.result, '1');
    });
  });

  group('factorizationSteps', () {
    test('360 = 2^3 × 3^2 × 5', () {
      final r = StepsService.factorizationSteps(bi(360));
      expect(r.result, '2^3 × 3^2 × 5');
      expect(r.steps.any((s) => s.contains('360 ÷ 2')), true);
    });
    test('prime 13', () {
      final r = StepsService.factorizationSteps(bi(13));
      expect(r.result, '13');
    });
    test('17 × 17 = 289', () {
      final r = StepsService.factorizationSteps(bi(289));
      expect(r.result, '17^2');
    });
    test('n < 2', () {
      final r = StepsService.factorizationSteps(bi(1));
      expect(r.steps, isNotEmpty);
    });
  });

  group('crtSteps', () {
    test('x≡2(mod3), x≡3(mod5) → x≡8(mod15)', () {
      final r = StepsService.crtSteps([bi(2), bi(3)], [bi(3), bi(5)]);
      expect(r.result, 'x ≡ 8 (mod 15)');
      expect(r.steps, isNotEmpty);
    });
    test('three congruences', () {
      // x≡2(mod3), x≡3(mod5), x≡2(mod7) → x≡23(mod105)
      final r = StepsService.crtSteps([bi(2), bi(3), bi(2)], [bi(3), bi(5), bi(7)]);
      expect(r.result, 'x ≡ 23 (mod 105)');
    });
    test('incompatible system', () {
      // x≡1(mod2), x≡2(mod4) → incompatible
      final r = StepsService.crtSteps([bi(1), bi(2)], [bi(2), bi(4)]);
      expect(r.result, 'sin solución');
    });
  });
}
