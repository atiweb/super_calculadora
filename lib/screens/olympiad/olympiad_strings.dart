import 'package:flutter/widgets.dart';
import '../../models/calc_exception.dart';

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

  // Quiz
  String get catQuiz => pick('Práctica', 'Practice');
  String get catQuizSub =>
      pick('Problemas con verificación', 'Self-checking problems');
  String get quizAnswer => pick('Tu respuesta', 'Your answer');
  String get quizCheck => pick('Comprobar', 'Check');
  String get quizNext => pick('Siguiente', 'Next');
  String get quizCorrect => pick('¡Correcto!', 'Correct!');
  String quizIncorrect(String answer) =>
      pick('Incorrecto. Respuesta: $answer', 'Incorrect. Answer: $answer');
  String quizScore(int correct, int total) =>
      pick('Puntaje: $correct / $total', 'Score: $correct / $total');

  /// Traduce una [CalcException] al idioma activo.
  String errorText(CalcException e) {
    final v = e.arg('value');
    final k = e.arg('k');
    switch (e.code) {
      case CalcError.zeroDenominator:
        return pick('El denominador no puede ser cero',
            'Denominator cannot be zero');
      case CalcError.divisionByZero:
        return pick('División por cero', 'Division by zero');
      case CalcError.reciprocalOfZero:
        return pick('El recíproco de 0 no está definido',
            'The reciprocal of 0 is undefined');
      case CalcError.zeroToNegativePower:
        return pick('0 elevado a un exponente negativo',
            '0 raised to a negative power');
      case CalcError.invalidFraction:
        return pick('Fracción inválida: "$v"', 'Invalid fraction: "$v"');
      case CalcError.invalidNumber:
        return pick('Número inválido: "$v"', 'Invalid number: "$v"');
      case CalcError.invalidInteger:
        return pick('Entero inválido: "$v"', 'Invalid integer: "$v"');
      case CalcError.emptyInput:
        return pick('Entrada vacía', 'Empty input');
      case CalcError.negativeRadicand:
        return pick('Radicando negativo: no es un número real',
            'Negative radicand: not a real number');
      case CalcError.evenRootOfNegative:
        return pick('Raíz de índice par de un número negativo',
            'Even-index root of a negative number');
      case CalcError.rootIndexTooSmall:
        return pick('El índice de la raíz debe ser ≥ 2',
            'The root index must be ≥ 2');
      case CalcError.divisionByRootZero:
        return pick('División por √0', 'Division by √0');
      case CalcError.binomialVanishes:
        return pick('Denominador nulo: c² = d (el binomio se anula)',
            'Null denominator: c² = d (the binomial vanishes)');
      case CalcError.invalidTriangle:
        return pick('Los lados no forman un triángulo válido',
            'The sides do not form a valid triangle');
      case CalcError.needAtLeast3Vertices:
        return pick('Se requieren al menos 3 vértices',
            'At least 3 vertices are required');
      case CalcError.invalidPoint:
        return pick('Punto inválido: "$v"', 'Invalid point: "$v"');
      case CalcError.zeroPolynomialDivision:
        return pick('División entre el polinomio nulo',
            'Division by the zero polynomial');
      case CalcError.emptyExpression:
        return pick('Expresión vacía', 'Empty expression');
      case CalcError.invalidTerm:
        return pick('Término inválido: "$v"', 'Invalid term: "$v"');
      case CalcError.degreeAtLeastOne:
        return pick('Se requiere grado ≥ 1', 'Degree ≥ 1 is required');
      case CalcError.discriminantDegree:
        return pick('Discriminante disponible solo para grados 2 y 3',
            'Discriminant available only for degrees 2 and 3');
      case CalcError.zeroPolynomialRoots:
        return pick('El polinomio nulo tiene infinitas raíces',
            'The zero polynomial has infinitely many roots');
      case CalcError.notQuadratic:
        return pick('a = 0: no es una ecuación cuadrática',
            'a = 0: not a quadratic equation');
      case CalcError.notCubic:
        return pick('a = 0: no es una ecuación cúbica',
            'a = 0: not a cubic equation');
      case CalcError.modulusPositive:
        return pick('El módulo debe ser positivo',
            'The modulus must be positive');
      case CalcError.nNonNegative:
        return pick('n debe ser ≥ 0', 'n must be ≥ 0');
      case CalcError.nPositive:
        return pick('n debe ser ≥ 1', 'n must be ≥ 1');
      case CalcError.positiveDRequired:
        return pick('D debe ser positivo', 'D must be positive');
      case CalcError.perfectSquareD:
        return pick('D no debe ser un cuadrado perfecto',
            'D must not be a perfect square');
      case CalcError.needPositiveValue:
        return pick('Se requiere al menos un valor positivo',
            'At least one positive value is required');
      case CalcError.nGreaterThanOne:
        return pick('n debe ser > 1', 'n must be > 1');
      case CalcError.needKInitialTerms:
        return pick('Se requieren $k términos iniciales',
            '$k initial terms are required');
      case CalcError.countNonNegative:
        return pick('La cantidad debe ser ≥ 0', 'count must be ≥ 0');
      case CalcError.partsNonNegative:
        return pick('Las partes deben ser no negativas',
            'Parts must be non-negative');
      case CalcError.invalidOperation:
        return pick('Operación no válida (use + - * /)',
            'Invalid operation (use + - * /)');
      case CalcError.listsSameSize:
        return pick('Las listas deben tener el mismo tamaño y no estar vacías',
            'The lists must have the same size and be non-empty');
    }
  }
}
