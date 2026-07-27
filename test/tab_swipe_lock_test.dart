import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/screens/calculator_screen.dart';
import 'package:super_calculadora/widgets/calculator_keyboard.dart';

/// Regression from a tester's feedback: when typing numbers quickly, the taps
/// were interpreted as a horizontal drag of the tab PageView and the app
/// jumped tabs on its own. The fix disables the PageView's swipe
/// (tabs only change via the buttons), so its `physics` must be
/// NeverScrollableScrollPhysics.
Widget _wrap(Widget child) => ChangeNotifierProvider(
      create: (_) => CalculatorService(),
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );

void main() {
  testWidgets('El PageView de pestañas no permite swipe', (tester) async {
    tester.view.physicalSize = const Size(390, 840);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.devicePixelRatio = 1.0;
    });

    await tester.pumpWidget(_wrap(const CalculatorScreen()));
    await tester.pumpAndSettle();

    // Starts on the calculator keyboard.
    expect(find.byType(CalculatorKeyboard), findsOneWidget);

    // Swipe must be disabled so that fast typing doesn't switch
    // tabs; tabs only change via the buttons.
    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.physics, isA<NeverScrollableScrollPhysics>());
  });
}
