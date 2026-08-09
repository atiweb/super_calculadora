import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/utils/app_locale.dart';

/// The five special-function keys whose spelling changes with the language.
///
/// They are shown on the keypad, in the pending-operation indicator, in the
/// history label and in the in-app guide. The keypad and the guide used to
/// carry their own `es ? 'MCD' : 'GCD'`, so a French user read "press PGCD"
/// in the guide and saw GCD on the key. These tests pin the four places to a
/// single definition.
void main() {
  tearDown(() => appLanguage = 'en');

  test('each language spells the keys its own way', () {
    const expected = {
      'es': ['MCD', 'MCM', 'Diof', 'TCR', 'ΣdígB'],
      'en': ['GCD', 'LCM', 'Dioph', 'CRT', 'ΣdigB'],
      'pt': ['MDC', 'MMC', 'Diof', 'TCR', 'ΣdígB'],
      'fr': ['PGCD', 'PPCM', 'Dioph', 'TRC', 'ΣchifB'],
      'it': ['MCD', 'mcm', 'Dioph', 'TCR', 'ΣcifB'],
    };
    expected.forEach((lang, symbols) {
      appLanguage = lang;
      expect([symGcd, symLcm, symDioph, symCrt, symDigitSumBase], symbols,
          reason: 'wrong key symbols for $lang');
    });
  });

  test('the mean keys match the wording each guide already uses', () {
    // The guide tells the reader to "press Moy A"; if the key still said
    // Med A there would be nothing on screen by that name. The .arb files
    // are the reference here — these are the spellings they contain.
    const expected = {
      'es': ['Med A', 'Med G', 'Med H', 'Med C'],
      'en': ['Med A', 'Med G', 'Med H', 'Med C'],
      'pt': ['Méd A', 'Méd G', 'Méd H', 'Méd Q'],
      'fr': ['Moy A', 'Moy G', 'Moy H', 'Moy Q'],
      'it': ['Med A', 'Med G', 'Med H', 'Med Q'],
    };
    expected.forEach((lang, means) {
      appLanguage = lang;
      expect([symMeanA, symMeanG, symMeanH, symMeanQ], means,
          reason: 'wrong mean keys for $lang');
    });
  });

  test('every mean key is named in its own help text', () {
    // Catches the drift directly: the key label must appear verbatim in the
    // .arb of the same language.
    for (final lang in ['es', 'en', 'pt', 'fr', 'it']) {
      appLanguage = lang;
      final arb = File('lib/l10n/app_$lang.arb').readAsStringSync();
      for (final key in [symMeanA, symMeanG, symMeanH, symMeanQ]) {
        expect(arb.contains(key), true,
            reason: '$lang: the guide never mentions the key "$key"');
      }
    }
  });

  test('an unknown language falls back to the English symbols', () {
    appLanguage = 'zz';
    expect([symGcd, symLcm, symCrt], ['GCD', 'LCM', 'CRT']);
  });

  test('no two-language ternary is left in the UI', () {
    // `es ? 'X' : 'Y'` cannot express a third language, so it silently shows
    // English to everyone else. That is how the keypad drifted away from the
    // guide; the whole app now goes through trLang/pick instead.
    final offenders = <String>[];
    for (final f in Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      // Comments are stripped so the doc comment that explains this rule
      // (in app_locale.dart, which quotes the pattern) does not trip it.
      final src = f
          .readAsStringSync()
          .split('\n')
          .where((l) => !l.trimLeft().startsWith('//'))
          .join('\n');
      if (RegExp("es \\? '").hasMatch(src)) offenders.add(f.path);
    }
    expect(offenders, isEmpty,
        reason: 'two-language ternaries left: $offenders');
  });
}
