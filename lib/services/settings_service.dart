import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_mode.dart' as app_theme;

/// Service for managing the application settings
class SettingsService {
  static const String _useScientificNotationKey = 'use_scientific_notation';
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';
  static const String _highPrecisionKey = 'high_precision_mode';
  static const String _precisionDigitsKey = 'precision_digits';

  /// Default digits and limits for high precision mode.
  static const int defaultPrecisionDigits = 30;
  static const int minPrecisionDigits = 5;
  static const int maxPrecisionDigits = 100;
  
  static SharedPreferences? _prefs;
  static bool _useMemoryStore = false;
  static final Map<String, Object> _memoryStore = <String, Object>{};
  
  /// Initializes the settings service
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _useMemoryStore = false;
    } catch (e) {
      // In test environments (no plugins), use in-memory storage.
      _prefs = null;
      _useMemoryStore = true;
    }
  }
  
  /// Gets whether scientific notation should be used
  static bool getUseScientificNotation() {
    if (_useMemoryStore) {
      return (_memoryStore[_useScientificNotationKey] as bool?) ?? false;
    }
    return _prefs?.getBool(_useScientificNotationKey) ?? false;
  }
  
  /// Sets whether scientific notation should be used
  static Future<void> setUseScientificNotation(bool value) async {
    if (_useMemoryStore) {
      _memoryStore[_useScientificNotationKey] = value;
      return;
    }
    await _prefs?.setBool(_useScientificNotationKey, value);
  }
  
  /// Gets the current theme mode
  static app_theme.ThemeMode getThemeMode() {
    final themeString = _useMemoryStore
        ? (_memoryStore[_themeModeKey] as String? ?? 'system')
        : (_prefs?.getString(_themeModeKey) ?? 'system');
    return app_theme.ThemeModeExtension.fromString(themeString);
  }
  
  /// Sets the theme mode
  static Future<void> setThemeMode(app_theme.ThemeMode mode) async {
    if (_useMemoryStore) {
      _memoryStore[_themeModeKey] = mode.name;
      return;
    }
    await _prefs?.setString(_themeModeKey, mode.name);
  }

  /// Gets whether high precision mode (constructive reals) is active.
  static bool getHighPrecisionMode() {
    if (_useMemoryStore) {
      return (_memoryStore[_highPrecisionKey] as bool?) ?? false;
    }
    return _prefs?.getBool(_highPrecisionKey) ?? false;
  }

  /// Enables/disables high precision mode.
  static Future<void> setHighPrecisionMode(bool value) async {
    if (_useMemoryStore) {
      _memoryStore[_highPrecisionKey] = value;
      return;
    }
    await _prefs?.setBool(_highPrecisionKey, value);
  }

  /// Precision digits to display in high precision mode (clamped to limits).
  static int getPrecisionDigits() {
    final raw = _useMemoryStore
        ? (_memoryStore[_precisionDigitsKey] as int?)
        : _prefs?.getInt(_precisionDigitsKey);
    final value = raw ?? defaultPrecisionDigits;
    return value.clamp(minPrecisionDigits, maxPrecisionDigits);
  }

  /// Sets the precision digits (clamped to [minPrecisionDigits, maxPrecisionDigits]).
  static Future<void> setPrecisionDigits(int value) async {
    final clamped = value.clamp(minPrecisionDigits, maxPrecisionDigits);
    if (_useMemoryStore) {
      _memoryStore[_precisionDigitsKey] = clamped;
      return;
    }
    await _prefs?.setInt(_precisionDigitsKey, clamped);
  }

  /// Gets the saved language code (empty string = system default)
  static String getLocale() {
    if (_useMemoryStore) {
      return (_memoryStore[_localeKey] as String?) ?? '';
    }
    return _prefs?.getString(_localeKey) ?? '';
  }

  /// Sets the language code (empty string = system default)
  static Future<void> setLocale(String localeCode) async {
    if (_useMemoryStore) {
      _memoryStore[_localeKey] = localeCode;
      return;
    }
    await _prefs?.setString(_localeKey, localeCode);
  }
}
