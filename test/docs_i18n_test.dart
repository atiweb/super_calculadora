// Guards the structure of the published help page (docs/index.html).
//
// The page used to carry both languages inline, one <span> per language
// toggled by CSS. That does not scale past two, so every translatable string
// now carries a data-i18n key and the translations live in
// docs/i18n/<code>.js. Adding a language means dropping one file next to
// the others — these tests are what tell you whether that file is complete.
//
// Run with: flutter test test/docs_i18n_test.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final String html = File('docs/index.html').readAsStringSync();
  final List<String> keys = RegExp(r'data-i18n="([^"]+)"')
      .allMatches(html)
      .map((m) => m.group(1)!)
      .toList();

  List<File> languageFiles() => Directory('docs/i18n')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.js'))
      .toList();

  /// A language file is a JSON object wrapped in one `i18nRegister()` call —
  /// a plain .json could not be loaded when the page is opened from disk,
  /// because browsers block fetch() for local files.
  Map<String, String> read(File f) {
    final String src = f.readAsStringSync();
    final Match? m =
        RegExp(r'i18nRegister\(\s*"[^"]+"\s*,\s*(\{.*\})\s*\);', dotAll: true)
            .firstMatch(src);
    expect(m, isNotNull, reason: '${f.path}: unexpected wrapper');
    return (jsonDecode(m!.group(1)!) as Map).cast<String, String>();
  }

  test('the page is keyed and every key is unique', () {
    expect(keys, isNotEmpty);
    expect(keys.toSet().length, keys.length,
        reason: 'a repeated data-i18n key would translate two different texts '
            'with the same string');
  });

  test('every language file covers exactly the keys the page uses', () {
    final files = languageFiles();
    expect(files, isNotEmpty, reason: 'docs/i18n has no translations');
    for (final f in files) {
      final Map<String, String> dict = read(f);
      expect(keys.toSet().difference(dict.keys.toSet()), isEmpty,
          reason: '${f.path}: untranslated keys');
      expect(dict.keys.toSet().difference(keys.toSet()), isEmpty,
          reason: '${f.path}: keys that no longer exist in the page');
    }
  });

  test('no translation is left empty', () {
    for (final f in languageFiles()) {
      read(f).forEach((k, v) {
        expect(v.trim(), isNotEmpty, reason: '${f.path}: "$k" is empty');
      });
    }
  });

  test('the English shipped inline matches i18n/en.js', () {
    // The inline text is what a visitor without JavaScript reads, and what
    // search engines index, so it must not drift from the file translators
    // actually edit.
    final Map<String, String> en = read(File('docs/i18n/en.js'));
    final RegExp element =
        RegExp(r'<(span|p|div|a)[^>]*data-i18n="([^"]+)"[^>]*>(.*?)</\1>',
            dotAll: true);

    // The page is stored with CRLF and JSON keeps plain \n, so compare the
    // text rather than the line endings.
    String lf(String? s) => (s ?? '').replaceAll('\r\n', '\n');

    int checked = 0;
    for (final m in element.allMatches(html)) {
      expect(lf(m.group(3)), lf(en[m.group(2)]),
          reason: 'inline English drifted from en.js at "${m.group(2)}"');
      checked++;
    }
    expect(checked, keys.length,
        reason: 'some keyed element was not matched — check its markup');
  });

  test('the old CSS-toggled scheme is gone', () {
    expect(html.contains('html[lang=es]'), false,
        reason: 'the per-language CSS rules should have been removed');
    expect(RegExp(r'class="[^"]*\b(en|es)(-blk)?\b').hasMatch(html), false,
        reason: 'a language-toggled element survived the migration');
  });
}
