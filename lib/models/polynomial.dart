import 'fraction.dart';

/// Polinomio en una variable con coeficientes racionales exactos.
///
/// Los coeficientes se almacenan de menor a mayor grado:
/// `coefficients[0]` es el término independiente. Se eliminan los ceros de
/// mayor grado, de modo que el coeficiente líder nunca es cero (salvo el
/// polinomio nulo, que tiene la lista vacía).
class Polynomial {
  final List<Fraction> coefficients;

  const Polynomial._(this.coefficients);

  /// Construye desde coeficientes (menor a mayor grado), recortando ceros líderes.
  factory Polynomial(List<Fraction> coeffs) {
    int last = coeffs.length - 1;
    while (last >= 0 && coeffs[last].isZero) {
      last--;
    }
    if (last < 0) return Polynomial._(const []);
    return Polynomial._(List.unmodifiable(coeffs.sublist(0, last + 1)));
  }

  factory Polynomial.fromInts(List<int> coeffs) =>
      Polynomial(coeffs.map((c) => Fraction.fromInt(c)).toList());

  /// Polinomio constante.
  factory Polynomial.constant(Fraction c) => Polynomial([c]);

  static final Polynomial zero = Polynomial._(const []);

  bool get isZero => coefficients.isEmpty;

  /// Grado del polinomio; el polinomio nulo tiene grado -1.
  int get degree => coefficients.length - 1;

  /// Coeficiente líder (de mayor grado); cero para el polinomio nulo.
  Fraction get leadingCoefficient =>
      isZero ? Fraction.zero : coefficients.last;

  Fraction coefficient(int power) =>
      (power >= 0 && power < coefficients.length)
          ? coefficients[power]
          : Fraction.zero;

  // ── Evaluación ─────────────────────────────────────────────────────────

  /// Evalúa el polinomio en [x] usando el método de Horner.
  Fraction evaluate(Fraction x) {
    Fraction result = Fraction.zero;
    for (int i = coefficients.length - 1; i >= 0; i--) {
      result = result * x + coefficients[i];
    }
    return result;
  }

  // ── Aritmética ───────────────────────────────────────────────────────────

  Polynomial operator +(Polynomial other) {
    final int n =
        coefficients.length > other.coefficients.length
            ? coefficients.length
            : other.coefficients.length;
    final List<Fraction> result = List.filled(n, Fraction.zero);
    for (int i = 0; i < n; i++) {
      result[i] = coefficient(i) + other.coefficient(i);
    }
    return Polynomial(result);
  }

  Polynomial operator -(Polynomial other) => this + (-other);

  Polynomial operator -() =>
      Polynomial(coefficients.map((c) => -c).toList());

  Polynomial operator *(Polynomial other) {
    if (isZero || other.isZero) return zero;
    final List<Fraction> result = List.filled(
        coefficients.length + other.coefficients.length - 1, Fraction.zero);
    for (int i = 0; i < coefficients.length; i++) {
      for (int j = 0; j < other.coefficients.length; j++) {
        result[i + j] = result[i + j] + coefficients[i] * other.coefficients[j];
      }
    }
    return Polynomial(result);
  }

  Polynomial scale(Fraction factor) =>
      Polynomial(coefficients.map((c) => c * factor).toList());

  /// Derivada formal.
  Polynomial derivative() {
    if (degree < 1) return zero;
    final List<Fraction> result = [];
    for (int i = 1; i < coefficients.length; i++) {
      result.add(coefficients[i] * Fraction.fromInt(i));
    }
    return Polynomial(result);
  }

  /// División con resto: devuelve (cociente, resto) tales que
  /// this = cociente·divisor + resto, con grado(resto) < grado(divisor).
  ({Polynomial quotient, Polynomial remainder}) divMod(Polynomial divisor) {
    if (divisor.isZero) {
      throw ArgumentError('División entre el polinomio nulo');
    }
    List<Fraction> rem = List.of(coefficients);
    final List<Fraction> quot =
        List.filled(degree - divisor.degree + 1 > 0 ? degree - divisor.degree + 1 : 0,
            Fraction.zero);

    final int dDeg = divisor.degree;
    final Fraction dLead = divisor.leadingCoefficient;

    for (int i = degree - dDeg; i >= 0; i--) {
      final int remDeg = rem.length - 1;
      if (remDeg < dDeg + i) continue;
      final Fraction factor = rem[dDeg + i] / dLead;
      quot[i] = factor;
      for (int j = 0; j <= dDeg; j++) {
        rem[i + j] = rem[i + j] - factor * divisor.coefficients[j];
      }
    }

    return (quotient: Polynomial(quot), remainder: Polynomial(rem));
  }

  /// Resto de la división (this mod divisor).
  Polynomial operator %(Polynomial divisor) => divMod(divisor).remainder;

  /// Convierte a polinomio mónico (coeficiente líder 1) dividiendo por el líder.
  Polynomial toMonic() {
    if (isZero) return this;
    return scale(leadingCoefficient.reciprocal());
  }

  // ── Formato ────────────────────────────────────────────────────────────

  @override
  String toString() {
    if (isZero) return '0';
    final List<String> terms = [];
    for (int i = coefficients.length - 1; i >= 0; i--) {
      final Fraction c = coefficients[i];
      if (c.isZero) continue;

      final bool neg = c.isNegative;
      final Fraction mag = c.abs();
      final String sign = terms.isEmpty ? (neg ? '-' : '') : (neg ? ' - ' : ' + ');

      String body;
      final bool magIsOne = mag == Fraction.one;
      if (i == 0) {
        body = mag.toString();
      } else if (i == 1) {
        body = magIsOne ? 'x' : '${mag}x';
      } else {
        body = magIsOne ? 'x^$i' : '${mag}x^$i';
      }
      terms.add('$sign$body');
    }
    return terms.join();
  }

  @override
  bool operator ==(Object other) {
    if (other is! Polynomial) return false;
    if (coefficients.length != other.coefficients.length) return false;
    for (int i = 0; i < coefficients.length; i++) {
      if (coefficients[i] != other.coefficients[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(coefficients);
}
