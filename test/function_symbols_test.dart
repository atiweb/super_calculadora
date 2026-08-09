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
