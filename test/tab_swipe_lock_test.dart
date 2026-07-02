import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/screens/calculator_screen.dart';
import 'package:super_calculadora/widgets/calculator_keyboard.dart';

/// Regresión del feedback de un tester: al teclear números rápido, los toques
/// se interpretaban como arrastre horizontal del PageView de pestañas y la app
/// saltaba de pestaña sola. La corrección deshabilita el swipe del PageView
/// (las pestañas solo cambian con los botones), así que su `physics` debe ser
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

    // Arranca en el teclado de la calculadora.
    expect(find.byType(CalculatorKeyboard), findsOneWidget);

    // El swipe debe estar deshabilitado para que teclear rápido no cambie de
    // pestaña; las pestañas solo cambian mediante los botones.
    final pageView = tester.widget<PageView>(find.byType(PageView));
    expect(pageView.physics, isA<NeverScrollableScrollPhysics>());
  });
}
