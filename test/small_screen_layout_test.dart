import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/widgets/calculator_keyboard.dart';
import 'package:super_calculadora/widgets/scientific_calculator_keyboard.dart';
import 'package:super_calculadora/widgets/special_calculator_keyboard.dart';

Widget _wrapWithProviders(Widget child) {
  return ChangeNotifierProvider(
    create: (_) => CalculatorService(),
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('Small-screen layout smoke tests', () {
    // Common tiny device sizes to catch overflow issues
    final sizes = <Size>[
      const Size(320, 480), // legacy small phone
      const Size(360, 640), // small Android
      const Size(375, 667), // iPhone 8 size
    ];

    testWidgets('Standard keyboard has no overflow on small screens', (tester) async {
      for (final s in sizes) {
        tester.view.physicalSize = Size(s.width, s.height) * tester.view.devicePixelRatio;
        tester.view.devicePixelRatio = 1.0; // stable
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.devicePixelRatio = 1.0;
        });

        await tester.pumpWidget(_wrapWithProviders(const CalculatorKeyboard()));
        await tester.pumpAndSettle();

        // Attempt a full layout; if there is a render overflow, test framework throws
        expect(find.byType(CalculatorKeyboard), findsOneWidget);
      }
    });

    testWidgets('Scientific keyboard has no overflow on small screens', (tester) async {
      for (final s in sizes) {
        tester.view.physicalSize = Size(s.width, s.height) * tester.view.devicePixelRatio;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.devicePixelRatio = 1.0;
        });

        await tester.pumpWidget(_wrapWithProviders(const ScientificCalculatorKeyboard()));
        await tester.pumpAndSettle();
        expect(find.byType(ScientificCalculatorKeyboard), findsOneWidget);
      }
    });

    testWidgets('Special keyboard has no overflow on small screens', (tester) async {
      for (final s in sizes) {
        tester.view.physicalSize = Size(s.width, s.height) * tester.view.devicePixelRatio;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.devicePixelRatio = 1.0;
        });

        await tester.pumpWidget(_wrapWithProviders(const SpecialCalculatorKeyboard()));
        await tester.pumpAndSettle();
        expect(find.byType(SpecialCalculatorKeyboard), findsOneWidget);
      }
    });

    // Optional golden tests (skipped by default to keep CI light)
    testWidgets('Goldens (optional) - standard keyboard', (tester) async {
      final s = const Size(360, 640);
      tester.view.physicalSize = s;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.devicePixelRatio = 1.0;
      });

      await tester.pumpWidget(_wrapWithProviders(const CalculatorKeyboard()));
      await tester.pumpAndSettle();
      // To enable, add flutter_goldens and compareWithGolden here.
      expect(find.byType(CalculatorKeyboard), findsOneWidget);
    }, skip: true);
  });
}
