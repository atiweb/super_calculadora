# Sistema de Temas - Super Calculadora

## Visión General

La Super Calculadora incluye un sistema de temas completamente personalizable que permite cambiar la apariencia visual de la aplicación. El sistema soporta múltiples temas predefinidos y permite la creación de temas personalizados.

## Características Principales

### 1. Temas Disponibles
- **Clásico**: Tema tradicional con colores neutros
- **Oscuro**: Tema oscuro para reducir la fatiga visual
- **Azul**: Tema con tonos azules profesionales
- **Verde**: Tema con tonos verdes naturales
- **Morado**: Tema con tonos morados elegantes
- **Naranja**: Tema con tonos naranjas vibrantes

### 2. Persistencia de Configuración
- Los temas seleccionados se guardan automáticamente
- La configuración persiste entre sesiones de la aplicación
- Carga automática del último tema seleccionado

### 3. Aplicación Dinámica
- Cambio de tema en tiempo real sin necesidad de reiniciar
- Transiciones suaves entre temas
- Actualización automática de todos los componentes

## Estructura del Sistema

### ThemeService
El servicio principal que gestiona los temas:

```dart
class ThemeService extends ChangeNotifier {
  ThemeData _currentTheme;
  String _currentThemeName;
  
  // Métodos principales
  void setTheme(String themeName);
  void loadSavedTheme();
  void saveTheme(String themeName);
}
```

### CalculatorThemes
Clase que define todos los temas disponibles:

```dart
class CalculatorThemes {
  static final Map<String, ThemeData> themes = {
    'clasico': _createClassicTheme(),
    'oscuro': _createDarkTheme(),
    'azul': _createBlueTheme(),
    'verde': _createGreenTheme(),
    'morado': _createPurpleTheme(),
    'naranja': _createOrangeTheme(),
  };
}
```

### Componentes de Tema

#### 1. Colores
Cada tema define:
- **Colores primarios**: Para elementos principales
- **Colores secundarios**: Para elementos de apoyo
- **Colores de fondo**: Para diferentes niveles de profundidad
- **Colores de texto**: Para diferentes tipos de contenido
- **Colores de botones**: Para diferentes tipos de botones

#### 2. Tipografía
- **Fuente principal**: Para el display de la calculadora
- **Fuente secundaria**: Para botones y etiquetas
- **Tamaños de texto**: Escalados apropiadamente

#### 3. Efectos Visuales
- **Elevación**: Sombras y profundidad
- **Bordes**: Redondeado y estilos
- **Transparencias**: Efectos de overlay

## Uso del Sistema

### Cambio de Tema en la Interfaz

1. **Botón de Configuración**: Accede al menú de configuración
2. **Selector de Tema**: Dropdown con todos los temas disponibles
3. **Vista Previa**: Cambio inmediato al seleccionar

### Implementación en Código

```dart
// Obtener el servicio de temas
final themeService = Provider.of<ThemeService>(context);

// Cambiar tema
themeService.setTheme('oscuro');

// Obtener tema actual
ThemeData currentTheme = themeService.currentTheme;
```

## Personalización

### Crear un Nuevo Tema

1. **Definir colores base**:
```dart
static ThemeData _createCustomTheme() {
  return ThemeData(
    primaryColor: Color(0xFF123456),
    scaffoldBackgroundColor: Color(0xFF789ABC),
    // ... más configuraciones
  );
}
```

2. **Agregar al mapa de temas**:
```dart
static final Map<String, ThemeData> themes = {
  // ... temas existentes
  'personalizado': _createCustomTheme(),
};
```

3. **Actualizar lista de nombres**:
```dart
static final List<String> themeNames = [
  // ... nombres existentes
  'personalizado',
];
```

### Modificar Temas Existentes

Los temas se pueden modificar editando los métodos correspondientes en `CalculatorThemes`:

```dart
static ThemeData _createDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF1E1E1E),
    // Modificar colores aquí
  );
}
```

## Estructura de Archivos

```
lib/
├── services/
│   └── theme_service.dart          # Servicio principal de temas
├── themes/
│   └── calculator_themes.dart      # Definición de todos los temas
├── widgets/
│   └── theme_selector.dart         # Widget selector de temas
└── main.dart                       # Integración del sistema
```

## Mejores Prácticas

### 1. Consistencia Visual
- Mantener coherencia en la paleta de colores
- Usar contrastes adecuados para accesibilidad
- Seguir las guías de Material Design

### 2. Rendimiento
- Los temas se cargan una vez al inicio
- Cambios eficientes sin reconstruir toda la app
- Persistencia ligera usando SharedPreferences

### 3. Mantenibilidad
- Separación clara entre definición y aplicación
- Código reutilizable y modular
- Documentación clara de cada tema

## Extensibilidad

### Futuras Mejoras
- **Temas dinámicos**: Basados en hora del día
- **Temas personalizados**: Editor visual de temas
- **Temas de temporada**: Temas especiales para festividades
- **Sincronización**: Temas compartidos entre dispositivos

### API de Extensión
```dart
// Registrar un nuevo tema
ThemeService.registerTheme('miTema', miThemeData);

// Obtener lista de temas disponibles
List<String> availableThemes = ThemeService.getAvailableThemes();

// Verificar si un tema existe
bool exists = ThemeService.themeExists('miTema');
```

## Resolución de Problemas

### Problemas Comunes

1. **Tema no se aplica**:
   - Verificar que el theme service esté inicializado
   - Comprobar que el tema esté registrado correctamente

2. **Colores incorrectos**:
   - Revisar los valores hexadecimales
   - Verificar la consistencia en brightness

3. **Persistencia no funciona**:
   - Verificar permisos de escritura
   - Comprobar inicialización de SharedPreferences

### Debugging

```dart
// Habilitar logs de tema
ThemeService.enableDebugMode();

// Verificar tema actual
print('Tema actual: ${ThemeService.currentThemeName}');

// Listar temas disponibles
print('Temas disponibles: ${CalculatorThemes.themeNames}');
```

## Conclusión

El sistema de temas de la Super Calculadora proporciona una experiencia visual rica y personalizable. Su arquitectura modular permite fácil extensión y mantenimiento, mientras que su interfaz intuitiva hace que cambiar temas sea simple para los usuarios.

El sistema está diseñado para ser robusto, eficiente y fácil de usar, proporcionando una base sólida para futuras mejoras y personalizaciones.
