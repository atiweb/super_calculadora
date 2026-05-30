// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:super_calculadora/main.dart';

void main() {
  testWidgets('Calculator basic functionality test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SuperCalculadoraApp());

    // Verify that we start with 0 in the display.
    expect(find.text('0'), findsAtLeastNWidgets(1));

    // Tap the '1' button.
    await tester.tap(find.text('1'));
    await tester.pump();

    // Verify the display shows '1'.
    expect(find.text('1'), findsAtLeastNWidgets(1));

    // Tap the '+' button.
    await tester.tap(find.text('+'));
    await tester.pump();

    // Tap the '2' button.
    await tester.tap(find.text('2'));
    await tester.pump();

    // Tap the '=' button.
    await tester.tap(find.text('='));
    await tester.pump();

    // Verify the result is '3'.
    expect(find.text('3'), findsAtLeastNWidgets(1));
  });
}
