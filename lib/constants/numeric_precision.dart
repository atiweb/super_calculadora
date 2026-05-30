/// Central configuration for numeric formatting precision used across the app.
class NumericPrecision {
  /// Number of decimal places used when stabilizing floating-point outputs
  /// from scientific functions (e.g., sin, cos, log) and general formatting
  /// thresholds to avoid double precision loss on large integers/strings.
  static const int decimals = 15;
}
