import '../vendor/computable_reals/computable_reals.dart';
import 'settings_service.dart';

/// Excepción del modo de alta precisión que transporta una clave de error
/// localizada (las mismas que usa la calculadora), para que el llamador la
/// muestre con `_setError(key)` sin filtrar la excepción cruda.
class PrecisionException implements Exception {
  final String errorKey;
  const PrecisionException([this.errorKey = 'errResultInvalid']);
}

/// Cálculo de funciones transcendentes/irracionales con **reales constructivos**
/// (paquete `computable_reals`, ver atribución en la pantalla de licencias).
///
/// A diferencia de `double`, el resultado es exacto y se redondea solo al
/// formatear a N dígitos. Las singularidades (p. ej. tan en un polo) no
/// producen un número enorme erróneo: la librería lanza una excepción que aquí
/// convertimos en [PrecisionException] → "indefinido".
///
/// Solo cubre lo que el `double` degrada (sin/cos/tan/asin/acos/atan/ln/log/
/// exp/√/∛). Potencias enteras y factoriales siguen por la ruta exacta
/// (BigDecimal/BigInt), que ya es exacta.
///
/// IMPORTANTE: los métodos reciben `digits` de forma explícita en vez de leer
/// `SettingsService`, para poder ejecutarse dentro de un isolate (donde los
/// plugins de almacenamiento no están disponibles). El dispatcher
/// [precisionWorker] permite usarlos con `compute()`.
class PrecisionService {
  static CReal get _pi => CReal.pi;

  /// ¿Está activo el modo de alta precisión? (Solo en el isolate principal.)
  static bool get isEnabled => SettingsService.getHighPrecisionMode();

  // ── Helpers ────────────────────────────────────────────────────────────

  static CReal _parse(String value) {
    try {
      return CReal.parse(_normalize(value));
    } catch (_) {
      throw const PrecisionException();
    }
  }

  /// CReal.parse no admite notación científica; normaliza signos unicode.
  static String _normalize(String value) =>
      value.trim().replaceAll('−', '-').replaceAll('+', '');

  static CReal _toRadians(CReal degrees) => degrees * _pi / CReal.from(180);
  static CReal _toDegrees(CReal radians) => radians * CReal.from(180) / _pi;

  static bool _isZero(String value) => double.tryParse(_normalize(value)) == 0;

  /// Formatea a N dígitos y limpia ceros finales; envuelve fallos de la
  /// librería (ArithmeticException/TimeoutException) en [PrecisionException].
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

  // ── Funciones ──────────────────────────────────────────────────────────

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

  /// Raíz cúbica real, con signo: ∛(-8) = -2. ∛x = signo·|x|^(1/3).
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

/// Dispatcher para ejecutar [PrecisionService] dentro de un isolate vía
/// `compute()`. Recibe y devuelve solo tipos primitivos (sendables).
///
/// Entrada: `{op, value, degrees, digits}`.
/// Salida: `{ok: true, result: String}` o `{ok: false, errorKey: String}`.
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
