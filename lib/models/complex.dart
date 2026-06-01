import 'dart:math' as math;
import 'calc_exception.dart';

/// Número complejo en coordenadas cartesianas (parte real e imaginaria).
///
/// Incluye De Moivre (potencias), raíces n-ésimas y raíces de la unidad,
/// herramientas habituales en problemas de olimpiada.
class Complex {
  final double re;
  final double im;

  const Complex(this.re, this.im);

  factory Complex.fromPolar(double modulus, double argument) =>
      Complex(modulus * math.cos(argument), modulus * math.sin(argument));

  static const Complex zero = Complex(0, 0);
  static const Complex one = Complex(1, 0);
  static const Complex i = Complex(0, 1);

  Complex operator +(Complex o) => Complex(re + o.re, im + o.im);
  Complex operator -(Complex o) => Complex(re - o.re, im - o.im);
  Complex operator *(Complex o) =>
      Complex(re * o.re - im * o.im, re * o.im + im * o.re);

  Complex operator /(Complex o) {
    final double d = o.re * o.re + o.im * o.im;
    if (d == 0) throw CalcException(CalcError.divisionByZero);
    return Complex((re * o.re + im * o.im) / d, (im * o.re - re * o.im) / d);
  }

  Complex operator -() => Complex(-re, -im);

  Complex conjugate() => Complex(re, -im);

  double get modulus => math.sqrt(re * re + im * im);
  double get argument => math.atan2(im, re);

  /// Potencia entera mediante De Moivre.
  Complex pow(int n) {
    if (n == 0) return one;
    final double r = math.pow(modulus, n).toDouble();
    final double theta = argument * n;
    return Complex.fromPolar(r, theta);
  }

  /// Las n raíces n-ésimas de este número complejo.
  List<Complex> nthRoots(int n) {
    if (n < 1) throw CalcException(CalcError.nPositive);
    final double r = math.pow(modulus, 1 / n).toDouble();
    final double theta = argument;
    return List.generate(n, (k) {
      final double angle = (theta + 2 * math.pi * k) / n;
      return Complex.fromPolar(r, angle);
    });
  }

  /// Las n raíces n-ésimas de la unidad: e^(2πik/n).
  static List<Complex> rootsOfUnity(int n) {
    if (n < 1) throw CalcException(CalcError.nPositive);
    return List.generate(n, (k) {
      final double angle = 2 * math.pi * k / n;
      return Complex(math.cos(angle), math.sin(angle));
    });
  }

  /// Comparación aproximada (para tolerar el redondeo de punto flotante).
  bool approxEquals(Complex o, [double tol = 1e-9]) =>
      (re - o.re).abs() <= tol && (im - o.im).abs() <= tol;

  @override
  bool operator ==(Object other) =>
      other is Complex && re == other.re && im == other.im;

  @override
  int get hashCode => Object.hash(re, im);

  @override
  String toString() {
    String fmt(double v) {
      final r = (v * 1e9).roundToDouble() / 1e9; // limpiar ruido
      if (r == r.roundToDouble()) return r.toInt().toString();
      return r.toString();
    }

    if (im == 0) return fmt(re);
    if (re == 0) return '${fmt(im)}i';
    final String sign = im < 0 ? '-' : '+';
    return '${fmt(re)} $sign ${fmt(im.abs())}i';
  }
}
