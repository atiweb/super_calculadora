import 'dart:math' as math;
import '../utils/app_locale.dart';

/// Custom class for handling arbitrary-precision decimal numbers
/// Simulates 1024 integer bits + 64 decimal bits
class BigDecimal {
  final BigInt _integerPart;
  final BigInt _fractionalPart;
  final int _scale; // Number of decimal digits

  static const int maxDecimalPlaces = 20; // Simulates 64 decimal bits

  BigDecimal._(this._integerPart, this._fractionalPart, this._scale);

  /// Constructor from string. Accepts scientific notation ("1e+25",
  /// "3.16e-7"), expanding it to plain form. Throws [FormatException] if the
  /// text is not a number: silently degrading to 0 (the previous
  /// behavior) corrupted roots, powers and the formatting of large
  /// results, because `double.toString()` emits an exponent from 1e21.
  factory BigDecimal.fromString(String value) {
    if (value.isEmpty) {
      return BigDecimal.zero;
    }

    value = value.trim();

    // Expand scientific notation before splitting.
    final Match? expMatch =
        RegExp(r'^([+-]?[0-9]*\.?[0-9]+)[eE]([+-]?[0-9]+)$').firstMatch(value);
    if (expMatch != null) {
      value = _expandScientific(
          expMatch.group(1)!, int.parse(expMatch.group(2)!));
    }

    // Handle sign
    bool isNegative = value.startsWith('-');
    if (isNegative || value.startsWith('+')) {
      value = value.substring(1);
    }

    // Split into integer and decimal parts
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
      // Limit to maxDecimalPlaces decimal digits
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

  /// Expands "mantissa × 10^exponent" to a plain decimal literal.
  static String _expandScientific(String mantissa, int exponent) {
    final bool neg = mantissa.startsWith('-');
    if (neg || mantissa.startsWith('+')) {
      mantissa = mantissa.substring(1);
    }
    final int dot = mantissa.indexOf('.');
    final String digits = mantissa.replaceAll('.', '');
    // Position of the decimal point within `digits` after applying the exponent
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

  /// Constructor from BigInt
  factory BigDecimal.fromBigInt(BigInt value) {
    return BigDecimal._(value, BigInt.zero, 0);
  }

  /// Constructor from int
  factory BigDecimal.fromInt(int value) {
    return BigDecimal._(BigInt.from(value), BigInt.zero, 0);
  }

  /// Constructor from double
  factory BigDecimal.fromDouble(double value) {
    return BigDecimal.fromString(value.toString());
  }

  /// Builds a BigDecimal from a scaled integer value (total)
  /// and its scale, guaranteeing that the integer part and the fractional
  /// part share the same sign as the actual value.
  ///
  /// Uses truncation toward zero (`~/`) and `remainder` (whose sign matches
  /// the dividend's) so that the invariant
  ///   total = integerPart * 10^scale + fractionalPart
  /// holds with consistent signs. This avoids states like
  /// (integerPart > 0, fractionalPart < 0) that break `toString`.
  factory BigDecimal._fromTotal(BigInt total, int scale) {
    if (scale <= 0) {
      // The value is an integer (possibly rescaled by 10^(-scale)).
      if (scale < 0) {
        total = total * BigInt.from(10).pow(-scale);
      }
      return BigDecimal._(total, BigInt.zero, 0);
    }

    final BigInt scaleMultiplier = BigInt.from(10).pow(scale);
    final BigInt integerPart = total ~/ scaleMultiplier; // truncates toward zero
    final BigInt fractionalPart =
        total.remainder(scaleMultiplier); // sign = sign of total
    return BigDecimal._(integerPart, fractionalPart, scale);
  }

  /// Zero constant
  static final BigDecimal zero = BigDecimal._(BigInt.zero, BigInt.zero, 0);

  /// One constant
  static final BigDecimal one = BigDecimal._(BigInt.one, BigInt.zero, 0);

  /// Getter for the integer part
  BigInt get integerPart => _integerPart;

  /// Getter for the decimal part
  BigInt get fractionalPart => _fractionalPart;

  /// Getter for the scale
  int get scale => _scale;

  /// Checks whether it is zero
  bool get isZero => _integerPart == BigInt.zero && _fractionalPart == BigInt.zero;

  /// Checks whether it is negative
  bool get isNegative => _integerPart < BigInt.zero || (_integerPart == BigInt.zero && _fractionalPart < BigInt.zero);

  /// Checks whether it is positive
  bool get isPositive => !isNegative && !isZero;

  /// Addition
  BigDecimal operator +(BigDecimal other) {
    // Normalize both operands to the same scale and add as scaled
    // integers. Re-canonicalization (via _fromTotal) guarantees consistent
    // signs even when the sum crosses zero (e.g. 1.0 + (-0.5)).
    int maxScale = math.max(_scale, other._scale);

    BigInt totalThis =
        _toTotalDecimal() * BigInt.from(10).pow(maxScale - _scale);
    BigInt totalOther =
        other._toTotalDecimal() * BigInt.from(10).pow(maxScale - other._scale);

    return BigDecimal._fromTotal(totalThis + totalOther, maxScale);
  }

  /// Subtraction
  BigDecimal operator -(BigDecimal other) {
    return this + (-other);
  }

  /// Negation
  BigDecimal operator -() {
    return BigDecimal._(-_integerPart, -_fractionalPart, _scale);
  }

  /// Multiplication
  BigDecimal operator *(BigDecimal other) {
    // (a · 10^sa) · (b · 10^sb) = (a·b) · 10^(sa+sb)
    BigInt result = _toTotalDecimal() * other._toTotalDecimal();
    return BigDecimal._fromTotal(result, _scale + other._scale);
  }

  /// Division
  BigDecimal operator /(BigDecimal other) {
    if (other.isZero) {
      throw ArgumentError(trLocale('División por cero', 'Division by zero'));
    }

  // Convert to full decimal form with extra precision.
  // To preserve enough decimals regardless of the denominator's scale,
  // we multiply the numerator by 10^(extraPrecision + other._scale).
  // Then we set the final scale to (extraPrecision + _scale).
  // Thus, the represented value will be: floor((A * 10^(p + sb)) / B) / 10^(p + sa)
  // which is equivalent to (A/B) * 10^(sb - sa), that is, a / b.
  int extraPrecision = maxDecimalPlaces;
  final int p = extraPrecision;
  final int sa = _scale;
  final int sb = other._scale;

  BigInt A = _toTotalDecimal();
  BigInt B = other._toTotalDecimal();

  BigInt scaledNumerator = A * BigInt.from(10).pow(p + sb);
  BigInt result = scaledNumerator ~/ B; // intentional truncation

  // The final scale is based on the numerator's scale + extra precision
  int newScale = p + sa;

    // Never exceed the precision the class can represent. Chained divisions
    // reached scale 40 while fromString clips at 20, so toString showed 40
    // decimals that vanished the moment the display was re-parsed for the next
    // operation — digits presented as exact that the type cannot round-trip.
    if (newScale > maxDecimalPlaces) {
      result ~/= BigInt.from(10).pow(newScale - maxDecimalPlaces);
      newScale = maxDecimalPlaces;
    }

    // _fromTotal handles re-canonicalization (consistent signs) and the
    // negative-scale case.
    return BigDecimal._fromTotal(result, newScale);
  }

  /// Power
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

  /// Square root, exact to [maxDecimalPlaces] decimals (truncated).
  ///
  /// Works on integers: √(t/10^s) = ⌊√(t·10^(2p−s))⌋ / 10^p. The previous
  /// version went through `double.toString()`, whose scientific notation
  /// (≥ 1e21) corrupted the result (√10^44 returned 0).
  BigDecimal sqrt() {
    if (isNegative) {
      throw ArgumentError(trLocale('Raíz cuadrada de número negativo', 'Square root of a negative number'));
    }
    if (isZero) return BigDecimal.zero;
    if (this == BigDecimal.one) return BigDecimal.one;

    const int p = maxDecimalPlaces;
    // The internal scale can exceed p (e.g. after dividing); the negative
    // offset is truncated, which only discards decimals beyond 2p.
    final int shift = 2 * p - _scale;
    final BigInt scaled = shift >= 0
        ? _toTotalDecimal() * BigInt.from(10).pow(shift)
        : _toTotalDecimal() ~/ BigInt.from(10).pow(-shift);
    return BigDecimal._fromTotal(_sqrtBigInt(scaled), p);
  }

  /// ⌊√n⌋ by integer Newton with initial estimate 2^⌈bits/2⌉ (≥ √n, decreases
  /// monotonically down to the root).
  static BigInt _sqrtBigInt(BigInt n) {
    if (n < BigInt.two) return n;
    BigInt x = BigInt.one << ((n.bitLength + 1) >> 1);
    while (true) {
      final BigInt y = (x + n ~/ x) >> 1;
      if (y >= x) return x;
      x = y;
    }
  }

  /// Cube root, exact to [maxDecimalPlaces] decimals (truncated).
  /// ∛(t/10^s) = ⌊∛(t·10^(3p−s))⌋ / 10^p, all in integers.
  BigDecimal cbrt() {
    if (isZero) return BigDecimal.zero;
    // Handling negatives: the cube root of a negative is negative
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

  /// ⌊∛n⌋ by integer Newton, with a final adjustment in case the iteration
  /// stops at ±1 from the root.
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

  /// Absolute value
  BigDecimal abs() {
    return isNegative ? -this : this;
  }

  /// Comparison
  int compareTo(BigDecimal other) {
    // Compare integer parts first
    int integerComparison = _integerPart.compareTo(other._integerPart);
    if (integerComparison != 0) return integerComparison;
    
    // Normalize scales and compare decimal parts
    int maxScale = math.max(_scale, other._scale);
    BigInt thisNormalizedFrac = _normalizeScale(_fractionalPart, _scale, maxScale);
    BigInt otherNormalizedFrac = _normalizeScale(other._fractionalPart, other._scale, maxScale);
    
    return thisNormalizedFrac.compareTo(otherNormalizedFrac);
  }

  /// Comparison operators
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

  /// Must agree with [==], which compares by VALUE across scales. Hashing the
  /// raw representation broke the contract: 1.5 and 1.50 are equal yet hashed
  /// differently, so a Set or Map key would have silently duplicated them.
  @override
  int get hashCode {
    // Strip trailing zeros so equal values hash equally: 1.5 and 1.50 compare
    // equal but hashed differently, breaking the ==/hashCode contract and
    // silently duplicating entries in any Set or Map keyed by BigDecimal.
    final BigInt ten = BigInt.from(10);
    BigInt fraction = _fractionalPart;
    int scale = _scale;
    while (scale > 0 && fraction != BigInt.zero && fraction % ten == BigInt.zero) {
      fraction ~/= ten;
      scale--;
    }
    if (fraction == BigInt.zero) scale = 0;
    return Object.hash(_integerPart, fraction, scale);
  }

  /// Convert to string without scientific notation
  @override
  String toString() {
    if (isZero) return '0';

    // The sign is determined with isNegative because the integer part can be 0
    // for small negative values (e.g. -0.5 has integerPart == 0).
    final String sign = isNegative ? '-' : '';
    final String integerStr = _integerPart.abs().toString();

    if (_fractionalPart == BigInt.zero || _scale == 0) {
      return '$sign$integerStr';
    }

    String fractionalStr = _fractionalPart.abs().toString();

    // Pad with leading zeros if needed
    while (fractionalStr.length < _scale) {
      fractionalStr = '0$fractionalStr';
    }

    // Remove trailing zeros
    fractionalStr = fractionalStr.replaceAll(RegExp(r'0+$'), '');

    if (fractionalStr.isEmpty) {
      return '$sign$integerStr';
    }

    return '$sign$integerStr.$fractionalStr';
  }

  /// Convert to binary representation
  String toBinary() {
    if (isZero) return '0';
    
    String integerBinary = _integerPart.abs().toRadixString(2);
    String result = isNegative ? '-$integerBinary' : integerBinary;
    
    if (_fractionalPart != BigInt.zero && _scale > 0) {
      // Convert the decimal part to binary (approximation)
      double decimalValue = _fractionalPart.abs().toDouble() / math.pow(10, _scale);
      String fractionalBinary = _decimalToBinary(decimalValue);
      if (fractionalBinary.isNotEmpty) {
        result += '.$fractionalBinary';
      }
    }
    
    return result;
  }

  /// Helper methods
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
    int maxIterations = 20; // Limit precision
    
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

  /// Convert to double (may lose precision for very large values)
  double toDouble() {
    // Parsing from the string representation avoids precision loss that occurs
    // when _fractionalPart exceeds 2^53 and cannot round-trip through double.
    return double.parse(toString());
  }

  /// Create a copy with adjusted precision
  BigDecimal withPrecision(int precision) {
    if (precision >= _scale) return this;
    
    BigInt newFractionalPart = _fractionalPart ~/ BigInt.from(10).pow(_scale - precision);
    return BigDecimal._(integerPart, newFractionalPart, precision);
  }
}
