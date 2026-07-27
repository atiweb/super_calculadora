/// Available calculator types
enum CalculatorType {
  standard,
  scientific,
  special,
}

/// Calculator configuration
class CalculatorConfig {
  static const String calculatorTypeKey = 'calculator_type';
  
  /// Gets the saved calculator type
  static CalculatorType getCalculatorType() {
    // Standard calculator by default
    return CalculatorType.standard;
  }
  
  /// Saves the calculator type
  static void setCalculatorType(CalculatorType type) {
    // Future implementation with SharedPreferences if needed
  }
}
