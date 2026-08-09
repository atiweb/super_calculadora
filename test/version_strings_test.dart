import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The version appears twice in the UI — the About dialog (`appVersion`) and
/// the drawer subtitle (`navAboutSub`) — in every language. Both used to be
/// hand-edited, and the drawer one silently fell three releases behind
/// (it still said v1.0 while the app shipped as 1.2.1). This pins both to
/// pubspec.yaml so a release bump can't leave one of them behind again.
void main() {
  late final String version;

  setUpAll(() {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final m = RegExp(r'^version:\s*([0-9]+\.[0-9]+\.[0-9]+)', multiLine: true)
        .firstMatch(pubspec);
    expect(m, isNotNull, reason: 'no version: line in pubspec.yaml');
    version = m!.group(1)!;
  });

  test('every .arb states the pubspec version in both places', () {
    final arbs = Directory('lib/l10n')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb'))
        .toList();
    expect(arbs, isNotEmpty);

    for (final f in arbs) {
      final json =
          jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      final name = f.uri.pathSegments.last;

      final appVersion = json['appVersion'] as String?;
      expect(appVersion, isNotNull, reason: '$name has no appVersion');
      expect(appVersion, contains(version),
          reason: '$name: appVersion is "$appVersion", pubspec is $version');

      final navAboutSub = json['navAboutSub'] as String?;
      expect(navAboutSub, isNotNull, reason: '$name has no navAboutSub');
      expect(navAboutSub, contains('v$version'),
          reason: '$name: navAboutSub is "$navAboutSub", pubspec is $version');
    }
  });
}
