/// Códigos de error neutrales al idioma para las herramientas de cálculo.
///
/// Los servicios lanzan estos códigos (no texto) y la capa de UI los traduce
/// al idioma activo. Así no hay mensajes "hardcodeados" en un solo idioma.
enum CalcError {
  zeroDenominator,
  divisionByZero,
  reciprocalOfZero,
  zeroToNegativePower,
  invalidFraction,
  invalidNumber,
  invalidInteger,
  emptyInput,
  negativeRadicand,
  evenRootOfNegative,
  rootIndexTooSmall,
  divisionByRootZero,
  binomialVanishes,
  invalidTriangle,
  needAtLeast3Vertices,
  invalidPoint,
  zeroPolynomialDivision,
  emptyExpression,
  invalidTerm,
  degreeAtLeastOne,
  discriminantDegree,
  zeroPolynomialRoots,
  notQuadratic,
  notCubic,
  modulusPositive,
  nNonNegative,
  nPositive,
  positiveDRequired,
  perfectSquareD,
  needPositiveValue,
  nGreaterThanOne,
  needKInitialTerms,
  countNonNegative,
  partsNonNegative,
  invalidOperation,
  listsSameSize,
}

/// Excepción de cálculo con un código localizable y argumentos opcionales.
///
/// Extiende [ArgumentError] para mantener compatibilidad con código y pruebas
/// existentes que esperan `throwsArgumentError`. El `message` heredado es solo
/// el nombre del código (neutral); el texto mostrado al usuario lo produce la
/// UI a partir de [code] y [args].
class CalcException extends ArgumentError {
  final CalcError code;
  final Map<String, String> args;

  CalcException(this.code, [this.args = const {}]) : super(code.name);

  /// Valor de un argumento (cadena vacía si no existe).
  String arg(String key) => args[key] ?? '';
}
