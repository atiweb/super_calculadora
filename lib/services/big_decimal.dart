import 'dart:math' as math;
import '../utils/app_locale.dart';

/// Clase personalizada para manejar números decimales de precisión arbitraria
/// Simula 1024 bits enteros + 64 bits decimales
class BigDecimal {
  final BigInt _integerPart;
  final BigInt _fractionalPart;
  final int _scale; // Número de dígitos decimales

  static const int maxDecimalPlaces = 20; // Simula 64 bits decimales

  BigDecimal._(this._integerPart, this._fractionalPart, this._scale);

  /// Constructor desde string. Acepta notación científica ("1e+25",
  /// "3.16e-7") expandiéndola a forma plana. Lanza [FormatException] si el
  /// texto no es un número: degradar en silencio a 0 (comportamiento
  /// anterior) corrompía raíces, potencias y el formateo de resultados
  /// grandes, porque `double.toString()` emite exponente desde 1e21.
  factory BigDecimal.fromString(String value) {
    if (value.isEmpty) {
      return BigDecimal.zero;
    }

    value = value.trim();

    // Expandir notación científica antes de trocear.
    final Match? expMatch =
        RegExp(r'^([+-]?[0-9]*\.?[0-9]+)[eE]([+-]?[0-9]+)$').firstMatch(value);
    if (expMatch != null) {
      value = _expandScientific(
          expMatch.group(1)!, int.parse(expMatch.group(2)!));
    }

    // Manejar signo
    bool isNegative = value.startsWith('-');
    if (isNegative || value.startsWith('+')) {
      value = value.substring(1);
    }

    // Dividir en parte entera y decimal
    List<String> parts = value.split('.');
    final RegExp digitsOnly = RegExp(r'^[0-9]*$');
    if (parts.length > 2 ||
        parts.any((p) => !digitsOnly.hasMatch(p)) ||
        parts.every((p) => p.isEmpty)) {
      throw FormatException('Número inválido: $value');
    }

    BigInt integerPart =
        parts[0].isEmpty ? BigInt.zero : BigInt.parse(parts[0]);
    BigInt fractionalPart = BigInt.zero;
    int scale = 0;

    if (parts.length > 1 && parts[1].isNotEmpty) {
      String decimalStr = parts[1];
      // Limitar a maxDecimalPlaces dígitos decimales
      if (decimalStr.length > maxDecimalPlaces) {
        decimalStr = decimalStr.substring(0, maxDecimalPlaces);
      }

      fractionalPart = BigInt.parse(decimalStr);
      scale = decimalStr.length;
    }

    if (isNegative) {
      integerPart = -integerPart;
      if (fractionalPart > BigInt.zero) {
        fractionalPart = -fractionalPart;
      }
    }

    return BigDecimal._(integerPart, fractionalPart, scale);
  }

  /// Expande "mantisa × 10^exponente" a un literal decimal plano.
  static String _expandScientific(String mantissa, int exponent) {
    final bool neg = mantissa.startsWith('-');
    if (neg || mantissa.startsWith('+')) {
      mantissa = mantissa.substring(1);
    }
    final int dot = mantissa.indexOf('.');
    final String digits = mantissa.replaceAll('.', '');
    // Posición del punto decimal dentro de `digits` tras aplicar el exponente
    int pointPos = (dot == -1 ? mantissa.length : dot) + exponent;

    String result;
    if (pointPos <= 0) {
      result = '0.${'0' * (-pointPos)}$digits';
    } else if (pointPos >= digits.length) {
      result = digits + '0' * (pointPos - digits.length);
    } else {
      result =
          '${digits.substring(0, pointPos)}.${digits.substring(pointPos)}';
    }
    return neg ? '-$result' : result;
  }

  /// Constructor desde BigInt
  factory BigDecimal.fromBigInt(BigInt value) {
    return BigDecimal._(value, BigInt.zero, 0);
  }

  /// Constructor desde int
  factory BigDecimal.fromInt(int value) {
    return BigDecimal._(BigInt.from(value), BigInt.zero, 0);
  }

  /// Constructor desde double
  factory BigDecimal.fromDouble(double value) {
    return BigDecimal.fromString(value.toString());
  }

