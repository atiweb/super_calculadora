import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/settings_service.dart';

void main() {
  group('Settings Service Tests', () {
    setUpAll(() async {
      // Inicializar el binding de Flutter para los tests
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() async {
      // Inicializar el servicio antes de cada test
      await SettingsService.init();
    });

    test('configuración por defecto debe ser false', () {
      // La configuración por defecto debe ser false (sin notación científica)
      bool defaultValue = SettingsService.getUseScientificNotation();
      expect(defaultValue, false);
    });

    test('debe poder guardar y recuperar configuración', () async {
      // Establecer notación científica como true
      await SettingsService.setUseScientificNotation(true);
      
      // Verificar que se guardó correctamente
      bool savedValue = SettingsService.getUseScientificNotation();
      expect(savedValue, true);
      
      // Cambiar a false
      await SettingsService.setUseScientificNotation(false);
      
      // Verificar que se cambió correctamente
      bool changedValue = SettingsService.getUseScientificNotation();
      expect(changedValue, false);
    });

    test('configuración debe persistir entre sesiones', () async {
      // Establecer valor inicial
      await SettingsService.setUseScientificNotation(true);
      bool initialValue = SettingsService.getUseScientificNotation();
      expect(initialValue, true);
      
      // Simular reinicio de la aplicación reinicializando el servicio
      await SettingsService.init();
      
      // Verificar que el valor persiste
      bool persistedValue = SettingsService.getUseScientificNotation();
      expect(persistedValue, true);
      
      // Limpiar para no afectar otros tests
      await SettingsService.setUseScientificNotation(false);
    });
  });
}
