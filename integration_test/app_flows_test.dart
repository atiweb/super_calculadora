import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/main.dart' as app;
import 'package:super_calculadora/models/calculator_config.dart';
import 'package:super_calculadora/screens/olympiad/olympiad_tool_screens.dart';
import 'package:super_calculadora/screens/olympiad/olympiad_tools_screen.dart';
import 'package:super_calculadora/screens/olympiad/quiz_screen.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/settings_service.dart';

/// On-device flows for the behaviours the audit changed. These run against the
/// real app on a real Android device, so they cover what unit tests cannot:
/// the wiring between keyboards, screens and the service, and that no path
/// blocks the UI thread long enough to freeze.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await SettingsService.init();
  });

  /// Mounts the real app widget.
  ///
  /// pumpWidget, not app.main(): calling main() once per test left the earlier
  /// widget tree alive, so finders matched keys from a stale instance and taps
  /// landed on the wrong buttons ("12" plus a phantom "7187").
  Future<void> startApp(WidgetTester tester) async {
    await tester.pumpWidget(const app.SuperCalculadoraApp());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets, reason: 'app should have started');
  }

  /// Taps a keyboard key by its caption.
  ///
  /// Settling after every tap is what makes this reliable: with a short fixed
  /// pump the next tap could be delivered mid-rebuild and land on a different
  /// key, which silently typed digits instead of pressing LCM. No scrolling is
  /// needed — every key of both keyboards lays out within the viewport, and
  /// ensureVisible cannot help anyway because the tabs PageView above them is
  /// deliberately unscrollable.
  Future<void> key(WidgetTester tester, String label) async {
    final f = find.text(label);
    expect(f, findsWidgets, reason: 'key "$label" should exist');

    // The function area scrolls and clips. A key below its viewport still
    // reports a layout position, and that position overlaps the keypad drawn
    // underneath — so tapping "LCM" actually pressed the 7 key and the display
    // read 127187. Scroll it into the visible part before tapping.
    // Must be the scroller that actually contains the key: the display has one
    // of its own, and picking that instead scrolled the wrong thing.
    final scroller =
        find.ancestor(of: f.first, matching: find.byType(SingleChildScrollView));
    if (scroller.evaluate().isNotEmpty) {
      final Rect viewport = tester.getRect(scroller.first);
      for (int guard = 0; guard < 20; guard++) {
        final Rect r = tester.getRect(f.first);
        if (r.top >= viewport.top && r.bottom <= viewport.bottom) break;
        final double delta =
            r.bottom > viewport.bottom ? -(r.bottom - viewport.bottom + 24) : (viewport.top - r.top + 24);
        await tester.drag(scroller.first, Offset(0, delta));
        await tester.pumpAndSettle();
      }
    }

    await tester.tap(f.first, warnIfMissed: false);
    await tester.pumpAndSettle();
    // Advance past the multi-tap window. Without it, consecutive taps on the
    // same key land at the same position and timestamp and get coalesced, so
    // typing "999…" registered a single 9.
    await tester.pump(const Duration(milliseconds: 350));
  }

  Future<void> keys(WidgetTester tester, List<String> labels) async {
    for (final l in labels) {
      await key(tester, l);
    }
  }

  group('Special keyboard: variable-parameter operations', () {
    testWidgets('GCD flow "12 → GCD → 18 → = → GCD" gives 6, not 0',
        (tester) async {
      await startApp(tester);
      final calc = _service(tester);
      calc.setCalculatorType(CalculatorType.special);
      await tester.pumpAndSettle();

      await keys(tester, ['1', '2']);
      await key(tester, 'GCD');
      await keys(tester, ['1', '8']);
      await key(tester, '=');
      await key(tester, 'GCD');
      await tester.pumpAndSettle();

      // Pressing the key to solve used to append a phantom operand.
      expect(calc.display, '6');
    });

    testWidgets('LCM through the same flow gives 36', (tester) async {
      await startApp(tester);
      final calc = _service(tester);
      calc.setCalculatorType(CalculatorType.special);
      await tester.pumpAndSettle();

      await keys(tester, ['1', '2']);
      await key(tester, 'LCM');
      await keys(tester, ['1', '8']);
      await key(tester, '=');
      await key(tester, 'LCM');
      await tester.pumpAndSettle();

      expect(calc.display, '36');
    });
  });

  group('Special keyboard: heavy number theory does not freeze', () {
    testWidgets('phi of a 15-digit prime answers promptly', (tester) async {
      await startApp(tester);
      final calc = _service(tester);
      calc.setCalculatorType(CalculatorType.special);
      await tester.pumpAndSettle();

      // The operand goes in through the service: tapping the same digit key
      // repeatedly gets coalesced into one press by the gesture recognizer,
      // and what this test is about is the φ key, not typing. 999999999999989
      // used to cost about 26 s of frozen UI thread.
      calc.setDisplay('999999999999989');
      await tester.pumpAndSettle();
      expect(calc.display, '999999999999989');

      final sw = Stopwatch()..start();
      await key(tester, 'φ');
      await tester.pumpAndSettle();
      sw.stop();

      expect(calc.display, '999999999999988');
      expect(sw.elapsedMilliseconds, lessThan(5000),
          reason: 'phi of a large prime must not block the UI thread');
    });
  });

  group('Scientific keyboard', () {
    testWidgets('the mod key computes instead of erroring', (tester) async {
      await startApp(tester);
      final calc = _service(tester);
      calc.setCalculatorType(CalculatorType.scientific);
      await tester.pumpAndSettle();

      await keys(tester, ['1', '7']);
      await key(tester, 'mod');
      await key(tester, '5');
      await key(tester, '=');
      await tester.pumpAndSettle();

      expect(calc.hasError, isFalse, reason: 'mod used to fail to parse');
      expect(calc.display, '2');
    });
  });

  group('Olympiad geometry tools are reachable and compute', () {
    testWidgets('law of cosines and law of sines produce results',
        (tester) async {
      await tester.pumpWidget(_host(const GeometryToolScreen()));
      await tester.pumpAndSettle();

      expect(await _runTool(tester, 'law of cosines', ['13', '14', '15']),
          contains('cos = 3/5'));
      expect(await _runTool(tester, 'Law of sines', ['10', '30', '90']),
          contains('20.000000'));
    });

    testWidgets('an impossible triangle shows a localized error',
        (tester) async {
      await tester.pumpWidget(_host(const GeometryToolScreen()));
      await tester.pumpAndSettle();

      final out = await _runTool(tester, 'law of cosines', ['10', '1', '2']);
      expect(out.toLowerCase(), contains('triangle'));
    });

    testWidgets('the Heronian enumeration lists triangles with their area',
        (tester) async {
      await tester.pumpWidget(_host(const GeometryToolScreen()));
      await tester.pumpAndSettle();

      // Far enough down the list that the ListView has not built it yet.
      await tester.scrollUntilVisible(
        find.textContaining('Heronian triangles'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      final out = await _runTool(tester, 'Heronian triangles', ['15']);
      expect(out, contains('(3, 4, 5)'));
      expect(out, contains('area=6'));
    });
  });

  group('Practice tab clears the system navigation bar', () {
    testWidgets('bottom padding accounts for the real device inset',
        (tester) async {
      await tester.pumpWidget(_host(const QuizScreen()));
      await tester.pumpAndSettle();

      // The answer field autofocuses, and while the soft keyboard is up it
      // covers the navigation bar — MediaQuery padding is then legitimately
      // zero and Scaffold has already resized the body. The inset only has to
      // be cleared once the keyboard is down, so measure that state.
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final listView = tester.widget<ListView>(find.byType(ListView).first);
      final padding = listView.padding as EdgeInsets;
      final inset = tester.view.viewPadding.bottom / tester.view.devicePixelRatio;
      expect(inset, greaterThan(0),
          reason: 'device must actually have a system bar for this to mean anything');

      // Diego's report: the last row sat behind the phone's nav buttons.
      expect(padding.bottom, greaterThanOrEqualTo(16 + inset - 0.5),
          reason: 'bottom padding must clear the system inset of $inset');
    });

    testWidgets('the olympiad tool list clears it too', (tester) async {
      await tester.pumpWidget(_host(const OlympiadToolsScreen()));
      await tester.pumpAndSettle();

      final listView = tester.widget<ListView>(find.byType(ListView).first);
      final padding = listView.padding as EdgeInsets;
      final inset = tester.view.viewPadding.bottom / tester.view.devicePixelRatio;

      expect(padding.bottom, greaterThanOrEqualTo(16 + inset - 0.5));
    });
  });
}

// ── helpers ────────────────────────────────────────────────────────────────

CalculatorService _service(WidgetTester tester) =>
    tester.element(find.byType(MaterialApp).first).read<CalculatorService>();

Widget _host(Widget screen) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: screen,
    );

