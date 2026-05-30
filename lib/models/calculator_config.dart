/// Tipos de calculadora disponibles
enum CalculatorType {
  standard,
  scientific,
  special,
}

/// Configuración de la calculadora
class CalculatorConfig {
  static const String calculatorTypeKey = 'calculator_type';
  
  /// Obtiene el tipo de calculadora guardado
  static CalculatorType getCalculatorType() {
    // Por defecto, calculadora estándar
    return CalculatorType.standard;
  }
  
  /// Guarda el tipo de calculadora
  static void setCalculatorType(CalculatorType type) {
    // Implementación futura con SharedPreferences si es necesario
  }
}
