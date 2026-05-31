// Regression tests for sign handling in BigDecimal.
//
// These lock in fixes for three classes of bugs that previously produced
// wrong results:
//   1. toString() dropped the sign when the integer part was 0  (-0.5 → "0.5")
//   2. addition left the integer and fractional parts with opposite signs
//      when the result crossed zero  (1.0 - 0.5 → "1.5")
//   3. multiplication/division mixed `~/` (truncating) with `%` (Euclidean),
//      corrupting negative results  ((-2.3) * 2 → "-4.4")

import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/big_decimal.dart';

BigDecimal d(String s) => BigDecimal.fromString(s);

void main() {
  group('toString preserves sign for |value| < 1', () {
    test('-0.5',  () => expect(d('-0.5').toString(),  '-0.5'));
    test('-0.25', () => expect(d('-0.25').toString(), '-0.25'));
    test('-0.001',() => expect(d('-0.001').toString(),'-0.001'));
    test('0.5',   () => expect(d('0.5').toString(),   '0.5'));
  });

  group('addition / subtraction across zero', () {
    test('1.0 - 0.5 = 0.5',     () => expect((d('1.0') - d('0.5')).toString(),  '0.5'));
    test('0.5 - 1.0 = -0.5',    () => expect((d('0.5') - d('1.0')).toString(),  '-0.5'));
    test('1.0 + (-0.5) = 0.5',  () => expect((d('1.0') + d('-0.5')).toString(), '0.5'));
    test('3.7 - 5 = -1.3',      () => expect((d('3.7') - d('5')).toString(),    '-1.3'));
    test('5 - 3.7 = 1.3',       () => expect((d('5') - d('3.7')).toString(),    '1.3'));
    test('10.5 + (-3.2) = 7.3', () => expect((d('10.5') + d('-3.2')).toString(),'7.3'));
    test('0.1 + 0.2 = 0.3',     () => expect((d('0.1') + d('0.2')).toString(),  '0.3'));
    test('1 - 2.68 = -1.68',    () => expect((d('1') - d('2.68')).toString(),   '-1.68'));
  });

  group('multiplication with negatives', () {
    test('(-2.3) * 2 = -4.6',    () => expect((d('-2.3') * d('2')).toString(),   '-4.6'));
    test('2.3 * (-2) = -4.6',    () => expect((d('2.3') * d('-2')).toString(),   '-4.6'));
    test('(-2.3) * (-2) = 4.6',  () => expect((d('-2.3') * d('-2')).toString(),  '4.6'));
    test('(-0.5) * 0.5 = -0.25', () => expect((d('-0.5') * d('0.5')).toString(), '-0.25'));
    test('2.5 * 2.5 = 6.25',     () => expect((d('2.5') * d('2.5')).toString(),  '6.25'));
  });

  group('division with negatives', () {
    test('(-6) / 4 = -1.5',  () => expect((d('-6') / d('4')).toString(),  '-1.5'));
    test('6 / (-4) = -1.5',  () => expect((d('6') / d('-4')).toString(),  '-1.5'));
    test('-100 / 8 = -12.5', () => expect((d('-100') / d('8')).toString(),'-12.5'));
    test('100 / 8 = 12.5',   () => expect((d('100') / d('8')).toString(), '12.5'));
  });

  group('toDouble round-trips small decimals exactly', () {
    test('-0.5',  () => expect(d('-0.5').toDouble(),  -0.5));
    test('3.2',   () => expect(d('3.2').toDouble(),   3.2));
    test('1.0 - 0.5', () => expect((d('1.0') - d('0.5')).toDouble(), 0.5));
  });

  group('comparison consistent after sign-crossing arithmetic', () {
    test('(1.0 - 0.5) == 0.5', () => expect((d('1.0') - d('0.5')) == d('0.5'), true));
    test('(0.5 - 1.0) == -0.5', () => expect((d('0.5') - d('1.0')) == d('-0.5'), true));
  });
}
