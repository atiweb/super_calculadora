/// Language-neutral error codes for the calculation tools.
///
/// Services throw these codes (not text) and the UI layer translates them
/// into the active language. This way no messages are hardcoded in a single language.
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
  inputTooLarge,
  integerCoordinatesRequired,
  collinearPoints,
  invalidSystem,
}

/// Calculation exception with a localizable code and optional arguments.
///
/// Extends [ArgumentError] to keep compatibility with existing code and
/// tests that expect `throwsArgumentError`. The inherited `message` is just
/// the code name (neutral); the text shown to the user is produced by the
/// UI from [code] and [args].
class CalcException extends ArgumentError {
  final CalcError code;
  final Map<String, String> args;

  CalcException(this.code, [this.args = const {}]) : super(code.name);

  /// Value of an argument (empty string if it does not exist).
  String arg(String key) => args[key] ?? '';
}
