import 'dart:math' as math;

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';

import '../../models/big_complex.dart';
import '../../models/calc_exception.dart';
import '../../models/complex.dart';
import '../../models/fraction.dart';
import '../../models/matrix.dart';
import '../../models/point.dart';
import '../../models/surd.dart';
import '../../models/polynomial.dart';
import '../../services/calculus_service.dart';
import '../../services/combinatorics_extra_service.dart';
import '../../services/geometry_service.dart';
import '../../services/linear_system_service.dart';
import '../../services/number_theory_advanced_service.dart';
import '../../services/polynomial_service.dart';
import '../../services/sequence_service.dart';
import '../../services/special_functions_service.dart';
import '../../services/statistics_service.dart';
import '../../services/steps_service.dart';
import '../../services/surd_service.dart';
import '../../widgets/geometry_painters.dart';
import '../../widgets/number_painters.dart';
import 'calc_tool.dart';
import 'olympiad_strings.dart';

// ── Helpers de parseo ────────────────────────────────────────────────────────

BigInt _bi(String s) {
  final v = BigInt.tryParse(s.trim());
  if (v == null) throw CalcException(CalcError.invalidInteger, {'value': s});
  return v;
}

int _int(String s) {
  final v = int.tryParse(s.trim());
  if (v == null) throw CalcException(CalcError.invalidInteger, {'value': s});
  return v;
}

List<BigInt> _biList(String s) => s
    .split(RegExp(r'[,;\s]+'))
    .where((e) => e.isNotEmpty)
    .map(_bi)
    .toList();

List<int> _intList(String s) => s
    .split(RegExp(r'[,;\s]+'))
    .where((e) => e.isNotEmpty)
    .map(_int)
    .toList();

List<Fraction> _fracList(String s) => s
    .split(RegExp(r'[,;\s]+'))
    .where((e) => e.isNotEmpty)
    .map(Fraction.parse)
    .toList();

/// Parsea una matriz: filas separadas por ';', entradas por ',' o espacios.
Matrix _matrix(String s) {
  final rows = s
      .split(';')
      .where((r) => r.trim().isNotEmpty)
      .map((r) => r
          .split(RegExp(r'[,\s]+'))
          .where((e) => e.isNotEmpty)
          .map(Fraction.parse)
          .toList())
      .toList();
  return Matrix(rows);
}

/// Parsea "x,y" como punto de coordenadas racionales.
Point _point(String s) {
  final xy = s.split(',');
  if (xy.length != 2) {
    throw CalcException(CalcError.invalidPoint, {'value': s});
  }
  return Point(Fraction.parse(xy[0]), Fraction.parse(xy[1]));
}

/// Parsea una lista de puntos "x,y" separados por ";".
List<Point> _pointList(String s) => s
    .split(';')
    .where((p) => p.trim().isNotEmpty)
    .map(_point)
    .toList();

/// Suma de divisores σ(n) para la tabla de funciones multiplicativas.
BigInt _sigma1(BigInt n) {
  BigInt result = BigInt.one;
  BigInt temp = n;
  for (BigInt p = BigInt.two; p * p <= temp; p += BigInt.one) {
    if (temp % p == BigInt.zero) {
      BigInt term = BigInt.one, power = BigInt.one;
      while (temp % p == BigInt.zero) {
        temp ~/= p;
        power *= p;
        term += power;
      }
      result *= term;
    }
  }
  if (temp > BigInt.one) result *= temp + BigInt.one;
  return result;
}

/// Raíces reales aproximadas de un polinomio de grado 1–3 (para extremos del
/// graficador); para grados mayores devuelve solo las raíces racionales.
List<double> _realRootsApprox(Polynomial p) {
  final c = p.coefficients;
  switch (p.degree) {
    case 1:
      return [(-c[0] / c[1]).toDouble()];
    case 2:
      final sol = PolynomialService.solveQuadratic(c[2], c[1], c[0]);
      return sol.realRoots;
    case 3:
      return PolynomialService.solveCubicReal(c[3].toDouble(),
          c[2].toDouble(), c[1].toDouble(), c[0].toDouble());
    default:
      return PolynomialService.rationalRoots(p)
          .map((r) => r.toDouble())
          .toList();
  }
}

/// Enumera los puntos reticulares de un polígono de vértices enteros, para
/// dibujarlos: (frontera, interior). Si el área de barrido es muy grande,
/// devuelve listas vacías (el dibujo omite los puntos).
({List<Offset> boundary, List<Offset> interior}) _latticePoints(
    List<Point> poly) {
  final xs = poly.map((p) => p.x.toDouble()).toList();
  final ys = poly.map((p) => p.y.toDouble()).toList();
  final int minX = xs.reduce(math.min).ceil();
  final int maxX = xs.reduce(math.max).floor();
  final int minY = ys.reduce(math.min).ceil();
  final int maxY = ys.reduce(math.max).floor();

  if ((maxX - minX + 1) * (maxY - minY + 1) > 2500) {
    return (boundary: const [], interior: const []);
  }

  bool onSegment(double px, double py, double ax, double ay, double bx, double by) {
    final cross = (bx - ax) * (py - ay) - (by - ay) * (px - ax);
    if (cross != 0) return false;
    return px >= math.min(ax, bx) &&
        px <= math.max(ax, bx) &&
        py >= math.min(ay, by) &&
        py <= math.max(ay, by);
  }

  bool onBoundary(double px, double py) {
    for (int i = 0; i < poly.length; i++) {
      final j = (i + 1) % poly.length;
      if (onSegment(px, py, xs[i], ys[i], xs[j], ys[j])) return true;
    }
    return false;
  }

  bool inside(double px, double py) {
    // Ray casting hacia +x.
    bool odd = false;
    for (int i = 0; i < poly.length; i++) {
      final j = (i + 1) % poly.length;
      if ((ys[i] > py) != (ys[j] > py)) {
        final double xCross =
            xs[i] + (py - ys[i]) / (ys[j] - ys[i]) * (xs[j] - xs[i]);
        if (px < xCross) odd = !odd;
      }
    }
    return odd;
  }

  final List<Offset> boundary = [];
  final List<Offset> interior = [];
  for (int x = minX; x <= maxX; x++) {
    for (int y = minY; y <= maxY; y++) {
      final px = x.toDouble(), py = y.toDouble();
      if (onBoundary(px, py)) {
        boundary.add(Offset(px, py));
      } else if (inside(px, py)) {
        interior.add(Offset(px, py));
      }
    }
  }
  return (boundary: boundary, interior: interior);
}

