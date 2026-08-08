import 'package:flutter/widgets.dart';
import '../../models/calc_exception.dart';
import '../../utils/app_locale.dart';

/// Bilingual (ES/EN) texts for the Olympiad Tools module.
///
/// They are kept co-located with the functionality (instead of in the shared
/// .arb files) because they are a large set specific to this module.
class OlympiadStrings {
  /// Active UI language code ('es', 'en', 'pt', …).
  final String lang;

  const OlympiadStrings(this.lang);

  factory OlympiadStrings.of(BuildContext context) =>
      OlympiadStrings(Localizations.localeOf(context).languageCode);

  /// Whether the active language is Spanish.
  bool get es => lang == 'es';

  /// Text for the active language, falling back to English (see [trLang]),
  /// so a language can be filled in tool by tool.
  String pick(String spanish, String english, {String? pt}) =>
      trLang(lang, spanish, english, pt: pt);

  // Hub
  String get title => pick('Herramientas de Olimpiada', 'Olympiad Tools', pt: 'Ferramentas de Olimpíada');
  String get subtitle => pick(
      'Herramientas exactas para entrenamiento', 'Exact tools for training', pt: 'Ferramentas exatas para treinamento');

  // Chrome
  String get compute => pick('Calcular', 'Compute', pt: 'Calcular');
  String get copy => pick('Copiar', 'Copy', pt: 'Copiar');
  String get result => pick('Resultado', 'Result', pt: 'Resultado');
  String get errorPrefix => pick('Error', 'Error', pt: 'Erro');

  // Categories
  String get catFractions => pick('Fracciones', 'Fractions', pt: 'Frações');
  String get catFractionsSub =>
      pick('Aritmética racional exacta', 'Exact rational arithmetic', pt: 'Aritmética racional exata');
  String get catSurds => pick('Radicales', 'Radicals', pt: 'Radicais');
  String get catSurdsSub =>
      pick('Simplificar y racionalizar', 'Simplify and rationalize', pt: 'Simplificar e racionalizar');
  String get catGeometry => pick('Geometría', 'Geometry', pt: 'Geometria');
  String get catGeometrySub =>
      pick('Triángulos, áreas, ternas', 'Triangles, areas, triples', pt: 'Triângulos, áreas, ternos');
  String get catPolynomials => pick('Polinomios', 'Polynomials', pt: 'Polinômios');
  String get catPolynomialsSub =>
      pick('Raíces, Vieta, discriminante', 'Roots, Vieta, discriminant', pt: 'Raízes, Vieta, discriminante');
  String get catAlgebra => pick('Álgebra', 'Algebra', pt: 'Álgebra');
  String get catAlgebraSub => pick(
      'Expandir, identidades, factor común',
      'Expand, identities, common factor', pt: 'Expandir, identidades, fator comum');
  String get catNumberTheory => pick('Teoría de Números', 'Number Theory', pt: 'Teoria dos Números');
  String get catNumberTheorySub =>
      pick('Congruencias, Pell, cuadrados', 'Congruences, Pell, squares', pt: 'Congruências, Pell, quadrados');
  String get catSteps => pick('Procedimientos', 'Step by step', pt: 'Procedimentos');
  String get catStepsSub =>
      pick('Euclides, TCR, factorización', 'Euclid, CRT, factorization', pt: 'Euclides, TCR, fatoração');
  String get catComplexSeq => pick('Complejos y Sucesiones', 'Complex & Sequences', pt: 'Complexos e Sequências');
  String get catComplexSeqSub =>
      pick('Raíces de la unidad, recurrencias', 'Roots of unity, recurrences', pt: 'Raízes da unidade, recorrências');
  String get catStatistics => pick('Estadística', 'Statistics', pt: 'Estatística');
  String get catStatisticsSub =>
      pick('Descriptiva exacta y desigualdad de medias',
          'Exact descriptive stats and mean inequality', pt: 'Descritiva exata e desigualdade das médias');
  String get catMatrices => pick('Matrices', 'Matrices', pt: 'Matrizes');
  String get catMatricesSub =>
      pick('Determinante, inversa, sistemas (exacto)',
          'Determinant, inverse, systems (exact)', pt: 'Determinante, inversa, sistemas (exato)');
  String get catCalculus => pick('Cálculo', 'Calculus', pt: 'Cálculo');
  String get catCalculusSub =>
      pick('Derivada, integral y límite numéricos',
          'Numerical derivative, integral and limit', pt: 'Derivada, integral e limite numéricos');

