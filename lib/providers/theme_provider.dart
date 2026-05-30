import 'package:flutter/material.dart';
import '../models/theme_mode.dart' as app_theme;
import '../services/settings_service.dart';

/// Provider para manejar el estado del tema de la aplicación
class ThemeProvider extends ChangeNotifier {
  app_theme.ThemeMode _currentTheme = app_theme.ThemeMode.system;
  bool _useScientificNotation = false;
  Locale? _locale;

  app_theme.ThemeMode get currentTheme => _currentTheme;
  bool get useScientificNotation => _useScientificNotation;
  /// Retorna el locale seleccionado, o null para seguir el sistema
  Locale? get locale => _locale;

  /// Inicializa el provider con el tema guardado
  void init() {
    _currentTheme = SettingsService.getThemeMode();
    _useScientificNotation = SettingsService.getUseScientificNotation();
    final savedLocale = SettingsService.getLocale();
    if (savedLocale.isNotEmpty) {
      _locale = Locale(savedLocale);
    }
    notifyListeners();
  }
  
  /// Cambia el tema y lo guarda en las preferencias
  Future<void> setTheme(app_theme.ThemeMode theme) async {
    _currentTheme = theme;
    await SettingsService.setThemeMode(theme);
    notifyListeners();
  }
  
  /// Cambia la configuración de notación científica
  Future<void> setUseScientificNotation(bool value) async {
    _useScientificNotation = value;
    await SettingsService.setUseScientificNotation(value);
    notifyListeners();
  }

  /// Cambia el idioma de la aplicación (cadena vacía = automático del sistema)
  Future<void> setLocale(String localeCode) async {
    if (localeCode.isEmpty) {
      _locale = null;
    } else {
      _locale = Locale(localeCode);
    }
    await SettingsService.setLocale(localeCode);
    notifyListeners();
  }
  
  /// Convierte el tema de la app al ThemeMode de Flutter
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
