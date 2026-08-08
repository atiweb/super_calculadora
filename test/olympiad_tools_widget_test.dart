import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/screens/olympiad/calc_tool.dart';
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
  testWidgets('hub renders every category', (tester) async {
    await tester.pumpWidget(_wrap(const OlympiadToolsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Olympiad Tools'), findsOneWidget);

    // The hub is taller than the viewport, so the cards near the bottom are
    // only built once they are scrolled into view.
    for (final title in const [
      'Fractions',
      'Radicals',
      'Geometry',
      'Polynomials',
      'Algebra',
      'Number Theory',
      'Step by step',
      'Complex & Sequences',
      'Statistics',
      'Matrices',
      'Calculus',
      'Practice',
    ]) {
      await tester.scrollUntilVisible(find.text(title), 100);
      expect(find.text(title), findsOneWidget, reason: title);
    }
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

  testWidgets('hub lists the Algebra category and opens it', (tester) async {
    await tester.pumpWidget(_wrap(const OlympiadToolsScreen()));
    await tester.pumpAndSettle();

    final algebra = find.text('Algebra');
    await tester.scrollUntilVisible(algebra, 100);
    await tester.tap(algebra);
    await tester.pumpAndSettle();

    expect(find.text('Expand and simplify'), findsOneWidget);
  });

  testWidgets('algebra tool expands (a+b+c)²', (tester) async {
    await tester.pumpWidget(_wrap(const AlgebraToolScreen()));
    await tester.pumpAndSettle();

    // The first tool ships with (a+b+c)^2 as its default input.
    await tester.tap(find.text('Compute').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('a² + 2ab + 2ac + b² + 2bc + c²'), findsOneWidget);
    expect(find.textContaining('symmetric'), findsOneWidget);
  });

  testWidgets('every algebra tool computes its own example', (tester) async {
    await tester.pumpWidget(_wrap(const AlgebraToolScreen()));
    await tester.pumpAndSettle();

    for (final title in const [
      'Expand and simplify',
      'Check identity',
      'Common factor',
      'Substitute / evaluate',
      'Coefficient of a monomial',
      'Partial derivative',
      'Notable products',
      'Binomial theorem (a+b)ⁿ',
    ]) {
      // Every TextField carries its own Scrollable, so the list has to be
      // named explicitly; it is the outermost one.
      await tester.scrollUntilVisible(find.text(title), 200,
          scrollable: find.byType(Scrollable).first);
      final card = find.ancestor(
          of: find.text(title), matching: find.byType(CalcTool));
      final button = find.descendant(of: card, matching: find.text('Compute'));
      // A visible title does not mean a visible button: the tap would land
      // below the fold and quietly do nothing.
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();

      // The shipped defaults must produce a result, never the error box.
      expect(find.descendant(of: card, matching: find.textContaining('Error')),
          findsNothing,
          reason: title);
      expect(find.descendant(of: card, matching: find.byIcon(Icons.copy)),
          findsOneWidget,
          reason: title);
    }
  });

  testWidgets('the result box can render glyphs monospace lacks',
      (tester) async {
    await tester.pumpWidget(_wrap(const AlgebraToolScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Compute').first);
    await tester.pumpAndSettle();

    // Android's monospace family has no ⁰⁵⁶⁷⁸⁹ and does not fall back on its
    // own: on the emulator every such exponent came out as a tofu box
    // (a¹⁰ → a¹□, 252a⁵b⁵ → 252a□b□), here and in the older tools.
    final result = tester.widget<SelectableText>(
        find.descendant(
            of: find.byType(CalcTool), matching: find.byType(SelectableText)));
    expect(result.style?.fontFamily, 'monospace');
    expect(result.style?.fontFamilyFallback, isNotEmpty);
  });

  testWidgets('a malformed number is reported, not silently computed',
      (tester) async {
    await tester.pumpWidget(_wrap(const AlgebraToolScreen()));
    await tester.pumpAndSettle();

    // "1.000.000" used to be read as 1.000 · 0.000 = 0.
    await tester.enterText(find.byType(TextField).first, '1.000.000');
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
