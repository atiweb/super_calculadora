import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/widgets/number_analysis_panel.dart';

void main() {
  group('Number Analysis Panel Tests', () {
    test('Prime factors should be formatted with proper superscripts', () {
      // Crear una instancia del panel
      const panel = NumberAnalysisPanel();
      
      // Verificar que se puede formatear factores primos
      List<dynamic> factors = [2, 2, 2, 3, 3, 5];
      String formatted = panel.formatPrimeFactorsAsPowers(factors);
      
      print('Factores originales: $factors');
      print('Factores formateados: $formatted');
      
      // Verificar que contiene superíndices
      expect(formatted, contains('²'));
      expect(formatted, contains('³'));
      expect(formatted, contains('×'));
    });
    
    test('Unicode superscripts should be available', () {
      // Verificar que los caracteres Unicode de superíndice existen
      const Map<int, String> expectedSuperscripts = {
        0: '⁰',
        1: '¹',
        2: '²',
        3: '³',
        4: '⁴',
        5: '⁵',
        6: '⁶',
        7: '⁷',
        8: '⁸',
        9: '⁹',
      };
      
      expectedSuperscripts.forEach((number, expected) {
        print('Número $number -> $expected');
        // Solo verificar que el string no está vacío
        expect(expected, isNotEmpty);
        expect(expected.length, 1);
      });
    });
  });
}
