import 'package:math_expressions/math_expressions.dart';

/// Cálculo **numérico** sobre funciones de una variable `x`, parseadas con
/// `math_expressions` (p. ej. `x^2 + sin(x)`, `1/x`, `exp(x)`).
///
/// Trigonometría en radianes (convención de cálculo). Métodos rápidos (no
/// requieren isolate). Lanzan [FormatException] si la expresión no parsea.
class CalculusService {
  /// Compila la expresión a una función double→double (evalúa enlazando `x`).
  static double Function(double) _compile(String expr) {
    final parsed = ShuntingYardParser().parse(expr);
    final x = Variable('x');
    return (double v) {
      final cm = ContextModel()..bindVariable(x, Number(v));
      return parsed.evaluate(EvaluationType.REAL, cm) as double;
    };
  }

  /// Derivada f'(x₀) por diferencias centrales con extrapolación de Richardson.
  static double derivative(String expr, double at) {
    final f = _compile(expr);
    final h = (at.abs() > 1 ? at.abs() : 1.0) * 1e-5;
    double central(double step) => (f(at + step) - f(at - step)) / (2 * step);
    // Richardson: combina h y h/2 para cancelar el término O(h²).
    final d1 = central(h);
    final d2 = central(h / 2);
    return (4 * d2 - d1) / 3;
  }

  /// Integral definida ∫ₐᵇ f(x) dx por la regla de Simpson compuesta.
  static double integral(String expr, double a, double b, {int n = 1000}) {
    final f = _compile(expr);
    if (n.isOdd) n++; // Simpson requiere n par
    final h = (b - a) / n;
    double sum = f(a) + f(b);
    for (int i = 1; i < n; i++) {
      sum += (i.isOdd ? 4 : 2) * f(a + i * h);
    }
    return sum * h / 3;
  }

  /// Límite numérico de f en x₀ (aproximación bilateral). Devuelve `null` si
  /// los límites laterales no concuerdan (posible discontinuidad de salto).
  static double? limit(String expr, double at, {double tol = 1e-6}) {
    final f = _compile(expr);
    final deltas = [1e-3, 1e-4, 1e-5, 1e-6];
    double? left, right;
    for (final d in deltas) {
      final l = f(at - d), r = f(at + d);
      if (l.isFinite) left = l;
      if (r.isFinite) right = r;
    }
    if (left == null || right == null) return null;
    if ((left - right).abs() > tol * (1 + left.abs())) return null;
    return (left + right) / 2;
  }

  /// Evalúa f(x₀) directamente.
  static double evaluateAt(String expr, double at) => _compile(expr)(at);

  /// ¿Es un resultado utilizable (finito)?
  static bool isUsable(double v) => v.isFinite;
}
