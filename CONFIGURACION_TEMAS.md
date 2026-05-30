# Configuración de Temas - Super Calculadora

## Descripción

La aplicación Super Calculadora ahora incluye un sistema completo de temas que permite al usuario personalizar la apariencia visual de la aplicación. Esta funcionalidad se ha implementado como una extensión del sistema de configuraciones persistentes.

## Funcionalidades Implementadas

### 1. Modos de Tema Disponibles

- **Modo Claro**: Utiliza siempre el tema claro con colores brillantes y fondos blancos
- **Modo Oscuro**: Utiliza siempre el tema oscuro con colores suaves y fondos negros
- **Modo Automático**: Sigue automáticamente la configuración del sistema operativo

### 2. Persistencia de Configuración

- La selección del tema se guarda automáticamente usando `SharedPreferences`
- Al reiniciar la aplicación, se mantiene el tema seleccionado por el usuario
- Los cambios de tema se aplican instantáneamente sin necesidad de reiniciar

### 3. Detección Automática del Sistema

- El modo automático detecta el tema del sistema operativo
- Se actualiza dinámicamente cuando el usuario cambia el tema del sistema
- Funciona tanto en Windows como en Android/iOS

## Implementación Técnica

### Archivos Creados/Modificados

1. **`lib/models/theme_mode.dart`**
   - Enum personalizado para los modos de tema
   - Extensiones para conversión y propiedades de display
   - Iconos y descripciones para la interfaz

2. **`lib/providers/theme_provider.dart`**
   - Provider para manejar el estado del tema
   - Conversión entre el enum personalizado y el ThemeMode de Flutter
   - Gestión de persistencia automática

3. **`lib/services/settings_service.dart`**
   - Métodos para guardar/cargar la configuración del tema
   - Integración con el sistema de configuraciones existente

4. **`lib/screens/settings_screen.dart`**
   - Interfaz para seleccionar el tema
   - RadioListTile para cada opción de tema
   - Feedback visual inmediato al cambiar temas

5. **`lib/main.dart`**
   - Integración del ThemeProvider con la aplicación
   - Configuración de temas claro y oscuro
   - Uso de Consumer para reactualización automática

### Estructura del Sistema

```
Sistema de Temas
├── Enum ThemeMode (personalizado)
├── ThemeProvider (gestión de estado)
├── SettingsService (persistencia)
├── SettingsScreen (interfaz)
└── main.dart (aplicación)
```

## Experiencia de Usuario

### Acceso a Configuraciones

1. Abrir el menú lateral (drawer)
2. Seleccionar "Configuraciones"
3. En la sección "Apariencia", elegir el tema deseado

### Opciones Disponibles

- **Claro**: Siempre tema claro
- **Oscuro**: Siempre tema oscuro  
- **Automático**: Sigue la configuración del sistema

### Feedback Visual

- Cambio instantáneo del tema al seleccionar una opción
- Mensaje de confirmación (SnackBar) con el tema seleccionado
- Los iconos se actualizan según el tema activo

## Beneficios

1. **Personalización**: El usuario puede elegir el tema que prefiera
2. **Comodidad**: El modo automático se adapta al sistema
3. **Persistencia**: La configuración se mantiene entre sesiones
4. **Accesibilidad**: Mejora la experiencia en diferentes condiciones de iluminación

## Compatibilidad

- ✅ Windows (probado)
- ✅ Android (configurado)
- ✅ iOS (configurado)
- ✅ Modo automático funciona en todas las plataformas

## Notas Técnicas

- Se utiliza `Material Design 3` para ambos temas
- Los colores base se generan a partir de `Colors.deepPurple`
- La configuración se guarda en `SharedPreferences` con la clave `theme_mode`
- El sistema detecta automáticamente cambios en el tema del sistema operativo

## Próximas Mejoras

- Posibilidad de temas personalizados con colores específicos
- Modo de alto contraste para accesibilidad
- Integración con horarios (tema claro de día, oscuro de noche)
