import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/big_decimal.dart';

void main() {
  group('BigDecimal Square Root Tests', () {
    test('should calculate square root of numbers greater than 1', () {
      // Probar raíz cuadrada de 4
      BigDecimal four = BigDecimal.fromInt(4);
      BigDecimal sqrtFour = four.sqrt();
      expect(sqrtFour.toString(), contains('2'));
      
      // Probar raíz cuadrada de 9
      BigDecimal nine = BigDecimal.fromInt(9);
      BigDecimal sqrtNine = nine.sqrt();
      expect(sqrtNine.toString(), contains('3'));
      
      // Probar raíz cuadrada de 16
      BigDecimal sixteen = BigDecimal.fromInt(16);
      BigDecimal sqrtSixteen = sixteen.sqrt();
      expect(sqrtSixteen.toString(), contains('4'));
      
      // Probar raíz cuadrada de 25
      BigDecimal twentyFive = BigDecimal.fromInt(25);
      BigDecimal sqrtTwentyFive = twentyFive.sqrt();
      expect(sqrtTwentyFive.toString(), contains('5'));
      
      print('✓ Square root of 4: ${sqrtFour.toString()}');
      print('✓ Square root of 9: ${sqrtNine.toString()}');
      print('✓ Square root of 16: ${sqrtSixteen.toString()}');
      print('✓ Square root of 25: ${sqrtTwentyFive.toString()}');
    });
    
    test('should handle division operations correctly', () {
      // Probar división que podría causar escalas negativas
      BigDecimal big = BigDecimal.fromString('1000');
      BigDecimal small = BigDecimal.fromString('0.1');
      BigDecimal result = big / small;
      expect(result.toString(), contains('10000'));
      
      print('✓ Division 1000 / 0.1: ${result.toString()}');
    });
  });
}