/// Convierte un entero a superíndices Unicode (3 → "³"), para el índice de raíz.
String _superscript(int n) {
  const map = {
    '0': '⁰', '1': '¹', '2': '²', '3': '³', '4': '⁴',
    '5': '⁵', '6': '⁶', '7': '⁷', '8': '⁸', '9': '⁹', '-': '⁻',
  };
  return n.toString().split('').map((d) => map[d] ?? d).join();
}

// Localización de los resultados que los servicios devuelven como enumeraciones.

String _sidesLabel(OlympiadStrings s, TriangleSides v) {
  switch (v) {
    case TriangleSides.equilateral:
      return s.pick('equilátero', 'equilateral');
    case TriangleSides.isosceles:
      return s.pick('isósceles', 'isosceles');
    case TriangleSides.scalene:
      return s.pick('escaleno', 'scalene');
  }
}

String _anglesLabel(OlympiadStrings s, TriangleAngles v) {
  switch (v) {
    case TriangleAngles.right:
      return s.pick('rectángulo', 'right');
    case TriangleAngles.acute:
      return s.pick('acutángulo', 'acute');
    case TriangleAngles.obtuse:
      return s.pick('obtusángulo', 'obtuse');
  }
}

String _natureLabel(OlympiadStrings s, QuadraticNature v) {
  switch (v) {
    case QuadraticNature.twoRealDistinct:
      return s.pick('dos reales distintas', 'two distinct real');
    case QuadraticNature.doubleRoot:
      return s.pick('una raíz doble', 'one double root');
    case QuadraticNature.complexConjugate:
      return s.pick('complejas conjugadas', 'complex conjugate');
  }
}

/// Pantalla base: una lista desplazable de herramientas.
class _ToolScaffold extends StatelessWidget {
  final String title;
  final List<Widget> tools;
  const _ToolScaffold({required this.title, required this.tools});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), elevation: 0),
      body: ListView(padding: const EdgeInsets.all(16), children: tools),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// FRACCIONES
// ════════════════════════════════════════════════════════════════════════════

