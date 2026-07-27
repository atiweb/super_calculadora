import 'package:math_expressions/math_expressions.dart';

/// **Numerical** calculus on functions of one variable `x`, parsed with
/// `math_expressions` (e.g. `x^2 + sin(x)`, `1/x`, `exp(x)`).
///
/// Trigonometry in radians (calculus convention). Fast methods (no
/// isolate needed). They throw [FormatException] if the expression does not parse.
class CalculusService {
  /// Compiles the expression to a double→double function (evaluates by binding `x`).
  static double Function(double) _compile(String expr) {
    final parsed = ShuntingYardParser().parse(expr);
    final x = Variable('x');
    return (double v) {
      final cm = ContextModel()..bindVariable(x, Number(v));
      return parsed.evaluate(EvaluationType.REAL, cm) as double;
    };
  }

  /// Derivative f'(x₀) via central differences with Richardson extrapolation.
  static double derivative(String expr, double at) {
    final f = _compile(expr);
    final h = (at.abs() > 1 ? at.abs() : 1.0) * 1e-5;
    double central(double step) => (f(at + step) - f(at - step)) / (2 * step);
    // Richardson: combines h and h/2 to cancel the O(h²) term.
    final d1 = central(h);
    final d2 = central(h / 2);
    return (4 * d2 - d1) / 3;
  }

  /// Definite integral ∫ₐᵇ f(x) dx via the composite Simpson's rule.
  static double integral(String expr, double a, double b, {int n = 1000}) {
    final f = _compile(expr);
    // n < 2 used to produce NaN (n=0) or an incorrect finite value (negative n:
    // the loop never runs and a negative step is divided by).
    if (n < 2) n = 2;
    if (n.isOdd) n++; // Simpson requires even n
    final h = (b - a) / n;
    double sum = f(a) + f(b);
    for (int i = 1; i < n; i++) {
      sum += (i.isOdd ? 4 : 2) * f(a + i * h);
    }
    return sum * h / 3;
  }

  /// Numerical limit of f at x₀ (two-sided approximation). Returns `null` if
  /// the one-sided limits do not agree (possible jump discontinuity).
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

  /// Evaluates f(x₀) directly.
  static double evaluateAt(String expr, double at) => _compile(expr)(at);

  /// Is the result usable (finite)?
  static bool isUsable(double v) => v.isFinite;
}
