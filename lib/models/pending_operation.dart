/// Modelo genérico para operaciones pendientes de N parámetros.
///
/// Soporta dos modos:
/// - **Fijo**: se define [requiredParams] y se autojecuta al completarse.
/// - **Variable**: [requiredParams] es null; el usuario agrega params con = y
///   presiona el botón de la función otra vez para ejecutar.
///
/// Cada paso tiene una etiqueta que se muestra al usuario (ej: "12 mod _").
class PendingOperation {
  /// Identificador de la operación (ej: 'mod', 'gcd', 'crt')
  final String name;

  /// Símbolo visible en el display (ej: 'mod', 'MCD', 'TCR')
  final String symbol;

  /// Número de parámetros requeridos.
  /// null = variable (se ejecuta manualmente).
  final int? requiredParams;

  /// Parámetros recolectados hasta ahora.
  final List<String> params;

  /// Si es variable, mínimo de parámetros antes de poder ejecutar.
  final int minParams;

  /// Etiquetas para cada paso (opcionales).
  /// Si el paso i existe en la lista, se usa; si no, se genera automáticamente.
  final List<String> stepLabels;

  /// Función que construye el texto del display dados los params actuales.
  /// Si es null, se usa un builder por defecto.
  final String Function(List<String> params)? displayBuilder;

  PendingOperation({
    required this.name,
    required this.symbol,
    this.requiredParams,
    List<String>? params,
    this.minParams = 2,
    this.stepLabels = const [],
    this.displayBuilder,
  }) : params = params ?? [];

  /// Si ya tiene todos los parámetros requeridos (modo fijo).
  bool get isComplete =>
      requiredParams != null && params.length >= requiredParams!;

  /// Si es de parámetros variables.
  bool get isVariable => requiredParams == null;

  /// Si se puede ejecutar (tiene suficientes parámetros).
  bool get canExecute =>
      isComplete || (isVariable && params.length >= minParams);

  /// Cuántos parámetros faltan (modo fijo). -1 si es variable.
  int get remaining =>
      requiredParams != null ? requiredParams! - params.length : -1;

  /// Agrega un parámetro y retorna una copia nueva (inmutable).
  PendingOperation addParam(String value) {
    return PendingOperation(
      name: name,
      symbol: symbol,
      requiredParams: requiredParams,
      params: [...params, value],
      minParams: minParams,
      stepLabels: stepLabels,
      displayBuilder: displayBuilder,
    );
  }

  /// Construye la etiqueta para el display.
  String buildDisplayLabel() {
    if (displayBuilder != null) {
      return displayBuilder!(params);
    }
    // Builder por defecto
    return _defaultDisplayLabel();
  }

  String _defaultDisplayLabel() {
    if (params.isEmpty) return '$symbol(_)';

    String collected = params.join(', ');

    if (isVariable) {
      return '$symbol($collected, _) [= agregar, $symbol resolver]';
    }

    int totalNeeded = requiredParams ?? 0;
    int got = params.length;
    if (got < totalNeeded) {
      // Usar stepLabel si existe
      if (got < stepLabels.length) {
        return stepLabels[got];
      }
      return '$symbol($collected, _)';
    }

    return '$symbol($collected)';
  }
}
