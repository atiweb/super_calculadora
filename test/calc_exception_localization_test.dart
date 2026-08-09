import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/calc_exception.dart';
import 'package:super_calculadora/screens/olympiad/olympiad_strings.dart';

void main() {
  const es = OlympiadStrings('es');
  const en = OlympiadStrings('en');
  const pt = OlympiadStrings('pt');
  const fr = OlympiadStrings('fr');

  test('every CalcError code has a non-empty translation in every language', () {
    for (final code in CalcError.values) {
      final e = CalcException(code, {'value': 'foo', 'k': '2'});
      expect(es.errorText(e).isNotEmpty, true, reason: 'ES missing for $code');
      expect(en.errorText(e).isNotEmpty, true, reason: 'EN missing for $code');
      expect(pt.errorText(e).isNotEmpty, true, reason: 'PT missing for $code');
      expect(fr.errorText(e).isNotEmpty, true, reason: 'FR missing for $code');
    }
  });

  test('every CalcError code is actually translated into French', () {
    const sameInEnglish = <CalcError>{};
    for (final code in CalcError.values) {
      if (sameInEnglish.contains(code)) continue;
      final e = CalcException(code, {'value': 'foo', 'k': '2', 'max': '10'});
      expect(fr.errorText(e) == en.errorText(e), false,
          reason: 'FR falls back to EN for $code');
    }
  });

  test('French reaches the tool labels, not just the errors', () {
    expect(fr.title, "Outils d'Olympiades");
    expect(fr.catAlgebra, 'Algèbre');
    expect(fr.catFractions, 'Fractions');
    expect(fr.compute, 'Calculer');
  });

  test('French puts a space before the colon, other languages do not', () {
    expect(fr.colon, ' :');
    expect(es.colon, ':');
    expect(en.colon, ':');
    expect(pt.colon, ':');
  });

  test('every CalcError code is actually translated into Portuguese', () {
    // A missing `pt:` argument silently falls back to English, which is the
    // point of the design — but for a language that ships as complete, that
    // fallback would be a hole. Codes whose wording is identical in both
    // languages are listed so the check stays honest.
    const sameInEnglish = <CalcError>{};
    for (final code in CalcError.values) {
      if (sameInEnglish.contains(code)) continue;
      final e = CalcException(code, {'value': 'foo', 'k': '2', 'max': '10'});
      expect(pt.errorText(e) == en.errorText(e), false,
          reason: 'PT falls back to EN for $code');
    }
  });

  test('a language with no translation falls back to English', () {
    // Deliberately a code that will never be a real translation: this test
    // used to name a plausible one and started failing the day that language
    // was actually added.
    const unknown = OlympiadStrings('zz');
    final e = CalcException(CalcError.divisionByZero);
    expect(unknown.errorText(e), en.errorText(e));
    expect(unknown.compute, en.compute);
  });

  test('Portuguese reaches the tool labels, not just the errors', () {
    expect(pt.title, 'Ferramentas de Olimpíada');
    expect(pt.catAlgebra, 'Álgebra');
    expect(pt.catFractions, 'Frações');
    expect(pt.compute, 'Calcular');
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
