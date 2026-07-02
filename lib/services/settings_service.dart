import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_mode.dart' as app_theme;

/// Servicio para manejar las configuraciones de la aplicación
class SettingsService {
  static const String _useScientificNotationKey = 'use_scientific_notation';
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';
  static const String _highPrecisionKey = 'high_precision_mode';
  static const String _precisionDigitsKey = 'precision_digits';

  /// Dígitos por defecto y límites para el modo de alta precisión.
  static const int defaultPrecisionDigits = 30;
  static const int minPrecisionDigits = 5;
  static const int maxPrecisionDigits = 100;
  
  static SharedPreferences? _prefs;
  static bool _useMemoryStore = false;
  static final Map<String, Object> _memoryStore = <String, Object>{};
  
  /// Inicializa el servicio de configuraciones
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _useMemoryStore = false;
    } catch (e) {
      // En entorno de tests (sin plugins), usar un almacenamiento en memoria.
      _prefs = null;
      _useMemoryStore = true;
    }
  }
  
  /// Obtiene si se debe usar notación científica
  static bool getUseScientificNotation() {
    if (_useMemoryStore) {
      return (_memoryStore[_useScientificNotationKey] as bool?) ?? false;
    }
    return _prefs?.getBool(_useScientificNotationKey) ?? false;
  }
  
  /// Establece si se debe usar notación científica
  static Future<void> setUseScientificNotation(bool value) async {
    if (_useMemoryStore) {
      _memoryStore[_useScientificNotationKey] = value;
      return;
    }
    await _prefs?.setBool(_useScientificNotationKey, value);
  }
  
  /// Obtiene el modo de tema actual
  static app_theme.ThemeMode getThemeMode() {
    final themeString = _useMemoryStore
        ? (_memoryStore[_themeModeKey] as String? ?? 'system')
        : (_prefs?.getString(_themeModeKey) ?? 'system');
    return app_theme.ThemeModeExtension.fromString(themeString);
  }
  
  /// Establece el modo de tema
  static Future<void> setThemeMode(app_theme.ThemeMode mode) async {
    if (_useMemoryStore) {
      _memoryStore[_themeModeKey] = mode.name;
      return;
    }
    await _prefs?.setString(_themeModeKey, mode.name);
  }

  /// Obtiene si el modo de alta precisión (reales constructivos) está activo.
  static bool getHighPrecisionMode() {
    if (_useMemoryStore) {
      return (_memoryStore[_highPrecisionKey] as bool?) ?? false;
    }
    return _prefs?.getBool(_highPrecisionKey) ?? false;
  }

  /// Activa/desactiva el modo de alta precisión.
  static Future<void> setHighPrecisionMode(bool value) async {
    if (_useMemoryStore) {
      _memoryStore[_highPrecisionKey] = value;
      return;
    }
    await _prefs?.setBool(_highPrecisionKey, value);
  }

  /// Dígitos de precisión a mostrar en modo alta precisión (acotado a límites).
  static int getPrecisionDigits() {
    final raw = _useMemoryStore
        ? (_memoryStore[_precisionDigitsKey] as int?)
        : _prefs?.getInt(_precisionDigitsKey);
    final value = raw ?? defaultPrecisionDigits;
    return value.clamp(minPrecisionDigits, maxPrecisionDigits);
  }

  /// Establece los dígitos de precisión (se acota a [minPrecisionDigits, maxPrecisionDigits]).
  static Future<void> setPrecisionDigits(int value) async {
    final clamped = value.clamp(minPrecisionDigits, maxPrecisionDigits);
    if (_useMemoryStore) {
      _memoryStore[_precisionDigitsKey] = clamped;
      return;
    }
    await _prefs?.setInt(_precisionDigitsKey, clamped);
  }

  /// Obtiene el código de idioma guardado (cadena vacía = automático del sistema)
  static String getLocale() {
    if (_useMemoryStore) {
      return (_memoryStore[_localeKey] as String?) ?? '';
    }
    return _prefs?.getString(_localeKey) ?? '';
  }

  /// Establece el código de idioma (cadena vacía = automático del sistema)
  static Future<void> setLocale(String localeCode) async {
    if (_useMemoryStore) {
      _memoryStore[_localeKey] = localeCode;
      return;
    }
    await _prefs?.setString(_localeKey, localeCode);
  }
}
