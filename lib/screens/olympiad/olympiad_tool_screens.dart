import 'package:flutter/material.dart';

import '../../models/calc_exception.dart';
import '../../models/complex.dart';
import '../../models/fraction.dart';
import '../../models/point.dart';
import '../../models/surd.dart';
import '../../services/combinatorics_extra_service.dart';
import '../../services/geometry_service.dart';
import '../../services/number_theory_advanced_service.dart';
import '../../services/polynomial_service.dart';
import '../../services/sequence_service.dart';
import '../../services/steps_service.dart';
import '../../services/surd_service.dart';
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
            final pts = i[0].split(';').where((p) => p.trim().isNotEmpty).map((p) {
              final xy = p.split(',');
              if (xy.length != 2) {
                throw CalcException(CalcError.invalidPoint, {'value': p});
              }
              return Point(Fraction.parse(xy[0]), Fraction.parse(xy[1]));
            }).toList();
            final area = GeometryService.shoelaceArea(pts);
            return '${s.pick('Área', 'Area')}: $area  ≈ ${area.toDouble()}';
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
          compute: (i) => Complex.rootsOfUnity(_int(i[0]))
              .map((c) => c.toString())
              .join('\n'),
        ),
        CalcTool(
          title: s.pick('Potencia de complejo (De Moivre)', 'Complex power (De Moivre)'),
          description: '(re + im·i)^n',
          fields: [
            ToolField('re', initial: '1'),
            ToolField('im', initial: '1'),
            ToolField('n', initial: '8'),
          ],
          compute: (i) => Complex(double.parse(i[0]), double.parse(i[1]))
              .pow(_int(i[2]))
              .toString(),
        ),
        CalcTool(
          title: s.pick('Raíces n-ésimas de complejo', 'n-th roots of complex'),
          fields: [
            ToolField('re', initial: '3'),
            ToolField('im', initial: '4'),
            ToolField('n', initial: '3'),
          ],
          compute: (i) => Complex(double.parse(i[0]), double.parse(i[1]))
              .nthRoots(_int(i[2]))
              .map((c) => c.toString())
              .join('\n'),
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
      ],
    );
  }
}
