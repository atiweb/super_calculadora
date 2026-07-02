import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/settings_service.dart';
import 'package:super_calculadora/services/precision_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Phase 1: optional high-precision mode backed by constructive reals.
void main() {
  setUpAll(() => TestWidgetsFlutterBinding.ensureInitialized());

  late CalculatorService calc;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SettingsService.init();
    calc = CalculatorService();
  });

  group('PrecisionService (unit)', () {
    test('sqrt(2) to high precision (stable prefix)', () {
      final s = PrecisionService.sqrt('2', digits: 40);
      expect(s.startsWith('1.4142135623730950488016887242'), isTrue,
          reason: s);
      expect(s.length, greaterThan(35));
    });

    test('sin(30°) = 0.5 exactly', () {
      expect(PrecisionService.sin('30', degrees: true, digits: 40), '0.5');
    });

    test('cos(60°) = 0.5', () {
      expect(PrecisionService.cos('60', degrees: true, digits: 40), '0.5');
    });

    test('cbrt(-8) = -2 (sign-aware)', () {
      expect(PrecisionService.cbrt('-8', digits: 20), '-2');
    });

    test('cbrt(27) = 3', () {
      expect(PrecisionService.cbrt('27', digits: 20), '3');
    });

    test('cbrt(0) = 0', () {
      expect(PrecisionService.cbrt('0', digits: 20), '0');
    });

    test('tan(90°) throws PrecisionException(errTanUndefined)', () {
      expect(
          () => PrecisionService.tan('90', degrees: true, digits: 20),
          throwsA(isA<PrecisionException>()
              .having((e) => e.errorKey, 'errorKey', 'errTanUndefined')));
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('ln of negative throws PrecisionException(errLnDomain)', () {
      expect(
          () => PrecisionService.ln('-2', digits: 20),
          throwsA(isA<PrecisionException>()
              .having((e) => e.errorKey, 'errorKey', 'errLnDomain')));
    });

    test('precisionWorker dispatches and returns ok/result', () {
      final r = precisionWorker(
          {'op': 'sqrt', 'value': '2', 'degrees': false, 'digits': 20});
      expect(r['ok'], true);
      expect((r['result'] as String).startsWith('1.41421356'), isTrue);
    });

    test('precisionWorker returns errorKey on singularity', () {
      final r = precisionWorker(
          {'op': 'tan', 'value': '90', 'degrees': true, 'digits': 20});
      expect(r['ok'], false);
      expect(r['errorKey'], 'errTanUndefined');
    }, timeout: const Timeout(Duration(seconds: 10)));
  });

  group('CalculatorService routes to high precision when enabled', () {
    test('sqrt(2) shows many exact digits (not the ~15 of double)', () async {
      await SettingsService.setHighPrecisionMode(true);
      await SettingsService.setPrecisionDigits(30);
      calc.addDigit('2');
      await calc.squareRoot();
      expect(calc.errorMessage, isEmpty);
      expect(calc.display.startsWith('1.41421356237309504880'), isTrue,
          reason: calc.display);
      expect(calc.display.length, greaterThan(25));
    });

    test('sin(30°) = 0.5 in high precision', () async {
      await SettingsService.setHighPrecisionMode(true);
      calc.addDigit('3');
      calc.addDigit('0');
      await calc.sin();
      expect(calc.errorMessage, isEmpty);
      expect(calc.display, '0.5');
    });

    test('tan(90°) is undefined in high precision (pole guard)', () async {
      await SettingsService.setHighPrecisionMode(true);
      calc.addDigit('9');
      calc.addDigit('0');
      await calc.tan();
      expect(calc.errorMessage, 'errTanUndefined');
    });

    test('high precision yields more digits than the default path', () async {
      await SettingsService.setHighPrecisionMode(false);
      calc.addDigit('2');
      await calc.squareRoot();
      final off = calc.display;

      await SettingsService.setHighPrecisionMode(true);
      await SettingsService.setPrecisionDigits(60);
      calc.clear();
      calc.addDigit('2');
      await calc.squareRoot();
      final on = calc.display;

      expect(on.length, greaterThan(off.length), reason: 'on=$on off=$off');
      expect(on.startsWith('1.41421356237309504880'), isTrue);
    });
  });
}
