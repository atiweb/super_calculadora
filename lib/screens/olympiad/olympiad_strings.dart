import 'package:flutter/widgets.dart';

/// Textos bilingües (ES/EN) del módulo de Herramientas de Olimpiada.
///
/// Se mantienen co-localizados con la funcionalidad (en lugar de en los .arb
/// compartidos) porque son un conjunto grande y específico de este módulo.
class OlympiadStrings {
  final bool es;
  const OlympiadStrings(this.es);

  factory OlympiadStrings.of(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return OlympiadStrings(code == 'es');
  }

  String pick(String spanish, String english) => es ? spanish : english;

  // Hub
  String get title => pick('Herramientas de Olimpiada', 'Olympiad Tools');
  String get subtitle => pick(
      'Herramientas exactas para entrenamiento', 'Exact tools for training');

  // Chrome
  String get compute => pick('Calcular', 'Compute');
  String get result => pick('Resultado', 'Result');
  String get errorPrefix => pick('Error', 'Error');

  // Categorías
  String get catFractions => pick('Fracciones', 'Fractions');
  String get catFractionsSub =>
      pick('Aritmética racional exacta', 'Exact rational arithmetic');
  String get catSurds => pick('Radicales', 'Radicals');
  String get catSurdsSub =>
      pick('Simplificar y racionalizar', 'Simplify and rationalize');
  String get catGeometry => pick('Geometría', 'Geometry');
  String get catGeometrySub =>
      pick('Triángulos, áreas, ternas', 'Triangles, areas, triples');
  String get catPolynomials => pick('Polinomios', 'Polynomials');
  String get catPolynomialsSub =>
      pick('Raíces, Vieta, discriminante', 'Roots, Vieta, discriminant');
  String get catNumberTheory => pick('Teoría de Números', 'Number Theory');
  String get catNumberTheorySub =>
      pick('Congruencias, Pell, cuadrados', 'Congruences, Pell, squares');
  String get catSteps => pick('Procedimientos', 'Step by step');
  String get catStepsSub =>
      pick('Euclides, TCR, factorización', 'Euclid, CRT, factorization');
  String get catComplexSeq => pick('Complejos y Sucesiones', 'Complex & Sequences');
  String get catComplexSeqSub =>
      pick('Raíces de la unidad, recurrencias', 'Roots of unity, recurrences');
}
