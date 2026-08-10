import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:super_calculadora/l10n/app_localizations.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/utils/app_locale.dart';
import 'package:super_calculadora/widgets/calculator_display.dart';

/// The pending-operation indicator must never truncate.
///
/// Its label is the instructions — "MDC(12, 18, _) [= acrescentar, MDC
/// resolver]" — and the Portuguese one runs 44 monospace characters, wider
/// than a 320dp screen. It used to be a single-line Text with an ellipsis,
/// which cut exactly the part that tells the user which keys to press next.
/// It now shrinks to fit instead, so the whole label is always legible.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() => appLanguage = 'en');

  Widget wrap(CalculatorService calc, {required double width}) {
    return ChangeNotifierProvider.value(
      value: calc,
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: SizedBox(width: width, child: const CalculatorDisplay()),
          ),
        ),
      ),
    );
  }

  testWidgets('the longest pending label survives a narrow display untrimmed',
      (tester) async {
    // Portuguese has the longest label of the eight languages.
    appLanguage = 'pt';
    final calc = CalculatorService();
    calc.addDigit('1');
    calc.addDigit('2');
    calc.gcdFunction();

    final label = calc.pendingDisplayLabel;
    expect(label, contains('['), reason: 'expected the variable-length hint');

    await tester.pumpWidget(wrap(calc, width: 240));
    await tester.pump();

    // Untruncated means the paragraph was laid out at the width the text
    // actually needs; with the old ellipsis it was clamped to the 240px box.
    final paragraph = tester.renderObject<RenderParagraph>(find.text(label));
    expect(
      paragraph.size.width,
      greaterThanOrEqualTo(paragraph.getMaxIntrinsicWidth(double.infinity) - 0.5),
      reason: 'the pending label was laid out narrower than its text, '
          'i.e. it got truncated: "$label"',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('a short label is not scaled on a normal display',
      (tester) async {
    final calc = CalculatorService();
    calc.addDigit('1');
    calc.addDigit('2');
    calc.gcdFunction();
    final label = calc.pendingDisplayLabel;

    await tester.pumpWidget(wrap(calc, width: 600));
    await tester.pump();

    // BoxFit.scaleDown must leave text that fits at its natural 13px: the
    // FittedBox reports no scaling transform when width is plentiful.
    final fitted = tester.renderObject<RenderFittedBox>(
      find.ancestor(of: find.text(label), matching: find.byType(FittedBox)),
    );
    expect(fitted.size.width, lessThan(600),
        reason: 'the pill should shrink-wrap its text, not fill the row');
    expect(tester.takeException(), isNull);
  });
}
