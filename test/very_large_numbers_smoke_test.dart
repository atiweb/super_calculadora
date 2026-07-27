import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';
import 'package:super_calculadora/services/big_decimal.dart';

void main() {
  group('Very large numbers smoke tests', () {
    test('Load and sqrt million and billion', () async {
      final calc = CalculatorService();

      for (final value in ['1000000', '1000000000', '1000000000000']) {
        calc.loadNumber(value);
        // square root should compute and not crash
        await calc.squareRoot();
        expect(calc.display.isNotEmpty, isTrue);

        // power back to 2 roughly recovers magnitude
        await calc.power('2');
        final original = BigDecimal.fromString(value);
        final roundtrip = BigDecimal.fromString(calc.display);

        // If value is a perfect square, expect exact equality
        final isPerfectSquare = () {
          final v = BigInt.parse(value);
          BigInt r = BigInt.from((BigDecimal.fromString(value).sqrt()).toDouble().floor());
          while (r * r < v) {
            r += BigInt.one;
          }
          while (r * r > v) {
            r -= BigInt.one;
          }
          return r * r == v;
        }();

        if (isPerfectSquare) {
          expect(roundtrip.toString(), original.toString());
        } else {
          // Relative error within 1e-9
          final diff = (roundtrip - original).abs();
          final rel = (diff / original).toDouble();
          expect(rel < 1e-9, isTrue, reason: 'relative error too large: $rel');
        }
      }
    });

    test('Special functions handle big integers (gcd/lcm, radical)', () async {
      final calc = CalculatorService();
      // gcdFunction uses the variable pending system: pressing the function again executes
      calc.loadNumber('1000000000');
      calc.gcdFunction(); // starts pending
      calc.addDigit('500');
      calc.gcdFunction(); // adds param and executes GCD(1000000000, 500)
      expect(calc.display, isNotEmpty);

      // lcmFunction uses the variable pending system
      calc.loadNumber('1000000000');
      calc.lcmFunction();
      calc.addDigit('7');
      calc.lcmFunction(); // adds param and executes
      expect(calc.display, isNotEmpty);

      calc.loadNumber('1234567891011121314151617');
      await calc.radical();
      expect(calc.display, isNotEmpty);
    });
  });
}