  /// Construye un BigDecimal a partir de un valor entero escalado (total)
  /// y su escala, garantizando que la parte entera y la parte fraccionaria
  /// compartan el mismo signo que el valor real.
  ///
  /// Usa truncamiento hacia cero (`~/`) y `remainder` (cuyo signo coincide con
  /// el del dividendo) para que la invariante
  ///   total = integerPart * 10^scale + fractionalPart
  /// se cumpla con signos consistentes. Esto evita estados como
  /// (integerPart > 0, fractionalPart < 0) que rompen `toString`.
  factory BigDecimal._fromTotal(BigInt total, int scale) {
    if (scale <= 0) {
      // El valor es un entero (posiblemente reescalado por 10^(-scale)).
      if (scale < 0) {
        total = total * BigInt.from(10).pow(-scale);
      }
      return BigDecimal._(total, BigInt.zero, 0);
    }

    final BigInt scaleMultiplier = BigInt.from(10).pow(scale);
    final BigInt integerPart = total ~/ scaleMultiplier; // trunca hacia cero
    final BigInt fractionalPart =
        total.remainder(scaleMultiplier); // signo = signo de total
    return BigDecimal._(integerPart, fractionalPart, scale);
  }

  /// Zero constant
  static final BigDecimal zero = BigDecimal._(BigInt.zero, BigInt.zero, 0);

  /// One constant
  static final BigDecimal one = BigDecimal._(BigInt.one, BigInt.zero, 0);

  /// Getter para parte entera
  BigInt get integerPart => _integerPart;

  /// Getter para parte decimal
  BigInt get fractionalPart => _fractionalPart;

  /// Getter para escala
  int get scale => _scale;

  /// Verifica si es cero
  bool get isZero => _integerPart == BigInt.zero && _fractionalPart == BigInt.zero;

  /// Verifica si es negativo
  bool get isNegative => _integerPart < BigInt.zero || (_integerPart == BigInt.zero && _fractionalPart < BigInt.zero);

  /// Verifica si es positivo
  bool get isPositive => !isNegative && !isZero;

  /// Suma
  BigDecimal operator +(BigDecimal other) {
    // Normalizar ambos operandos a la misma escala y sumar como enteros
    // escalados. La re-canonicalización (vía _fromTotal) garantiza signos
    // consistentes incluso cuando la suma cruza el cero (p. ej. 1.0 + (-0.5)).
    int maxScale = math.max(_scale, other._scale);

    BigInt totalThis =
        _toTotalDecimal() * BigInt.from(10).pow(maxScale - _scale);
    BigInt totalOther =
        other._toTotalDecimal() * BigInt.from(10).pow(maxScale - other._scale);

    return BigDecimal._fromTotal(totalThis + totalOther, maxScale);
  }

  /// Resta
  BigDecimal operator -(BigDecimal other) {
    return this + (-other);
  }

  /// Negación
  BigDecimal operator -() {
    return BigDecimal._(-_integerPart, -_fractionalPart, _scale);
  }

  /// Multiplicación
  BigDecimal operator *(BigDecimal other) {
    // (a · 10^sa) · (b · 10^sb) = (a·b) · 10^(sa+sb)
    BigInt result = _toTotalDecimal() * other._toTotalDecimal();
    return BigDecimal._fromTotal(result, _scale + other._scale);
  }

  /// División
  BigDecimal operator /(BigDecimal other) {
    if (other.isZero) {
      throw ArgumentError(trLocale('División por cero', 'Division by zero'));
    }

  // Convertir a forma decimal completa con precisión extra.
  // Para preservar suficientes decimales independientemente de la escala del denominador,
  // multiplicamos el numerador por 10^(extraPrecision + other._scale).
  // Luego configuramos la escala final a (extraPrecision + _scale).
  // Así, el valor representado será: floor((A * 10^(p + sb)) / B) / 10^(p + sa)
  // que equivale a (A/B) * 10^(sb - sa), es decir, a / b.
  int extraPrecision = maxDecimalPlaces;
  final int p = extraPrecision;
  final int sa = _scale;
  final int sb = other._scale;

  BigInt A = _toTotalDecimal();
  BigInt B = other._toTotalDecimal();

  BigInt scaledNumerator = A * BigInt.from(10).pow(p + sb);
  BigInt result = scaledNumerator ~/ B; // truncamiento intencional

  // La escala final se basa en la escala del numerador + precisión extra
  int newScale = p + sa;

    // _fromTotal maneja la re-canonicalización (signos consistentes) y el
    // caso de escala negativa.
    return BigDecimal._fromTotal(result, newScale);
  }

