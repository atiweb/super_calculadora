import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Draws a triangle from three side lengths (a, b, c) using the convention:
///   A = (0, 0),  B = (c, 0),  C computed via law of cosines.
///   Side a = BC,  side b = AC,  side c = AB.
class TrianglePainter extends CustomPainter {
  final double a, b, c;
  final Color strokeColor;
  final Color textColor;

  const TrianglePainter({
    required this.a,
    required this.b,
    required this.c,
    required this.strokeColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Vertex C: Cx = (b²+c²-a²)/(2c), Cy = sqrt(b²-Cx²)
    final double cx = (b * b + c * c - a * a) / (2 * c);
    final double cySquared = b * b - cx * cx;
    if (cySquared < 0) return; // degenerate
    final double cy = math.sqrt(cySquared);

    // Axis-aligned bounding box
    final double minX = math.min(0.0, math.min(c, cx));
    final double maxX = math.max(0.0, math.max(c, cx));
    final double triW = maxX - minX;
    final double triH = cy; // minY = 0 always

    const double pad = 36.0;
    final double scaleX = triW > 0 ? (size.width - 2 * pad) / triW : 1;
    final double scaleY = triH > 0 ? (size.height - 2 * pad) / triH : 1;
    final double scale = math.min(scaleX, scaleY);

    // Map model → canvas (flip y so y=0 is at bottom)
    Offset mp(double x, double y) => Offset(
          pad + (x - minX) * scale,
          size.height - pad - y * scale,
        );

    final Offset pA = mp(0, 0);
    final Offset pB = mp(c, 0);
    final Offset pC = mp(cx, cy);

    final Offset centroid = Offset(
      (pA.dx + pB.dx + pC.dx) / 3,
      (pA.dy + pB.dy + pC.dy) / 3,
    );

    final fillPaint = Paint()
      ..color = strokeColor.withAlpha(22)
      ..style = PaintingStyle.fill;

    final edgePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(pA.dx, pA.dy)
      ..lineTo(pB.dx, pB.dy)
      ..lineTo(pC.dx, pC.dy)
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, edgePaint);

    // Vertex dots and labels
    _dot(canvas, pA);
    _dot(canvas, pB);
    _dot(canvas, pC);
    _vertexLabel(canvas, pA, 'A', centroid);
    _vertexLabel(canvas, pB, 'B', centroid);
    _vertexLabel(canvas, pC, 'C', centroid);

    // Side labels (centroid-outward placement)
    _sideLabel(canvas, pB, pC, _fmt(a), centroid, 'a'); // BC = a
    _sideLabel(canvas, pA, pC, _fmt(b), centroid, 'b'); // AC = b
    _sideLabel(canvas, pA, pB, _fmt(c), centroid, 'c'); // AB = c

    // Angle labels at each vertex
    _angleLabel(canvas, pA, _angleDeg(b, c, a), centroid);
    _angleLabel(canvas, pB, _angleDeg(a, c, b), centroid);
    _angleLabel(canvas, pC, _angleDeg(a, b, c), centroid);
  }

  /// Angle in degrees opposite to `opp`, between sides `s1` and `s2`.
  double _angleDeg(double s1, double s2, double opp) {
    final cos = (s1 * s1 + s2 * s2 - opp * opp) / (2 * s1 * s2);
    return math.acos(cos.clamp(-1.0, 1.0)) * 180 / math.pi;
  }

  String _fmt(double v) {
    if (v == v.truncateToDouble()) return v.truncate().toString();
    return v.toStringAsFixed(2);
  }

  void _dot(Canvas canvas, Offset p) {
    canvas.drawCircle(p, 4, Paint()..color = strokeColor);
  }

  void _vertexLabel(Canvas canvas, Offset p, String label, Offset centroid) {
    final dir = _outward(p, centroid, 14);
    _text(canvas, Offset(p.dx + dir.dx - 5, p.dy + dir.dy - 7),
        label, textColor, 12, bold: true);
  }

