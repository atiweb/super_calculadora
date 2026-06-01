import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  test('clearEntry (CE) clears the analysis panel', () {
    final svc = CalculatorService();

    // Build a number on the display.
    svc.addDigit('1');
    svc.addDigit('6');
    expect(svc.display, '16');

    // CE should reset the display AND not leave the previous analysis showing.
    svc.clearEntry();
    expect(svc.display, '0');
    expect(svc.currentAnalysis.isEmpty, true,
        reason: 'analysis should be cleared when the display returns to 0');
  });
}