  /// Potencia
  BigDecimal pow(int exponent) {
    if (exponent == 0) return BigDecimal.one;
    if (exponent == 1) return this;
    if (exponent < 0) return BigDecimal.one / pow(-exponent);
    
    BigDecimal result = BigDecimal.one;
    BigDecimal base = this;
    
    while (exponent > 0) {
      if (exponent % 2 == 1) {
        result = result * base;
      }
      base = base * base;
      exponent ~/= 2;
    }
    
    return result;
  }

  /// Raíz cuadrada, exacta a [maxDecimalPlaces] decimales (truncada).
  ///
  /// Trabaja sobre enteros: √(t/10^s) = ⌊√(t·10^(2p−s))⌋ / 10^p. La versión
  /// anterior pasaba por `double.toString()`, cuya notación científica
  /// (≥ 1e21) corrompía el resultado (√10^44 devolvía 0).
  BigDecimal sqrt() {
    if (isNegative) {
      throw ArgumentError(trLocale('Raíz cuadrada de número negativo', 'Square root of a negative number'));
    }
    if (isZero) return BigDecimal.zero;
    if (this == BigDecimal.one) return BigDecimal.one;

    const int p = maxDecimalPlaces;
    // La escala interna puede superar p (p. ej. tras dividir); el desfase
    // negativo se trunca, lo que solo descarta decimales más allá de 2p.
    final int shift = 2 * p - _scale;
    final BigInt scaled = shift >= 0
        ? _toTotalDecimal() * BigInt.from(10).pow(shift)
        : _toTotalDecimal() ~/ BigInt.from(10).pow(-shift);
    return BigDecimal._fromTotal(_sqrtBigInt(scaled), p);
  }

  /// ⌊√n⌋ por Newton entero con estimación inicial 2^⌈bits/2⌉ (≥ √n, decrece
  /// monótonamente hasta la raíz).
  static BigInt _sqrtBigInt(BigInt n) {
    if (n < BigInt.two) return n;
    BigInt x = BigInt.one << ((n.bitLength + 1) >> 1);
    while (true) {
      final BigInt y = (x + n ~/ x) >> 1;
      if (y >= x) return x;
      x = y;
    }
  }

  /// Raíz cúbica, exacta a [maxDecimalPlaces] decimales (truncada).
  /// ∛(t/10^s) = ⌊∛(t·10^(3p−s))⌋ / 10^p, todo en enteros.
  BigDecimal cbrt() {
    if (isZero) return BigDecimal.zero;
    // Manejo de negativos: la raíz cúbica de negativo es negativa
    if (isNegative) {
      return -((-this).cbrt());
    }

    const int p = maxDecimalPlaces;
    final int shift = 3 * p - _scale;
    final BigInt scaled = shift >= 0
        ? _toTotalDecimal() * BigInt.from(10).pow(shift)
        : _toTotalDecimal() ~/ BigInt.from(10).pow(-shift);
    return BigDecimal._fromTotal(_cbrtBigInt(scaled), p);
  }

  /// ⌊∛n⌋ por Newton entero, con ajuste final por si la iteración se detiene
  /// a ±1 de la raíz.
  static BigInt _cbrtBigInt(BigInt n) {
    if (n < BigInt.two) return n;
    final BigInt three = BigInt.from(3);
    BigInt x = BigInt.one << (n.bitLength ~/ 3 + 1);
    while (true) {
      final BigInt y = (BigInt.two * x + n ~/ (x * x)) ~/ three;
      if (y >= x) break;
      x = y;
    }
    while (x * x * x > n) {
      x -= BigInt.one;
    }
    while ((x + BigInt.one) * (x + BigInt.one) * (x + BigInt.one) <= n) {
      x += BigInt.one;
    }
    return x;
  }

  /// Valor absoluto
  BigDecimal abs() {
    return isNegative ? -this : this;
  }

