import '../services/settings_service.dart';

/// Available calculator types
enum CalculatorType {
  standard,
  scientific,
  special,
}

/// Calculator configuration, persisted through [SettingsService].
class CalculatorConfig {
  /// Gets the saved calculator type (standard if none or unknown).
  static CalculatorType getCalculatorType() {
    final name = SettingsService.getCalculatorType();
    for (final type in CalculatorType.values) {
      if (type.name == name) return type;
    }
    return CalculatorType.standard;
  }

  /// Saves the calculator type
  static Future<void> setCalculatorType(CalculatorType type) =>
      SettingsService.setCalculatorType(type.name);
}
