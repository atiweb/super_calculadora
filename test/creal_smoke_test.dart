import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/vendor/computable_reals/computable_reals.dart';

// Smoke test to validate the computable_reals API and behavior before building
// the high-precision layer on top of it.
CReal cr(num n) => CReal.from(n);

void main() {
  test('0.1 + 0.2 == 0.3 exactly (no float error)', () {
    final r = CReal.parse('0.1') + CReal.parse('0.2');
    expect(r.toStringAsPrecision(30), '0.3');
  });

  test('1/3 to 30 digits', () {
    final r = cr(1) / cr(3);
    expect(r.toStringAsPrecision(30), '0.333333333333333333333333333333');
  });

  test('sqrt(2) high precision', () {
    final r = cr(2).sqrt();
    expect(r.toStringAsPrecision(20, 10, true), '1.41421356237309504880');
  });

  test('sin(pi/6) = 0.5 (radians)', () {
    final r = (CReal.pi / cr(6)).sin();
    expect(r.toStringAsPrecision(20), '0.5');
  });

  test('cos(0) = 1', () {
    expect(cr(0).cos().toStringAsPrecision(10), '1');
  });

  test('tan(pi/4) = 1', () {
    final r = (CReal.pi / cr(4)).tan();
    expect(r.toStringAsPrecision(15), '1');
  });

  test('ln(e) = 1', () {
    expect(CReal.e.ln().toStringAsPrecision(20), '1');
  });

  test('ln of negative throws ArithmeticException', () {
    expect(() => cr(-5).ln().toStringAsPrecision(10),
        throwsA(isA<ArithmeticException>()));
  });

  test('tan(pi/2) does not return a finite value: throws (timeout/arith)', () {
    // cos(pi/2) == 0 constructively, so tan = sin/cos diverges.
    expect(() => (CReal.pi / cr(2)).tan().toStringAsPrecision(10),
        throwsA(anyOf(isA<TimeoutException>(), isA<ArithmeticException>())));
  }, timeout: const Timeout(Duration(seconds: 10)));
}
