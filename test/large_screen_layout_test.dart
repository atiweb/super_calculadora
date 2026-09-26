import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/models/calculator_config.dart';
import 'package:super_calculadora/screens/calculator_screen.dart';
import 'package:super_calculadora/services/calculator_service.dart';

/// targetSdk 36: on Android 16 tablets and unfolded foldables the portrait
/// lock is ignored, and on Windows the window is freely resizable. The
/// screen must lay out without overflow in those shapes too.
void main() {
  const sizes = <Size>[
    Size(1280, 800), // tablet landscape
    Size(900, 600), // small tablet / foldable landscape
    Size(840, 900), // unfolded foldable
    Size(340, 560), // Windows minimum window
  ];

  for (final type in CalculatorType.values) {
    for (final size in sizes) {
      testWidgets('${type.name} at ${size.width}x${size.height}',
          (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        final calc = CalculatorService()..setCalculatorType(type);
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
        expect(tester.takeException(), isNull);
      });
    }
  }
}