class FractionsToolScreen extends StatelessWidget {
  const FractionsToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    return _ToolScaffold(
      title: s.catFractions,
      tools: [
        CalcTool(
          title: s.pick('Aritmética de fracciones', 'Fraction arithmetic'),
          description: s.pick(
              'Operación exacta entre dos fracciones (p/q).',
              'Exact operation between two fractions (p/q).'),
          fields: [
            ToolField(s.pick('Fracción 1', 'Fraction 1'), hint: '1/2', initial: '1/2'),
            ToolField(s.pick('Operación (+ - * /)', 'Operation (+ - * /)'), initial: '+'),
            ToolField(s.pick('Fracción 2', 'Fraction 2'), hint: '1/3', initial: '1/3'),
          ],
          compute: (i) {
            final a = Fraction.parse(i[0]);
            final b = Fraction.parse(i[2]);
            final Fraction r;
            switch (i[1]) {
              case '+': r = a + b; break;
              case '-': r = a - b; break;
              case '*': case '×': r = a * b; break;
              case '/': case '÷': r = a / b; break;
              default: throw CalcException(CalcError.invalidOperation);
            }
            return '${r.toString()}\n'
                '${s.pick('Mixto', 'Mixed')}: ${r.toMixedString()}\n'
                '${s.pick('Decimal', 'Decimal')}: ${r.toDouble()}';
          },
        ),
        CalcTool(
          title: s.pick('Simplificar / convertir', 'Simplify / convert'),
          description: s.pick('Reduce una fracción o un decimal a su forma exacta.',
              'Reduce a fraction or decimal to exact form.'),
          fields: [
            ToolField(s.pick('Valor (p/q o decimal)', 'Value (p/q or decimal)'), initial: '18/12'),
          ],
          compute: (i) {
            final r = Fraction.parse(i[0]);
            return '${s.pick('Reducida', 'Reduced')}: $r\n'
                '${s.pick('Mixto', 'Mixed')}: ${r.toMixedString()}\n'
                '${s.pick('Decimal', 'Decimal')}: ${r.toDouble()}';
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RADICALES
// ════════════════════════════════════════════════════════════════════════════

class SurdsToolScreen extends StatelessWidget {
  const SurdsToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    return _ToolScaffold(
      title: s.catSurds,
      tools: [
        CalcTool(
          title: s.pick('Simplificar √n', 'Simplify √n'),
          fields: [ToolField('n', initial: '72')],
          compute: (i) => Surd.sqrt(_bi(i[0])).toString(),
        ),
        CalcTool(
          title: s.pick('Raíz n-ésima', 'n-th root'),
          description: s.pick('Extrae factores de la raíz de índice k.',
              'Extracts factors from the k-th root.'),
          fields: [
            ToolField(s.pick('Radicando', 'Radicand'), initial: '54'),
            ToolField(s.pick('Índice k', 'Index k'), initial: '3'),
          ],
          compute: (i) {
            final r = SurdService.simplifyNthRoot(_bi(i[0]), _int(i[1]));
            if (r.radicand == BigInt.one) return r.coefficient.toString();
            final coef = r.coefficient == BigInt.one ? '' : '${r.coefficient}·';
            final idx = _superscript(_int(i[1]));
            return '$coef$idx√${r.radicand}';
          },
        ),
        CalcTool(
          title: s.pick('Racionalizar a/√b', 'Rationalize a/√b'),
          fields: [
            ToolField('a (p/q)', initial: '1'),
            ToolField('b', initial: '2'),
          ],
          compute: (i) =>
              SurdService.rationalizeOverSqrt(Fraction.parse(i[0]), _bi(i[1])).toString(),
        ),
        CalcTool(
          title: s.pick('Racionalizar a/(c+√d)', 'Rationalize a/(c+√d)'),
          fields: [
            ToolField('a (p/q)', initial: '1'),
            ToolField('c (p/q)', initial: '1'),
            ToolField('d', initial: '2'),
          ],
          compute: (i) => SurdService.rationalizeOverBinomial(
                  Fraction.parse(i[0]), Fraction.parse(i[1]), _bi(i[2]))
              .toString(),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// GEOMETRÍA
// ════════════════════════════════════════════════════════════════════════════

class GeometryToolScreen extends StatelessWidget {
  const GeometryToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    return _ToolScaffold(
      title: s.catGeometry,
      tools: [
        CalcTool(
          title: s.pick('Triángulo por lados', 'Triangle from sides'),
          description: s.pick('Tipo, área (Herón), R, r y perímetro.',
              'Type, area (Heron), R, r and perimeter.'),
          fields: [
            ToolField('a', initial: '13'),
            ToolField('b', initial: '14'),
            ToolField('c', initial: '15'),
          ],
          compute: (i) {
            final a = _bi(i[0]), b = _bi(i[1]), c = _bi(i[2]);
            if (!GeometryService.isValidTriangle(a, b, c)) {
              throw CalcException(CalcError.invalidTriangle);
            }
            final t = GeometryService.triangleType(a, b, c);
            final area = GeometryService.heronArea(a, b, c);
            final r = GeometryService.inradius(a, b, c);
            final big = GeometryService.circumradius(a, b, c);
            return '${s.pick('Tipo', 'Type')}: ${_sidesLabel(s, t.bySides)}, ${_anglesLabel(s, t.byAngles)}\n'
                '${s.pick('Perímetro', 'Perimeter')}: ${a + b + c}\n'
                '${s.pick('Área', 'Area')}: $area  ≈ ${area.toDouble().toStringAsFixed(4)}\n'
                'R = $big  ≈ ${big.toDouble().toStringAsFixed(4)}\n'
                'r = $r  ≈ ${r.toDouble().toStringAsFixed(4)}';
          },
          visualize: (ctx, i) {
            final a = double.tryParse(i[0]);
            final b = double.tryParse(i[1]);
            final c = double.tryParse(i[2]);
            if (a == null || b == null || c == null) return null;
            if (a <= 0 || b <= 0 || c <= 0) return null;
            if (a + b <= c || a + c <= b || b + c <= a) return null;
            final scheme = Theme.of(ctx).colorScheme;
            return CustomPaint(
              painter: TrianglePainter(
                a: a,
                b: b,
                c: c,
                strokeColor: scheme.primary,
                textColor: scheme.onSurface,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        CalcTool(
          title: s.pick('Ternas pitagóricas primitivas', 'Primitive Pythagorean triples'),
          fields: [ToolField(s.pick('Hipotenusa máx', 'Max hypotenuse'), initial: '50')],
          compute: (i) {
            final list = GeometryService.primitivePythagoreanTriples(_int(i[0]));
            if (list.isEmpty) return s.pick('Ninguna', 'None');
            return list.map((t) => '${t[0]}, ${t[1]}, ${t[2]}').join('\n');
          },
        ),
        CalcTool(
          title: s.pick('Área por coordenadas (shoelace)', 'Area from coordinates (shoelace)'),
          description: s.pick('Vértices "x,y" separados por ";".',
              'Vertices "x,y" separated by ";".'),
          fields: [
            ToolField(s.pick('Vértices', 'Vertices'), initial: '0,0; 4,0; 0,3'),
          ],
          compute: (i) {
            final area = GeometryService.shoelaceArea(_pointList(i[0]));
            return '${s.pick('Área', 'Area')}: $area  ≈ ${area.toDouble()}';
          },
          visualize: (ctx, i) {
            final pts = _pointList(i[0]);
            if (pts.length < 3) return null;
            final offsets = pts
                .map((p) => Offset(p.x.toDouble(), p.y.toDouble()))
                .toList();
            final scheme = Theme.of(ctx).colorScheme;
            return CustomPaint(
              painter: PolygonPainter(
                vertices: offsets,
                strokeColor: scheme.secondary,
                textColor: scheme.onSurface,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        CalcTool(
          title: s.pick('Teorema de Pick', "Pick's theorem"),
          description: s.pick(
              'Polígono de vértices enteros: A = I + B/2 − 1. Vértices "x,y" separados por ";".',
              'Integer-vertex polygon: A = I + B/2 − 1. Vertices "x,y" separated by ";".'),
          fields: [
            ToolField(s.pick('Vértices', 'Vertices'), initial: '0,0; 5,0; 5,4; 0,4'),
          ],
          compute: (i) {
            final r = GeometryService.pickAnalysis(_pointList(i[0]));
            return '${s.pick('Área', 'Area')}: ${r.area}\n'
                'B (${s.pick('frontera', 'boundary')}): ${r.boundary}\n'
                'I (${s.pick('interior', 'interior')}): ${r.interior}\n'
                '${s.pick('Verificación', 'Check')}: ${r.interior} + ${r.boundary}/2 − 1 = ${r.area}';
          },
          visualize: (ctx, i) {
            final pts = _pointList(i[0]);
            if (pts.length < 3) return null;
            if (pts.any((p) => !p.x.isInteger || !p.y.isInteger)) return null;
            final lattice = _latticePoints(pts);
            final scheme = Theme.of(ctx).colorScheme;
            return CustomPaint(
              painter: PolygonPainter(
                vertices: pts
                    .map((p) => Offset(p.x.toDouble(), p.y.toDouble()))
                    .toList(),
                strokeColor: scheme.secondary,
                textColor: scheme.onSurface,
                boundaryLattice: lattice.boundary,
                interiorLattice: lattice.interior,
                accentColor: scheme.tertiary,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        CalcTool(
          title: s.pick('Centros del triángulo', 'Triangle centers'),
          description: s.pick(
              'G, O, H exactos y recta de Euler; incentro aproximado. Vértices "x,y".',
              'Exact G, O, H and Euler line; approximate incenter. Vertices "x,y".'),
          fields: [
            ToolField('A', initial: '0,0'),
            ToolField('B', initial: '6,0'),
            ToolField('C', initial: '2,4'),
          ],
          compute: (i) {
            final r = GeometryService.triangleCenters(
                _point(i[0]), _point(i[1]), _point(i[2]));
            return '${s.pick('Baricentro', 'Centroid')} G: ${r.centroid}\n'
                '${s.pick('Circuncentro', 'Circumcenter')} O: ${r.circumcenter}\n'
                '${s.pick('Ortocentro', 'Orthocenter')} H: ${r.orthocenter}\n'
                '${s.pick('Incentro', 'Incenter')} I ≈ '
                '(${r.incenterX.toStringAsFixed(4)}, ${r.incenterY.toStringAsFixed(4)})\n'
                '${s.pick('Recta de Euler', 'Euler line')}: H = 3·G − 2·O ✓';
          },
          visualize: (ctx, i) {
            final a = _point(i[0]), b = _point(i[1]), c = _point(i[2]);
            final r = GeometryService.triangleCenters(a, b, c);
            Offset toOffset(Point p) => Offset(p.x.toDouble(), p.y.toDouble());
            final scheme = Theme.of(ctx).colorScheme;
            final o = toOffset(r.circumcenter);
            final h = toOffset(r.orthocenter);
            return CustomPaint(
              painter: TriangleCentersPainter(
                vertices: [toOffset(a), toOffset(b), toOffset(c)],
                centers: [
                  CenterMark('G', toOffset(r.centroid), const Color(0xFF43A047)),
                  CenterMark('O', o, const Color(0xFF1E88E5)),
                  CenterMark('H', h, const Color(0xFFE53935)),
                  CenterMark('I', Offset(r.incenterX, r.incenterY),
                      const Color(0xFFFB8C00)),
                ],
                eulerA: o,
                eulerB: h,
                strokeColor: scheme.primary,
                textColor: scheme.onSurface,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// POLINOMIOS
// ════════════════════════════════════════════════════════════════════════════

class PolynomialsToolScreen extends StatelessWidget {
  const PolynomialsToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    return _ToolScaffold(
      title: s.catPolynomials,
      tools: [
        CalcTool(
          title: s.pick('Analizar polinomio', 'Analyze polynomial'),
          description: s.pick('Grado, raíces racionales, Vieta, discriminante, derivada.',
              'Degree, rational roots, Vieta, discriminant, derivative.'),
          fields: [ToolField(s.pick('Polinomio', 'Polynomial'), initial: 'x^2-5x+6')],
          compute: (i) {
            final p = PolynomialService.parse(i[0]);
            final sb = StringBuffer();
            sb.writeln('${s.pick('Grado', 'Degree')}: ${p.degree}');
            final roots = PolynomialService.rationalRoots(p);
            sb.writeln('${s.pick('Raíces racionales', 'Rational roots')}: '
                '${roots.isEmpty ? s.pick('ninguna', 'none') : roots.join(', ')}');
            if (p.degree >= 1) {
              final v = PolynomialService.vieta(p);
              sb.writeln('${s.pick('Suma de raíces', 'Sum of roots')}: ${v.sumOfRoots}');
              sb.writeln('${s.pick('Producto de raíces', 'Product of roots')}: ${v.productOfRoots}');
            }
            if (p.degree == 2 || p.degree == 3) {
              sb.writeln('${s.pick('Discriminante', 'Discriminant')}: '
                  '${PolynomialService.discriminant(p)}');
            }
            sb.write('${s.pick('Derivada', 'Derivative')}: ${p.derivative()}');
            return sb.toString();
          },
          visualize: (ctx, i) {
            final p = PolynomialService.parse(i[0]);
            if (p.degree < 1) return null;
            final roots = PolynomialService.rationalRoots(p)
                .map((r) => r.toDouble())
                .toList();
            final extrema =
                p.degree >= 2 ? _realRootsApprox(p.derivative()) : <double>[];
            // Rango centrado en los puntos de interés.
            final interesting = [...roots, ...extrema];
            double xMin, xMax;
            if (interesting.isEmpty) {
              xMin = -5;
              xMax = 5;
            } else {
              xMin = interesting.reduce(math.min) - 2;
              xMax = interesting.reduce(math.max) + 2;
              if (xMax - xMin < 4) {
                final mid = (xMin + xMax) / 2;
                xMin = mid - 2;
                xMax = mid + 2;
              }
            }
            final scheme = Theme.of(ctx).colorScheme;
            return CustomPaint(
              painter: PolynomialPlotPainter(
                coefficients:
                    p.coefficients.map((c) => c.toDouble()).toList(),
                xMin: xMin,
                xMax: xMax,
                roots: roots,
                extrema: extrema,
                curveColor: scheme.primary,
                textColor: scheme.onSurface,
                rootColor: scheme.error,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        CalcTool(
          title: s.pick('Ruffini: dividir entre (x − c)', 'Ruffini: divide by (x − c)'),
          description: s.pick('División sintética con pasos.',
              'Synthetic division with steps.'),
          fields: [
            ToolField(s.pick('Polinomio', 'Polynomial'), initial: 'x^3-6x^2+11x-6'),
            ToolField('c (p/q)', initial: '1'),
          ],
          compute: (i) => StepsService.ruffiniSteps(
                  PolynomialService.parse(i[0]), Fraction.parse(i[1]),
                  spanish: s.es)
              .toString(),
        ),
        CalcTool(
          title: s.pick('Sistema lineal 2×2 / 3×3', 'Linear system 2×2 / 3×3'),
          description: s.pick(
              'Filas "a,b,…,k" (coeficientes y término independiente) separadas por ";".',
              'Rows "a,b,…,k" (coefficients and constant) separated by ";".'),
          fields: [
            ToolField(s.pick('Sistema', 'System'), initial: '2,1,5; 1,-1,1'),
          ],
          compute: (i) {
            final rows = i[0]
                .split(';')
                .where((r) => r.trim().isNotEmpty)
                .map(_fracList)
                .toList();
            final sol = LinearSystemService.solveCramer(rows); // valida dimensiones
            final det = LinearSystemService.determinant(
                rows.map((r) => r.sublist(0, r.length - 1)).toList());
            final sb = StringBuffer();
            sb.writeln('det = $det');
            if (sol == null) {
              sb.write(s.pick('Sin solución única (determinante 0)',
                  'No unique solution (zero determinant)'));
            } else {
              const names = ['x', 'y', 'z'];
              for (int k = 0; k < sol.length; k++) {
                sb.write('${k > 0 ? '\n' : ''}${names[k]} = ${sol[k]}'
                    '  ≈ ${sol[k].toDouble().toStringAsFixed(6)}');
              }
            }
            return sb.toString();
          },
        ),
        CalcTool(
          title: s.pick('Resolver cuadrática ax²+bx+c', 'Solve quadratic ax²+bx+c'),
          fields: [
            ToolField('a (p/q)', initial: '1'),
            ToolField('b (p/q)', initial: '-5'),
            ToolField('c (p/q)', initial: '6'),
          ],
          compute: (i) {
            final sol = PolynomialService.solveQuadratic(
                Fraction.parse(i[0]), Fraction.parse(i[1]), Fraction.parse(i[2]));
            final sb = StringBuffer();
            sb.writeln('${s.pick('Discriminante', 'Discriminant')}: ${sol.discriminant}');
            sb.writeln('${s.pick('Naturaleza', 'Nature')}: ${_natureLabel(s, sol.nature)}');
            if (sol.rationalRoots.isNotEmpty) {
              sb.writeln('${s.pick('Raíces exactas', 'Exact roots')}: ${sol.rationalRoots.join(', ')}');
            }
            if (sol.realRoots.isNotEmpty) {
              sb.write('${s.pick('Raíces reales', 'Real roots')} ≈ '
                  '${sol.realRoots.map((r) => r.toStringAsFixed(6)).join(', ')}');
            }
            return sb.toString();
          },
        ),
        CalcTool(
          title: s.pick('Raíces reales de cúbica', 'Real roots of cubic'),
          description: 'ax³+bx²+cx+d',
          fields: [
            ToolField('a', initial: '1'),
            ToolField('b', initial: '-6'),
            ToolField('c', initial: '11'),
            ToolField('d', initial: '-6'),
          ],
          compute: (i) {
            final roots = PolynomialService.solveCubicReal(
                double.parse(i[0]), double.parse(i[1]),
                double.parse(i[2]), double.parse(i[3]));
            return '${s.pick('Raíces reales', 'Real roots')} ≈\n'
                '${roots.map((r) => r.toStringAsFixed(6)).join('\n')}';
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// TEORÍA DE NÚMEROS
// ════════════════════════════════════════════════════════════════════════════

class NumberTheoryToolScreen extends StatelessWidget {
  const NumberTheoryToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    return _ToolScaffold(
      title: s.catNumberTheory,
      tools: [
        CalcTool(
          title: s.pick('Raíz cuadrada modular √a mod p', 'Modular square root √a mod p'),
          description: s.pick('p debe ser primo.', 'p must be prime.'),
          fields: [ToolField('a', initial: '2'), ToolField('p', initial: '7')],
          compute: (i) {
            final a = _bi(i[0]), p = _bi(i[1]);
            final r = NumberTheoryAdvancedService.sqrtMod(a, p);
            if (r == null) {
              return s.pick('a no es residuo cuadrático mod p',
                  'a is not a quadratic residue mod p');
            }
            return '±$r  →  $r, ${p - r}';
          },
        ),
        CalcTool(
          title: s.pick('Congruencia lineal ax≡b (mod n)', 'Linear congruence ax≡b (mod n)'),
          fields: [ToolField('a', initial: '3'), ToolField('b', initial: '6'), ToolField('n', initial: '9')],
          compute: (i) {
            final sols = NumberTheoryAdvancedService.solveLinearCongruence(
                _bi(i[0]), _bi(i[1]), _bi(i[2]));
            return sols.isEmpty
                ? s.pick('Sin solución', 'No solution')
                : 'x ≡ ${sols.join(', ')} (mod ${i[2]})';
          },
          visualize: (ctx, i) {
            final n = _int(i[2]);
            if (n < 2 || n > 120) return null;
            final sols = NumberTheoryAdvancedService.solveLinearCongruence(
                _bi(i[0]), _bi(i[1]), _bi(i[2]));
            final scheme = Theme.of(ctx).colorScheme;
            return CustomPaint(
              painter: ModularClockPainter(
                modulus: n,
                highlighted: sols.map((x) => x.toInt()).toSet(),
                strokeColor: scheme.primary,
                highlightColor: scheme.error,
                textColor: scheme.onSurface,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        CalcTool(
          title: s.pick('Ecuación de Pell x²−Dy²=1', 'Pell equation x²−Dy²=1'),
          fields: [ToolField('D', initial: '61')],
          compute: (i) {
            final sol = NumberTheoryAdvancedService.solvePell(_bi(i[0]));
            return 'x = ${sol.x}\ny = ${sol.y}';
          },
        ),
        CalcTool(
          title: s.pick('Fracción continua de √n', 'Continued fraction of √n'),
          fields: [ToolField('n', initial: '7')],
          compute: (i) {
            final cf = NumberTheoryAdvancedService.continuedFractionSqrt(_bi(i[0]));
            if (cf.period.isEmpty) return '[${cf.a0}]';
            return '[${cf.a0}; (${cf.period.join(', ')})]';
          },
        ),
        CalcTool(
          title: s.pick('Sumas de cuadrados', 'Sums of squares'),
          fields: [ToolField('n', initial: '25')],
          compute: (i) {
            final n = _bi(i[0]);
            final two = NumberTheoryAdvancedService.sumOfTwoSquares(n);
            final four = NumberTheoryAdvancedService.sumOfFourSquares(n);
            final twoStr = two == null
                ? s.pick('no es suma de 2 cuadrados', 'not a sum of 2 squares')
                : '${two.a}² + ${two.b}²';
            return '${s.pick('Dos', 'Two')}: $twoStr\n'
                '${s.pick('Cuatro', 'Four')}: ${four.a}² + ${four.b}² + ${four.c}² + ${four.d}²';
          },
        ),
        CalcTool(
          title: s.pick('Número de Frobenius', 'Frobenius number'),
          description: s.pick('Valores separados por comas (mcd = 1).',
              'Comma-separated values (gcd = 1).'),
          fields: [ToolField(s.pick('Denominaciones', 'Denominations'), initial: '6, 9, 20')],
          compute: (i) {
            final r = NumberTheoryAdvancedService.frobeniusNumber(_intList(i[0]));
            if (r == null) {
              return s.pick('mcd ≠ 1: infinitos no representables',
                  'gcd ≠ 1: infinitely many non-representable');
            }
            return r.toString();
          },
        ),
        CalcTool(
          title: s.pick('Criba de Eratóstenes', 'Sieve of Eratosthenes'),
          description: s.pick('Cuadrícula con los primos hasta n resaltados (n ≤ 400).',
              'Grid with the primes up to n highlighted (n ≤ 400).'),
          fields: [ToolField('n', initial: '100')],
          compute: (i) {
            final n = _int(i[0]);
            if (n < 2) throw CalcException(CalcError.nGreaterThanOne);
            if (n > 400) {
              throw CalcException(CalcError.inputTooLarge, {'max': '400'});
            }
            final flags = NumberTheoryAdvancedService.sieveOfEratosthenes(n);
            final primes = <int>[];
            for (int v = 2; v <= n; v++) {
              if (flags[v]) primes.add(v);
            }
            return 'π($n) = ${primes.length}\n${primes.join(', ')}';
          },
          visualize: (ctx, i) {
            final n = _int(i[0]);
            if (n < 2 || n > 400) return null;
            final scheme = Theme.of(ctx).colorScheme;
            return CustomPaint(
              painter: SievePainter(
                isPrime: NumberTheoryAdvancedService.sieveOfEratosthenes(n),
                primeColor: scheme.primary,
                textColor: scheme.onSurface,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        CalcTool(
          title: s.pick('Residuos cuadráticos mod n', 'Quadratic residues mod n'),
          fields: [ToolField('n', initial: '11')],
          compute: (i) {
            final n = _int(i[0]);
            if (n < 2) throw CalcException(CalcError.nGreaterThanOne);
            if (n > 2000) {
              throw CalcException(CalcError.inputTooLarge, {'max': '2000'});
            }
            final residues = <int>{};
            for (int x = 0; x <= n ~/ 2; x++) {
              residues.add(x * x % n);
            }
            final sorted = residues.toList()..sort();
            return '${s.pick('Residuos', 'Residues')} (${sorted.length}): '
                '${sorted.join(', ')}\n'
                '${s.pick('No residuos', 'Non-residues')}: ${n - sorted.length}';
          },
        ),
        CalcTool(
          title: s.pick('Tabla φ, τ, σ, μ', 'Table φ, τ, σ, μ'),
          description: s.pick('Funciones multiplicativas para n en [a, b] (máx 30 filas).',
              'Multiplicative functions for n in [a, b] (max 30 rows).'),
          fields: [
            ToolField(s.pick('Desde', 'From'), initial: '1'),
            ToolField(s.pick('Hasta', 'To'), initial: '12'),
          ],
          compute: (i) {
            final a = _bi(i[0]), b = _bi(i[1]);
            if (a < BigInt.one) throw CalcException(CalcError.nPositive);
            if (b - a >= BigInt.from(30)) {
              throw CalcException(CalcError.inputTooLarge, {'max': '30'});
            }
            final sb = StringBuffer();
            sb.writeln('     n |     φ |     τ |      σ |  μ');
            for (BigInt n = a; n <= b; n += BigInt.one) {
              final phi = SpecialFunctionsService.eulerPhi(n);
              final tau = SpecialFunctionsService.divisorCount(n);
              final sigma = _sigma1(n);
              final mu = SpecialFunctionsService.moebiusMu(n);
              sb.writeln('${'$n'.padLeft(6)} |'
                  '${'$phi'.padLeft(6)} |'
                  '${'$tau'.padLeft(6)} |'
                  '${'$sigma'.padLeft(7)} |'
                  '${'$mu'.padLeft(3)}');
            }
            return sb.toString().trimRight();
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PROCEDIMIENTOS (PASO A PASO)
// ════════════════════════════════════════════════════════════════════════════

class StepsToolScreen extends StatelessWidget {
  const StepsToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    return _ToolScaffold(
      title: s.catSteps,
      tools: [
        CalcTool(
          title: s.pick('Euclides con pasos', 'Euclid with steps'),
          fields: [ToolField('a', initial: '240'), ToolField('b', initial: '46')],
          compute: (i) =>
              StepsService.euclidSteps(_bi(i[0]), _bi(i[1]), spanish: s.es)
                  .toString(),
        ),
        CalcTool(
          title: s.pick('Factorización con pasos', 'Factorization with steps'),
          fields: [ToolField('n', initial: '360')],
          compute: (i) =>
              StepsService.factorizationSteps(_bi(i[0]), spanish: s.es).toString(),
        ),
        CalcTool(
          title: s.pick('TCR con pasos', 'CRT with steps'),
          description: s.pick('Restos y módulos separados por comas.',
              'Comma-separated remainders and moduli.'),
          fields: [
            ToolField(s.pick('Restos', 'Remainders'), initial: '2, 3, 2'),
            ToolField(s.pick('Módulos', 'Moduli'), initial: '3, 5, 7'),
          ],
          compute: (i) =>
              StepsService.crtSteps(_biList(i[0]), _biList(i[1]), spanish: s.es)
                  .toString(),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// COMPLEJOS Y SUCESIONES
// ════════════════════════════════════════════════════════════════════════════

class ComplexSequencesToolScreen extends StatelessWidget {
  const ComplexSequencesToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    return _ToolScaffold(
      title: s.catComplexSeq,
      tools: [
        CalcTool(
          title: s.pick('Raíces de la unidad', 'Roots of unity'),
          fields: [ToolField('n', initial: '3')],
          computeAsync: (i) async {
            final n = _int(i[0]);
            final res = await compute(bigComplexRootsOfUnityWorker,
                <String, dynamic>{'n': n, 'digits': 20});
            if (res['ok'] != true) {
              throw FormatException(res['error'] as String? ?? 'error');
            }
            return res['result'] as String;
          },
          visualize: (ctx, i) {
            final n = _int(i[0]);
            if (n < 1 || n > 60) return null;
            final scheme = Theme.of(ctx).colorScheme;
            return CustomPaint(
              painter: UnitCirclePainter(
                points: Complex.rootsOfUnity(n)
                    .map((c) => Offset(c.re, c.im))
                    .toList(),
                strokeColor: scheme.primary,
                textColor: scheme.onSurface,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        CalcTool(
          title: s.pick('Potencia de complejo (De Moivre)', 'Complex power (De Moivre)'),
          description: '(re + im·i)^n',
          fields: [
            ToolField('re', initial: '1'),
            ToolField('im', initial: '1'),
            ToolField('n', initial: '8'),
          ],
          computeAsync: (i) async {
            final res = await compute(bigComplexPowWorker, <String, dynamic>{
              're': i[0],
              'im': i[1],
              'n': _int(i[2]),
              'digits': 20,
            });
            if (res['ok'] != true) {
              throw FormatException(res['error'] as String? ?? 'error');
            }
            return res['result'] as String;
          },
        ),
        CalcTool(
          title: s.pick('Raíces n-ésimas de complejo', 'n-th roots of complex'),
          fields: [
            ToolField('re', initial: '3'),
            ToolField('im', initial: '4'),
            ToolField('n', initial: '3'),
          ],
          computeAsync: (i) async {
            final res = await compute(bigComplexNthRootsWorker,
                <String, dynamic>{
                  're': i[0],
                  'im': i[1],
                  'n': _int(i[2]),
                  'digits': 20,
                });
            if (res['ok'] != true) {
              throw FormatException(res['error'] as String? ?? 'error');
            }
            return res['result'] as String;
          },
          visualize: (ctx, i) {
            final n = _int(i[2]);
            if (n < 1 || n > 60) return null;
            final z = Complex(double.parse(i[0]), double.parse(i[1]));
            if (z.modulus == 0) return null;
            final scheme = Theme.of(ctx).colorScheme;
            return CustomPaint(
              painter: UnitCirclePainter(
                points: z.nthRoots(n).map((c) => Offset(c.re, c.im)).toList(),
                strokeColor: scheme.primary,
                textColor: scheme.onSurface,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        CalcTool(
          title: s.pick('Recurrencia lineal', 'Linear recurrence'),
          description: s.pick(
              'aₙ = c₁aₙ₋₁+…+cₖaₙ₋ₖ. Coef. e iniciales por comas.',
              'aₙ = c₁aₙ₋₁+…+cₖaₙ₋ₖ. Comma-separated coeffs and seeds.'),
          fields: [
            ToolField(s.pick('Coeficientes', 'Coefficients'), initial: '1, 1'),
            ToolField(s.pick('Iniciales', 'Initial terms'), initial: '0, 1'),
            ToolField(s.pick('Cantidad', 'Count'), initial: '12'),
          ],
          compute: (i) {
            final terms = SequenceService.linearRecurrenceInts(
                _intList(i[0]), _intList(i[1]), _int(i[2]));
            return terms.map((f) => f.toString()).join(', ');
          },
        ),
        CalcTool(
          title: s.pick('Triángulo de Pascal (fila n)', 'Pascal triangle (row n)'),
          fields: [ToolField('n', initial: '6')],
          compute: (i) =>
              CombinatoricsExtraService.pascalRow(_int(i[0])).join(', '),
        ),
        CalcTool(
          title: s.pick('Pascal mod m (Sierpiński)', 'Pascal mod m (Sierpiński)'),
          description: s.pick(
              'Triángulo de Pascal módulo m coloreado por residuo. Con m=2 aparece el fractal de Sierpiński.',
              'Pascal triangle modulo m colored by residue. With m=2 the Sierpiński fractal appears.'),
          fields: [
            ToolField(s.pick('Filas', 'Rows'), initial: '32'),
            ToolField('m', initial: '2'),
          ],
          compute: (i) {
            final n = _int(i[0]), m = _int(i[1]);
            if (n < 0) throw CalcException(CalcError.nNonNegative);
            if (m < 2) throw CalcException(CalcError.nGreaterThanOne);
            if (n > 128) {
              throw CalcException(CalcError.inputTooLarge, {'max': '128'});
            }
            final rows = CombinatoricsExtraService.pascalTriangleMod(n - 1, m);
            int zeros = 0, total = 0;
            for (final row in rows) {
              for (final v in row) {
                total++;
                if (v == 0) zeros++;
              }
            }
            return '${s.pick('Filas', 'Rows')}: $n  (mod $m)\n'
                '${s.pick('Coeficientes', 'Coefficients')}: $total, '
                '${s.pick('divisibles por', 'divisible by')} $m: $zeros';
          },
          visualize: (ctx, i) {
            final n = _int(i[0]), m = _int(i[1]);
            if (n < 1 || n > 128 || m < 2) return null;
            final scheme = Theme.of(ctx).colorScheme;
            return CustomPaint(
              painter: PascalModPainter(
                rows: CombinatoricsExtraService.pascalTriangleMod(n - 1, m),
                modulus: m,
                fillColor: scheme.primary,
                textColor: scheme.onSurface,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        CalcTool(
          title: s.pick('Expansión binomial (a+b)ⁿ', 'Binomial expansion (a+b)ⁿ'),
          fields: [ToolField('n', initial: '5')],
          compute: (i) {
            final n = _int(i[0]);
            if (n < 0) throw CalcException(CalcError.nNonNegative);
            if (n > 30) {
              throw CalcException(CalcError.inputTooLarge, {'max': '30'});
            }
            final row = CombinatoricsExtraService.pascalRow(n);
            final terms = <String>[];
            for (int k = 0; k <= n; k++) {
              final coef = row[k];
              final pa = n - k, pb = k;
              final sb = StringBuffer();
              if (coef != BigInt.one || (pa == 0 && pb == 0)) sb.write(coef);
              if (pa > 0) sb.write(pa == 1 ? 'a' : 'a${_superscript(pa)}');
              if (pb > 0) sb.write(pb == 1 ? 'b' : 'b${_superscript(pb)}');
              terms.add(sb.toString());
            }
            return '(a+b)${_superscript(n)} = ${terms.join(' + ')}';
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ESTADÍSTICA
// ════════════════════════════════════════════════════════════════════════════

class StatisticsToolScreen extends StatelessWidget {
  const StatisticsToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    return _ToolScaffold(
      title: s.catStatistics,
      tools: [
        CalcTool(
          title: s.pick('Estadística descriptiva', 'Descriptive statistics'),
          description: s.pick(
              'Valores (enteros, fracciones o decimales) separados por comas.',
              'Comma-separated values (integers, fractions or decimals).'),
          fields: [
            ToolField(s.pick('Valores', 'Values'), initial: '2, 4, 4, 5, 7'),
          ],
          compute: (i) {
            final r = StatisticsService.descriptive(_fracList(i[0]));
            final modes = r.modes.isEmpty
                ? s.pick('ninguna', 'none')
                : r.modes.join(', ');
            final sb = StringBuffer();
            sb.writeln('n = ${r.count}');
            sb.writeln('min = ${r.min}, max = ${r.max}, '
                '${s.pick('rango', 'range')} = ${r.range}');
            sb.writeln('${s.pick('Media', 'Mean')}: ${r.mean}'
                '  ≈ ${r.mean.toDouble().toStringAsFixed(6)}');
            sb.writeln('${s.pick('Mediana', 'Median')}: ${r.median}');
            sb.writeln('${s.pick('Moda', 'Mode')}: $modes');
            sb.writeln('${s.pick('Varianza (poblacional)', 'Variance (population)')}: '
                '${r.variancePopulation}');
            if (r.varianceSample != null) {
              sb.writeln('${s.pick('Varianza (muestral)', 'Variance (sample)')}: '
                  '${r.varianceSample}');
            }
            sb.write('${s.pick('Desv. estándar', 'Std. deviation')} ≈ '
                '${r.stdDevPopulation.toStringAsFixed(6)}');
            return sb.toString();
          },
        ),
        CalcTool(
          title: s.pick('Desigualdad de medias (QM ≥ AM ≥ GM ≥ HM)',
              'Mean inequality (QM ≥ AM ≥ GM ≥ HM)'),
          description: s.pick('Valores positivos separados por comas.',
              'Comma-separated positive values.'),
          fields: [
            ToolField(s.pick('Valores', 'Values'), initial: '1, 2, 4'),
          ],
          compute: (i) {
            final r = StatisticsService.means(_fracList(i[0]));
            return 'QM ≈ ${r.quadratic.toStringAsFixed(6)}\n'
                'AM = ${r.arithmetic}  ≈ ${r.arithmetic.toDouble().toStringAsFixed(6)}\n'
                'GM ≈ ${r.geometric.toStringAsFixed(6)}\n'
                'HM = ${r.harmonic}  ≈ ${r.harmonic.toDouble().toStringAsFixed(6)}\n'
                'QM ≥ AM ≥ GM ≥ HM ✓';
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MATRICES (álgebra lineal exacta)
// ════════════════════════════════════════════════════════════════════════════

class MatricesToolScreen extends StatelessWidget {
  const MatricesToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    final matrixHint = s.pick(
        'Filas separadas por ";", entradas por ",". Admite fracciones.',
        'Rows separated by ";", entries by ",". Fractions allowed.');
    return _ToolScaffold(
      title: s.catMatrices,
      tools: [
        CalcTool(
          title: s.pick('Determinante', 'Determinant'),
          description: matrixHint,
          fields: [
            ToolField(s.pick('Matriz', 'Matrix'), initial: '6,1,1; 4,-2,5; 2,8,7'),
          ],
          compute: (i) {
            final m = _matrix(i[0]);
            if (!m.isSquare) {
              return s.pick('La matriz debe ser cuadrada', 'Matrix must be square');
            }
            final det = m.determinant();
            return 'det = $det  ≈ ${det.toDouble()}';
          },
        ),
        CalcTool(
          title: s.pick('Inversa', 'Inverse'),
          description: matrixHint,
          fields: [
            ToolField(s.pick('Matriz', 'Matrix'), initial: '4,7; 2,6'),
          ],
          compute: (i) {
            final m = _matrix(i[0]);
            final inv = m.inverse();
            if (inv == null) {
              return s.pick('Matriz singular o no cuadrada (sin inversa)',
                  'Singular or non-square matrix (no inverse)');
            }
            return inv.toString();
          },
        ),
        CalcTool(
          title: s.pick('Multiplicar A × B', 'Multiply A × B'),
          description: s.pick('Dos matrices separadas por "|".',
              'Two matrices separated by "|".'),
          fields: [
            ToolField('A | B', initial: '1,2; 3,4 | 5,6; 7,8'),
          ],
          compute: (i) {
            final parts = i[0].split('|');
            if (parts.length != 2) {
              throw CalcException(CalcError.invalidSystem);
            }
            return (_matrix(parts[0]) * _matrix(parts[1])).toString();
          },
        ),
        CalcTool(
          title: s.pick('Resolver A·x = b (n×n)', 'Solve A·x = b (n×n)'),
          description: s.pick(
              'Matriz A y vector b separados por "|".',
              'Matrix A and vector b separated by "|".'),
          fields: [
            ToolField('A | b', initial: '2,1,1; 1,2,1; 1,1,2 | 1,1,1'),
          ],
          compute: (i) {
            final parts = i[0].split('|');
            if (parts.length != 2) {
              throw CalcException(CalcError.invalidSystem);
            }
            final a = _matrix(parts[0]);
            final b = _fracList(parts[1]);
            final x = a.solve(b);
            if (x == null) {
              return s.pick('Sin solución única (singular)',
                  'No unique solution (singular)');
            }
            final names = ['x', 'y', 'z', 'w'];
            final sb = StringBuffer();
            for (int k = 0; k < x.length; k++) {
              final name = k < names.length ? names[k] : 'x${k + 1}';
              sb.write('${k > 0 ? '\n' : ''}$name = ${x[k]}'
                  '  ≈ ${x[k].toDouble().toStringAsFixed(6)}');
            }
            return sb.toString();
          },
        ),
        CalcTool(
          title: s.pick('Rango y transpuesta', 'Rank and transpose'),
          description: matrixHint,
          fields: [
            ToolField(s.pick('Matriz', 'Matrix'), initial: '1,2,3; 2,4,6; 1,0,1'),
          ],
          compute: (i) {
            final m = _matrix(i[0]);
            return '${s.pick('Rango', 'Rank')}: ${m.rank()}\n'
                '${s.pick('Transpuesta', 'Transpose')}:\n${m.transpose()}';
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// CÁLCULO (numérico)
// ════════════════════════════════════════════════════════════════════════════

class CalculusToolScreen extends StatelessWidget {
  const CalculusToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    final fnHint = s.pick(
        'Función de x. Trig en radianes. Ej: x^2+sin(x), 1/x, exp(x).',
        'Function of x. Trig in radians. E.g. x^2+sin(x), 1/x, exp(x).');
    return _ToolScaffold(
      title: s.catCalculus,
      tools: [
        CalcTool(
          title: s.pick('Derivada f\'(x₀)', 'Derivative f\'(x₀)'),
          description: fnHint,
          fields: [
            ToolField('f(x)', initial: 'x^2 + sin(x)'),
            ToolField('x₀', initial: '1'),
          ],
          compute: (i) {
            final d = CalculusService.derivative(i[0], double.parse(i[1]));
            if (!CalculusService.isUsable(d)) {
              throw CalcException(CalcError.invalidOperation);
            }
            return "f'(${i[1]}) ≈ ${_fmtNum(d)}";
          },
        ),
        CalcTool(
          title: s.pick('Integral definida ∫', 'Definite integral ∫'),
          description: fnHint,
          fields: [
            ToolField('f(x)', initial: 'x^2'),
            ToolField('a', initial: '0'),
            ToolField('b', initial: '1'),
          ],
          compute: (i) {
            final v = CalculusService.integral(
                i[0], double.parse(i[1]), double.parse(i[2]));
            if (!CalculusService.isUsable(v)) {
              throw CalcException(CalcError.invalidOperation);
            }
            return '∫ from ${i[1]} to ${i[2]} ≈ ${_fmtNum(v)}';
          },
        ),
        CalcTool(
          title: s.pick('Límite (numérico)', 'Limit (numerical)'),
          description: fnHint,
          fields: [
            ToolField('f(x)', initial: 'sin(x)/x'),
            ToolField('x₀', initial: '0'),
          ],
          compute: (i) {
            final l = CalculusService.limit(i[0], double.parse(i[1]));
            if (l == null) {
              return s.pick(
                  'No existe (límites laterales distintos o no finitos)',
                  'Does not exist (one-sided limits differ or not finite)');
            }
            return 'lim x→${i[1]} ≈ ${_fmtNum(l)}';
          },
        ),
      ],
    );
  }
}

/// Formatea un double: entero exacto sin decimales; si no, ~10 cifras limpias.
String _fmtNum(double v) {
  if (v == v.roundToDouble() && v.abs() < 1e15) {
    return v.toInt().toString();
  }
  return double.parse(v.toStringAsPrecision(10)).toString();
}
