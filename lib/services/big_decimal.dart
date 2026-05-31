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
