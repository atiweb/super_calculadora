import 'package:flutter/material.dart';
import '../models/theme_mode.dart' as app_theme;
import '../services/settings_service.dart';

/// Provider to manage the application theme state
class ThemeProvider extends ChangeNotifier {
  app_theme.ThemeMode _currentTheme = app_theme.ThemeMode.system;
  bool _useScientificNotation = false;
  Locale? _locale;

  app_theme.ThemeMode get currentTheme => _currentTheme;
  bool get useScientificNotation => _useScientificNotation;
  /// Returns the selected locale, or null to follow the system
  Locale? get locale => _locale;

  /// Initializes the provider with the saved theme
  void init() {
    _currentTheme = SettingsService.getThemeMode();
    _useScientificNotation = SettingsService.getUseScientificNotation();
    final savedLocale = SettingsService.getLocale();
    if (savedLocale.isNotEmpty) {
      _locale = Locale(savedLocale);
    }
    notifyListeners();
  }
  
  /// Changes the theme and saves it in preferences
  Future<void> setTheme(app_theme.ThemeMode theme) async {
    _currentTheme = theme;
    await SettingsService.setThemeMode(theme);
    notifyListeners();
  }
  
  /// Changes the scientific notation setting
  Future<void> setUseScientificNotation(bool value) async {
    _useScientificNotation = value;
    await SettingsService.setUseScientificNotation(value);
    notifyListeners();
  }

  /// Changes the application language (empty string = follow the system)
  Future<void> setLocale(String localeCode) async {
    if (localeCode.isEmpty) {
      _locale = null;
    } else {
      _locale = Locale(localeCode);
    }
    await SettingsService.setLocale(localeCode);
    notifyListeners();
  }
  
  /// Converts the app theme to Flutter's ThemeMode
  ThemeMode get flutterThemeMode {
    switch (_currentTheme) {
      case app_theme.ThemeMode.light:
        return ThemeMode.light;
      case app_theme.ThemeMode.dark:
        return ThemeMode.dark;
      case app_theme.ThemeMode.system:
        return ThemeMode.system;
    }
  }
}
