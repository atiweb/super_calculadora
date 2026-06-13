import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Pascal's triangle mod m as a grid of cells. Nonzero residues are filled
/// (darker for larger residue); zeros are left empty. With m = 2 this is the
/// Sierpiński triangle.
class PascalModPainter extends CustomPainter {
  final List<List<int>> rows; // rows[i] has i+1 residues in [0, m)
  final int modulus;
  final Color fillColor;
  final Color textColor;

  const PascalModPainter({
    required this.rows,
    required this.modulus,
    required this.fillColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (rows.isEmpty) return;
    final int n = rows.length;

    const double pad = 8.0;
    // Cells are squares in a centered triangular layout.
    final double cell = math.min(
      (size.width - 2 * pad) / n,
      (size.height - 2 * pad) / n,
    );
    final double x0 = size.width / 2;
    final double y0 = pad;

    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < n; i++) {
      for (int k = 0; k <= i; k++) {
        final int v = rows[i][k];
        if (v == 0) continue;
        // Intensity by residue: 1 → full, m−1 → lighter floor of 90.
        final int alpha = modulus == 2
            ? 255
            : 90 + (165 * (modulus - v) ~/ (modulus - 1));
        paint.color = fillColor.withAlpha(alpha);
        final double cx = x0 + (k - i / 2) * cell;
        final double cy = y0 + i * cell;
        canvas.drawRect(
          Rect.fromLTWH(cx - cell / 2 + 0.5, cy + 0.5, cell - 1, cell - 1),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(PascalModPainter old) =>
      rows != old.rows || modulus != old.modulus;
}

/// Sieve of Eratosthenes as a numbered grid: primes highlighted, composites
/// dimmed, 1 crossed out.
class SievePainter extends CustomPainter {
  final List<bool> isPrime; // index 0..n
  final Color primeColor;
  final Color textColor;

  const SievePainter({
    required this.isPrime,
    required this.primeColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final int n = isPrime.length - 1;
    if (n < 1) return;

    // Grid layout close to the canvas aspect ratio.
    const double pad = 6.0;
    final double availW = size.width - 2 * pad;
    final double availH = size.height - 2 * pad;
    int cols = math.max(1, math.sqrt(n * availW / availH).round());
    cols = math.min(cols, n);
    final int rows = (n + cols - 1) ~/ cols;
    final double cell = math.min(availW / cols, availH / rows);
    final double x0 = (size.width - cols * cell) / 2;
    final double y0 = (size.height - rows * cell) / 2;

    final primePaint = Paint()..color = primeColor.withAlpha(200);
    final compositePaint = Paint()..color = textColor.withAlpha(18);
    final bool drawNumbers = cell >= 14;

    for (int v = 1; v <= n; v++) {
      final int idx = v - 1;
      final int r = idx ~/ cols, c = idx % cols;
      final rect = Rect.fromLTWH(
          x0 + c * cell + 1, y0 + r * cell + 1, cell - 2, cell - 2);
      final bool prime = isPrime[v];
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        prime ? primePaint : compositePaint,
      );
      if (drawNumbers) {
        final tp = TextPainter(
          text: TextSpan(
            text: '$v',
            style: TextStyle(
              color: prime ? Colors.white : textColor.withAlpha(120),
              fontSize: math.min(cell * 0.42, 12),
              fontWeight: prime ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
            canvas,
            Offset(rect.center.dx - tp.width / 2,
                rect.center.dy - tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(SievePainter old) => isPrime != old.isPrime;
}

/// "Modular clock": the residues 0..n−1 on a circle, with the solution
/// residues of a congruence highlighted.
class ModularClockPainter extends CustomPainter {
  final int modulus;
  final Set<int> highlighted;
  final Color strokeColor;
  final Color highlightColor;
  final Color textColor;

  const ModularClockPainter({
    required this.modulus,
    required this.highlighted,
    required this.strokeColor,
    required this.highlightColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (modulus < 1) return;

    const double pad = 26.0;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) / 2 - pad;

    final circlePaint = Paint()
      ..color = strokeColor.withAlpha(90)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, circlePaint);

    final bool drawLabels = modulus <= 36;
    for (int r = 0; r < modulus; r++) {
      // 0 at the top, growing clockwise (like a clock).
      final double angle = -math.pi / 2 + 2 * math.pi * r / modulus;
      final Offset p = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final bool hl = highlighted.contains(r);
      canvas.drawCircle(
          p, hl ? 7 : 3.5, Paint()..color = hl ? highlightColor : strokeColor);
      if (drawLabels || hl) {
        final Offset lp = Offset(
          center.dx + (radius + 14) * math.cos(angle),
          center.dy + (radius + 14) * math.sin(angle),
        );
        final tp = TextPainter(
          text: TextSpan(
            text: '$r',
            style: TextStyle(
              color: hl ? highlightColor : textColor.withAlpha(150),
              fontSize: hl ? 12 : 9,
              fontWeight: hl ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(lp.dx - tp.width / 2, lp.dy - tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(ModularClockPainter old) =>
      modulus != old.modulus || highlighted != old.highlighted;
}