  // Quiz
  String get catQuiz => pick('Práctica', 'Practice', pt: 'Prática');
  String get catQuizSub =>
      pick('Problemas con verificación', 'Self-checking problems', pt: 'Problemas com verificação');
  String get quizAnswer => pick('Tu respuesta', 'Your answer', pt: 'Sua resposta');
  String get quizCheck => pick('Comprobar', 'Check', pt: 'Verificar');
  String get quizNext => pick('Siguiente', 'Next', pt: 'Próximo');
  String get quizCorrect => pick('¡Correcto!', 'Correct!', pt: 'Correto!');
  String quizIncorrect(String answer) =>
      pick('Incorrecto. Respuesta: $answer', 'Incorrect. Answer: $answer', pt: 'Incorreto. Resposta: $answer');
  String quizScore(int correct, int total) =>
      pick('Puntaje: $correct / $total', 'Score: $correct / $total', pt: 'Pontuação: $correct / $total');

  /// Translates a [CalcException] into the active language.
  String errorText(CalcException e) {
    final v = e.arg('value');
    final k = e.arg('k');
    switch (e.code) {
      case CalcError.zeroDenominator:
        return pick('El denominador no puede ser cero',
            'Denominator cannot be zero', pt: 'O denominador não pode ser zero');
      case CalcError.divisionByZero:
        return pick('División por cero', 'Division by zero', pt: 'Divisão por zero');
      case CalcError.reciprocalOfZero:
        return pick('El recíproco de 0 no está definido',
            'The reciprocal of 0 is undefined', pt: 'O recíproco de 0 não está definido');
      case CalcError.zeroToNegativePower:
        return pick('0 elevado a un exponente negativo',
            '0 raised to a negative power', pt: '0 elevado a um expoente negativo');
      case CalcError.invalidFraction:
        return pick('Fracción inválida: "$v"', 'Invalid fraction: "$v"', pt: 'Fração inválida: "$v"');
      case CalcError.invalidNumber:
        return pick('Número inválido: "$v"', 'Invalid number: "$v"', pt: 'Número inválido: "$v"');
      case CalcError.invalidInteger:
        return pick('Entero inválido: "$v"', 'Invalid integer: "$v"', pt: 'Inteiro inválido: "$v"');
      case CalcError.emptyInput:
        return pick('Entrada vacía', 'Empty input', pt: 'Entrada vazia');
      case CalcError.negativeRadicand:
        return pick('Radicando negativo: no es un número real',
            'Negative radicand: not a real number', pt: 'Radicando negativo: não é um número real');
      case CalcError.evenRootOfNegative:
        return pick('Raíz de índice par de un número negativo',
            'Even-index root of a negative number', pt: 'Raiz de índice par de um número negativo');
      case CalcError.rootIndexTooSmall:
        return pick('El índice de la raíz debe ser ≥ 2',
            'The root index must be ≥ 2', pt: 'O índice da raiz deve ser ≥ 2');
      case CalcError.divisionByRootZero:
        return pick('División por √0', 'Division by √0', pt: 'Divisão por √0');
      case CalcError.binomialVanishes:
        return pick('Denominador nulo: c² = d (el binomio se anula)',
            'Null denominator: c² = d (the binomial vanishes)', pt: 'Denominador nulo: c² = d (o binômio se anula)');
      case CalcError.invalidTriangle:
        return pick('Los lados no forman un triángulo válido',
            'The sides do not form a valid triangle', pt: 'Os lados não formam um triângulo válido');
      case CalcError.needAtLeast3Vertices:
        return pick('Se requieren al menos 3 vértices',
            'At least 3 vertices are required', pt: 'São necessários pelo menos 3 vértices');
      case CalcError.invalidPoint:
        return pick('Punto inválido: "$v"', 'Invalid point: "$v"', pt: 'Ponto inválido: "$v"');
      case CalcError.zeroPolynomialDivision:
        return pick('División entre el polinomio nulo',
            'Division by the zero polynomial', pt: 'Divisão pelo polinômio nulo');
      case CalcError.emptyExpression:
        return pick('Expresión vacía', 'Empty expression', pt: 'Expressão vazia');
      case CalcError.invalidTerm:
        return pick('Término inválido: "$v"', 'Invalid term: "$v"', pt: 'Termo inválido: "$v"');
      case CalcError.degreeAtLeastOne:
        return pick('Se requiere grado ≥ 1', 'Degree ≥ 1 is required', pt: 'É necessário grau ≥ 1');
      case CalcError.discriminantDegree:
        return pick('Discriminante disponible solo para grados 2 y 3',
            'Discriminant available only for degrees 2 and 3', pt: 'Discriminante disponível apenas para os graus 2 e 3');
      case CalcError.zeroPolynomialRoots:
        return pick('El polinomio nulo tiene infinitas raíces',
            'The zero polynomial has infinitely many roots', pt: 'O polinômio nulo tem infinitas raízes');
      case CalcError.notQuadratic:
        return pick('a = 0: no es una ecuación cuadrática',
            'a = 0: not a quadratic equation', pt: 'a = 0: não é uma equação quadrática');
      case CalcError.notCubic:
        return pick('a = 0: no es una ecuación cúbica',
            'a = 0: not a cubic equation', pt: 'a = 0: não é uma equação cúbica');
      case CalcError.modulusPositive:
        return pick('El módulo debe ser positivo',
            'The modulus must be positive', pt: 'O módulo deve ser positivo');
      case CalcError.nNonNegative:
        return pick('n debe ser ≥ 0', 'n must be ≥ 0', pt: 'n deve ser ≥ 0');
      case CalcError.nPositive:
        return pick('n debe ser ≥ 1', 'n must be ≥ 1', pt: 'n deve ser ≥ 1');
      case CalcError.positiveDRequired:
        return pick('D debe ser positivo', 'D must be positive', pt: 'D deve ser positivo');
      case CalcError.perfectSquareD:
        return pick('D no debe ser un cuadrado perfecto',
            'D must not be a perfect square', pt: 'D não deve ser um quadrado perfeito');
      case CalcError.needPositiveValue:
        // The rule is that EVERY value must be positive; the old wording said
        // "at least one", contradicting the check that actually runs.
        return pick('Todos los valores deben ser positivos',
            'All values must be positive', pt: 'Todos os valores devem ser positivos');
      case CalcError.nGreaterThanOne:
        return pick('n debe ser > 1', 'n must be > 1', pt: 'n deve ser > 1');
      case CalcError.needKInitialTerms:
        return pick('Se requieren $k términos iniciales',
            '$k initial terms are required', pt: 'São necessários $k termos iniciais');
      case CalcError.countNonNegative:
        return pick('La cantidad debe ser ≥ 0', 'count must be ≥ 0', pt: 'A quantidade deve ser ≥ 0');
      case CalcError.partsNonNegative:
        return pick('Las partes deben ser no negativas',
            'Parts must be non-negative', pt: 'As partes devem ser não negativas');
      case CalcError.invalidOperation:
        return pick('Operación no válida (use + - * /)',
            'Invalid operation (use + - * /)', pt: 'Operação inválida (use + - * /)');
      case CalcError.listsSameSize:
        return pick('Las listas deben tener el mismo tamaño y no estar vacías',
            'The lists must have the same size and be non-empty', pt: 'As listas devem ter o mesmo tamanho e não estar vazias');
      case CalcError.inputTooLarge:
        return pick('Entrada demasiado grande para este algoritmo (máx ${e.arg('max')})',
            'Input too large for this algorithm (max ${e.arg('max')})', pt: "Entrada grande demais para este algoritmo (máx ${e.arg('max')})");
      case CalcError.integerCoordinatesRequired:
        return pick('Se requieren coordenadas enteras',
            'Integer coordinates are required', pt: 'São necessárias coordenadas inteiras');
      case CalcError.collinearPoints:
        return pick('Los puntos son colineales: no forman un triángulo',
            'The points are collinear: they do not form a triangle', pt: 'Os pontos são colineares: não formam um triângulo');
      case CalcError.invalidSystem:
        return pick(
            'Sistema inválido: 2 o 3 filas "a,b,…,k" separadas por ";"',
            'Invalid system: 2 or 3 rows "a,b,…,k" separated by ";"', pt: 'Sistema inválido: 2 ou 3 linhas "a,b,…,k" separadas por ";"');
      case CalcError.primeRequired:
        return pick('p debe ser primo (${e.arg('value')} no lo es)',
            'p must be prime (${e.arg('value')} is not)', pt: "p deve ser primo (${e.arg('value')} não é)");
      case CalcError.moduliPositive:
        return pick('Los módulos deben ser positivos',
            'The moduli must be positive', pt: 'Os módulos devem ser positivos');
      case CalcError.invalidAngle:
        return pick('Cada ángulo debe estar entre 0° y 180° (exclusive)',
            'Each angle must be between 0° and 180° (exclusive)', pt: 'Cada ângulo deve estar entre 0° e 180° (exclusive)');
      case CalcError.angleSumTooLarge:
        return pick('Los dos ángulos suman 180° o más: no forman un triángulo',
            'The two angles add up to 180° or more: they cannot form a triangle', pt: 'Os dois ângulos somam 180° ou mais: não formam um triângulo');
      case CalcError.invalidExponent:
        return pick('El exponente debe ser un entero ≥ 0 (recibido: "$v")',
            'The exponent must be an integer ≥ 0 (got: "$v")', pt: 'O expoente deve ser um inteiro ≥ 0 (recebido: "$v")');
      case CalcError.unbalancedParentheses:
        return pick('Paréntesis desbalanceados', 'Unbalanced parentheses', pt: 'Parênteses desbalanceados');
      case CalcError.unexpectedToken:
        // The parser reports the end of the input as an empty token: there is
        // no symbol to quote, the expression simply stops too early ("2a +").
        return v.isEmpty
            ? pick('Expresión incompleta', 'Incomplete expression', pt: 'Expressão incompleta')
            : pick('Símbolo inesperado: "$v"', 'Unexpected symbol: "$v"', pt: 'Símbolo inesperado: "$v"');
      case CalcError.divisionNotExact:
        return pick(
            'Solo se puede dividir entre un número o un monomio que divida a '
            'todos los términos',
            'Division is only allowed by a number or by a monomial that '
            'divides every term', pt: 'Só é possível dividir por um número ou por um monômio que divida todos os termos');
      case CalcError.variableNotAssigned:
        return pick('Falta el valor de "$v"', 'Missing value for "$v"', pt: 'Falta o valor de "$v"');
      case CalcError.invalidAssignment:
        return pick('Asignación inválida: "$v" (use "a=1, b=2")',
            'Invalid assignment: "$v" (use "a=1, b=2")', pt: 'Atribuição inválida: "$v" (use "a=1, b=2")');
      case CalcError.expansionTooLarge:
        return pick(
            'El desarrollo tiene demasiados términos (máx ${e.arg('max')})',
            'The expansion has too many terms (max ${e.arg('max')})', pt: "O desenvolvimento tem termos demais (máx ${e.arg('max')})");
      case CalcError.computationTooLong:
        return pick('El cálculo es demasiado costoso: simplifica la expresión',
            'The computation is too expensive: simplify the expression', pt: 'O cálculo é custoso demais: simplifique a expressão');
      case CalcError.singleVariableOnly:
        return pick(
            'Esta herramienta solo admite polinomios en x (p. ej. x^2-5x+6). '
            'Para varias variables o paréntesis usa Álgebra → '
            'Expandir y simplificar',
            'This tool only takes polynomials in x (e.g. x^2-5x+6). For '
            'several variables or parentheses use Algebra → '
            'Expand and simplify', pt: 'Esta ferramenta só aceita polinômios em x (p. ex. x^2-5x+6). Para várias variáveis ou parênteses use Álgebra → Expandir e simplificar');
    }
  }
}
