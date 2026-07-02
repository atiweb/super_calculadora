import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Regression for the ANR/freeze bug: `1.000634080395851 ^ 99999999` tried to
/// compute an exact ~1.5-billion-digit number on the main thread and hung the
/// UI. The feasibility guard must reject such powers INSTANTLY (and this test
/// completing at all proves there is no longer an infinite hang).
void main() {
  setUpAll(() => TestWidgetsFlutterBinding.ensureInitialized());

  late CalculatorService calc;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    calc = CalculatorService();
  });

  test('huge non-integer power is rejected instantly as too large', () {
    final r = calc.evaluateCompleteExpression('1.000634080395851^99999999');
    expect(r, 'err:errResultTooLarge');
  }, timeout: const Timeout(Duration(seconds: 5)));

  test('huge integer-base power also rejected (digit explosion)', () {
    final r = calc.evaluateCompleteExpression('123456^9999999');
    expect(r, 'err:errResultTooLarge');
  }, timeout: const Timeout(Duration(seconds: 5)));

  test('feasible power still computes exactly: 2^100', () {
    final r = calc.evaluateCompleteExpression('2^100');
    expect(r, '1267650600228229401496703205376');
  });

  test('feasible non-integer power still computes: 1.5^10', () {
    final r = calc.evaluateCompleteExpression('1.5^10');
    expect(r, '57.6650390625');
  });

  test('moderate large power within limit computes: 7^200 has 170 digits', () {
    final r = calc.evaluateCompleteExpression('7^200');
    expect(r.startsWith('err:'), isFalse);
    expect(r.replaceAll('.', '').length, greaterThan(160));
  });
}
