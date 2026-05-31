import 'dart:math' as math;

/// Clase personalizada para manejar números decimales de precisión arbitraria
/// Simula 1024 bits enteros + 64 bits decimales
class BigDecimal {
  final BigInt _integerPart;
  final BigInt _fractionalPart;
  final int _scale; // Número de dígitos decimales

  static const int maxDecimalPlaces = 20; // Simula 64 bits decimales

  BigDecimal._(this._integerPart, this._fractionalPart, this._scale);

  /// Constructor desde string
  factory BigDecimal.fromString(String value) {
    if (value.isEmpty) {
      return BigDecimal.zero;
    }

    // Remover espacios y validar formato
    value = value.trim();
    
    // Manejar signo negativo
    bool isNegative = value.startsWith('-');
    if (isNegative) {
      value = value.substring(1);
    }

    // Dividir en parte entera y decimal
    List<String> parts = value.split('.');
    
    BigInt integerPart = BigInt.tryParse(parts[0]) ?? BigInt.zero;
    BigInt fractionalPart = BigInt.zero;
    int scale = 0;

    if (parts.length > 1) {
      String decimalStr = parts[1];
      // Limitar a maxDecimalPlaces dígitos decimales
      if (decimalStr.length > maxDecimalPlaces) {
        decimalStr = decimalStr.substring(0, maxDecimalPlaces);
      }
      
      fractionalPart = BigInt.tryParse(decimalStr) ?? BigInt.zero;
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
    // Normalizar escalas
    int maxScale = math.max(_scale, other._scale);
    
    BigInt thisNormalizedFrac = _normalizeScale(_fractionalPart, _scale, maxScale);
    BigInt otherNormalizedFrac = _normalizeScale(other._fractionalPart, other._scale, maxScale);
    
    // Sumar partes
    BigInt newIntegerPart = _integerPart + other._integerPart;
    BigInt newFractionalPart = thisNormalizedFrac + otherNormalizedFrac;
    
    // Manejar carry
    BigInt scaleMultiplier = BigInt.from(10).pow(maxScale);
    if (newFractionalPart.abs() >= scaleMultiplier) {
      BigInt carry = newFractionalPart ~/ scaleMultiplier;
      newIntegerPart += carry;
      newFractionalPart = newFractionalPart % scaleMultiplier;
    }
    
    return BigDecimal._(newIntegerPart, newFractionalPart, maxScale);
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
    // Convertir a forma decimal completa
    BigInt thisTotal = _toTotalDecimal();
    BigInt otherTotal = other._toTotalDecimal();
    
    // Multiplicar
    BigInt result = thisTotal * otherTotal;
    
    // Ajustar escala
    int newScale = _scale + other._scale;
    
    // Convertir de vuelta
    BigInt scaleMultiplier = BigInt.from(10).pow(newScale);
    BigInt newIntegerPart = result ~/ scaleMultiplier;
    BigInt newFractionalPart = result % scaleMultiplier;
    
    return BigDecimal._(newIntegerPart, newFractionalPart, newScale);
  }

  /// División
  BigDecimal operator /(BigDecimal other) {
    if (other.isZero) {
      throw ArgumentError('División por cero');
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
    
    // Manejar escalas negativas
    if (newScale < 0) {
      // Si la escala es negativa, multiplicar el resultado por 10^(-newScale)
      BigInt multiplier = BigInt.from(10).pow(-newScale);
      result = result * multiplier;
      newScale = 0;
    }
    
    // Convertir de vuelta
    BigInt scaleMultiplier = BigInt.from(10).pow(newScale);
    BigInt newIntegerPart = result ~/ scaleMultiplier;
    BigInt newFractionalPart = result % scaleMultiplier;

    return BigDecimal._(newIntegerPart, newFractionalPart, newScale);
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

  /// Raíz cuadrada (aproximación)
  BigDecimal sqrt() {
    if (isNegative) {
      throw ArgumentError('Raíz cuadrada de número negativo');
    }
    if (isZero) return BigDecimal.zero;
    if (this == BigDecimal.one) return BigDecimal.one;
    
    // Para números simples, usar la función sqrt de dart y convertir
    try {
      double thisAsDouble = double.parse(toString());
      if (!thisAsDouble.isInfinite && !thisAsDouble.isNaN) {
        double sqrtResult = math.sqrt(thisAsDouble);
        if (!sqrtResult.isInfinite && !sqrtResult.isNaN) {
          return BigDecimal.fromString(sqrtResult.toString());
        }
      }
    } catch (e) {
      // Si falla la conversión, usar método de Newton-Raphson
    }
    
    // Usar método de Newton-Raphson como respaldo
    BigDecimal x = this;
    BigDecimal two = BigDecimal.fromInt(2);
    
    // Mejor aproximación inicial
    if (this > BigDecimal.one) {
      x = this / two; // Empezar con la mitad del número
    } else {
      x = this; // Para números entre 0 y 1
    }
    
    // Iterar hasta convergencia
    for (int i = 0; i < 100; i++) {
      BigDecimal xPrev = x;
      try {
        x = (x + (this / x)) / two;
        
        // Verificar convergencia con mayor precisión
        BigDecimal diff = (x - xPrev).abs();
        if (diff < BigDecimal.fromString('0.000000000001')) {
          break;
        }
      } catch (e) {
        // Si hay error en la división, devolver la aproximación actual
        break;
      }
    }
    
    return x;
  }

  /// Raíz cúbica (aproximación)
  BigDecimal cbrt() {
    if (isZero) return BigDecimal.zero;
    // Manejo de negativos: la raíz cúbica de negativo es negativa
    if (isNegative) {
      return (-this).cbrt() * BigDecimal.fromInt(-1);
    }

    // Intento rápido con double si es posible
    try {
      double thisAsDouble = double.parse(toString());
      if (!thisAsDouble.isInfinite && !thisAsDouble.isNaN) {
        double cbrtResult = thisAsDouble.sign * math.pow(thisAsDouble.abs(), 1 / 3).toDouble();
        if (!cbrtResult.isInfinite && !cbrtResult.isNaN) {
          return BigDecimal.fromString(cbrtResult.toString());
        }
      }
    } catch (e) {
      // caemos al método iterativo
    }

    // Método de Newton-Raphson para raíz cúbica
    BigDecimal x = this; // estimación inicial
    BigDecimal three = BigDecimal.fromInt(3);

    if (this > BigDecimal.one) {
      // estimación inicial mejorada
      x = this / three;
    }

    for (int i = 0; i < 100; i++) {
      BigDecimal xPrev = x;
      try {
        // x_{n+1} = (2x_n + N / x_n^2) / 3
        x = (x * BigDecimal.fromInt(2) + (this / (x * x))) / three;
        BigDecimal diff = (x - xPrev).abs();
        if (diff < BigDecimal.fromString('0.000000000001')) {
          break;
        }
      } catch (e) {
        break;
      }
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
    
    String integerStr = _integerPart.toString();
    
    if (_fractionalPart == BigInt.zero || _scale == 0) {
      return integerStr;
    }
    
    String fractionalStr = _fractionalPart.abs().toString();
    
    // Rellenar con ceros a la izquierda si es necesario
    while (fractionalStr.length < _scale) {
      fractionalStr = '0$fractionalStr';
    }
    
    // Remover ceros finales
    fractionalStr = fractionalStr.replaceAll(RegExp(r'0+$'), '');
    
    if (fractionalStr.isEmpty) {
      return integerStr;
    }
    
    return '$integerStr.$fractionalStr';
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