  /// Comparación
  int compareTo(BigDecimal other) {
    // Comparar partes enteras primero
    int integerComparison = _integerPart.compareTo(other._integerPart);
    if (integerComparison != 0) return integerComparison;
    
    // Normalizar escalas y comparar partes decimales
    int maxScale = math.max(_scale, other._scale);
    BigInt thisNormalizedFrac = _normalizeScale(_fractionalPart, _scale, maxScale);
    BigInt otherNormalizedFrac = _normalizeScale(other._fractionalPart, other._scale, maxScale);
    
    return thisNormalizedFrac.compareTo(otherNormalizedFrac);
  }

  /// Operadores de comparación
  @override
  bool operator ==(Object other) {
    if (other is BigDecimal) {
      return compareTo(other) == 0;
    }
    return false;
  }

  bool operator <(BigDecimal other) => compareTo(other) < 0;
  bool operator >(BigDecimal other) => compareTo(other) > 0;
  bool operator <=(BigDecimal other) => compareTo(other) <= 0;
  bool operator >=(BigDecimal other) => compareTo(other) >= 0;

  @override
  int get hashCode => _integerPart.hashCode ^ _fractionalPart.hashCode ^ _scale.hashCode;

  /// Convertir a string sin notación científica
  @override
  String toString() {
    if (isZero) return '0';

    // El signo se determina con isNegative porque la parte entera puede ser 0
    // para valores negativos pequeños (p. ej. -0.5 tiene integerPart == 0).
    final String sign = isNegative ? '-' : '';
    final String integerStr = _integerPart.abs().toString();

    if (_fractionalPart == BigInt.zero || _scale == 0) {
      return '$sign$integerStr';
    }

    String fractionalStr = _fractionalPart.abs().toString();

    // Rellenar con ceros a la izquierda si es necesario
    while (fractionalStr.length < _scale) {
      fractionalStr = '0$fractionalStr';
    }

    // Remover ceros finales
    fractionalStr = fractionalStr.replaceAll(RegExp(r'0+$'), '');

    if (fractionalStr.isEmpty) {
      return '$sign$integerStr';
    }

    return '$sign$integerStr.$fractionalStr';
  }

  /// Convertir a representación binaria
  String toBinary() {
    if (isZero) return '0';
    
    String integerBinary = _integerPart.abs().toRadixString(2);
    String result = isNegative ? '-$integerBinary' : integerBinary;
    
    if (_fractionalPart != BigInt.zero && _scale > 0) {
      // Convertir parte decimal a binario (aproximación)
      double decimalValue = _fractionalPart.abs().toDouble() / math.pow(10, _scale);
      String fractionalBinary = _decimalToBinary(decimalValue);
      if (fractionalBinary.isNotEmpty) {
        result += '.$fractionalBinary';
      }
    }
    
    return result;
  }

  /// Métodos auxiliares
  BigInt _normalizeScale(BigInt fractionalPart, int currentScale, int targetScale) {
    if (currentScale == targetScale) return fractionalPart;
    
    if (currentScale < targetScale) {
      return fractionalPart * BigInt.from(10).pow(targetScale - currentScale);
    } else {
      return fractionalPart ~/ BigInt.from(10).pow(currentScale - targetScale);
    }
  }

  BigInt _toTotalDecimal() {
    if (_scale == 0) return _integerPart;
    return _integerPart * BigInt.from(10).pow(_scale) + _fractionalPart;
  }

  String _decimalToBinary(double decimal) {
    if (decimal == 0) return '';
    
    String result = '';
    int maxIterations = 20; // Limitar precisión
    
    for (int i = 0; i < maxIterations && decimal > 0; i++) {
      decimal *= 2;
      if (decimal >= 1) {
        result += '1';
        decimal -= 1;
      } else {
        result += '0';
      }
    }
    
    return result;
  }

  /// Convertir a double (puede perder precisión para valores muy grandes)
  double toDouble() {
    // Parsing from the string representation avoids precision loss that occurs
    // when _fractionalPart exceeds 2^53 and cannot round-trip through double.
    return double.parse(toString());
  }

  /// Crear copia con precisión ajustada
  BigDecimal withPrecision(int precision) {
    if (precision >= _scale) return this;
    
    BigInt newFractionalPart = _fractionalPart ~/ BigInt.from(10).pow(_scale - precision);
    return BigDecimal._(integerPart, newFractionalPart, precision);
  }
}
