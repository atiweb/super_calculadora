import 'package:shared_preferences/shared_preferences.dart';
import '../models/theme_mode.dart' as app_theme;

/// Service for managing the application settings
class SettingsService {
  static const String _useScientificNotationKey = 'use_scientific_notation';
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';
  static const String _highPrecisionKey = 'high_precision_mode';
  static const String _precisionDigitsKey = 'precision_digits';
  static const String _calculatorTypeKey = 'calculator_type';
  static const String _radianModeKey = 'radian_mode';

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
  
  /// Reads [key] tolerating a value of the wrong type (left by an older
  /// build): SharedPreferences' typed getters throw a TypeError then, and
  /// these reads run while the app starts.
  static T? _read<T>(String key) {
    try {
      final Object? value =
          _useMemoryStore ? _memoryStore[key] : _prefs?.get(key);
      return value is T ? value : null;
    } catch (_) {
      return null;
    }
  }

  /// Gets whether scientific notation should be used
  static bool getUseScientificNotation() {
    return _read<bool>(_useScientificNotationKey) ?? false;
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
    final themeString = _read<String>(_themeModeKey) ?? 'system';
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
    return _read<bool>(_highPrecisionKey) ?? false;
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
    final raw = _read<int>(_precisionDigitsKey);
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
    return _read<String>(_localeKey) ?? '';
  }

  /// Sets the language code (empty string = system default)
  static Future<void> setLocale(String localeCode) async {
    if (_useMemoryStore) {
      _memoryStore[_localeKey] = localeCode;
      return;
    }
    await _prefs?.setString(_localeKey, localeCode);
  }

  /// Last calculator type used (standard/scientific/special), by enum name.
  static String getCalculatorType() => _read<String>(_calculatorTypeKey) ?? '';

  static Future<void> setCalculatorType(String name) async {
    if (_useMemoryStore) {
      _memoryStore[_calculatorTypeKey] = name;
      return;
    }
    await _prefs?.setString(_calculatorTypeKey, name);
  }

  /// Whether trigonometry works in radians (false = degrees, the default).
  static bool getRadianMode() => _read<bool>(_radianModeKey) ?? false;

  static Future<void> setRadianMode(bool value) async {
    if (_useMemoryStore) {
      _memoryStore[_radianModeKey] = value;
      return;
    }
    await _prefs?.setBool(_radianModeKey, value);
  }
}
