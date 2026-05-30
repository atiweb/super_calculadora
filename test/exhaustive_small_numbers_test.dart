import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/calculator_service.dart';

void main() {
  group('Exhaustive checks 1..100', () {
    late CalculatorService calc;
    setUp(() {
      calc = CalculatorService();
    });

    test('Square and sqrt roundtrip for 1..100', () async {
      for (int n = 1; n <= 100; n++) {
        calc.setDisplay(n.toString());
        await calc.power('2');
        final squared = calc.display;
        expect(squared, isNotEmpty);

        await calc.squareRoot();
        final sqrtBack = calc.display;
        // Allow minor formatting differences but value must start with n as integer
        expect(sqrtBack.split('.')[0], n.toString());
      }
    });

    test('Factorial for small n (1..12) matches BigInt product', () async {
      BigInt running = BigInt.one;
      for (int n = 1; n <= 12; n++) {
        running *= BigInt.from(n);
        calc.setDisplay(n.toString());
        await calc.factorial();
        expect(BigInt.parse(calc.display), running);
      }
    });

    test('GCD and LCM neighbours for 2..100', () async {
      for (int n = 2; n <= 100; n++) {
        // gcdFunction usa sistema pendiente variable: presionar función otra vez ejecuta
        calc.setDisplay(n.toString());
        calc.gcdFunction();
        calc.addDigit('${n - 1}');
        calc.gcdFunction(); // agrega param y ejecuta
        // GCD(n, n-1) siempre es 1
        expect(calc.display, '1');

        calc.setDisplay(n.toString());
        calc.lcmFunction();
        calc.addDigit('2');
        calc.lcmFunction(); // agrega param y ejecuta
        expect(BigInt.parse(calc.display) > BigInt.zero, isTrue);
      }
    });

    test('Trig functions formatting stable for small degrees', () async {
      // Use degrees by default
      for (final n in [0, 30, 45, 60, 90]) {
        calc.setDisplay(n.toString());
        await calc.sin();
        expect(calc.display, isNotEmpty);

        calc.setDisplay(n.toString());
        await calc.cos();
        expect(calc.display, isNotEmpty);
      }
    });
  });
}