Future<String> _runTool(
    WidgetTester tester, String title, List<String> values) async {
  // The tool list is long and built lazily, so scroll until the title exists
  // before trying to reach its card.
  final titleFinder = find.textContaining(title);
  if (titleFinder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(titleFinder, 300,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
  }

  final card = find.ancestor(of: titleFinder, matching: find.byType(Card));
  expect(card, findsOneWidget, reason: 'tool "$title" should be on screen');

  await tester.ensureVisible(card);
  await tester.pumpAndSettle();

  final fields = find.descendant(of: card, matching: find.byType(TextField));
  for (int i = 0; i < values.length; i++) {
    await tester.enterText(fields.at(i), values[i]);
  }
  // Tap the caption: FilledButton.icon builds a private subclass that
  // find.byType(FilledButton) does not match.
  final compute = find.descendant(of: card, matching: find.text('Compute'));
  await tester.ensureVisible(compute);
  await tester.pumpAndSettle();
  await tester.tap(compute);
  await tester.pumpAndSettle();

  final result = find.descendant(of: card, matching: find.byType(SelectableText));
  if (result.evaluate().isNotEmpty) {
    return tester.widget<SelectableText>(result).data ?? '';
  }
  final errors = tester
      .widgetList<Text>(find.descendant(of: card, matching: find.byType(Text)))
      .map((t) => t.data ?? '')
      .where((t) => t.startsWith('Error'));
  return errors.isEmpty ? '' : errors.first;
}
