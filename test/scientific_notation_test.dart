import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/settings_service.dart';

void main() {
  group('Scientific Notation Settings Tests', () {
    test('SettingsService should return correct scientific notation preference', () {
      // Verify the setting can be read
      bool useScientific = SettingsService.getUseScientificNotation();
      
      // The setting should be a boolean
      expect(useScientific, isA<bool>());
      
      print('Configuración actual de notación científica: $useScientific');
    });
    
    test('Scientific notation should be disabled by default', () {
      // By default, scientific notation should be disabled
      bool useScientific = SettingsService.getUseScientificNotation();
      
      // Per the user's report, it is set to NOT use scientific notation
      expect(useScientific, isFalse);
    });
  });
}
