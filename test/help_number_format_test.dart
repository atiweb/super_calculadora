import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The help text must write numbers the way the calculator does.
///
/// There is one decimal key and it types a dot; the display never prints a
/// comma and never groups thousands. Translations were written with the local
/// convention instead, so the Italian help said `⌊3,7⌋ = 3` — an example the
/// keypad cannot even produce — and `π(1.000.000) = 78.498`, where the dot
/// means "decimal point" everywhere else on screen.
void main() {
  final arbs = Directory('lib/l10n')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb'))
      .toList();

  /// Values that show a number the user types or reads on the display.
  const examples = <String>[
    'hlpDerangementEx3',
    'hlpFloorCeilEx1',
    'hlpFloorCeilEx2',
    'hlpGeoMeanEx2',
    'hlpHarmMeanEx1',
    'hlpHarmMeanEx2',
    'hlpQuadMeanEx1',
    'hlpQuadMeanEx2',
    'hlpHighPrecContent',
  ];

  Map<String, dynamic> read(File f) =>
      jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

  test('no example uses a comma as the decimal separator', () {
    // A comma between digits is fine as an argument separator — C(10,3),
    // mcm(2,4) — so only the keys that state a value are checked.
    final decimal = RegExp(r'\d,\d');
    for (final f in arbs) {
      final json = read(f);
      for (final key in examples) {
        final v = json[key] as String?;
        if (v == null) continue;
        expect(decimal.hasMatch(v), false,
            reason: '${f.uri.pathSegments.last} · $key writes a decimal comma, '
                'but the keypad only has a dot: "$v"');
      }
    }
  });

  test('each language names a parameter the same way everywhere', () {
    // The translation batches skipped every key whose Spanish already matched
    // the English, on the theory that it was a formula. "1 param" is not: the
    // Russian help ended up alternating "N парам." with "1 param". hlpGcdParams
    // is the reference — whatever word it uses must appear in all the others.
    for (final f in arbs) {
      final json = read(f);
      final reference = json['hlpGcdParams'] as String?;
      if (reference == null) continue;
      // The word right after the leading "N ", minus any plural or full stop.
      final token = RegExp(r'N\s+([^\s(]+)').firstMatch(reference)?.group(1);
      if (token == null) continue;
      final stem = token.replaceAll(RegExp(r'[.]$'), '').replaceAll(RegExp(r's$'), '');
      json.forEach((key, value) {
        if (!key.endsWith('Params') || value is! String) return;
        expect(value.contains(stem), true,
            reason: '${f.uri.pathSegments.last} · $key says "$value" but this '
                'language calls a parameter "$stem" (see hlpGcdParams)');
      });
    }
  });

  test('no help text groups thousands with a dot', () {
    // "78.498" reads as a decimal on a screen whose decimal separator is the
    // dot. English and Spanish use a comma and French and Russian a space,
    // neither of which collides.
    final grouped = RegExp(r'\d\.\d{3}(?!\d)');
    for (final f in arbs) {
      read(f).forEach((key, value) {
        if (key.startsWith('@') || value is! String) return;
        expect(grouped.hasMatch(value), false,
            reason: '${f.uri.pathSegments.last} · $key groups thousands with a '
                'dot, which the display uses as the decimal point: "$value"');
      });
    }
  });
}
