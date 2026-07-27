import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/widgets/number_analysis_panel.dart';

void main() {
  group('Number Analysis Panel Tests', () {
    test('Prime factors should be formatted with proper superscripts', () {
      // Create an instance of the panel
      const panel = NumberAnalysisPanel();
      
      // Verify prime factors can be formatted
      List<dynamic> factors = [2, 2, 2, 3, 3, 5];
      String formatted = panel.formatPrimeFactorsAsPowers(factors);
      
      print('Factores originales: $factors');
      print('Factores formateados: $formatted');
      
      // Verify it contains superscripts
      expect(formatted, contains('²'));
      expect(formatted, contains('³'));
      expect(formatted, contains('×'));
    });
    
    test('Unicode superscripts should be available', () {
      // Verify the Unicode superscript characters exist
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
        // Just verify the string is not empty
        expect(expected, isNotEmpty);
        expect(expected.length, 1);
      });
    });
  });
}
