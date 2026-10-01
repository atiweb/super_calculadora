import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/screens/special_functions_help_screen.dart';

/// The help screen in every language at a 360-dp phone width. A section
/// header was a bare Text in a Row, so the 1.4 header "Keypad, expressions
/// and your own functions" overflowed by 132 px on the emulator. The view is
/// made very tall so the ListView builds every section, not only the first
/// screenful.
void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('help screen lays out without overflow in ${locale.languageCode}',
        (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(360, 40000);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SpecialFunctionsHelpScreen(),
      ));
      await tester.pumpAndSettle();

      final l = AppLocalizations.of(
          tester.element(find.byType(SpecialFunctionsHelpScreen)))!;
      expect(find.text(l.hlpUsageHeader), findsOneWidget);
      expect(find.text(l.hlpWhatsNewTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
