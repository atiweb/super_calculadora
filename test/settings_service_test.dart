import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/settings_service.dart';

void main() {
  group('Settings Service Tests', () {
    setUpAll(() async {
      // Initialize the Flutter binding for the tests
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() async {
      // Initialize the service before each test
      await SettingsService.init();
    });

    test('configuración por defecto debe ser false', () {
      // The default setting must be false (no scientific notation)
      bool defaultValue = SettingsService.getUseScientificNotation();
      expect(defaultValue, false);
    });

    test('debe poder guardar y recuperar configuración', () async {
      // Set scientific notation to true
      await SettingsService.setUseScientificNotation(true);
      
      // Verify it was saved correctly
      bool savedValue = SettingsService.getUseScientificNotation();
      expect(savedValue, true);
      
      // Change to false
      await SettingsService.setUseScientificNotation(false);
      
      // Verify it was changed correctly
      bool changedValue = SettingsService.getUseScientificNotation();
      expect(changedValue, false);
    });

    test('configuración debe persistir entre sesiones', () async {
      // Set initial value
      await SettingsService.setUseScientificNotation(true);
      bool initialValue = SettingsService.getUseScientificNotation();
      expect(initialValue, true);
      
      // Simulate an app restart by re-initializing the service
      await SettingsService.init();
      
      // Verify the value persists
      bool persistedValue = SettingsService.getUseScientificNotation();
      expect(persistedValue, true);
      
      // Clean up so other tests are not affected
      await SettingsService.setUseScientificNotation(false);
    });
  });
}
