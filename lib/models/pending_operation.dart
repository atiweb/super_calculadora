/// Generic model for pending operations with N parameters.
///
/// Supports two modes:
/// - **Fixed**: [requiredParams] is defined and it auto-executes when complete.
/// - **Variable**: [requiredParams] is null; the user adds params with = and
///   presses the function button again to execute.
///
/// Each step has a label shown to the user (e.g.: "12 mod _").
class PendingOperation {
  /// Operation identifier (e.g.: 'mod', 'gcd', 'crt')
  final String name;

  /// Symbol visible on the display (e.g.: 'mod', 'MCD', 'TCR')
  final String symbol;

  /// Number of required parameters.
  /// null = variable (executed manually).
  final int? requiredParams;

  /// Parameters collected so far.
  final List<String> params;

  /// If variable, minimum number of parameters before it can execute.
  final int minParams;

  /// Labels for each step (optional).
  /// If step i exists in the list, it is used; otherwise one is generated automatically.
  final List<String> stepLabels;

  /// Function that builds the display text given the current params.
  /// If null, a default builder is used.
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

  /// Whether it already has all required parameters (fixed mode).
  bool get isComplete =>
      requiredParams != null && params.length >= requiredParams!;

  /// Whether it takes a variable number of parameters.
  bool get isVariable => requiredParams == null;

  /// Whether it can be executed (has enough parameters).
  bool get canExecute =>
      isComplete || (isVariable && params.length >= minParams);

  /// How many parameters are missing (fixed mode). -1 if variable.
  int get remaining =>
      requiredParams != null ? requiredParams! - params.length : -1;

  /// Adds a parameter and returns a new copy (immutable).
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

  /// Builds the label for the display.
  String buildDisplayLabel() {
    if (displayBuilder != null) {
      return displayBuilder!(params);
    }
    // Default builder
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
      // Use the stepLabel if it exists
      if (got < stepLabels.length) {
        return stepLabels[got];
      }
      return '$symbol($collected, _)';
    }

    return '$symbol($collected)';
  }
}
