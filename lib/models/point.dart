import 'dart:math' as math;
import 'fraction.dart';

/// Punto 2D con coordenadas racionales exactas.
///
/// Usar `Fraction` permite calcular áreas (shoelace) y otras cantidades de
/// geometría analítica de forma exacta, sin pérdida por punto flotante.
class Point {
  final Fraction x;
  final Fraction y;

  const Point(this.x, this.y);

  factory Point.ints(int x, int y) =>
      Point(Fraction.fromInt(x), Fraction.fromInt(y));

  /// Distancia al cuadrado (exacta).
  Fraction distanceSquaredTo(Point other) =>
      (x - other.x).pow(2) + (y - other.y).pow(2);

  /// Distancia euclidiana (aproximada en double).
  double distanceTo(Point other) =>
      math.sqrt(distanceSquaredTo(other).toDouble());

  @override
  String toString() => '($x, $y)';

  @override
  bool operator ==(Object other) =>
      other is Point && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}
