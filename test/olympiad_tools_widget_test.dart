import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/screens/olympiad/olympiad_tools_screen.dart';
import 'package:super_calculadora/screens/olympiad/olympiad_tool_screens.dart';

Widget _wrap(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  testWidgets('hub renders all 7 categories', (tester) async {
    await tester.pumpWidget(_wrap(const OlympiadToolsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Olympiad Tools'), findsOneWidget);
    expect(find.text('Fractions'), findsOneWidget);
    expect(find.text('Radicals'), findsOneWidget);
    expect(find.text('Geometry'), findsOneWidget);
    expect(find.text('Polynomials'), findsOneWidget);
    expect(find.text('Number Theory'), findsOneWidget);
    expect(find.text('Step by step'), findsOneWidget);
    expect(find.text('Complex & Sequences'), findsOneWidget);
  });

  testWidgets('tapping a category opens its tool screen', (tester) async {
    await tester.pumpWidget(_wrap(const OlympiadToolsScreen()));
    await tester.pumpAndSettle();

    // Fractions is at the top of the hub (no scrolling needed).
    await tester.tap(find.text('Fractions'));
    await tester.pumpAndSettle();

    // A fraction tool should now be present.
    expect(find.textContaining('Fraction arithmetic'), findsOneWidget);
  });

  testWidgets('surds tool computes √72 = 6√2', (tester) async {
    await tester.pumpWidget(_wrap(const SurdsToolScreen()));
    await tester.pumpAndSettle();

    // First tool "Simplify √n" has default n=72; tap its Compute button.
    final computeButtons = find.text('Compute');
    expect(computeButtons, findsWidgets);
    await tester.tap(computeButtons.first);
    await tester.pumpAndSettle();

    expect(find.text('6√2'), findsOneWidget);
  });

  testWidgets('invalid input surfaces an error', (tester) async {
    await tester.pumpWidget(_wrap(const SurdsToolScreen()));
    await tester.pumpAndSettle();

    // Clear the first field and enter garbage.
    final field = find.byType(TextField).first;
    await tester.enterText(field, 'abc');
    await tester.tap(find.text('Compute').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('Error'), findsOneWidget);
  });

  testWidgets('Spanish locale shows translated titles', (tester) async {
    await tester.pumpWidget(_wrap(const OlympiadToolsScreen(), locale: const Locale('es')));
    await tester.pumpAndSettle();

    expect(find.text('Herramientas de Olimpiada'), findsOneWidget);
    expect(find.text('Fracciones'), findsOneWidget);
  });
}
