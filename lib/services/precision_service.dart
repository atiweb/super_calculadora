import '../vendor/computable_reals/computable_reals.dart';
import 'settings_service.dart';

/// High-precision-mode exception that carries a localized error
/// key (the same ones the calculator uses), so that the caller can
/// display it with `_setError(key)` without leaking the raw exception.
class PrecisionException implements Exception {
  final String errorKey;
  const PrecisionException([this.errorKey = 'errResultInvalid']);
}

/// Computation of transcendental/irrational functions with **constructive reals**
/// (package `computable_reals`, see attribution on the licenses screen).
///
/// Unlike `double`, the result is exact and is rounded only when
/// formatting to N digits. Singularities (e.g. tan at a pole) do not
/// produce a huge wrong number: the library throws an exception that here
/// we convert into [PrecisionException] → "indefinido".
///
/// Only covers what `double` degrades (sin/cos/tan/asin/acos/atan/ln/log/
/// exp/√/∛). Integer powers and factorials keep going through the exact route
/// (BigDecimal/BigInt), which is already exact.
///
/// IMPORTANT: the methods receive `digits` explicitly instead of reading
/// `SettingsService`, so they can run inside an isolate (where storage
/// plugins are not available). The dispatcher
/// [precisionWorker] allows using them with `compute()`.
class PrecisionService {
  static CReal get _pi => CReal.pi;

  /// Is high-precision mode active? (Only on the main isolate.)
  static bool get isEnabled => SettingsService.getHighPrecisionMode();

  // ── Helpers ────────────────────────────────────────────────────────────

  static CReal _parse(String value) {
    try {
      return CReal.parse(_normalize(value));
    } catch (_) {
      throw const PrecisionException();
    }
  }

  /// CReal.parse does not accept scientific notation; normalizes unicode signs.
  static String _normalize(String value) =>
      value.trim().replaceAll('−', '-').replaceAll('+', '');

  static CReal _toRadians(CReal degrees) => degrees * _pi / CReal.from(180);
  static CReal _toDegrees(CReal radians) => radians * CReal.from(180) / _pi;

  static bool _isZero(String value) => double.tryParse(_normalize(value)) == 0;

  /// Formats to N digits and cleans trailing zeros; wraps library
  /// failures (ArithmeticException/TimeoutException) in [PrecisionException].
  static String _format(CReal Function() compute, int digits,
      [String errorKey = 'errResultInvalid']) {
    try {
      var s = compute().toStringAsPrecision(digits);
      if (s == '-0') s = '0';
      return s;
    } on PrecisionException {
      rethrow;
    } catch (_) {
      throw PrecisionException(errorKey);
    }
  }

  // ── Functions ──────────────────────────────────────────────────────────

  static String sin(String value, {required bool degrees, required int digits}) =>
      _format(() {
        final a = _parse(value);
        return (degrees ? _toRadians(a) : a).sin();
      }, digits);

  static String cos(String value, {required bool degrees, required int digits}) =>
      _format(() {
        final a = _parse(value);
        return (degrees ? _toRadians(a) : a).cos();
      }, digits);

  static String tan(String value, {required bool degrees, required int digits}) =>
      _format(() {
        final a = _parse(value);
        return (degrees ? _toRadians(a) : a).tan();
      }, digits, 'errTanUndefined');

  static String asin(String value, {required bool degrees, required int digits}) =>
      _format(() {
        final r = _parse(value).asin();
        return degrees ? _toDegrees(r) : r;
      }, digits);

  static String acos(String value, {required bool degrees, required int digits}) =>
      _format(() {
        final r = _parse(value).acos();
        return degrees ? _toDegrees(r) : r;
      }, digits);

  static String atan(String value, {required bool degrees, required int digits}) =>
      _format(() {
        final r = _parse(value).atan();
        return degrees ? _toDegrees(r) : r;
      }, digits);

  static String ln(String value, {required int digits}) =>
      _format(() => _parse(value).ln(), digits, 'errLnDomain');

  static String log10(String value, {required int digits}) =>
      _format(() => _parse(value).log(), digits, 'errLogDomain');

  static String exp(String value, {required int digits}) =>
      _format(() => _parse(value).exp(), digits);

  static String sqrt(String value, {required int digits}) =>
      _format(() => _parse(value).sqrt(), digits, 'errNegativeSqrt');

  /// Real cube root, signed: ∛(-8) = -2. ∛x = sign·|x|^(1/3).
  static String cbrt(String value, {required int digits}) {
    if (_isZero(value)) return '0';
    final norm = _normalize(value);
    final negative = norm.startsWith('-');
    final absStr = negative ? norm.substring(1) : norm;
    return _format(() {
      final third = CReal.from(1) / CReal.from(3);
      final r = _parse(absStr).pow(third); // |x|^(1/3), base > 0
      return negative ? -r : r;
    }, digits);
  }
}

/// Dispatcher to run [PrecisionService] inside an isolate via
/// `compute()`. Receives and returns only primitive (sendable) types.
///
/// Input: `{op, value, degrees, digits}`.
/// Output: `{ok: true, result: String}` or `{ok: false, errorKey: String}`.
Map<String, dynamic> precisionWorker(Map<String, dynamic> a) {
  final op = a['op'] as String;
  final value = a['value'] as String;
  final digits = a['digits'] as int;
  final degrees = a['degrees'] as bool? ?? false;
  try {
    final String r;
    switch (op) {
      case 'sin':
        r = PrecisionService.sin(value, degrees: degrees, digits: digits);
      case 'cos':
        r = PrecisionService.cos(value, degrees: degrees, digits: digits);
      case 'tan':
        r = PrecisionService.tan(value, degrees: degrees, digits: digits);
      case 'asin':
        r = PrecisionService.asin(value, degrees: degrees, digits: digits);
      case 'acos':
        r = PrecisionService.acos(value, degrees: degrees, digits: digits);
      case 'atan':
        r = PrecisionService.atan(value, degrees: degrees, digits: digits);
      case 'ln':
        r = PrecisionService.ln(value, digits: digits);
      case 'log10':
        r = PrecisionService.log10(value, digits: digits);
      case 'exp':
        r = PrecisionService.exp(value, digits: digits);
      case 'sqrt':
        r = PrecisionService.sqrt(value, digits: digits);
      case 'cbrt':
        r = PrecisionService.cbrt(value, digits: digits);
      default:
        return {'ok': false, 'errorKey': 'errResultInvalid'};
    }
    return {'ok': true, 'result': r};
  } on PrecisionException catch (e) {
    return {'ok': false, 'errorKey': e.errorKey};
  } catch (_) {
    return {'ok': false, 'errorKey': 'errResultInvalid'};
  }
}