  void _sideLabel(Canvas canvas, Offset p1, Offset p2, String text,
      Offset centroid, String letter) {
    final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
    final dir = _outward(mid, centroid, 16);
    _text(canvas, Offset(mid.dx + dir.dx - 5, mid.dy + dir.dy - 7),
        '$letter=$text', textColor, 10);
  }

  void _angleLabel(Canvas canvas, Offset p, double deg, Offset centroid) {
    final dir = _outward(p, centroid, -18); // inward
    _text(canvas, Offset(p.dx + dir.dx - 14, p.dy + dir.dy - 6),
        '${deg.toStringAsFixed(1)}°', textColor.withAlpha(180), 9);
  }

  /// Unit vector from [centroid] to [p], scaled by [dist].
  Offset _outward(Offset p, Offset centroid, double dist) {
    final dx = p.dx - centroid.dx;
    final dy = p.dy - centroid.dy;
    final len = math.sqrt(dx * dx + dy * dy);
    if (len == 0) return Offset.zero;
    return Offset(dx / len * dist, dy / len * dist);
  }

  void _text(Canvas canvas, Offset pos, String text, Color color, double size,
      {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(TrianglePainter old) =>
      a != old.a || b != old.b || c != old.c;
}

/// Draws a polygon from a list of 2D vertices, fitting the canvas with padding.
/// Vertices are labeled with their coordinates. Optionally marks lattice
/// points: boundary points with the stroke color, interior with the accent.
class PolygonPainter extends CustomPainter {
  final List<Offset> vertices;
  final Color strokeColor;
  final Color textColor;
  final List<Offset> boundaryLattice;
  final List<Offset> interiorLattice;
  final Color accentColor;

  const PolygonPainter({
    required this.vertices,
    required this.strokeColor,
    required this.textColor,
    this.boundaryLattice = const [],
    this.interiorLattice = const [],
    this.accentColor = const Color(0xFFE53935),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (vertices.length < 3) return;

    final double minX = vertices.map((v) => v.dx).reduce(math.min);
    final double maxX = vertices.map((v) => v.dx).reduce(math.max);
    final double minY = vertices.map((v) => v.dy).reduce(math.min);
    final double maxY = vertices.map((v) => v.dy).reduce(math.max);

    final double polyW = (maxX - minX).abs();
    final double polyH = (maxY - minY).abs();

    const double pad = 36.0;
    final double scaleX = polyW > 0 ? (size.width - 2 * pad) / polyW : 1;
    final double scaleY = polyH > 0 ? (size.height - 2 * pad) / polyH : 1;
    final double scale = math.min(scaleX, scaleY);

    // Map model → canvas (flip y)
    Offset mp(Offset v) => Offset(
          pad + (v.dx - minX) * scale,
          size.height - pad - (v.dy - minY) * scale,
        );

    final mapped = vertices.map(mp).toList();

    final fillPaint = Paint()
      ..color = strokeColor.withAlpha(22)
      ..style = PaintingStyle.fill;

    final edgePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(mapped[0].dx, mapped[0].dy);
    for (int i = 1; i < mapped.length; i++) {
      path.lineTo(mapped[i].dx, mapped[i].dy);
    }
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, edgePaint);

    // Lattice points (Pick's theorem): interior in accent, boundary in stroke.
    for (final lp in interiorLattice) {
      canvas.drawCircle(mp(lp), 3, Paint()..color = accentColor);
    }
    for (final lp in boundaryLattice) {
      canvas.drawCircle(mp(lp), 3, Paint()..color = strokeColor);
    }

    // Vertex dots and coordinate labels
    for (int i = 0; i < mapped.length; i++) {
      final p = mapped[i];
      canvas.drawCircle(p, 4, Paint()..color = strokeColor);
      final v = vertices[i];
      final label = '(${_fmt(v.dx)}, ${_fmt(v.dy)})';
      _text(canvas, Offset(p.dx + 5, p.dy - 14), label, textColor, 10);
    }

    // Light coordinate axes through origin if visible in bounding box
    if (minX <= 0 && maxX >= 0) {
      _axis(canvas, mp(Offset(0, minY)), mp(Offset(0, maxY)), size);
    }
    if (minY <= 0 && maxY >= 0) {
      _axis(canvas, mp(Offset(minX, 0)), mp(Offset(maxX, 0)), size);
    }
  }

  void _axis(Canvas canvas, Offset from, Offset to, Size size) {
    final axisPaint = Paint()
      ..color = textColor.withAlpha(40)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(from, to, axisPaint);
  }

  String _fmt(double v) {
    if (v == v.truncateToDouble()) return v.truncate().toString();
    return v.toStringAsFixed(2);
  }

  void _text(Canvas canvas, Offset pos, String text, Color color, double size) {
    final tp = TextPainter(
      text: TextSpan(
          text: text, style: TextStyle(color: color, fontSize: size)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(PolygonPainter old) =>
      vertices != old.vertices ||
      boundaryLattice != old.boundaryLattice ||
      interiorLattice != old.interiorLattice;
}

/// Draws complex numbers as points on/around the unit circle, connected as a
/// regular polygon (the classic picture for n-th roots of unity / of z).
class UnitCirclePainter extends CustomPainter {
  final List<Offset> points; // (re, im)
  final Color strokeColor;
  final Color textColor;

  const UnitCirclePainter({
    required this.points,
    required this.strokeColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    double maxR = 1.0;
    for (final p in points) {
      maxR = math.max(maxR, p.distance);
    }

    const double pad = 30.0;
    final double scale =
        (math.min(size.width, size.height) / 2 - pad) / maxR;
    final Offset center = Offset(size.width / 2, size.height / 2);

    Offset mp(Offset z) =>
        Offset(center.dx + z.dx * scale, center.dy - z.dy * scale);

    // Axes Re / Im
    final axisPaint = Paint()
      ..color = textColor.withAlpha(50)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(pad / 2, center.dy),
        Offset(size.width - pad / 2, center.dy), axisPaint);
    canvas.drawLine(Offset(center.dx, pad / 2),
        Offset(center.dx, size.height - pad / 2), axisPaint);
    _text(canvas, Offset(size.width - pad / 2 - 14, center.dy + 4), 'Re',
        textColor.withAlpha(120), 9);
    _text(canvas, Offset(center.dx + 5, pad / 2), 'Im',
        textColor.withAlpha(120), 9);

    // Unit circle (radius of the points' modulus)
    final double pointR = points.first.distance;
    final circlePaint = Paint()
      ..color = strokeColor.withAlpha(90)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, (pointR > 0 ? pointR : 1) * scale, circlePaint);

    // Polygon connecting the points in order
    if (points.length >= 3) {
      final mapped = points.map(mp).toList();
      final polyPaint = Paint()
        ..color = strokeColor.withAlpha(150)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      final path = Path()..moveTo(mapped[0].dx, mapped[0].dy);
      for (int i = 1; i < mapped.length; i++) {
        path.lineTo(mapped[i].dx, mapped[i].dy);
      }
      path.close();
      canvas.drawPath(path, polyPaint);
    }

    // Points + labels z₀, z₁, …
    const subDigits = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉'];
    String sub(int n) =>
        n.toString().split('').map((d) => subDigits[int.parse(d)]).join();
    for (int i = 0; i < points.length; i++) {
      final p = mp(points[i]);
      canvas.drawCircle(p, 4, Paint()..color = strokeColor);
      // Label outward from center
      final dx = p.dx - center.dx, dy = p.dy - center.dy;
      final len = math.sqrt(dx * dx + dy * dy);
      final off = len > 0
          ? Offset(dx / len * 12, dy / len * 12)
          : const Offset(12, 0);
      _text(canvas, Offset(p.dx + off.dx - 6, p.dy + off.dy - 7),
          'z${sub(i)}', textColor, 10);
    }
  }

  void _text(Canvas canvas, Offset pos, String text, Color color, double size) {
    final tp = TextPainter(
      text: TextSpan(
          text: text, style: TextStyle(color: color, fontSize: size)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(UnitCirclePainter old) => points != old.points;
}

/// A labeled point drawn by [TriangleCentersPainter].
class CenterMark {
  final String label;
  final Offset position;
  final Color color;
  const CenterMark(this.label, this.position, this.color);
}

/// Draws a triangle from three coordinates, its notable centers, and the
/// Euler line through circumcenter–centroid–orthocenter.
class TriangleCentersPainter extends CustomPainter {
  final List<Offset> vertices; // exactly 3
  final List<CenterMark> centers;
  final Offset? eulerA; // two points defining the Euler line (O and H)
  final Offset? eulerB;
  final Color strokeColor;
  final Color textColor;

  const TriangleCentersPainter({
    required this.vertices,
    required this.centers,
    this.eulerA,
    this.eulerB,
    required this.strokeColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (vertices.length != 3) return;

    // Bounding box over vertices AND centers (orthocenter can be far outside)
    final all = [...vertices, ...centers.map((c) => c.position)];
    double minX = all.map((v) => v.dx).reduce(math.min);
    double maxX = all.map((v) => v.dx).reduce(math.max);
    double minY = all.map((v) => v.dy).reduce(math.min);
    double maxY = all.map((v) => v.dy).reduce(math.max);
    if (maxX - minX < 1e-9) maxX = minX + 1;
    if (maxY - minY < 1e-9) maxY = minY + 1;

    const double pad = 34.0;
    final double scale = math.min(
      (size.width - 2 * pad) / (maxX - minX),
      (size.height - 2 * pad) / (maxY - minY),
    );

    Offset mp(Offset v) => Offset(
          pad + (v.dx - minX) * scale,
          size.height - pad - (v.dy - minY) * scale,
        );

    final mapped = vertices.map(mp).toList();

    final fillPaint = Paint()
      ..color = strokeColor.withAlpha(22)
      ..style = PaintingStyle.fill;
    final edgePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(mapped[0].dx, mapped[0].dy)
      ..lineTo(mapped[1].dx, mapped[1].dy)
      ..lineTo(mapped[2].dx, mapped[2].dy)
      ..close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, edgePaint);

    // Euler line, extended across the canvas
    if (eulerA != null && eulerB != null) {
      final a = mp(eulerA!), b = mp(eulerB!);
      final dir = b - a;
      if (dir.distance > 1e-9) {
        final unit = dir / dir.distance;
        final double ext = size.width + size.height;
        final eulerPaint = Paint()
          ..color = textColor.withAlpha(70)
          ..strokeWidth = 1.2;
        canvas.drawLine(a - unit * ext, b + unit * ext, eulerPaint);
      }
    }

    // Vertices
    const names = ['A', 'B', 'C'];
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(mapped[i], 4, Paint()..color = strokeColor);
      _text(canvas, Offset(mapped[i].dx + 6, mapped[i].dy - 14), names[i],
          textColor, 11, bold: true);
    }

    // Centers
    for (final c in centers) {
      final p = mp(c.position);
      canvas.drawCircle(p, 5, Paint()..color = c.color);
      canvas.drawCircle(
          p,
          5,
          Paint()
            ..color = textColor.withAlpha(140)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1);
      _text(canvas, Offset(p.dx + 7, p.dy - 6), c.label, c.color, 11,
          bold: true);
    }
  }

  void _text(Canvas canvas, Offset pos, String text, Color color, double size,
      {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(TriangleCentersPainter old) =>
      vertices != old.vertices || centers != old.centers;
}

/// Plots y = p(x) for a polynomial given by coefficients (lowest degree
/// first), marking the supplied roots on the x-axis and extrema on the curve.
class PolynomialPlotPainter extends CustomPainter {
  final List<double> coefficients; // ascending degree
  final double xMin;
  final double xMax;
  final List<double> roots;
  final List<double> extrema; // x-coordinates
  final Color curveColor;
  final Color textColor;
  final Color rootColor;

  const PolynomialPlotPainter({
    required this.coefficients,
    required this.xMin,
    required this.xMax,
    this.roots = const [],
    this.extrema = const [],
    required this.curveColor,
    required this.textColor,
    this.rootColor = const Color(0xFFE53935),
  });

  double _eval(double x) {
    double y = 0;
    for (int i = coefficients.length - 1; i >= 0; i--) {
      y = y * x + coefficients[i];
    }
    return y;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (coefficients.isEmpty || xMax <= xMin) return;

    const int samples = 240;
    final xs = List.generate(
        samples + 1, (i) => xMin + (xMax - xMin) * i / samples);
    final ys = xs.map(_eval).toList();

    // y-range from finite samples, padded; always include y = 0.
    double yMin = 0, yMax = 0;
    for (final y in ys) {
      if (y.isFinite) {
        yMin = math.min(yMin, y);
        yMax = math.max(yMax, y);
      }
    }
    if (yMax - yMin < 1e-9) {
      yMin -= 1;
      yMax += 1;
    }
    final double yPad = (yMax - yMin) * 0.08;
    yMin -= yPad;
    yMax += yPad;

    const double pad = 28.0;
    final double sx = (size.width - 2 * pad) / (xMax - xMin);
    final double sy = (size.height - 2 * pad) / (yMax - yMin);

    Offset mp(double x, double y) => Offset(
          pad + (x - xMin) * sx,
          size.height - pad - (y - yMin) * sy,
        );

    // Axes
    final axisPaint = Paint()
      ..color = textColor.withAlpha(60)
      ..strokeWidth = 1.0;
    if (yMin <= 0 && yMax >= 0) {
      canvas.drawLine(mp(xMin, 0), mp(xMax, 0), axisPaint);
    }
    if (xMin <= 0 && xMax >= 0) {
      canvas.drawLine(mp(0, yMin), mp(0, yMax), axisPaint);
    }
    _text(canvas, Offset(pad, size.height - pad + 4),
        _fmt(xMin), textColor.withAlpha(140), 9);
    _text(canvas, Offset(size.width - pad - 20, size.height - pad + 4),
        _fmt(xMax), textColor.withAlpha(140), 9);

    // Curve
    final curvePaint = Paint()
      ..color = curveColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    final path = Path();
    bool started = false;
    for (int i = 0; i <= samples; i++) {
      final y = ys[i];
      if (!y.isFinite || y < yMin - (yMax - yMin) || y > yMax + (yMax - yMin)) {
        started = false;
        continue;
      }
      final p = mp(xs[i], y.clamp(yMin, yMax));
      if (!started) {
        path.moveTo(p.dx, p.dy);
        started = true;
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, curvePaint);

    // Roots on the x-axis
    for (final r in roots) {
      if (r < xMin || r > xMax) continue;
      final p = mp(r, 0);
      canvas.drawCircle(p, 4, Paint()..color = rootColor);
      _text(canvas, Offset(p.dx - 8, p.dy + 6), _fmt(r), rootColor, 9);
    }

    // Extrema on the curve
    for (final e in extrema) {
      if (e < xMin || e > xMax) continue;
      final y = _eval(e);
      if (!y.isFinite || y < yMin || y > yMax) continue;
      final p = mp(e, y);
      canvas.drawCircle(
          p,
          4,
          Paint()
            ..color = curveColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
    }
  }

  String _fmt(double v) {
    if (v == v.truncateToDouble()) return v.truncate().toString();
    return v.toStringAsFixed(2);
  }

  void _text(Canvas canvas, Offset pos, String text, Color color, double size) {
    final tp = TextPainter(
      text: TextSpan(
          text: text, style: TextStyle(color: color, fontSize: size)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(PolynomialPlotPainter old) =>
      coefficients != old.coefficients ||
      xMin != old.xMin ||
      xMax != old.xMax;
}
