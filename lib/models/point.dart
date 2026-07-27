import 'dart:math' as math;
import 'fraction.dart';

/// 2D point with exact rational coordinates.
///
/// Using `Fraction` allows computing areas (shoelace) and other analytic
/// geometry quantities exactly, with no floating-point loss.
class Point {
  final Fraction x;
  final Fraction y;

  const Point(this.x, this.y);

  factory Point.ints(int x, int y) =>
      Point(Fraction.fromInt(x), Fraction.fromInt(y));

  /// Squared distance (exact).
  Fraction distanceSquaredTo(Point other) =>
      (x - other.x).pow(2) + (y - other.y).pow(2);

  /// Euclidean distance (approximated as double).
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
