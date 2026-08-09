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
import '../../services/algebra_service.dart';
import '../../services/calculus_service.dart';
import '../../services/combinatorics_extra_service.dart';
import '../../services/geometry_service.dart';
import '../../services/linear_system_service.dart';
import '../../services/number_theory_advanced_service.dart';
import '../../services/polynomial_service.dart';
import '../../services/prime_utils.dart';
import '../../services/sequence_service.dart';
import '../../services/special_functions_service.dart';
import '../../services/statistics_service.dart';
import '../../services/steps_service.dart';
import '../../services/surd_service.dart';
import '../../widgets/geometry_painters.dart';
import '../../widgets/number_painters.dart';
import 'calc_tool.dart';
import 'olympiad_strings.dart';

// ── Parsing helpers ──────────────────────────────────────────────────────────

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

double _dbl(String s) {
  final v = double.tryParse(s.trim());
  if (v == null || !v.isFinite) {
    throw CalcException(CalcError.invalidNumber, {'value': s});
  }
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

/// Parses a matrix: rows separated by ';', entries by ',' or spaces.
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

/// Parses "x,y" as a point with rational coordinates.
Point _point(String s) {
  final xy = s.split(',');
  if (xy.length != 2) {
    throw CalcException(CalcError.invalidPoint, {'value': s});
  }
  return Point(Fraction.parse(xy[0]), Fraction.parse(xy[1]));
}

/// Parses a list of "x,y" points separated by ";".
List<Point> _pointList(String s) => s
    .split(';')
    .where((p) => p.trim().isNotEmpty)
    .map(_point)
    .toList();

/// Sum of divisors σ(n) for the multiplicative functions table.
///
/// σ(pᵉ) = 1 + p + … + pᵉ, multiplied across the factorization. Uses the
/// shared factorizer rather than an O(√n) walk, which hung on large inputs.
BigInt _sigma1(BigInt n) {
  BigInt result = BigInt.one;
  factorize(n).forEach((p, e) {
    BigInt term = BigInt.one, power = BigInt.one;
    for (int i = 0; i < e; i++) {
      power *= p;
      term += power;
    }
    result *= term;
  });
  return result;
}

/// Approximate real roots of a degree 1–3 polynomial (for the plotter's
/// extrema); for higher degrees it returns only the rational roots.
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

/// Enumerates the lattice points of an integer-vertex polygon, so they can
/// be drawn: (boundary, interior). If the sweep area is too large,
/// it returns empty lists (the drawing omits the points).
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
    // Ray casting towards +x.
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

/// Converts an integer to Unicode superscripts (3 → "³"), for the root index.
String _superscript(int n) {
  const map = {
    '0': '⁰', '1': '¹', '2': '²', '3': '³', '4': '⁴',
    '5': '⁵', '6': '⁶', '7': '⁷', '8': '⁸', '9': '⁹', '-': '⁻',
  };
  return n.toString().split('').map((d) => map[d] ?? d).join();
}

// Localization of the results that the services return as enumerations.

String _sidesLabel(OlympiadStrings s, TriangleSides v) {
  switch (v) {
    case TriangleSides.equilateral:
      return s.pick('equilátero', 'equilateral', pt: 'equilátero', fr: 'équilatéral', id: 'sama sisi', vi: 'đều', ru: 'равносторонний', it: 'equilatero');
    case TriangleSides.isosceles:
      return s.pick('isósceles', 'isosceles', pt: 'isósceles', fr: 'isocèle', id: 'sama kaki', vi: 'cân', ru: 'равнобедренный', it: 'isoscele');
    case TriangleSides.scalene:
      return s.pick('escaleno', 'scalene', pt: 'escaleno', fr: 'scalène', id: 'sembarang', vi: 'thường', ru: 'разносторонний', it: 'scaleno');
  }
}

String _anglesLabel(OlympiadStrings s, TriangleAngles v) {
  switch (v) {
    case TriangleAngles.right:
      return s.pick('rectángulo', 'right', pt: 'retângulo', fr: 'rectangle', id: 'siku-siku', vi: 'vuông', ru: 'прямоугольный', it: 'rettangolo');
    case TriangleAngles.acute:
      return s.pick('acutángulo', 'acute', pt: 'acutângulo', fr: 'acutangle', id: 'lancip', vi: 'nhọn', ru: 'остроугольный', it: 'acutangolo');
    case TriangleAngles.obtuse:
      return s.pick('obtusángulo', 'obtuse', pt: 'obtusângulo', fr: 'obtusangle', id: 'tumpul', vi: 'tù', ru: 'тупоугольный', it: 'ottusangolo');
  }
}

String _natureLabel(OlympiadStrings s, QuadraticNature v) {
  switch (v) {
    case QuadraticNature.twoRealDistinct:
      return s.pick('dos reales distintas', 'two distinct real', pt: 'duas reais distintas', fr: 'deux réelles distinctes', id: 'dua akar real berbeda', vi: 'hai nghiệm thực phân biệt', ru: 'два различных вещественных', it: 'due reali distinte');
    case QuadraticNature.doubleRoot:
      return s.pick('una raíz doble', 'one double root', pt: 'uma raiz dupla', fr: 'une racine double', id: 'satu akar kembar', vi: 'một nghiệm kép', ru: 'один двойной корень', it: 'una radice doppia');
    case QuadraticNature.complexConjugate:
      return s.pick('complejas conjugadas', 'complex conjugate', pt: 'complexas conjugadas', fr: 'complexes conjuguées', id: 'sepasang akar kompleks konjugat', vi: 'hai nghiệm phức liên hợp', ru: 'комплексно-сопряжённые', it: 'complesse coniugate');
  }
}

/// Base screen: a scrollable list of tools.
class _ToolScaffold extends StatelessWidget {
  final String title;
  final List<Widget> tools;
  const _ToolScaffold({required this.title, required this.tools});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), elevation: 0),
      // Extra bottom padding: in edge-to-edge (Android 15) the content ends
      // up behind the system navigation bar without this inset.
      body: ListView(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, 16 + MediaQuery.paddingOf(context).bottom),
          children: tools),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// FRACTIONS
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
          title: s.pick('Aritmética de fracciones', 'Fraction arithmetic', pt: 'Aritmética de frações', fr: 'Arithmétique des fractions', id: 'Aritmetika pecahan', vi: 'Số học phân số', ru: 'Арифметика дробей', it: 'Aritmetica delle frazioni'),
          description: s.pick(
              'Operación exacta entre dos fracciones (p/q).',
              'Exact operation between two fractions (p/q).', pt: 'Operação exata entre duas frações (p/q).', fr: 'Opération exacte entre deux fractions (p/q).', id: 'Operasi eksak antara dua pecahan (p/q).', vi: 'Phép tính chính xác giữa hai phân số (p/q).', ru: 'Точная операция над двумя дробями (p/q).', it: 'Operazione esatta tra due frazioni (p/q).'),
          fields: [
            ToolField(s.pick('Fracción 1', 'Fraction 1', pt: 'Fração 1', fr: 'Fraction 1', id: 'Pecahan 1', vi: 'Phân số 1', ru: 'Дробь 1', it: 'Frazione 1'), hint: '1/2', initial: '1/2'),
            ToolField(s.pick('Operación (+ - * /)', 'Operation (+ - * /)', pt: 'Operação (+ - * /)', fr: 'Opération (+ - * /)', id: 'Operasi (+ - * /)', vi: 'Phép tính (+ - * /)', ru: 'Операция (+ - * /)', it: 'Operazione (+ - * /)'), initial: '+'),
            ToolField(s.pick('Fracción 2', 'Fraction 2', pt: 'Fração 2', fr: 'Fraction 2', id: 'Pecahan 2', vi: 'Phân số 2', ru: 'Дробь 2', it: 'Frazione 2'), hint: '1/3', initial: '1/3'),
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
                '${s.pick('Mixto', 'Mixed', pt: 'Misto', fr: 'Mixte', id: 'Pecahan campuran', vi: 'Hỗn số', ru: 'Смешанная', it: 'Misto')}${s.colon} ${r.toMixedString()}\n'
                '${s.pick('Decimal', 'Decimal', pt: 'Decimal', fr: 'Décimal', id: 'Desimal', vi: 'Thập phân', ru: 'Десятичная', it: 'Decimale')}${s.colon} ${r.toDouble()}';
          },
        ),
        CalcTool(
          title: s.pick('Simplificar / convertir', 'Simplify / convert', pt: 'Simplificar / converter', fr: 'Simplifier / convertir', id: 'Sederhanakan / konversikan', vi: 'Rút gọn / chuyển đổi', ru: 'Упростить / преобразовать', it: 'Semplifica / converti'),
          description: s.pick('Reduce una fracción o un decimal a su forma exacta.',
              'Reduce a fraction or decimal to exact form.', pt: 'Reduz uma fração ou um decimal à sua forma exata.', fr: 'Réduit une fraction ou un décimal à sa forme exacte.', id: 'Menyederhanakan sebuah pecahan atau desimal ke bentuk eksaknya.', vi: 'Đưa một phân số hoặc số thập phân về dạng chính xác.', ru: 'Приводит дробь или десятичное число к точному виду.', it: 'Riduce una frazione o un decimale alla sua forma esatta.'),
          fields: [
            ToolField(s.pick('Valor (p/q o decimal)', 'Value (p/q or decimal)', pt: 'Valor (p/q ou decimal)', fr: 'Valeur (p/q ou décimal)', id: 'Nilai (p/q atau desimal)', vi: 'Giá trị (p/q hoặc thập phân)', ru: 'Значение (p/q или десятичное)', it: 'Valore (p/q o decimale)'), initial: '18/12'),
          ],
          compute: (i) {
            final r = Fraction.parse(i[0]);
            return '${s.pick('Reducida', 'Reduced', pt: 'Reduzida', fr: 'Réduite', id: 'Bentuk paling sederhana', vi: 'Tối giản', ru: 'Несократимая', it: 'Ridotta')}${s.colon} $r\n'
                '${s.pick('Mixto', 'Mixed', pt: 'Misto', fr: 'Mixte', id: 'Pecahan campuran', vi: 'Hỗn số', ru: 'Смешанная', it: 'Misto')}${s.colon} ${r.toMixedString()}\n'
                '${s.pick('Decimal', 'Decimal', pt: 'Decimal', fr: 'Décimal', id: 'Desimal', vi: 'Thập phân', ru: 'Десятичная', it: 'Decimale')}${s.colon} ${r.toDouble()}';
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RADICALS
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
          title: s.pick('Simplificar √n', 'Simplify √n', pt: 'Simplificar √n', fr: 'Simplifier √n', id: 'Sederhanakan √n', vi: 'Rút gọn √n', ru: 'Упростить √n', it: 'Semplifica √n'),
          fields: [ToolField('n', initial: '72')],
          compute: (i) => Surd.sqrt(_bi(i[0])).toString(),
        ),
        CalcTool(
          title: s.pick('Raíz n-ésima', 'n-th root', pt: 'Raiz n-ésima', fr: 'Racine n-ième', id: 'Akar pangkat n', vi: 'Căn bậc n', ru: 'Корень n-й степени', it: 'Radice n-esima'),
          description: s.pick('Extrae factores de la raíz de índice k.',
              'Extracts factors from the k-th root.', pt: 'Extrai fatores da raiz de índice k.', fr: "Extrait des facteurs de la racine d'indice k.", id: 'Mengeluarkan faktor dari akar pangkat k.', vi: 'Rút các thừa số ra khỏi căn bậc k.', ru: 'Выносит множители из корня степени k.', it: 'Estrae fattori dalla radice di indice k.'),
          fields: [
            ToolField(s.pick('Radicando', 'Radicand', pt: 'Radicando', fr: 'Radicande', id: 'Bilangan di bawah akar', vi: 'Biểu thức dưới căn', ru: 'Подкоренное выражение', it: 'Radicando'), initial: '54'),
            ToolField(s.pick('Índice k', 'Index k', pt: 'Índice k', fr: 'Indice k', id: 'Indeks k', vi: 'Bậc k', ru: 'Показатель k', it: 'Indice k'), initial: '3'),
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
          title: s.pick('Racionalizar a/√b', 'Rationalize a/√b', pt: 'Racionalizar a/√b', fr: 'Rationaliser a/√b', id: 'Rasionalkan a/√b', vi: 'Trục căn thức a/√b', ru: 'Избавиться от иррациональности в a/√b', it: 'Razionalizza a/√b'),
          fields: [
            ToolField('a (p/q)', initial: '1'),
            ToolField('b', initial: '2'),
          ],
          compute: (i) =>
              SurdService.rationalizeOverSqrt(Fraction.parse(i[0]), _bi(i[1])).toString(),
        ),
        CalcTool(
          title: s.pick('Racionalizar a/(c+√d)', 'Rationalize a/(c+√d)', pt: 'Racionalizar a/(c+√d)', fr: 'Rationaliser a/(c+√d)', id: 'Rasionalkan a/(c+√d)', vi: 'Trục căn thức a/(c+√d)', ru: 'Избавиться от иррациональности в a/(c+√d)', it: 'Razionalizza a/(c+√d)'),
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
// GEOMETRY
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
          title: s.pick('Triángulo por lados', 'Triangle from sides', pt: 'Triângulo pelos lados', fr: 'Triangle par les côtés', id: 'Segitiga dari ketiga sisi', vi: 'Tam giác theo ba cạnh', ru: 'Треугольник по сторонам', it: 'Triangolo dai lati'),
          description: s.pick('Tipo, área (Herón), R, r y perímetro.',
              'Type, area (Heron), R, r and perimeter.', pt: 'Tipo, área (Heron), R, r e perímetro.', fr: 'Type, aire (Héron), R, r et périmètre.', id: 'Jenis, luas (Heron), R, r dan keliling.', vi: 'Loại tam giác, diện tích (Heron), R, r và chu vi.', ru: 'Вид, площадь (Герон), R, r и периметр.', it: 'Tipo, area (Erone), R, r e perimetro.'),
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
            return '${s.pick('Tipo', 'Type', pt: 'Tipo', fr: 'Type', id: 'Jenis', vi: 'Loại', ru: 'Вид', it: 'Tipo')}${s.colon} ${_sidesLabel(s, t.bySides)}, ${_anglesLabel(s, t.byAngles)}\n'
                '${s.pick('Perímetro', 'Perimeter', pt: 'Perímetro', fr: 'Périmètre', id: 'Keliling', vi: 'Chu vi', ru: 'Периметр', it: 'Perimetro')}${s.colon} ${a + b + c}\n'
                '${s.pick('Área', 'Area', pt: 'Área', fr: 'Aire', id: 'Luas', vi: 'Diện tích', ru: 'Площадь', it: 'Area')}${s.colon} $area  ≈ ${area.toDouble().toStringAsFixed(4)}\n'
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
          title: s.pick('Ángulos del triángulo (ley del coseno)',
              'Triangle angles (law of cosines)', pt: 'Ângulos do triângulo (lei dos cossenos)', fr: 'Angles du triangle (loi des cosinus)', id: 'Sudut-sudut segitiga (aturan kosinus)', vi: 'Các góc của tam giác (định lý cosin)', ru: 'Углы треугольника (теорема косинусов)', it: 'Angoli del triangolo (teorema del coseno)'),
          description: s.pick(
              'Coseno exacto de cada ángulo y su valor en grados.',
              'Exact cosine of each angle and its value in degrees.', pt: 'Cosseno exato de cada ângulo e seu valor em graus.', fr: 'Cosinus exact de chaque angle et sa valeur en degrés.', id: 'Kosinus eksak tiap sudut beserta nilainya dalam derajat.', vi: 'Cosin chính xác của từng góc và giá trị theo độ.', ru: 'Точный косинус каждого угла и его значение в градусах.', it: 'Coseno esatto di ogni angolo e il suo valore in gradi.'),
          fields: [
            ToolField('a', initial: '13'),
            ToolField('b', initial: '14'),
            ToolField('c', initial: '15'),
          ],
          compute: (i) {
            final a = _bi(i[0]), b = _bi(i[1]), c = _bi(i[2]);
            final sb = StringBuffer();
            // Each angle is named after the side it faces.
            const names = ['A', 'B', 'C'];
            final opposite = [a, b, c];
            final others = [
              [b, c],
              [a, c],
              [a, b],
            ];
            for (int k = 0; k < 3; k++) {
              final cos = GeometryService.cosineOfAngle(
                  opposite[k], others[k][0], others[k][1]);
              final deg = GeometryService.angleDegrees(
                  opposite[k], others[k][0], others[k][1]);
              sb.write('${k > 0 ? '\n' : ''}${names[k]}: cos = $cos'
                  '  ≈ ${deg.toStringAsFixed(4)}°');
            }
            return sb.toString();
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
          title: s.pick('Ley de los senos', 'Law of sines', pt: 'Lei dos senos', fr: 'Loi des sinus', id: 'Aturan sinus', vi: 'Định lý sin', ru: 'Теорема синусов', it: 'Teorema dei seni'),
          description: s.pick(
              'Dado un lado y su ángulo opuesto, halla el lado opuesto a otro ángulo.',
              'Given a side and its opposite angle, find the side opposite another angle.', pt: 'Dado um lado e o seu ângulo oposto, encontra o lado oposto a outro ângulo.', fr: 'Étant donné un côté et son angle opposé, trouve le côté opposé à un autre angle.', id: 'Diketahui satu sisi dan sudut di hadapannya, mencari sisi di hadapan sudut lain.', vi: 'Biết một cạnh và góc đối diện, tìm cạnh đối diện với một góc khác.', ru: 'По стороне и противолежащему ей углу находит сторону, противолежащую другому углу.', it: 'Dato un lato e il suo angolo opposto, trova il lato opposto a un altro angolo.'),
          fields: [
            ToolField(s.pick('Lado conocido', 'Known side', pt: 'Lado conhecido', fr: 'Côté connu', id: 'Sisi yang diketahui', vi: 'Cạnh đã biết', ru: 'Известная сторона', it: 'Lato noto'), initial: '10'),
            ToolField(s.pick('Su ángulo opuesto (°)', 'Its opposite angle (°)', pt: 'Seu ângulo oposto (°)', fr: 'Son angle opposé (°)', id: 'Sudut di hadapannya (°)', vi: 'Góc đối diện của nó (°)', ru: 'Противолежащий ей угол (°)', it: 'Il suo angolo opposto (°)'),
                initial: '30'),
            ToolField(s.pick('Ángulo buscado (°)', 'Wanted angle (°)', pt: 'Ângulo procurado (°)', fr: 'Angle cherché (°)', id: 'Sudut yang dicari (°)', vi: 'Góc cần tìm (°)', ru: 'Искомый угол (°)', it: 'Angolo cercato (°)'),
                initial: '45'),
          ],
          compute: (i) {
            final known = _dbl(i[0]);
            final knownAngle = _dbl(i[1]);
            final wantedAngle = _dbl(i[2]);
            final side = GeometryService.sideFromLawOfSines(
                known, knownAngle, wantedAngle);
            final third = 180 - knownAngle - wantedAngle;
            return '${s.pick('Lado buscado', 'Wanted side', pt: 'Lado procurado', fr: 'Côté cherché', id: 'Sisi yang dicari', vi: 'Cạnh cần tìm', ru: 'Искомая сторона', it: 'Lato cercato')} ≈ '
                '${side.toStringAsFixed(6)}\n'
                '${s.pick('Tercer ángulo', 'Third angle', pt: 'Terceiro ângulo', fr: 'Troisième angle', id: 'Sudut ketiga', vi: 'Góc thứ ba', ru: 'Третий угол', it: 'Terzo angolo')} = '
                '${third.toStringAsFixed(4)}°';
          },
        ),
        CalcTool(
          title: s.pick('Ternas pitagóricas primitivas', 'Primitive Pythagorean triples', pt: 'Ternos pitagóricos primitivos', fr: 'Triplets pythagoriciens primitifs', id: 'Tripel Pythagoras primitif', vi: 'Bộ ba Pythagore nguyên thuỷ', ru: 'Примитивные пифагоровы тройки', it: 'Terne pitagoriche primitive'),
          fields: [ToolField(s.pick('Hipotenusa máx', 'Max hypotenuse', pt: 'Hipotenusa máx', fr: 'Hypoténuse max', id: 'Sisi miring maks.', vi: 'Cạnh huyền tối đa', ru: 'Макс. гипотенуза', it: 'Ipotenusa max'), initial: '50')],
          compute: (i) {
            final list = GeometryService.primitivePythagoreanTriples(_int(i[0]));
            if (list.isEmpty) return s.pick('Ninguna', 'None', pt: 'Nenhuma', fr: 'Aucune', id: 'Tidak ada', vi: 'Không có', ru: 'Нет ни одной', it: 'Nessuna');
            return list.map((t) => '${t[0]}, ${t[1]}, ${t[2]}').join('\n');
          },
        ),
        CalcTool(
          title: s.pick('Todas las ternas pitagóricas',
              'All Pythagorean triples', pt: 'Todos os ternos pitagóricos', fr: 'Tous les triplets pythagoriciens', id: 'Semua tripel Pythagoras', vi: 'Tất cả bộ ba Pythagore', ru: 'Все пифагоровы тройки', it: 'Tutte le terne pitagoriche'),
          description: s.pick(
              'Primitivas y sus múltiplos, ordenadas por hipotenusa.',
              'Primitives and their multiples, ordered by hypotenuse.', pt: 'Primitivos e seus múltiplos, ordenados pela hipotenusa.', fr: 'Les primitifs et leurs multiples, triés par hypoténuse.', id: 'Yang primitif beserta kelipatannya, diurutkan menurut sisi miring.', vi: 'Bộ nguyên thuỷ và các bội của chúng, xếp theo cạnh huyền.', ru: 'Примитивные и кратные им, по возрастанию гипотенузы.', it: 'Le primitive e i loro multipli, ordinate per ipotenusa.'),
          fields: [ToolField(s.pick('Hipotenusa máx', 'Max hypotenuse', pt: 'Hipotenusa máx', fr: 'Hypoténuse max', id: 'Sisi miring maks.', vi: 'Cạnh huyền tối đa', ru: 'Макс. гипотенуза', it: 'Ipotenusa max'), initial: '50')],
          compute: (i) {
            final list = GeometryService.allPythagoreanTriples(_int(i[0]));
            if (list.isEmpty) return s.pick('Ninguna', 'None', pt: 'Nenhuma', fr: 'Aucune', id: 'Tidak ada', vi: 'Không có', ru: 'Нет ни одной', it: 'Nessuna');
            return '${s.pick('Total', 'Total', pt: 'Total', fr: 'Total', id: 'Total', vi: 'Tổng cộng', ru: 'Всего', it: 'Totale')}${s.colon} ${list.length}\n'
                '${list.map((t) => '${t[0]}, ${t[1]}, ${t[2]}').join('\n')}';
          },
        ),
        CalcTool(
          title: s.pick('Triángulos heronianos', 'Heronian triangles', pt: 'Triângulos heronianos', fr: 'Triangles héroniens', id: 'Segitiga Heron', vi: 'Tam giác Heron', ru: 'Героновы треугольники', it: 'Triangoli eroniani'),
          description: s.pick(
              'Lados enteros y área entera, con todos los lados ≤ n.',
              'Integer sides and integer area, with every side ≤ n.', pt: 'Lados inteiros e área inteira, com todos os lados ≤ n.', fr: 'Côtés entiers et aire entière, avec tous les côtés ≤ n.', id: 'Sisi bulat dan luas bulat, dengan semua sisi ≤ n.', vi: 'Ba cạnh nguyên và diện tích nguyên, mọi cạnh ≤ n.', ru: 'Целые стороны и целая площадь, все стороны ≤ n.', it: 'Lati interi e area intera, con tutti i lati ≤ n.'),
          fields: [ToolField(s.pick('Lado máx', 'Max side', pt: 'Lado máx', fr: 'Côté max', id: 'Sisi maks.', vi: 'Cạnh tối đa', ru: 'Макс. сторона', it: 'Lato max'), initial: '20')],
          compute: (i) {
            final list = GeometryService.heronianTriangles(_int(i[0]));
            if (list.isEmpty) return s.pick('Ninguno', 'None', pt: 'Nenhum', fr: 'Aucun', id: 'Tidak ada', vi: 'Không có', ru: 'Нет ни одного', it: 'Nessuno');
            final areaLabel = s.pick('área', 'area', pt: 'área', fr: 'aire', id: 'luas', vi: 'diện tích', ru: 'площадь', it: 'area');
            return '${s.pick('Total', 'Total', pt: 'Total', fr: 'Total', id: 'Total', vi: 'Tổng cộng', ru: 'Всего', it: 'Totale')}${s.colon} ${list.length}\n'
                '${list.map((t) => '$t  $areaLabel=${t.area}').join('\n')}';
          },
        ),
        CalcTool(
          title: s.pick('Área por coordenadas (shoelace)', 'Area from coordinates (shoelace)', pt: 'Área por coordenadas (shoelace)', fr: 'Aire par coordonnées (formule du lacet)', id: 'Luas dari koordinat (rumus tali sepatu)', vi: 'Diện tích theo toạ độ (công thức dây giày)', ru: 'Площадь по координатам (формула шнурования)', it: "Area da coordinate (formula dell'area di Gauss)"),
          description: s.pick('Vértices "x,y" separados por ";".',
              'Vertices "x,y" separated by ";".', pt: 'Vértices "x,y" separados por ";".', fr: 'Sommets « x,y » séparés par « ; ».', id: 'Titik sudut «x,y» dipisahkan «;».', vi: 'Các đỉnh «x,y» ngăn cách bằng «;».', ru: 'Вершины «x,y», разделённые «;».', it: 'Vertici «x,y» separati da «;».'),
          fields: [
            ToolField(s.pick('Vértices', 'Vertices', pt: 'Vértices', fr: 'Sommets', id: 'Titik sudut', vi: 'Các đỉnh', ru: 'Вершины', it: 'Vertici'), initial: '0,0; 4,0; 0,3'),
          ],
          compute: (i) {
            final area = GeometryService.shoelaceArea(_pointList(i[0]));
            return '${s.pick('Área', 'Area', pt: 'Área', fr: 'Aire', id: 'Luas', vi: 'Diện tích', ru: 'Площадь', it: 'Area')}${s.colon} $area  ≈ ${area.toDouble()}';
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
          title: s.pick('Teorema de Pick', "Pick's theorem", pt: 'Teorema de Pick', fr: 'Théorème de Pick', id: 'Teorema Pick', vi: 'Định lý Pick', ru: 'Теорема Пика', it: 'Teorema di Pick'),
          description: s.pick(
              'Polígono de vértices enteros: A = I + B/2 − 1. Vértices "x,y" separados por ";".',
              'Integer-vertex polygon: A = I + B/2 − 1. Vertices "x,y" separated by ";".', pt: 'Polígono de vértices inteiros: A = I + B/2 − 1. Vértices "x,y" separados por ";".', fr: 'Polygone à sommets entiers : A = I + B/2 − 1. Sommets « x,y » séparés par « ; ».', id: 'Poligon bertitik sudut bulat: A = I + B/2 − 1. Titik sudut «x,y» dipisahkan «;».', vi: 'Đa giác có đỉnh nguyên: A = I + B/2 − 1. Các đỉnh «x,y» ngăn cách bằng «;».', ru: 'Многоугольник с целыми вершинами: A = I + B/2 − 1. Вершины «x,y», разделённые «;».', it: 'Poligono a vertici interi: A = I + B/2 − 1. Vertici «x,y» separati da «;».'),
          fields: [
            ToolField(s.pick('Vértices', 'Vertices', pt: 'Vértices', fr: 'Sommets', id: 'Titik sudut', vi: 'Các đỉnh', ru: 'Вершины', it: 'Vertici'), initial: '0,0; 5,0; 5,4; 0,4'),
          ],
          compute: (i) {
            final r = GeometryService.pickAnalysis(_pointList(i[0]));
            return '${s.pick('Área', 'Area', pt: 'Área', fr: 'Aire', id: 'Luas', vi: 'Diện tích', ru: 'Площадь', it: 'Area')}${s.colon} ${r.area}\n'
                'B (${s.pick('frontera', 'boundary', pt: 'fronteira', fr: 'frontière', id: 'batas', vi: 'trên biên', ru: 'на границе', it: 'frontiera')}): ${r.boundary}\n'
                'I (${s.pick('interior', 'interior', pt: 'interior', fr: 'intérieur', id: 'dalam', vi: 'bên trong', ru: 'внутри', it: 'interno')}): ${r.interior}\n'
                '${s.pick('Verificación', 'Check', pt: 'Verificação', fr: 'Vérification', id: 'Pemeriksaan', vi: 'Kiểm chứng', ru: 'Проверка', it: 'Verifica')}${s.colon} ${r.interior} + ${r.boundary}/2 − 1 = ${r.area}';
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
          title: s.pick('Centros del triángulo', 'Triangle centers', pt: 'Centros do triângulo', fr: 'Centres du triangle', id: 'Titik-titik istimewa segitiga', vi: 'Các điểm đặc biệt của tam giác', ru: 'Замечательные точки треугольника', it: 'Punti notevoli del triangolo'),
          description: s.pick(
              'G, O, H exactos y recta de Euler; incentro aproximado. Vértices "x,y".',
              'Exact G, O, H and Euler line; approximate incenter. Vertices "x,y".', pt: 'G, O, H exatos e reta de Euler; incentro aproximado. Vértices "x,y".', fr: "G, O, H exacts et droite d'Euler ; incentre approché. Sommets « x,y ».", id: 'G, O, H eksak dan garis Euler; titik pusat lingkaran dalam dihampiri. Titik sudut «x,y».', vi: 'G, O, H chính xác và đường thẳng Euler; tâm nội tiếp gần đúng. Các đỉnh «x,y».', ru: 'Точные G, O, H и прямая Эйлера; инцентр приближённо. Вершины «x,y».', it: 'G, O, H esatti e retta di Eulero; incentro approssimato. Vertici «x,y».'),
          fields: [
            ToolField('A', initial: '0,0'),
            ToolField('B', initial: '6,0'),
            ToolField('C', initial: '2,4'),
          ],
          compute: (i) {
            final r = GeometryService.triangleCenters(
                _point(i[0]), _point(i[1]), _point(i[2]));
            return '${s.pick('Baricentro', 'Centroid', pt: 'Baricentro', fr: 'Barycentre', id: 'Titik berat', vi: 'Trọng tâm', ru: 'Центроид', it: 'Baricentro')} G: ${r.centroid}\n'
                '${s.pick('Circuncentro', 'Circumcenter', pt: 'Circuncentro', fr: 'Circoncentre', id: 'Titik pusat lingkaran luar', vi: 'Tâm đường tròn ngoại tiếp', ru: 'Центр описанной окружности', it: 'Circocentro')} O: ${r.circumcenter}\n'
                '${s.pick('Ortocentro', 'Orthocenter', pt: 'Ortocentro', fr: 'Orthocentre', id: 'Titik tinggi (ortosentrum)', vi: 'Trực tâm', ru: 'Ортоцентр', it: 'Ortocentro')} H: ${r.orthocenter}\n'
                '${s.pick('Incentro', 'Incenter', pt: 'Incentro', fr: 'Incentre', id: 'Titik pusat lingkaran dalam', vi: 'Tâm đường tròn nội tiếp', ru: 'Инцентр', it: 'Incentro')} I ≈ '
                '(${r.incenterX.toStringAsFixed(4)}, ${r.incenterY.toStringAsFixed(4)})\n'
                '${s.pick('Recta de Euler', 'Euler line', pt: 'Reta de Euler', fr: "Droite d'Euler", id: 'Garis Euler', vi: 'Đường thẳng Euler', ru: 'Прямая Эйлера', it: 'Retta di Eulero')}${s.colon} H = 3·G − 2·O ✓';
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
// POLYNOMIALS
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
          title: s.pick('Analizar polinomio', 'Analyze polynomial', pt: 'Analisar polinômio', fr: 'Analyser le polynôme', id: 'Analisis polinomial', vi: 'Phân tích đa thức', ru: 'Проанализировать многочлен', it: 'Analizza il polinomio'),
          description: s.pick(
              'Grado, raíces racionales, Vieta, discriminante, derivada. '
              'Solo en x, ya desarrollado (para varias variables o paréntesis: Álgebra).',
              'Degree, rational roots, Vieta, discriminant, derivative. '
              'In x only, already expanded (for several variables or parentheses: Algebra).', pt: 'Grau, raízes racionais, Vieta, discriminante, derivada. Somente em x, já desenvolvido (para várias variáveis ou parênteses: Álgebra).', fr: 'Degré, racines rationnelles, Viète, discriminant, dérivée. En x uniquement, déjà développé (pour plusieurs variables ou des parenthèses : Algèbre).', id: 'Derajat, akar rasional, rumus Vieta, diskriminan, turunan. Hanya dalam x dan sudah dijabarkan (untuk beberapa variabel atau tanda kurung: Aljabar).', vi: 'Bậc, nghiệm hữu tỉ, định lý Vi-ét, biệt thức, đạo hàm. Chỉ một biến x và đã khai triển sẵn (nhiều biến hoặc có ngoặc: dùng Đại số).', ru: 'Степень, рациональные корни, теорема Виета, дискриминант, производная. Только от x и уже раскрытый (для нескольких переменных или скобок — Алгебра).', it: 'Grado, radici razionali, Viète, discriminante, derivata. Solo in x, già sviluppato (per più variabili o parentesi: Algebra).'),
          fields: [
            ToolField(s.pick('Polinomio', 'Polynomial', pt: 'Polinômio', fr: 'Polynôme', id: 'Polinomial', vi: 'Đa thức', ru: 'Многочлен', it: 'Polinomio'),
                hint: 'x^2-5x+6', initial: 'x^2-5x+6')
          ],
          compute: (i) {
            final p = PolynomialService.parse(i[0]);
            final sb = StringBuffer();
            sb.writeln('${s.pick('Grado', 'Degree', pt: 'Grau', fr: 'Degré', id: 'Derajat', vi: 'Bậc', ru: 'Степень', it: 'Grado')}${s.colon} ${p.degree}');
            final roots = PolynomialService.rationalRoots(p);
            sb.writeln('${s.pick('Raíces racionales', 'Rational roots', pt: 'Raízes racionais', fr: 'Racines rationnelles', id: 'Akar rasional', vi: 'Nghiệm hữu tỉ', ru: 'Рациональные корни', it: 'Radici razionali')}${s.colon} '
                '${roots.isEmpty ? s.pick('ninguna', 'none', pt: 'nenhuma', fr: 'aucune', id: 'tidak ada', vi: 'không có', ru: 'нет', it: 'nessuna') : roots.join(', ')}');
            if (p.degree >= 1) {
              final v = PolynomialService.vieta(p);
              sb.writeln('${s.pick('Suma de raíces', 'Sum of roots', pt: 'Soma das raízes', fr: 'Somme des racines', id: 'Jumlah akar', vi: 'Tổng các nghiệm', ru: 'Сумма корней', it: 'Somma delle radici')}${s.colon} ${v.sumOfRoots}');
              sb.writeln('${s.pick('Producto de raíces', 'Product of roots', pt: 'Produto das raízes', fr: 'Produit des racines', id: 'Hasil kali akar', vi: 'Tích các nghiệm', ru: 'Произведение корней', it: 'Prodotto delle radici')}${s.colon} ${v.productOfRoots}');
            }
            if (p.degree == 2 || p.degree == 3) {
              sb.writeln('${s.pick('Discriminante', 'Discriminant', pt: 'Discriminante', fr: 'Discriminant', id: 'Diskriminan', vi: 'Biệt thức', ru: 'Дискриминант', it: 'Discriminante')}${s.colon} '
                  '${PolynomialService.discriminant(p)}');
            }
            sb.write('${s.pick('Derivada', 'Derivative', pt: 'Derivada', fr: 'Dérivée', id: 'Turunan', vi: 'Đạo hàm', ru: 'Производная', it: 'Derivata')}${s.colon} ${p.derivative()}');
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
            // Range centered on the points of interest.
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
          title: s.pick('Ruffini: dividir entre (x − c)', 'Ruffini: divide by (x − c)', pt: 'Ruffini: dividir por (x − c)', fr: 'Ruffini : diviser par (x − c)', id: 'Skema Horner: bagi dengan (x − c)', vi: 'Sơ đồ Horner: chia cho (x − c)', ru: 'Схема Горнера: деление на (x − c)', it: 'Ruffini: dividere per (x − c)'),
          description: s.pick('División sintética con pasos.',
              'Synthetic division with steps.', pt: 'Divisão sintética com passos.', fr: 'Division synthétique, étape par étape.', id: 'Pembagian sintetik lengkap dengan langkah-langkahnya.', vi: 'Chia theo sơ đồ Horner, có trình bày từng bước.', ru: 'Деление по схеме Горнера с показом шагов.', it: 'Divisione sintetica con i passaggi.'),
          fields: [
            ToolField(s.pick('Polinomio', 'Polynomial', pt: 'Polinômio', fr: 'Polynôme', id: 'Polinomial', vi: 'Đa thức', ru: 'Многочлен', it: 'Polinomio'), initial: 'x^3-6x^2+11x-6'),
            ToolField('c (p/q)', initial: '1'),
          ],
          compute: (i) => StepsService.ruffiniSteps(
                  PolynomialService.parse(i[0]), Fraction.parse(i[1]),
                  lang: s.lang)
              .toString(),
        ),
        CalcTool(
          title: s.pick('Sistema lineal 2×2 / 3×3', 'Linear system 2×2 / 3×3', pt: 'Sistema linear 2×2 / 3×3', fr: 'Système linéaire 2×2 / 3×3', id: 'Sistem persamaan linear 2×2 / 3×3', vi: 'Hệ phương trình bậc nhất 2×2 / 3×3', ru: 'Линейная система 2×2 / 3×3', it: 'Sistema lineare 2×2 / 3×3'),
          description: s.pick(
              'Filas "a,b,…,k" (coeficientes y término independiente) separadas por ";".',
              'Rows "a,b,…,k" (coefficients and constant) separated by ";".', pt: 'Linhas "a,b,…,k" (coeficientes e termo independente) separadas por ";".', fr: 'Lignes « a,b,…,k » (coefficients et terme constant) séparées par « ; ».', id: 'Baris «a,b,…,k» (koefisien dan suku tetap) dipisahkan «;».', vi: 'Các dòng «a,b,…,k» (hệ số và hệ số tự do) ngăn cách bằng «;».', ru: 'Строки «a,b,…,k» (коэффициенты и свободный член), разделённые «;».', it: 'Righe «a,b,…,k» (coefficienti e termine noto) separate da «;».'),
          fields: [
            ToolField(s.pick('Sistema', 'System', pt: 'Sistema', fr: 'Système', id: 'Sistem persamaan', vi: 'Hệ phương trình', ru: 'Система', it: 'Sistema'), initial: '2,1,5; 1,-1,1'),
          ],
          compute: (i) {
            final rows = i[0]
                .split(';')
                .where((r) => r.trim().isNotEmpty)
                .map(_fracList)
                .toList();
            final sol = LinearSystemService.solveCramer(rows); // validates dimensions
            final det = LinearSystemService.determinant(
                rows.map((r) => r.sublist(0, r.length - 1)).toList());
            final sb = StringBuffer();
            sb.writeln('det = $det');
            if (sol == null) {
              sb.write(s.pick('Sin solución única (determinante 0)',
                  'No unique solution (zero determinant)', pt: 'Sem solução única (determinante 0)', fr: 'Pas de solution unique (déterminant nul)', id: 'Tidak ada solusi tunggal (determinan nol)', vi: 'Không có nghiệm duy nhất (định thức bằng 0)', ru: 'Единственного решения нет (определитель равен нулю)', it: 'Nessuna soluzione unica (determinante nullo)'));
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
          title: s.pick('Resolver cuadrática ax²+bx+c', 'Solve quadratic ax²+bx+c', pt: 'Resolver a quadrática ax²+bx+c', fr: "Résoudre l'équation ax²+bx+c", id: 'Selesaikan persamaan kuadrat ax²+bx+c', vi: 'Giải phương trình bậc hai ax²+bx+c', ru: 'Решить квадратное уравнение ax²+bx+c', it: "Risolvi l'equazione ax²+bx+c"),
          fields: [
            ToolField('a (p/q)', initial: '1'),
            ToolField('b (p/q)', initial: '-5'),
            ToolField('c (p/q)', initial: '6'),
          ],
          compute: (i) {
            final sol = PolynomialService.solveQuadratic(
                Fraction.parse(i[0]), Fraction.parse(i[1]), Fraction.parse(i[2]));
            final sb = StringBuffer();
            sb.writeln('${s.pick('Discriminante', 'Discriminant', pt: 'Discriminante', fr: 'Discriminant', id: 'Diskriminan', vi: 'Biệt thức', ru: 'Дискриминант', it: 'Discriminante')}${s.colon} ${sol.discriminant}');
            sb.writeln('${s.pick('Naturaleza', 'Nature', pt: 'Natureza', fr: 'Nature', id: 'Sifat akar', vi: 'Loại nghiệm', ru: 'Характер корней', it: 'Natura')}${s.colon} ${_natureLabel(s, sol.nature)}');
            if (sol.rationalRoots.isNotEmpty) {
              sb.writeln('${s.pick('Raíces exactas', 'Exact roots', pt: 'Raízes exatas', fr: 'Racines exactes', id: 'Akar eksak', vi: 'Nghiệm chính xác', ru: 'Точные корни', it: 'Radici esatte')}${s.colon} ${sol.rationalRoots.join(', ')}');
            }
            if (sol.realRoots.isNotEmpty) {
              sb.write('${s.pick('Raíces reales', 'Real roots', pt: 'Raízes reais', fr: 'Racines réelles', id: 'Akar real', vi: 'Nghiệm thực', ru: 'Вещественные корни', it: 'Radici reali')} ≈ '
                  '${sol.realRoots.map((r) => r.toStringAsFixed(6)).join(', ')}');
            }
            return sb.toString();
          },
        ),
        CalcTool(
          title: s.pick('Raíces reales de cúbica', 'Real roots of cubic', pt: 'Raízes reais da cúbica', fr: 'Racines réelles de la cubique', id: 'Akar real persamaan kubik', vi: 'Nghiệm thực của phương trình bậc ba', ru: 'Вещественные корни кубического уравнения', it: 'Radici reali della cubica'),
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
            return '${s.pick('Raíces reales', 'Real roots', pt: 'Raízes reais', fr: 'Racines réelles', id: 'Akar real', vi: 'Nghiệm thực', ru: 'Вещественные корни', it: 'Radici reali')} ≈\n'
                '${roots.map((r) => r.toStringAsFixed(6)).join('\n')}';
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ALGEBRA (polynomials in several variables)
// ════════════════════════════════════════════════════════════════════════════

/// Syntax reminder, shown once at the top of the category since every tool
/// here reads expressions in the same notation.
String _algebraSyntax(OlympiadStrings s) => s.pick(
    'Variables: una letra con subíndice opcional (a, x, x1). Se admite '
        'multiplicación implícita (2ab, (a+b)(a−b)) y exponentes con ^ o '
        'superíndices ((a+b+c)²).',
    'Variables: a letter with an optional subscript (a, x, x1). Implicit '
        'multiplication (2ab, (a+b)(a−b)) and exponents with ^ or '
        'superscripts ((a+b+c)²) are supported.', pt: 'Variáveis: uma letra com subíndice opcional (a, x, x1). Admite multiplicação implícita (2ab, (a+b)(a−b)) e expoentes com ^ ou sobrescritos ((a+b+c)²).', fr: 'Variables : une lettre avec indice facultatif (a, x, x1). La multiplication implicite (2ab, (a+b)(a−b)) et les exposants avec ^ ou en exposant ((a+b+c)²) sont acceptés.', id: 'Variabel: satu huruf dengan indeks opsional (a, x, x1). Perkalian tersirat (2ab, (a+b)(a−b)) dan eksponen dengan ^ atau superskrip ((a+b+c)²) diterima.', vi: 'Biến: một chữ cái kèm chỉ số tuỳ chọn (a, x, x1). Chấp nhận phép nhân ngầm (2ab, (a+b)(a−b)) và số mũ viết bằng ^ hoặc chỉ số trên ((a+b+c)²).', ru: 'Переменные: буква с необязательным индексом (a, x, x1). Допускаются неявное умножение (2ab, (a+b)(a−b)) и показатели через ^ или надстрочные ((a+b+c)²).', it: 'Variabili: una lettera con indice facoltativo (a, x, x1). Sono ammessi la moltiplicazione implicita (2ab, (a+b)(a−b)) e gli esponenti con ^ o in apice ((a+b+c)²).');

class AlgebraToolScreen extends StatelessWidget {
  const AlgebraToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    return _ToolScaffold(
      title: s.catAlgebra,
      tools: [
        CalcTool(
          title: s.pick('Expandir y simplificar', 'Expand and simplify', pt: 'Expandir e simplificar', fr: 'Développer et simplifier', id: 'Jabarkan dan sederhanakan', vi: 'Khai triển và rút gọn', ru: 'Раскрыть и упростить', it: 'Sviluppa e semplifica'),
          description: '${s.pick('Desarrolla el producto y agrupa términos '
              'semejantes, en exacto.', 'Expands the product and collects like '
              'terms, exactly.', pt: 'Desenvolve o produto e agrupa os termos semelhantes, de forma exata.', fr: 'Développe le produit et regroupe les termes semblables, de façon exacte.', id: 'Menjabarkan hasil kali dan menggabungkan suku-suku sejenis, secara eksak.', vi: 'Khai triển tích và thu gọn các hạng tử đồng dạng, chính xác.', ru: 'Раскрывает произведение и приводит подобные члены, точно.', it: 'Sviluppa il prodotto e raccoglie i termini simili, in modo esatto.')} ${_algebraSyntax(s)}',
          fields: [
            ToolField(s.pick('Expresión', 'Expression', pt: 'Expressão', fr: 'Expression', id: 'Ekspresi', vi: 'Biểu thức', ru: 'Выражение', it: 'Espressione'), initial: '(a+b+c)^2'),
          ],
          compute: (i) {
            final p = AlgebraService.parse(i[0]);
            final sb = StringBuffer('= $p\n');
            sb.writeln('${s.pick('Grado', 'Degree', pt: 'Grau', fr: 'Degré', id: 'Derajat', vi: 'Bậc', ru: 'Степень', it: 'Grado')}${s.colon} ${p.degree}'
                '   ${s.pick('Términos', 'Terms', pt: 'Termos', fr: 'Termes', id: 'Banyak suku', vi: 'Số hạng tử', ru: 'Членов', it: 'Termini')}${s.colon} ${p.termCount}');
            if (p.variables.isNotEmpty) {
              sb.writeln('${s.pick('Variables', 'Variables', pt: 'Variáveis', fr: 'Variables', id: 'Variabel', vi: 'Các biến', ru: 'Переменные', it: 'Variabili')}${s.colon} '
                  '${p.variables.join(', ')}');
              final marks = <String>[
                if (p.isHomogeneous)
                  s.pick('homogéneo', 'homogeneous', pt: 'homogêneo', fr: 'homogène', id: 'homogen', vi: 'thuần nhất', ru: 'однородный', it: 'omogeneo'),
                if (AlgebraService.isSymmetric(p) && p.variables.length > 1)
                  s.pick('simétrico', 'symmetric', pt: 'simétrico', fr: 'symétrique', id: 'simetris', vi: 'đối xứng', ru: 'симметрический', it: 'simmetrico'),
              ];
              if (marks.isNotEmpty) sb.writeln(marks.join(', '));
            }
            final cf = AlgebraService.commonFactor(p);
            if (!cf.isTrivial && p.termCount > 1) {
              sb.writeln('${s.pick('Factor común', 'Common factor', pt: 'Fator comum', fr: 'Facteur commun', id: 'Faktor persekutuan', vi: 'Nhân tử chung', ru: 'Общий множитель', it: 'Fattore comune')}${s.colon} $cf');
            }
            return sb.toString().trimRight();
          },
        ),
        CalcTool(
          title: s.pick('Verificar identidad', 'Check identity', pt: 'Verificar identidade', fr: 'Vérifier une identité', id: 'Periksa identitas', vi: 'Kiểm tra hằng đẳng thức', ru: 'Проверить тождество', it: "Verifica un'identità"),
          description: s.pick(
              'Desarrolla ambos lados y compara. Si no coinciden, muestra la '
              'diferencia.',
              'Expands both sides and compares. If they differ, shows the '
              'difference.', pt: 'Desenvolve os dois lados e compara. Se não coincidirem, mostra a diferença.', fr: "Développe les deux membres et les compare. S'ils diffèrent, affiche la différence.", id: 'Menjabarkan kedua ruas lalu membandingkannya. Jika berbeda, selisihnya ditampilkan.', vi: 'Khai triển cả hai vế rồi so sánh. Nếu khác nhau, hiển thị hiệu.', ru: 'Раскрывает обе части и сравнивает их. Если они различны, показывает разность.', it: 'Sviluppa entrambi i membri e li confronta. Se differiscono, mostra la differenza.'),
          fields: [
            ToolField(s.pick('Lado izquierdo', 'Left side', pt: 'Lado esquerdo', fr: 'Membre de gauche', id: 'Ruas kiri', vi: 'Vế trái', ru: 'Левая часть', it: 'Primo membro'), initial: '(a+b)^3'),
            ToolField(s.pick('Lado derecho', 'Right side', pt: 'Lado direito', fr: 'Membre de droite', id: 'Ruas kanan', vi: 'Vế phải', ru: 'Правая часть', it: 'Secondo membro'),
                initial: 'a^3+3a^2b+3ab^2+b^3'),
          ],
          compute: (i) {
            final left = AlgebraService.parse(i[0]);
            final right = AlgebraService.parse(i[1]);
            final diff = left - right;
            if (diff.isZero) {
              return '${s.pick('✓ Son idénticas', '✓ They are identical', pt: '✓ São idênticas', fr: '✓ Elles sont identiques', id: '✓ Keduanya identik', vi: '✓ Hai vế trùng nhau', ru: '✓ Части совпадают', it: '✓ Sono identiche')}\n'
                  '= $left';
            }
            return '${s.pick('✗ No son iguales', '✗ Not equal', pt: '✗ Não são iguais', fr: '✗ Elles ne sont pas égales', id: '✗ Keduanya tidak sama', vi: '✗ Hai vế không bằng nhau', ru: '✗ Части не равны', it: '✗ Non sono uguali')}\n'
                '${s.pick('Izquierda', 'Left', pt: 'Esquerda', fr: 'Gauche', id: 'Kiri', vi: 'Trái', ru: 'Слева', it: 'Sinistra')} = $left\n'
                '${s.pick('Derecha', 'Right', pt: 'Direita', fr: 'Droite', id: 'Kanan', vi: 'Phải', ru: 'Справа', it: 'Destra')} = $right\n'
                '${s.pick('Diferencia', 'Difference', pt: 'Diferença', fr: 'Différence', id: 'Selisih', vi: 'Hiệu', ru: 'Разность', it: 'Differenza')} = $diff';
          },
        ),
        CalcTool(
          title: s.pick('Factor común', 'Common factor', pt: 'Fator comum', fr: 'Facteur commun', id: 'Faktor persekutuan', vi: 'Nhân tử chung', ru: 'Общий множитель', it: 'Fattore comune'),
          description: s.pick(
              'Extrae el mayor monomio y el contenido racional: '
              '2a²b + 4ab² = 2ab(a + 2b).',
              'Pulls out the greatest monomial and the rational content: '
              '2a²b + 4ab² = 2ab(a + 2b).', pt: 'Extrai o maior monômio e o conteúdo racional: 2a²b + 4ab² = 2ab(a + 2b).', fr: 'Extrait le plus grand monôme et le contenu rationnel : 2a²b + 4ab² = 2ab(a + 2b).', id: 'Mengeluarkan monomial terbesar beserta isi rasionalnya: 2a²b + 4ab² = 2ab(a + 2b).', vi: 'Đặt đơn thức lớn nhất và phần hữu tỉ ra ngoài: 2a²b + 4ab² = 2ab(a + 2b).', ru: 'Выносит наибольший одночлен и рациональное содержание: 2a²b + 4ab² = 2ab(a + 2b).', it: 'Raccoglie il monomio più grande e il contenuto razionale: 2a²b + 4ab² = 2ab(a + 2b).'),
          fields: [
            ToolField(s.pick('Expresión', 'Expression', pt: 'Expressão', fr: 'Expression', id: 'Ekspresi', vi: 'Biểu thức', ru: 'Выражение', it: 'Espressione'), initial: '2a^2b+4ab^2'),
          ],
          compute: (i) {
            final p = AlgebraService.parse(i[0]);
            final cf = AlgebraService.commonFactor(p);
            if (cf.isTrivial) {
              return '${s.pick('No hay factor común (aparte de 1)',
                  'No common factor (other than 1)', pt: 'Não há fator comum (além de 1)', fr: 'Aucun facteur commun (hormis 1)', id: 'Tidak ada faktor persekutuan selain 1', vi: 'Không có nhân tử chung nào khác 1', ru: 'Общего множителя (кроме 1) нет', it: "Non c'è alcun fattore comune (a parte 1)")}\n= $p';
            }
            return '= $cf\n'
                '${s.pick('Factor', 'Factor', pt: 'Fator', fr: 'Facteur', id: 'Faktor', vi: 'Nhân tử', ru: 'Множитель', it: 'Fattore')}${s.colon} ${cf.factor}\n'
                '${s.pick('Resto', 'Cofactor', pt: 'Cofator', fr: 'Cofacteur', id: 'Faktor sisanya', vi: 'Thừa số còn lại', ru: 'Второй множитель', it: 'Cofattore')}${s.colon} ${cf.cofactor}';
          },
        ),
        CalcTool(
          title: s.pick('Sustituir / evaluar', 'Substitute / evaluate', pt: 'Substituir / avaliar', fr: 'Substituer / évaluer', id: 'Substitusikan / hitung nilainya', vi: 'Thay số / tính giá trị', ru: 'Подставить / вычислить', it: 'Sostituisci / valuta'),
          description: s.pick(
              'Los valores pueden ser números o expresiones ("a=1, b=x+1"). '
              'Si faltan variables, el resultado queda en función de ellas.',
              'Values may be numbers or expressions ("a=1, b=x+1"). Any '
              'variable left unassigned stays in the result.', pt: 'Os valores podem ser números ou expressões ("a=1, b=x+1"). Se faltarem variáveis, o resultado fica em função delas.', fr: 'Les valeurs peuvent être des nombres ou des expressions (« a=1, b=x+1 »). Les variables non affectées restent dans le résultat.', id: 'Nilainya boleh berupa bilangan atau ekspresi («a=1, b=x+1»). Variabel yang belum diberi nilai tetap muncul di hasil.', vi: 'Giá trị có thể là số hoặc biểu thức («a=1, b=x+1»). Biến nào chưa gán vẫn còn trong kết quả.', ru: 'Значениями могут быть числа или выражения («a=1, b=x+1»). Переменные без значения остаются в результате.', it: 'I valori possono essere numeri o espressioni («a=1, b=x+1»). Le variabili non assegnate restano nel risultato.'),
          fields: [
            ToolField(s.pick('Expresión', 'Expression', pt: 'Expressão', fr: 'Expression', id: 'Ekspresi', vi: 'Biểu thức', ru: 'Выражение', it: 'Espressione'), initial: '(a+b+c)^2'),
            ToolField(s.pick('Valores', 'Values', pt: 'Valores', fr: 'Valeurs', id: 'Nilai-nilai', vi: 'Các giá trị', ru: 'Значения', it: 'Valori'), initial: 'a=1, b=2, c=3'),
          ],
          compute: (i) {
            final p = AlgebraService.parse(i[0]);
            final values = AlgebraService.parseAssignments(i[1]);
            final result = AlgebraService.substitute(p, values);
            final sb = StringBuffer('= $result');
            if (result.isConstant) {
              final v = result.constantValue;
              final double approx = v.toDouble();
              // Only worth showing for a fraction that a decimal can express:
              // a ratio of 300-digit integers overflows to "Infinity".
              if (!v.isInteger && approx.isFinite && approx.abs() < 1e15) {
                sb.write('\n≈ ${approx.toStringAsFixed(6)}');
              }
            }
            return sb.toString();
          },
        ),
        CalcTool(
          title: s.pick('Coeficiente de un monomio', 'Coefficient of a monomial', pt: 'Coeficiente de um monômio', fr: "Coefficient d'un monôme", id: 'Koefisien sebuah monomial', vi: 'Hệ số của một đơn thức', ru: 'Коэффициент при одночлене', it: 'Coefficiente di un monomio'),
          description: s.pick(
              'Coeficiente del monomio indicado en el desarrollo: el de a²b en '
              '(a+b+c)³ es 3.',
              'Coefficient of the given monomial in the expansion: that of a²b '
              'in (a+b+c)³ is 3.', pt: 'Coeficiente do monômio indicado no desenvolvimento: o de a²b em (a+b+c)³ é 3.', fr: 'Coefficient du monôme indiqué dans le développement : celui de a²b dans (a+b+c)³ vaut 3.', id: 'Koefisien monomial yang ditunjuk di dalam penjabaran: koefisien a²b dalam (a+b+c)³ adalah 3.', vi: 'Hệ số của đơn thức đã chỉ định trong khai triển: hệ số của a²b trong (a+b+c)³ bằng 3.', ru: 'Коэффициент при указанном одночлене в разложении: у a²b в (a+b+c)³ он равен 3.', it: 'Coefficiente del monomio indicato nello sviluppo: quello di a²b in (a+b+c)³ è 3.'),
          fields: [
            ToolField(s.pick('Expresión', 'Expression', pt: 'Expressão', fr: 'Expression', id: 'Ekspresi', vi: 'Biểu thức', ru: 'Выражение', it: 'Espressione'), initial: '(a+b+c)^3'),
            ToolField(s.pick('Monomio', 'Monomial', pt: 'Monômio', fr: 'Monôme', id: 'Monomial', vi: 'Đơn thức', ru: 'Одночлен', it: 'Monomio'), initial: 'a^2b'),
          ],
          compute: (i) {
            final p = AlgebraService.parse(i[0]);
            final m = AlgebraService.parseMonomial(i[1]);
            return '${s.pick('Coeficiente de', 'Coefficient of', pt: 'Coeficiente de', fr: 'Coefficient de', id: 'Koefisien dari', vi: 'Hệ số của', ru: 'Коэффициент при', it: 'Coefficiente di')} '
                '$m: ${p.coefficient(m)}';
          },
        ),
        CalcTool(
          title: s.pick('Derivada parcial', 'Partial derivative', pt: 'Derivada parcial', fr: 'Dérivée partielle', id: 'Turunan parsial', vi: 'Đạo hàm riêng', ru: 'Частная производная', it: 'Derivata parziale'),
          description: s.pick('∂/∂x del desarrollo, en exacto.',
              '∂/∂x of the expansion, exactly.', pt: '∂/∂x do desenvolvimento, de forma exata.', fr: '∂/∂x du développement, de façon exacte.', id: '∂/∂x dari penjabaran, secara eksak.', vi: '∂/∂x của khai triển, chính xác.', ru: '∂/∂x от разложения, точно.', it: '∂/∂x dello sviluppo, in modo esatto.'),
          fields: [
            ToolField(s.pick('Expresión', 'Expression', pt: 'Expressão', fr: 'Expression', id: 'Ekspresi', vi: 'Biểu thức', ru: 'Выражение', it: 'Espressione'), initial: '(a+b)^3'),
            ToolField(s.pick('Variable', 'Variable', pt: 'Variável', fr: 'Variable', id: 'Variabel', vi: 'Biến', ru: 'Переменная', it: 'Variabile'), initial: 'a'),
          ],
          compute: (i) {
            final p = AlgebraService.parse(i[0]);
            final v = i[1].trim();
            if (!RegExp(r'^[A-Za-z][0-9]*$').hasMatch(v)) {
              throw CalcException(CalcError.unexpectedToken, {'value': v});
            }
            return '∂/∂$v = ${p.derivative(v)}';
          },
        ),
        CalcTool(
          title: s.pick('Productos notables', 'Notable products', pt: 'Produtos notáveis', fr: 'Identités remarquables', id: 'Identitas aljabar istimewa', vi: 'Hằng đẳng thức đáng nhớ', ru: 'Формулы сокращённого умножения', it: 'Prodotti notevoli'),
          description: s.pick(
              'Las identidades clásicas con A y B a tu elección (pueden ser '
              'expresiones).',
              'The classic identities for your own A and B (they may be '
              'expressions).', pt: 'As identidades clássicas com A e B à sua escolha (podem ser expressões).', fr: 'Les identités classiques avec les A et B de votre choix (qui peuvent être des expressions).', id: 'Identitas klasik dengan A dan B pilihan Anda (boleh berupa ekspresi).', vi: 'Các hằng đẳng thức quen thuộc với A và B do bạn chọn (có thể là biểu thức).', ru: 'Классические тождества с вашими A и B (они могут быть выражениями).', it: 'Le identità classiche con A e B a tua scelta (possono essere espressioni).'),
          fields: [
            ToolField('A', initial: 'x'),
            ToolField('B', initial: '2y'),
          ],
          compute: (i) {
            final a = AlgebraService.parse(i[0]);
            final b = AlgebraService.parse(i[1]);
            final sb = StringBuffer('A = $a,  B = $b\n');
            for (final n in AlgebraService.notableProducts(a, b)) {
              sb.writeln('${n.formula} = ${n.value}');
            }
            return sb.toString().trimRight();
          },
        ),
        CalcTool(
          title: s.pick('Binomio de Newton (a+b)ⁿ', 'Binomial theorem (a+b)ⁿ', pt: 'Binômio de Newton (a+b)ⁿ', fr: 'Binôme de Newton (a+b)ⁿ', id: 'Binomial Newton (a+b)ⁿ', vi: 'Nhị thức Newton (a+b)ⁿ', ru: 'Бином Ньютона (a+b)ⁿ', it: 'Binomio di Newton (a+b)ⁿ'),
          description: s.pick(
              'Desarrollo simbólico término a término.',
              'Symbolic expansion, term by term.', pt: 'Desenvolvimento simbólico termo a termo.', fr: 'Développement symbolique, terme par terme.', id: 'Penjabaran simbolik, suku demi suku.', vi: 'Khai triển ký hiệu, từng hạng tử một.', ru: 'Символьное разложение, член за членом.', it: 'Sviluppo simbolico, termine per termine.'),
          fields: [ToolField('n', initial: '5')],
          compute: (i) {
            final n = _int(i[0]);
            if (n < 0) throw CalcException(CalcError.nNonNegative);
            if (n > 60) {
              throw CalcException(CalcError.inputTooLarge, {'max': '60'});
            }
            final p = AlgebraService.parse('(a+b)^$n');
            final sb = StringBuffer('(a+b)${_superscript(n)} = $p\n');
            sb.write('${s.pick('Coeficientes', 'Coefficients', pt: 'Coeficientes', fr: 'Coefficients', id: 'Koefisien', vi: 'Các hệ số', ru: 'Коэффициенты', it: 'Coefficienti')}${s.colon} '
                '${p.sortedMonomials.map((m) => p.coefficient(m)).join(', ')}');
            return sb.toString();
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// NUMBER THEORY
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
          title: s.pick('Raíz cuadrada modular √a mod p', 'Modular square root √a mod p', pt: 'Raiz quadrada modular √a mod p', fr: 'Racine carrée modulaire √a mod p', id: 'Akar kuadrat modular √a mod p', vi: 'Căn bậc hai modulo √a mod p', ru: 'Квадратный корень по модулю √a mod p', it: 'Radice quadrata modulare √a mod p'),
          description: s.pick('p debe ser primo.', 'p must be prime.', pt: 'p deve ser primo.', fr: 'p doit être premier.', id: 'p harus prima.', vi: 'p phải là số nguyên tố.', ru: 'p должно быть простым.', it: 'p deve essere primo.'),
          fields: [ToolField('a', initial: '2'), ToolField('p', initial: '7')],
          compute: (i) {
            final a = _bi(i[0]), p = _bi(i[1]);
            final r = NumberTheoryAdvancedService.sqrtMod(a, p);
            if (r == null) {
              return s.pick('a no es residuo cuadrático mod p',
                  'a is not a quadratic residue mod p', pt: 'a não é resíduo quadrático mod p', fr: "a n'est pas un résidu quadratique mod p", id: 'a bukan residu kuadratik mod p', vi: 'a không phải thặng dư bậc hai mod p', ru: 'a не является квадратичным вычетом по модулю p', it: 'a non è un residuo quadratico mod p');
            }
            return '±$r  →  $r, ${p - r}';
          },
        ),
        CalcTool(
          title: s.pick('Congruencia lineal ax≡b (mod n)', 'Linear congruence ax≡b (mod n)', pt: 'Congruência linear ax≡b (mod n)', fr: 'Congruence linéaire ax≡b (mod n)', id: 'Kongruensi linear ax≡b (mod n)', vi: 'Đồng dư bậc nhất ax≡b (mod n)', ru: 'Линейное сравнение ax≡b (mod n)', it: 'Congruenza lineare ax≡b (mod n)'),
          fields: [ToolField('a', initial: '3'), ToolField('b', initial: '6'), ToolField('n', initial: '9')],
          compute: (i) {
            final sols = NumberTheoryAdvancedService.solveLinearCongruence(
                _bi(i[0]), _bi(i[1]), _bi(i[2]));
            return sols.isEmpty
                ? s.pick('Sin solución', 'No solution', pt: 'Sem solução', fr: 'Aucune solution', id: 'Tidak ada solusi', vi: 'Vô nghiệm', ru: 'Решений нет', it: 'Nessuna soluzione')
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
          title: s.pick('Ecuación de Pell x²−Dy²=1', 'Pell equation x²−Dy²=1', pt: 'Equação de Pell x²−Dy²=1', fr: 'Équation de Pell x²−Dy²=1', id: 'Persamaan Pell x²−Dy²=1', vi: 'Phương trình Pell x²−Dy²=1', ru: 'Уравнение Пелля x²−Dy²=1', it: 'Equazione di Pell x²−Dy²=1'),
          fields: [ToolField('D', initial: '61')],
          compute: (i) {
            final sol = NumberTheoryAdvancedService.solvePell(_bi(i[0]));
            return 'x = ${sol.x}\ny = ${sol.y}';
          },
        ),
        CalcTool(
          title: s.pick('Fracción continua de √n', 'Continued fraction of √n', pt: 'Fração contínua de √n', fr: 'Fraction continue de √n', id: 'Pecahan berlanjut dari √n', vi: 'Liên phân số của √n', ru: 'Цепная дробь для √n', it: 'Frazione continua di √n'),
          fields: [ToolField('n', initial: '7')],
          compute: (i) {
            final cf = NumberTheoryAdvancedService.continuedFractionSqrt(_bi(i[0]));
            if (cf.period.isEmpty) return '[${cf.a0}]';
            return '[${cf.a0}; (${cf.period.join(', ')})]';
          },
        ),
        CalcTool(
          title: s.pick('Sumas de cuadrados', 'Sums of squares', pt: 'Somas de quadrados', fr: 'Sommes de carrés', id: 'Jumlah kuadrat', vi: 'Tổng các bình phương', ru: 'Суммы квадратов', it: 'Somme di quadrati'),
          fields: [ToolField('n', initial: '25')],
          compute: (i) {
            final n = _bi(i[0]);
            final two = NumberTheoryAdvancedService.sumOfTwoSquares(n);
            final four = NumberTheoryAdvancedService.sumOfFourSquares(n);
            final twoStr = two == null
                ? s.pick('no es suma de 2 cuadrados', 'not a sum of 2 squares', pt: 'não é soma de 2 quadrados', fr: "n'est pas somme de 2 carrés", id: 'bukan jumlah dari 2 kuadrat', vi: 'không viết được thành tổng 2 bình phương', ru: 'не представимо суммой 2 квадратов', it: 'non è somma di 2 quadrati')
                : '${two.a}² + ${two.b}²';
            return '${s.pick('Dos', 'Two', pt: 'Dois', fr: 'Deux', id: 'Dua', vi: 'Hai', ru: 'Два', it: 'Due')}${s.colon} $twoStr\n'
                '${s.pick('Cuatro', 'Four', pt: 'Quatro', fr: 'Quatre', id: 'Empat', vi: 'Bốn', ru: 'Четыре', it: 'Quattro')}${s.colon} ${four.a}² + ${four.b}² + ${four.c}² + ${four.d}²';
          },
        ),
        CalcTool(
          title: s.pick('Número de Frobenius', 'Frobenius number', pt: 'Número de Frobenius', fr: 'Nombre de Frobenius', id: 'Bilangan Frobenius', vi: 'Số Frobenius', ru: 'Число Фробениуса', it: 'Numero di Frobenius'),
          description: s.pick('Valores separados por comas (mcd = 1).',
              'Comma-separated values (gcd = 1).', pt: 'Valores separados por vírgulas (mdc = 1).', fr: 'Valeurs séparées par des virgules (pgcd = 1).', id: 'Nilai-nilai dipisahkan koma (FPB = 1).', vi: 'Các giá trị ngăn cách bằng dấu phẩy (ƯCLN = 1).', ru: 'Значения через запятую (НОД = 1).', it: 'Valori separati da virgole (MCD = 1).'),
          fields: [ToolField(s.pick('Denominaciones', 'Denominations', pt: 'Denominações', fr: 'Dénominations', id: 'Pecahan nilai uang', vi: 'Các mệnh giá', ru: 'Номиналы', it: 'Tagli'), initial: '6, 9, 20')],
          compute: (i) {
            final r = NumberTheoryAdvancedService.frobeniusNumber(_intList(i[0]));
            if (r == null) {
              return s.pick('mcd ≠ 1: infinitos no representables',
                  'gcd ≠ 1: infinitely many non-representable', pt: 'mdc ≠ 1: infinitos não representáveis', fr: 'pgcd ≠ 1 : une infinité de valeurs non représentables', id: 'FPB ≠ 1: tak hingga banyak nilai tidak terwakili', vi: 'ƯCLN ≠ 1: có vô số giá trị không biểu diễn được', ru: 'НОД ≠ 1: непредставимых значений бесконечно много', it: 'MCD ≠ 1: infiniti valori non rappresentabili');
            }
            return r.toString();
          },
        ),
        CalcTool(
          title: s.pick('Criba de Eratóstenes', 'Sieve of Eratosthenes', pt: 'Crivo de Eratóstenes', fr: "Crible d'Ératosthène", id: 'Saringan Eratosthenes', vi: 'Sàng Eratosthenes', ru: 'Решето Эратосфена', it: 'Crivello di Eratostene'),
          description: s.pick('Cuadrícula con los primos hasta n resaltados (n ≤ 400).',
              'Grid with the primes up to n highlighted (n ≤ 400).', pt: 'Grade com os primos até n destacados (n ≤ 400).', fr: "Grille des nombres jusqu'à n avec les premiers mis en évidence (n ≤ 400).", id: 'Kisi bilangan sampai n dengan bilangan prima disorot (n ≤ 400).', vi: 'Bảng số tới n với các số nguyên tố được tô đậm (n ≤ 400).', ru: 'Таблица с выделенными простыми до n (n ≤ 400).', it: 'Griglia con i primi fino a n evidenziati (n ≤ 400).'),
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
          title: s.pick('Residuos cuadráticos mod n', 'Quadratic residues mod n', pt: 'Resíduos quadráticos mod n', fr: 'Résidus quadratiques mod n', id: 'Residu kuadratik mod n', vi: 'Thặng dư bậc hai mod n', ru: 'Квадратичные вычеты по модулю n', it: 'Residui quadratici mod n'),
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
            return '${s.pick('Residuos', 'Residues', pt: 'Resíduos', fr: 'Résidus', id: 'Residu', vi: 'Thặng dư', ru: 'Вычеты', it: 'Residui')} (${sorted.length}): '
                '${sorted.join(', ')}\n'
                '${s.pick('No residuos', 'Non-residues', pt: 'Não resíduos', fr: 'Non-résidus', id: 'Bukan residu', vi: 'Bất thặng dư', ru: 'Невычеты', it: 'Non residui')}${s.colon} ${n - sorted.length}';
          },
        ),
        CalcTool(
          title: s.pick('Tabla φ, τ, σ, μ', 'Table φ, τ, σ, μ', pt: 'Tabela φ, τ, σ, μ', fr: 'Table φ, τ, σ, μ', id: 'Tabel φ, τ, σ, μ', vi: 'Bảng φ, τ, σ, μ', ru: 'Таблица φ, τ, σ, μ', it: 'Tabella φ, τ, σ, μ'),
          description: s.pick('Funciones multiplicativas para n en [a, b] (máx 30 filas).',
              'Multiplicative functions for n in [a, b] (max 30 rows).', pt: 'Funções multiplicativas para n em [a, b] (máx 30 linhas).', fr: 'Fonctions multiplicatives pour n dans [a, b] (max 30 lignes).', id: 'Fungsi multiplikatif untuk n dalam [a, b] (maks. 30 baris).', vi: 'Các hàm có tính nhân với n trong [a, b] (tối đa 30 dòng).', ru: 'Мультипликативные функции для n из [a, b] (макс. 30 строк).', it: 'Funzioni moltiplicative per n in [a, b] (max 30 righe).'),
          fields: [
            ToolField(s.pick('Desde', 'From', pt: 'De', fr: 'De', id: 'Dari', vi: 'Từ', ru: 'От', it: 'Da'), initial: '1'),
            ToolField(s.pick('Hasta', 'To', pt: 'Até', fr: 'À', id: 'Sampai', vi: 'Đến', ru: 'До', it: 'A'), initial: '12'),
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
// PROCEDURES (STEP BY STEP)
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
          title: s.pick('Euclides con pasos', 'Euclid with steps', pt: 'Euclides com passos', fr: 'Euclide étape par étape', id: 'Euclid langkah demi langkah', vi: 'Euclid từng bước', ru: 'Евклид по шагам', it: 'Euclide passo passo'),
          fields: [ToolField('a', initial: '240'), ToolField('b', initial: '46')],
          compute: (i) =>
              StepsService.euclidSteps(_bi(i[0]), _bi(i[1]), lang: s.lang)
                  .toString(),
        ),
        CalcTool(
          title: s.pick('Factorización con pasos', 'Factorization with steps', pt: 'Fatoração com passos', fr: 'Factorisation étape par étape', id: 'Faktorisasi langkah demi langkah', vi: 'Phân tích thừa số từng bước', ru: 'Разложение по шагам', it: 'Scomposizione passo passo'),
          fields: [ToolField('n', initial: '360')],
          compute: (i) =>
              StepsService.factorizationSteps(_bi(i[0]), lang: s.lang).toString(),
        ),
        CalcTool(
          title: s.pick('TCR con pasos', 'CRT with steps', pt: 'TCR com passos', fr: 'TRC étape par étape', id: 'CRT langkah demi langkah', vi: 'CRT từng bước', ru: 'КТО по шагам', it: 'TCR passo passo'),
          description: s.pick('Restos y módulos separados por comas.',
              'Comma-separated remainders and moduli.', pt: 'Restos e módulos separados por vírgulas.', fr: 'Restes et modules séparés par des virgules.', id: 'Sisa dan modulus dipisahkan koma.', vi: 'Các số dư và modulo ngăn cách bằng dấu phẩy.', ru: 'Остатки и модули через запятую.', it: 'Resti e moduli separati da virgole.'),
          fields: [
            ToolField(s.pick('Restos', 'Remainders', pt: 'Restos', fr: 'Restes', id: 'Sisa', vi: 'Các số dư', ru: 'Остатки', it: 'Resti'), initial: '2, 3, 2'),
            ToolField(s.pick('Módulos', 'Moduli', pt: 'Módulos', fr: 'Modules', id: 'Modulus', vi: 'Các modulo', ru: 'Модули', it: 'Moduli'), initial: '3, 5, 7'),
          ],
          compute: (i) =>
              StepsService.crtSteps(_biList(i[0]), _biList(i[1]), lang: s.lang)
                  .toString(),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// COMPLEX NUMBERS AND SEQUENCES
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
          title: s.pick('Raíces de la unidad', 'Roots of unity', pt: 'Raízes da unidade', fr: "Racines de l'unité", id: 'Akar-akar satuan', vi: 'Căn của đơn vị', ru: 'Корни из единицы', it: "Radici dell'unità"),
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
          title: s.pick('Potencia de complejo (De Moivre)', 'Complex power (De Moivre)', pt: 'Potência de complexo (De Moivre)', fr: "Puissance d'un complexe (De Moivre)", id: 'Pangkat bilangan kompleks (rumus De Moivre)', vi: 'Luỹ thừa số phức (công thức Moivre)', ru: 'Степень комплексного числа (формула Муавра)', it: 'Potenza di un complesso (De Moivre)'),
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
          title: s.pick('Raíces n-ésimas de complejo', 'n-th roots of complex', pt: 'Raízes n-ésimas de complexo', fr: "Racines n-ièmes d'un complexe", id: 'Akar pangkat n bilangan kompleks', vi: 'Căn bậc n của số phức', ru: 'Корни n-й степени из комплексного числа', it: 'Radici n-esime di un complesso'),
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
          title: s.pick('Recurrencia lineal', 'Linear recurrence', pt: 'Recorrência linear', fr: 'Récurrence linéaire', id: 'Relasi rekursif linear', vi: 'Dãy truy hồi tuyến tính', ru: 'Линейное рекуррентное соотношение', it: 'Ricorrenza lineare'),
          description: s.pick(
              'aₙ = c₁aₙ₋₁+…+cₖaₙ₋ₖ. Coef. e iniciales por comas.',
              'aₙ = c₁aₙ₋₁+…+cₖaₙ₋ₖ. Comma-separated coeffs and seeds.', pt: 'aₙ = c₁aₙ₋₁+…+cₖaₙ₋ₖ. Coef. e iniciais por vírgulas.', fr: 'aₙ = c₁aₙ₋₁+…+cₖaₙ₋ₖ. Coef. et termes initiaux séparés par des virgules.', id: 'aₙ = c₁aₙ₋₁+…+cₖaₙ₋ₖ. Koefisien dan suku awal dipisahkan koma.', vi: 'aₙ = c₁aₙ₋₁+…+cₖaₙ₋ₖ. Hệ số và số hạng đầu ngăn cách bằng dấu phẩy.', ru: 'aₙ = c₁aₙ₋₁+…+cₖaₙ₋ₖ. Коэффициенты и начальные члены через запятую.', it: 'aₙ = c₁aₙ₋₁+…+cₖaₙ₋ₖ. Coeff. e termini iniziali separati da virgole.'),
          fields: [
            ToolField(s.pick('Coeficientes', 'Coefficients', pt: 'Coeficientes', fr: 'Coefficients', id: 'Koefisien', vi: 'Các hệ số', ru: 'Коэффициенты', it: 'Coefficienti'), initial: '1, 1'),
            ToolField(s.pick('Iniciales', 'Initial terms', pt: 'Iniciais', fr: 'Termes initiaux', id: 'Suku awal', vi: 'Số hạng đầu', ru: 'Начальные члены', it: 'Termini iniziali'), initial: '0, 1'),
            ToolField(s.pick('Cantidad', 'Count', pt: 'Quantidade', fr: 'Quantité', id: 'Banyaknya', vi: 'Số lượng', ru: 'Количество', it: 'Quantità'), initial: '12'),
          ],
          compute: (i) {
            final terms = SequenceService.linearRecurrenceInts(
                _intList(i[0]), _intList(i[1]), _int(i[2]));
            return terms.map((f) => f.toString()).join(', ');
          },
        ),
        CalcTool(
          title: s.pick('Triángulo de Pascal (fila n)', 'Pascal triangle (row n)', pt: 'Triângulo de Pascal (linha n)', fr: 'Triangle de Pascal (ligne n)', id: 'Segitiga Pascal (baris n)', vi: 'Tam giác Pascal (dòng n)', ru: 'Треугольник Паскаля (строка n)', it: 'Triangolo di Tartaglia (riga n)'),
          fields: [ToolField('n', initial: '6')],
          compute: (i) {
            // Capped like its sibling tools: row n holds n+1 binomials whose
            // digit count grows with n, so an uncapped n froze the UI and
            // produced a megabyte-long string nobody can read.
            final n = _int(i[0]);
            if (n > 1000) {
              throw CalcException(CalcError.inputTooLarge, {'max': '1000'});
            }
            return CombinatoricsExtraService.pascalRow(n).join(', ');
          },
        ),
        CalcTool(
          title: s.pick('Pascal mod m (Sierpiński)', 'Pascal mod m (Sierpiński)', pt: 'Pascal mod m (Sierpiński)', fr: 'Pascal mod m (Sierpiński)', id: 'Pascal mod m (Sierpiński)', vi: 'Pascal mod m (Sierpiński)', ru: 'Паскаль mod m (Серпинский)', it: 'Tartaglia mod m (Sierpiński)'),
          description: s.pick(
              'Triángulo de Pascal módulo m coloreado por residuo. Con m=2 aparece el fractal de Sierpiński.',
              'Pascal triangle modulo m colored by residue. With m=2 the Sierpiński fractal appears.', pt: 'Triângulo de Pascal módulo m colorido por resíduo. Com m=2 aparece o fractal de Sierpiński.', fr: 'Triangle de Pascal modulo m, coloré par résidu. Avec m=2 apparaît la fractale de Sierpiński.', id: 'Segitiga Pascal modulo m diwarnai menurut sisanya. Dengan m=2 muncul fraktal Sierpiński.', vi: 'Tam giác Pascal theo modulo m, tô màu theo số dư. Với m=2 xuất hiện fractal Sierpiński.', ru: 'Треугольник Паскаля по модулю m, раскрашенный по остаткам. При m=2 проступает фрактал Серпинского.', it: 'Triangolo di Tartaglia modulo m, colorato per residuo. Con m=2 compare il frattale di Sierpiński.'),
          fields: [
            ToolField(s.pick('Filas', 'Rows', pt: 'Linhas', fr: 'Lignes', id: 'Baris', vi: 'Số dòng', ru: 'Строк', it: 'Righe'), initial: '32'),
            ToolField('m', initial: '2'),
          ],
          compute: (i) {
            final n = _int(i[0]), m = _int(i[1]);
            // n is a row count: with n=0 pascalTriangleMod(-1) was called
            // and blew up with the contradictory message "n debe ser ≥ 0".
            if (n < 1) throw CalcException(CalcError.nPositive);
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
            return '${s.pick('Filas', 'Rows', pt: 'Linhas', fr: 'Lignes', id: 'Baris', vi: 'Số dòng', ru: 'Строк', it: 'Righe')}${s.colon} $n  (mod $m)\n'
                '${s.pick('Coeficientes', 'Coefficients', pt: 'Coeficientes', fr: 'Coefficients', id: 'Koefisien', vi: 'Các hệ số', ru: 'Коэффициенты', it: 'Coefficienti')}${s.colon} $total, '
                '${s.pick('divisibles por', 'divisible by', pt: 'divisíveis por', fr: 'divisibles par', id: 'habis dibagi', vi: 'chia hết cho', ru: 'делятся на', it: 'divisibili per')} $m: $zeros';
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
          title: s.pick('Expansión binomial (a+b)ⁿ', 'Binomial expansion (a+b)ⁿ', pt: 'Expansão binomial (a+b)ⁿ', fr: 'Développement binomial (a+b)ⁿ', id: 'Penjabaran binomial (a+b)ⁿ', vi: 'Khai triển nhị thức (a+b)ⁿ', ru: 'Разложение бинома (a+b)ⁿ', it: 'Sviluppo binomiale (a+b)ⁿ'),
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
// STATISTICS
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
          title: s.pick('Estadística descriptiva', 'Descriptive statistics', pt: 'Estatística descritiva', fr: 'Statistiques descriptives', id: 'Statistika deskriptif', vi: 'Thống kê mô tả', ru: 'Описательная статистика', it: 'Statistica descrittiva'),
          description: s.pick(
              'Valores (enteros, fracciones o decimales) separados por comas.',
              'Comma-separated values (integers, fractions or decimals).', pt: 'Valores (inteiros, frações ou decimais) separados por vírgulas.', fr: 'Valeurs (entiers, fractions ou décimaux) séparées par des virgules.', id: 'Nilai-nilai (bilangan bulat, pecahan atau desimal) dipisahkan koma.', vi: 'Các giá trị (số nguyên, phân số hoặc thập phân) ngăn cách bằng dấu phẩy.', ru: 'Значения (целые, дроби или десятичные) через запятую.', it: 'Valori (interi, frazioni o decimali) separati da virgole.'),
          fields: [
            ToolField(s.pick('Valores', 'Values', pt: 'Valores', fr: 'Valeurs', id: 'Nilai-nilai', vi: 'Các giá trị', ru: 'Значения', it: 'Valori'), initial: '2, 4, 4, 5, 7'),
          ],
          compute: (i) {
            final r = StatisticsService.descriptive(_fracList(i[0]));
            final modes = r.modes.isEmpty
                ? s.pick('ninguna', 'none', pt: 'nenhuma', fr: 'aucune', id: 'tidak ada', vi: 'không có', ru: 'нет', it: 'nessuna')
                : r.modes.join(', ');
            final sb = StringBuffer();
            sb.writeln('n = ${r.count}');
            sb.writeln('min = ${r.min}, max = ${r.max}, '
                '${s.pick('rango', 'range', pt: 'amplitude', fr: 'étendue', id: 'jangkauan', vi: 'khoảng biến thiên', ru: 'размах', it: 'campo di variazione')} = ${r.range}');
            sb.writeln('${s.pick('Media', 'Mean', pt: 'Média', fr: 'Moyenne', id: 'Rata-rata', vi: 'Trung bình', ru: 'Среднее', it: 'Media')}${s.colon} ${r.mean}'
                '  ≈ ${r.mean.toDouble().toStringAsFixed(6)}');
            sb.writeln('${s.pick('Mediana', 'Median', pt: 'Mediana', fr: 'Médiane', id: 'Median', vi: 'Trung vị', ru: 'Медиана', it: 'Mediana')}${s.colon} ${r.median}');
            sb.writeln('${s.pick('Moda', 'Mode', pt: 'Moda', fr: 'Mode', id: 'Modus', vi: 'Mốt', ru: 'Мода', it: 'Moda')}${s.colon} $modes');
            sb.writeln('${s.pick('Varianza (poblacional)', 'Variance (population)', pt: 'Variância (populacional)', fr: 'Variance (population)', id: 'Ragam (populasi)', vi: 'Phương sai (tổng thể)', ru: 'Дисперсия (генеральная)', it: 'Varianza (popolazione)')}${s.colon} '
                '${r.variancePopulation}');
            if (r.varianceSample != null) {
              sb.writeln('${s.pick('Varianza (muestral)', 'Variance (sample)', pt: 'Variância (amostral)', fr: 'Variance (échantillon)', id: 'Ragam (sampel)', vi: 'Phương sai (mẫu)', ru: 'Дисперсия (выборочная)', it: 'Varianza (campionaria)')}${s.colon} '
                  '${r.varianceSample}');
            }
            sb.write('${s.pick('Desv. estándar', 'Std. deviation', pt: 'Desvio padrão', fr: 'Écart-type', id: 'Simpangan baku', vi: 'Độ lệch chuẩn', ru: 'Станд. отклонение', it: 'Dev. standard')} ≈ '
                '${r.stdDevPopulation.toStringAsFixed(6)}');
            return sb.toString();
          },
        ),
        CalcTool(
          title: s.pick('Desigualdad de medias (QM ≥ AM ≥ GM ≥ HM)',
              'Mean inequality (QM ≥ AM ≥ GM ≥ HM)', pt: 'Desigualdade das médias (MQ ≥ MA ≥ MG ≥ MH)', fr: 'Inégalité des moyennes (MQ ≥ MA ≥ MG ≥ MH)', id: 'Ketaksamaan rata-rata (QM ≥ AM ≥ GM ≥ HM)', vi: 'Bất đẳng thức AM-GM (QM ≥ AM ≥ GM ≥ HM)', ru: 'Неравенство о средних (СК ≥ СА ≥ СГ ≥ СГарм)', it: 'Disuguaglianza tra le medie (MQ ≥ MA ≥ MG ≥ MH)'),
          description: s.pick('Valores positivos separados por comas.',
              'Comma-separated positive values.', pt: 'Valores positivos separados por vírgulas.', fr: 'Valeurs positives séparées par des virgules.', id: 'Nilai-nilai positif dipisahkan koma.', vi: 'Các giá trị dương ngăn cách bằng dấu phẩy.', ru: 'Положительные значения через запятую.', it: 'Valori positivi separati da virgole.'),
          fields: [
            ToolField(s.pick('Valores', 'Values', pt: 'Valores', fr: 'Valeurs', id: 'Nilai-nilai', vi: 'Các giá trị', ru: 'Значения', it: 'Valori'), initial: '1, 2, 4'),
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
// MATRICES (exact linear algebra)
// ════════════════════════════════════════════════════════════════════════════

class MatricesToolScreen extends StatelessWidget {
  const MatricesToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    final matrixHint = s.pick(
        'Filas separadas por ";", entradas por ",". Admite fracciones.',
        'Rows separated by ";", entries by ",". Fractions allowed.', pt: 'Linhas separadas por ";", entradas por ",". Admite frações.', fr: 'Lignes séparées par « ; », entrées par « , ». Les fractions sont acceptées.', id: 'Baris dipisahkan «;», unsur dipisahkan «,». Pecahan diperbolehkan.', vi: 'Các dòng ngăn cách bằng «;», các phần tử bằng «,». Chấp nhận phân số.', ru: 'Строки разделяются «;», элементы — «,». Дроби допускаются.', it: 'Righe separate da «;», elementi da «,». Sono ammesse le frazioni.');
    return _ToolScaffold(
      title: s.catMatrices,
      tools: [
        CalcTool(
          title: s.pick('Determinante', 'Determinant', pt: 'Determinante', fr: 'Déterminant', id: 'Determinan', vi: 'Định thức', ru: 'Определитель', it: 'Determinante'),
          description: matrixHint,
          fields: [
            ToolField(s.pick('Matriz', 'Matrix', pt: 'Matriz', fr: 'Matrice', id: 'Matriks', vi: 'Ma trận', ru: 'Матрица', it: 'Matrice'), initial: '6,1,1; 4,-2,5; 2,8,7'),
          ],
          compute: (i) {
            final m = _matrix(i[0]);
            if (!m.isSquare) {
              return s.pick('La matriz debe ser cuadrada', 'Matrix must be square', pt: 'A matriz deve ser quadrada', fr: 'La matrice doit être carrée', id: 'Matriksnya harus persegi', vi: 'Ma trận phải là ma trận vuông', ru: 'Матрица должна быть квадратной', it: 'La matrice deve essere quadrata');
            }
            final det = m.determinant();
            return 'det = $det  ≈ ${det.toDouble()}';
          },
        ),
        CalcTool(
          title: s.pick('Inversa', 'Inverse', pt: 'Inversa', fr: 'Inverse', id: 'Invers', vi: 'Ma trận nghịch đảo', ru: 'Обратная матрица', it: 'Inversa'),
          description: matrixHint,
          fields: [
            ToolField(s.pick('Matriz', 'Matrix', pt: 'Matriz', fr: 'Matrice', id: 'Matriks', vi: 'Ma trận', ru: 'Матрица', it: 'Matrice'), initial: '4,7; 2,6'),
          ],
          compute: (i) {
            final m = _matrix(i[0]);
            final inv = m.inverse();
            if (inv == null) {
              return s.pick('Matriz singular o no cuadrada (sin inversa)',
                  'Singular or non-square matrix (no inverse)', pt: 'Matriz singular ou não quadrada (sem inversa)', fr: "Matrice singulière ou non carrée (pas d'inverse)", id: 'Matriks singular atau tidak persegi (tidak punya invers)', vi: 'Ma trận suy biến hoặc không vuông (không có nghịch đảo)', ru: 'Вырожденная или неквадратная матрица (обратной нет)', it: 'Matrice singolare o non quadrata (senza inversa)');
            }
            return inv.toString();
          },
        ),
        CalcTool(
          title: s.pick('Multiplicar A × B', 'Multiply A × B', pt: 'Multiplicar A × B', fr: 'Multiplier A × B', id: 'Kalikan A × B', vi: 'Nhân A × B', ru: 'Умножить A × B', it: 'Moltiplica A × B'),
          description: s.pick('Dos matrices separadas por "|".',
              'Two matrices separated by "|".', pt: 'Duas matrizes separadas por "|".', fr: 'Deux matrices séparées par « | ».', id: 'Dua matriks dipisahkan «|».', vi: 'Hai ma trận ngăn cách bằng «|».', ru: 'Две матрицы, разделённые «|».', it: 'Due matrici separate da «|».'),
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
          title: s.pick('Resolver A·x = b (n×n)', 'Solve A·x = b (n×n)', pt: 'Resolver A·x = b (n×n)', fr: 'Résoudre A·x = b (n×n)', id: 'Selesaikan A·x = b (n×n)', vi: 'Giải A·x = b (n×n)', ru: 'Решить A·x = b (n×n)', it: 'Risolvi A·x = b (n×n)'),
          description: s.pick(
              'Matriz A y vector b separados por "|".',
              'Matrix A and vector b separated by "|".', pt: 'Matriz A e vetor b separados por "|".', fr: 'Matrice A et vecteur b séparés par « | ».', id: 'Matriks A dan vektor b dipisahkan «|».', vi: 'Ma trận A và vectơ b ngăn cách bằng «|».', ru: 'Матрица A и вектор b, разделённые «|».', it: 'Matrice A e vettore b separati da «|».'),
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
                  'No unique solution (singular)', pt: 'Sem solução única (singular)', fr: 'Pas de solution unique (singulière)', id: 'Tidak ada solusi tunggal (matriks singular)', vi: 'Không có nghiệm duy nhất (ma trận suy biến)', ru: 'Единственного решения нет (матрица вырождена)', it: 'Nessuna soluzione unica (singolare)');
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
          title: s.pick('Rango y transpuesta', 'Rank and transpose', pt: 'Posto e transposta', fr: 'Rang et transposée', id: 'Rank dan transpos', vi: 'Hạng và ma trận chuyển vị', ru: 'Ранг и транспонированная', it: 'Rango e trasposta'),
          description: matrixHint,
          fields: [
            ToolField(s.pick('Matriz', 'Matrix', pt: 'Matriz', fr: 'Matrice', id: 'Matriks', vi: 'Ma trận', ru: 'Матрица', it: 'Matrice'), initial: '1,2,3; 2,4,6; 1,0,1'),
          ],
          compute: (i) {
            final m = _matrix(i[0]);
            return '${s.pick('Rango', 'Rank', pt: 'Posto', fr: 'Rang', id: 'Rank', vi: 'Hạng', ru: 'Ранг', it: 'Rango')}${s.colon} ${m.rank()}\n'
                '${s.pick('Transpuesta', 'Transpose', pt: 'Transposta', fr: 'Transposée', id: 'Transpos', vi: 'Ma trận chuyển vị', ru: 'Транспонированная', it: 'Trasposta')}${s.colon}\n${m.transpose()}';
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// CALCULUS (numerical)
// ════════════════════════════════════════════════════════════════════════════

class CalculusToolScreen extends StatelessWidget {
  const CalculusToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    final fnHint = s.pick(
        'Función de x. Trig en radianes. Ej: x^2+sin(x), 1/x, exp(x).',
        'Function of x. Trig in radians. E.g. x^2+sin(x), 1/x, exp(x).', pt: 'Função de x. Trigonometria em radianos. Ex.: x^2+sin(x), 1/x, exp(x).', fr: 'Fonction de x. Trigonométrie en radians. Ex. : x^2+sin(x), 1/x, exp(x).', id: 'Fungsi dalam x. Trigonometri dalam radian. Mis.: x^2+sin(x), 1/x, exp(x).', vi: 'Hàm theo x. Lượng giác tính bằng radian. Vd: x^2+sin(x), 1/x, exp(x).', ru: 'Функция от x. Тригонометрия в радианах. Напр.: x^2+sin(x), 1/x, exp(x).', it: 'Funzione di x. Trigonometria in radianti. Es.: x^2+sin(x), 1/x, exp(x).');
    return _ToolScaffold(
      title: s.catCalculus,
      tools: [
        CalcTool(
          title: s.pick('Derivada f\'(x₀)', 'Derivative f\'(x₀)', pt: "Derivada f'(x₀)", fr: "Dérivée f'(x₀)", id: "Turunan f'(x₀)", vi: "Đạo hàm f'(x₀)", ru: "Производная f'(x₀)", it: "Derivata f'(x₀)"),
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
          title: s.pick('Integral definida ∫', 'Definite integral ∫', pt: 'Integral definida ∫', fr: 'Intégrale définie ∫', id: 'Integral tentu ∫', vi: 'Tích phân xác định ∫', ru: 'Определённый интеграл ∫', it: 'Integrale definito ∫'),
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
            return s.pick('∫ de ${i[1]} a ${i[2]} ≈ ${_fmtNum(v)}',
                '∫ from ${i[1]} to ${i[2]} ≈ ${_fmtNum(v)}', pt: '∫ de ${i[1]} a ${i[2]} ≈ ${_fmtNum(v)}', fr: '∫ de ${i[1]} à ${i[2]} ≈ ${_fmtNum(v)}', id: '∫ dari ${i[1]} sampai ${i[2]} ≈ ${_fmtNum(v)}', vi: '∫ từ ${i[1]} đến ${i[2]} ≈ ${_fmtNum(v)}', ru: '∫ от ${i[1]} до ${i[2]} ≈ ${_fmtNum(v)}', it: '∫ da ${i[1]} a ${i[2]} ≈ ${_fmtNum(v)}');
          },
        ),
        CalcTool(
          title: s.pick('Límite (numérico)', 'Limit (numerical)', pt: 'Limite (numérico)', fr: 'Limite (numérique)', id: 'Limit (numerik)', vi: 'Giới hạn (bằng số)', ru: 'Предел (численно)', it: 'Limite (numerico)'),
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
                  'Does not exist (one-sided limits differ or not finite)', pt: 'Não existe (limites laterais diferentes ou não finitos)', fr: "N'existe pas (limites latérales différentes ou non finies)", id: 'Tidak ada (limit kiri dan kanan berbeda atau tak hingga)', vi: 'Không tồn tại (giới hạn hai phía khác nhau hoặc không hữu hạn)', ru: 'Не существует (односторонние пределы различны или бесконечны)', it: 'Non esiste (limiti laterali diversi o non finiti)');
            }
            return 'lim x→${i[1]} ≈ ${_fmtNum(l)}';
          },
        ),
      ],
    );
  }
}

/// Formats a double: exact integer without decimals; otherwise ~10 clean digits.
String _fmtNum(double v) {
  if (v == v.roundToDouble() && v.abs() < 1e15) {
    return v.toInt().toString();
  }
  return double.parse(v.toStringAsPrecision(10)).toString();
}
