import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Regression tests for the "operator dropped when display is 0" bug found
/// during emulator testing: 0×5 wrongly returned 5 (the leading 0 operand was
/// discarded). Operators ×, ÷, ^ must treat a displayed 0 as a real operand.
void main() {
  setUpAll(() => TestWidgetsFlutterBinding.ensureInitialized());

  late CalculatorService calc;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    calc = CalculatorService();
  });

  Future<String> eval(void Function() build) async {
    build();
    calc.calculate();
    // calculate() may run async work for heavy ops; these are all light.
    return calc.display;
  }

  test('0 × 5 = 0 (not 5)', () async {
    expect(
        await eval(() {
          calc.addDigit('0');
          calc.addOperator('×');
          calc.addDigit('5');
        }),
        '0');
  });

  test('0 ÷ 5 = 0 (not 5)', () async {
    expect(
        await eval(() {
          calc.addDigit('0');
          calc.addOperator('÷');
          calc.addDigit('5');
        }),
        '0');
  });

  test('0 ^ 3 = 0 (not 3)', () async {
    expect(
        await eval(() {
          calc.addDigit('0');
          calc.addOperator('^');
          calc.addDigit('3');
        }),
        '0');
  });

  test('0 ^ 0 = 1 (conventional)', () async {
    expect(
        await eval(() {
          calc.addDigit('0');
          calc.addOperator('^');
          calc.addDigit('0');
        }),
        '1');
  });

  test('non-zero base still works: 2 ^ 3 = 8', () async {
    expect(
        await eval(() {
          calc.addDigit('2');
          calc.addOperator('^');
          calc.addDigit('3');
        }),
        '8');
  });

  test('0 - 7 = -7 (minus still starts a negative number)', () async {
    expect(
        await eval(() {
          calc.addDigit('0');
          calc.addOperator('-');
          calc.addDigit('7');
        }),
        '-7');
  });

  test('sqrt of a negative number reports the localized key, no leak',
      () async {
    calc.addDigit('5');
    calc.toggleSign();
    await calc.squareRoot();
    expect(calc.errorMessage, 'errNegativeSqrt');
    // Must not leak the raw Dart exception text.
    expect(calc.errorMessage.contains('Invalid argument'), isFalse);
  });

  // tan poles: tan(90°), tan(270°)… are undefined. Floating-point rounding of
  // π makes math.tan return a huge finite number instead of Infinity, so we
  // detect the pole via the denominator (cos ≈ 0). General for every pole.
  group('tan poles report undefined (not a huge number)', () {
    test('tan(90°) is undefined', () async {
      calc.addDigit('9');
      calc.addDigit('0');
      await calc.tan();
      expect(calc.errorMessage, 'errTanUndefined');
    });

    test('tan(270°) is undefined', () async {
      calc.addDigit('2');
      calc.addDigit('7');
      calc.addDigit('0');
      await calc.tan();
      expect(calc.errorMessage, 'errTanUndefined');
    });

    test('tan(45°) = 1 (no false positive)', () async {
      calc.addDigit('4');
      calc.addDigit('5');
      await calc.tan();
      expect(calc.errorMessage, isEmpty);
      expect(double.parse(calc.display), closeTo(1.0, 1e-9));
    });

    test('tan(180°) = 0 (not flagged as a pole)', () async {
      calc.addDigit('1');
      calc.addDigit('8');
      calc.addDigit('0');
      await calc.tan();
      expect(calc.errorMessage, isEmpty);
      expect(double.parse(calc.display).abs(), lessThan(1e-9));
    });
  });
}
