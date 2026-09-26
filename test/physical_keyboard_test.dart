import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/screens/calculator_screen.dart';
import 'package:super_calculadora/services/calculator_service.dart';

/// The calculator screen answers the physical keyboard (Windows/web, or a
/// hardware keyboard on Android); before, only the expressions TextField did.
void main() {
  late CalculatorService calc;

  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    calc = CalculatorService();
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: calc,
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: CalculatorScreen(),
      ),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> type(WidgetTester tester, List<LogicalKeyboardKey> keys,
      {String? character}) async {
    for (final k in keys) {
      await tester.sendKeyEvent(k);
    }
    await tester.pump();
  }

  testWidgets('digits, operators and Enter compute', (tester) async {
    await pumpScreen(tester);
    await type(tester, [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.numpadMultiply,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.enter,
    ]);
    expect(calc.display, '36');
  });

  testWidgets('Backspace, Escape and numpad', (tester) async {
    await pumpScreen(tester);
    await type(tester, [
      LogicalKeyboardKey.numpad4,
      LogicalKeyboardKey.numpad5,
      LogicalKeyboardKey.backspace,
      LogicalKeyboardKey.numpadAdd,
      LogicalKeyboardKey.numpad2,
      LogicalKeyboardKey.numpadEnter,
    ]);
    expect(calc.display, '6');
    await type(tester, [LogicalKeyboardKey.escape]);
    expect(calc.display, '0');
  });

  testWidgets('system back on another tab returns to the keypad',
      (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.byIcon(Icons.analytics));
    await tester.pumpAndSettle();
    final dynamic state = tester.state(find.byType(CalculatorScreen));
    // Simulate the system back button.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(state.mounted, isTrue);
    expect(find.byIcon(Icons.calculate), findsOneWidget);
    // Keypad visible again: the digits work through the keyboard.
    await type(tester, [LogicalKeyboardKey.digit7]);
    expect(calc.display, '7');
  });
}
