import 'package:flutter/material.dart';

/// Enum para los modos de tema de la aplicación
enum ThemeMode {
  light,
  dark,
  system,
}

/// Extensión para convertir el enum a string y viceversa
extension ThemeModeExtension on ThemeMode {
  String get name {
    switch (this) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
  
  static ThemeMode fromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
  
  String get displayName {
    switch (this) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Automático';
    }
  }
  
  String get description {
    switch (this) {
      case ThemeMode.light:
        return 'Usa siempre el tema claro';
      case ThemeMode.dark:
        return 'Usa siempre el tema oscuro';
      case ThemeMode.system:
        return 'Sigue la configuración del sistema';
    }
  }
  
  IconData get icon {
    switch (this) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
