import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/calc_exception.dart';
import 'package:super_calculadora/screens/olympiad/olympiad_strings.dart';

void main() {
  const es = OlympiadStrings(true);
  const en = OlympiadStrings(false);

  test('every CalcError code has a non-empty translation in both languages', () {
    for (final code in CalcError.values) {
      final e = CalcException(code, {'value': 'foo', 'k': '2'});
      expect(es.errorText(e).isNotEmpty, true, reason: 'ES missing for $code');
      expect(en.errorText(e).isNotEmpty, true, reason: 'EN missing for $code');
    }
  });

  test('translations differ between ES and EN for a representative sample', () {
    final samples = [
      CalcError.divisionByZero,
      CalcError.invalidTriangle,
      CalcError.perfectSquareD,
      CalcError.notQuadratic,
    ];
    for (final code in samples) {
      final e = CalcException(code);
      expect(es.errorText(e) != en.errorText(e), true, reason: 'same text for $code');
    }
  });

  test('argument interpolation works', () {
    final e = CalcException(CalcError.invalidInteger, {'value': 'abc'});
    expect(en.errorText(e).contains('abc'), true);
    expect(es.errorText(e).contains('abc'), true);
  });

  test('CalcException is an ArgumentError (back-compat)', () {
    expect(CalcException(CalcError.divisionByZero), isA<ArgumentError>());
  });
}
