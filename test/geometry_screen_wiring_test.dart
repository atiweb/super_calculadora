import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/screens/olympiad/olympiad_tool_screens.dart';

/// End-to-end wiring for the geometry functions that had no screen: the tools
/// must appear, compute, and surface a localized message on bad input rather
/// than a raw exception.
Widget _wrap(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
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

void main() {
  /// Runs the tool whose title contains [title] with the given field values.
  /// [computeLabel] is the button caption in the active language.
  Future<String> runTool(WidgetTester tester, String title, List<String> values,
      {String computeLabel = 'Compute'}) async {
    final card = find.ancestor(
      of: find.textContaining(title),
      matching: find.byType(Card),
    );
    expect(card, findsOneWidget, reason: 'tool "$title" should be on screen');

    final fields = find.descendant(of: card, matching: find.byType(TextField));
    for (int i = 0; i < values.length; i++) {
      await tester.enterText(fields.at(i), values[i]);
    }
    // Tap the caption: FilledButton.icon builds a private subclass, which
    // find.byType(FilledButton) does not match.
    await tester.tap(find.descendant(of: card, matching: find.text(computeLabel)));
    await tester.pumpAndSettle();

    final result = find.descendant(of: card, matching: find.byType(SelectableText));
    if (result.evaluate().isEmpty) {
      // No result box → the tool reported an error instead.
      final texts = tester
          .widgetList<Text>(find.descendant(of: card, matching: find.byType(Text)))
          .map((t) => t.data ?? '')
          .where((t) => t.startsWith('Error'));
      return texts.isEmpty ? '' : texts.first;
    }
    return tester.widget<SelectableText>(result).data ?? '';
  }

  setUp(() {
    // Tall surface so every tool card is laid out without clipping.
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('law of cosines tool reports the three angles', (tester) async {
    tester.view.physicalSize = const Size(500, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.devicePixelRatio = 1.0;
    });

    await tester.pumpWidget(_wrap(const GeometryToolScreen()));
    await tester.pumpAndSettle();

    final out = await runTool(tester, 'Triangle angles', ['13', '14', '15']);
    expect(out, contains('cos = 3/5'));
    expect(out, contains('A:'));
    expect(out, contains('B:'));
    expect(out, contains('C:'));
  });

  testWidgets('law of cosines rejects an impossible triangle with a message',
      (tester) async {
    tester.view.physicalSize = const Size(500, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.devicePixelRatio = 1.0;
    });

    await tester.pumpWidget(_wrap(const GeometryToolScreen()));
    await tester.pumpAndSettle();

    final out = await runTool(tester, 'Triangle angles', ['10', '1', '2']);
    expect(out, contains('Error'));
    expect(out.toLowerCase(), contains('triangle'));
  });

  testWidgets('law of sines computes and guards its angles', (tester) async {
    tester.view.physicalSize = const Size(500, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.devicePixelRatio = 1.0;
    });

    await tester.pumpWidget(_wrap(const GeometryToolScreen()));
    await tester.pumpAndSettle();

    final ok = await runTool(tester, 'Law of sines', ['10', '30', '90']);
    expect(ok, contains('20.000000'));

    // sin(0°) = 0 used to yield Infinity presented as a length.
    final bad = await runTool(tester, 'Law of sines', ['10', '0', '90']);
    expect(bad, contains('Error'));
    expect(bad, contains('180'));
  });

  testWidgets('the two enumeration tools list their results', (tester) async {
    tester.view.physicalSize = const Size(500, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.devicePixelRatio = 1.0;
    });

    await tester.pumpWidget(_wrap(const GeometryToolScreen()));
    await tester.pumpAndSettle();

    final triples = await runTool(tester, 'All Pythagorean triples', ['25']);
    expect(triples, contains('3, 4, 5'));
    expect(triples, contains('6, 8, 10'));
    expect(triples, contains('Total'));

    final heronian = await runTool(tester, 'Heronian triangles', ['15']);
    expect(heronian, contains('(3, 4, 5)'));
    expect(heronian, contains('area=6'));
    expect(heronian, contains('(13, 14, 15)'));
  });

  testWidgets('the new tools are localized in Spanish', (tester) async {
    tester.view.physicalSize = const Size(500, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.devicePixelRatio = 1.0;
    });

    await tester.pumpWidget(
        _wrap(const GeometryToolScreen(), locale: const Locale('es')));
    await tester.pumpAndSettle();

    expect(find.textContaining('ley del coseno'), findsOneWidget);
    expect(find.textContaining('Ley de los senos'), findsOneWidget);
    expect(find.textContaining('Todas las ternas'), findsOneWidget);
    expect(find.textContaining('Triángulos heronianos'), findsOneWidget);

    // And the Heronian label is translated, not the old hardcoded "área".
    final heronian = await runTool(tester, 'Triángulos heronianos', ['15'],
        computeLabel: 'Calcular');
    expect(heronian, contains('área=6'));
  });
}
