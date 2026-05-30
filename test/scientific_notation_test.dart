import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/settings_service.dart';

void main() {
  group('Scientific Notation Settings Tests', () {
    test('SettingsService should return correct scientific notation preference', () {
      // Verificar que la configuración se puede leer
      bool useScientific = SettingsService.getUseScientificNotation();
      
      // La configuración debería ser un booleano
      expect(useScientific, isA<bool>());
      
      print('Configuración actual de notación científica: $useScientific');
    });
    
    test('Scientific notation should be disabled by default', () {
      // Por defecto, la notación científica debería estar deshabilitada
      bool useScientific = SettingsService.getUseScientificNotation();
      
      // Según el reporte del usuario, está marcado como NO usar notación científica
      expect(useScientific, isFalse);
    });
  });
}
