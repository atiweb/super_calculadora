import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/screens/olympiad/quiz_screen.dart';

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
  testWidgets('quiz shows a problem and a Check button', (tester) async {
    await tester.pumpWidget(_wrap(const QuizScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Check'), findsOneWidget);
    expect(find.text('Score: 0 / 0'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('wrong answer increments total but not the score, then Next advances',
      (tester) async {
    await tester.pumpWidget(_wrap(const QuizScreen()));
    await tester.pumpAndSettle();

    // Enter an answer guaranteed wrong (answers are numeric; this is non-numeric).
    await tester.enterText(find.byType(TextField), 'definitely-wrong');
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text('Score: 0 / 1'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Back to an answerable state.
    expect(find.text('Check'), findsOneWidget);
    expect(find.text('Score: 0 / 1'), findsOneWidget);
  });

  testWidgets('Spanish locale shows translated chrome', (tester) async {
    await tester.pumpWidget(_wrap(const QuizScreen(), locale: const Locale('es')));
    await tester.pumpAndSettle();

    expect(find.text('Comprobar'), findsOneWidget);
    expect(find.text('Puntaje: 0 / 0'), findsOneWidget);
  });
}
