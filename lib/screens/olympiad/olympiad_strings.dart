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
  String pick(String spanish, String english, {String? pt, String? fr, String? it, String? ru, String? vi,
          String? id}) =>
      trLang(lang, spanish, english, pt: pt, fr: fr, it: it, ru: ru, vi: vi, id: id);

  /// The colon that follows a label. French typography puts a space before
  /// it ("Degré : 2"); every other language we ship writes it tight.
  /// Use it as '${s.pick(...)}${s.colon} $value'.
  String get colon => lang == 'fr' ? ' :' : ':';

  // Hub
  String get title => pick('Herramientas de Olimpiada', 'Olympiad Tools', pt: 'Ferramentas de Olimpíada', fr: "Outils d'Olympiades", ru: 'Олимпиадные инструменты', it: 'Strumenti per le Olimpiadi');
  String get subtitle => pick(
      'Herramientas exactas para entrenamiento', 'Exact tools for training', pt: 'Ferramentas exatas para treinamento', fr: "Outils exacts pour l'entraînement", ru: 'Точные инструменты для тренировки', it: "Strumenti esatti per l'allenamento");

  // Chrome
  String get compute => pick('Calcular', 'Compute', pt: 'Calcular', fr: 'Calculer', ru: 'Вычислить', it: 'Calcola');
  String get copy => pick('Copiar', 'Copy', pt: 'Copiar', fr: 'Copier', ru: 'Копировать', it: 'Copia');
  String get result => pick('Resultado', 'Result', pt: 'Resultado', fr: 'Résultat', ru: 'Результат', it: 'Risultato');
  String get errorPrefix => pick('Error', 'Error', pt: 'Erro', fr: 'Erreur', ru: 'Ошибка', it: 'Errore');

  // Categories
  String get catFractions => pick('Fracciones', 'Fractions', pt: 'Frações', fr: 'Fractions', ru: 'Дроби', it: 'Frazioni');
  String get catFractionsSub =>
      pick('Aritmética racional exacta', 'Exact rational arithmetic', pt: 'Aritmética racional exata', fr: 'Arithmétique rationnelle exacte', ru: 'Точная рациональная арифметика', it: 'Aritmetica razionale esatta');
  String get catSurds => pick('Radicales', 'Radicals', pt: 'Radicais', fr: 'Radicaux', ru: 'Радикалы', it: 'Radicali');
  String get catSurdsSub =>
      pick('Simplificar y racionalizar', 'Simplify and rationalize', pt: 'Simplificar e racionalizar', fr: 'Simplifier et rationaliser', ru: 'Упрощение и избавление от иррациональности', it: 'Semplificare e razionalizzare');
  String get catGeometry => pick('Geometría', 'Geometry', pt: 'Geometria', fr: 'Géométrie', ru: 'Геометрия', it: 'Geometria');
  String get catGeometrySub =>
      pick('Triángulos, áreas, ternas', 'Triangles, areas, triples', pt: 'Triângulos, áreas, ternos', fr: 'Triangles, aires, triplets', ru: 'Треугольники, площади, тройки', it: 'Triangoli, aree, terne');
  String get catPolynomials => pick('Polinomios', 'Polynomials', pt: 'Polinômios', fr: 'Polynômes', ru: 'Многочлены', it: 'Polinomi');
  String get catPolynomialsSub =>
      pick('Raíces, Vieta, discriminante', 'Roots, Vieta, discriminant', pt: 'Raízes, Vieta, discriminante', fr: 'Racines, Viète, discriminant', ru: 'Корни, Виет, дискриминант', it: 'Radici, Viète, discriminante');
  String get catAlgebra => pick('Álgebra', 'Algebra', pt: 'Álgebra', fr: 'Algèbre', ru: 'Алгебра', it: 'Algebra');
  String get catAlgebraSub => pick(
      'Expandir, identidades, factor común',
      'Expand, identities, common factor', pt: 'Expandir, identidades, fator comum', fr: 'Développer, identités, facteur commun', ru: 'Раскрытие скобок, тождества, общий множитель', it: 'Sviluppo, identità, fattore comune');
  String get catNumberTheory => pick('Teoría de Números', 'Number Theory', pt: 'Teoria dos Números', fr: 'Théorie des nombres', ru: 'Теория чисел', it: 'Teoria dei numeri');
  String get catNumberTheorySub =>
      pick('Congruencias, Pell, cuadrados', 'Congruences, Pell, squares', pt: 'Congruências, Pell, quadrados', fr: 'Congruences, Pell, carrés', ru: 'Сравнения, Пелль, квадраты', it: 'Congruenze, Pell, quadrati');
  String get catSteps => pick('Procedimientos', 'Step by step', pt: 'Procedimentos', fr: 'Procédures', ru: 'Пошаговые процедуры', it: 'Procedure');
  String get catStepsSub =>
      pick('Euclides, TCR, factorización', 'Euclid, CRT, factorization', pt: 'Euclides, TCR, fatoração', fr: 'Euclide, TRC, factorisation', ru: 'Евклид, КТО, разложение', it: 'Euclide, TCR, scomposizione');
  String get catComplexSeq => pick('Complejos y Sucesiones', 'Complex & Sequences', pt: 'Complexos e Sequências', fr: 'Complexes et suites', ru: 'Комплексные числа и последовательности', it: 'Complessi e successioni');
  String get catComplexSeqSub =>
      pick('Raíces de la unidad, recurrencias', 'Roots of unity, recurrences', pt: 'Raízes da unidade, recorrências', fr: "Racines de l'unité, récurrences", ru: 'Корни из единицы, рекуррентные соотношения', it: "Radici dell'unità, ricorrenze");
  String get catStatistics => pick('Estadística', 'Statistics', pt: 'Estatística', fr: 'Statistiques', ru: 'Статистика', it: 'Statistica');
  String get catStatisticsSub =>
      pick('Descriptiva exacta y desigualdad de medias',
          'Exact descriptive stats and mean inequality', pt: 'Descritiva exata e desigualdade das médias', fr: 'Statistiques exactes et inégalité des moyennes', ru: 'Точная описательная статистика и неравенство о средних', it: 'Statistica descrittiva esatta e disuguaglianza tra le medie');
  String get catMatrices => pick('Matrices', 'Matrices', pt: 'Matrizes', fr: 'Matrices', ru: 'Матрицы', it: 'Matrici');
  String get catMatricesSub =>
      pick('Determinante, inversa, sistemas (exacto)',
          'Determinant, inverse, systems (exact)', pt: 'Determinante, inversa, sistemas (exato)', fr: 'Déterminant, inverse, systèmes (exact)', ru: 'Определитель, обратная, системы (точно)', it: 'Determinante, inversa, sistemi (esatto)');
  String get catCalculus => pick('Cálculo', 'Calculus', pt: 'Cálculo', fr: 'Analyse', ru: 'Анализ', it: 'Analisi');
  String get catCalculusSub =>
      pick('Derivada, integral y límite numéricos',
          'Numerical derivative, integral and limit', pt: 'Derivada, integral e limite numéricos', fr: 'Dérivée, intégrale et limite numériques', ru: 'Численные производная, интеграл и предел', it: 'Derivata, integrale e limite numerici');

  // Quiz
  String get catQuiz => pick('Práctica', 'Practice', pt: 'Prática', fr: 'Entraînement', ru: 'Тренировка', it: 'Allenamento');
  String get catQuizSub =>
      pick('Problemas con verificación', 'Self-checking problems', pt: 'Problemas com verificação', fr: 'Problèmes avec correction', ru: 'Задачи с проверкой', it: 'Problemi con verifica');
  String get quizAnswer => pick('Tu respuesta', 'Your answer', pt: 'Sua resposta', fr: 'Votre réponse', ru: 'Ваш ответ', it: 'La tua risposta');
  String get quizCheck => pick('Comprobar', 'Check', pt: 'Verificar', fr: 'Vérifier', ru: 'Проверить', it: 'Verifica');
  String get quizNext => pick('Siguiente', 'Next', pt: 'Próximo', fr: 'Suivant', ru: 'Далее', it: 'Avanti');
  String get quizCorrect => pick('¡Correcto!', 'Correct!', pt: 'Correto!', fr: 'Correct !', ru: 'Верно!', it: 'Corretto!');
  String quizIncorrect(String answer) =>
      pick('Incorrecto. Respuesta: $answer', 'Incorrect. Answer: $answer', pt: 'Incorreto. Resposta: $answer', fr: 'Incorrect. Réponse : $answer', ru: 'Неверно. Ответ: $answer', it: 'Sbagliato. Risposta: $answer');
  String quizScore(int correct, int total) =>
      pick('Puntaje: $correct / $total', 'Score: $correct / $total', pt: 'Pontuação: $correct / $total', fr: 'Score : $correct / $total', ru: 'Счёт: $correct / $total', it: 'Punteggio: $correct / $total');

  /// Translates a [CalcException] into the active language.
  String errorText(CalcException e) {
    final v = e.arg('value');
    final k = e.arg('k');
    switch (e.code) {
      case CalcError.zeroDenominator:
        return pick('El denominador no puede ser cero',
            'Denominator cannot be zero', pt: 'O denominador não pode ser zero', fr: 'Le dénominateur ne peut pas être nul', ru: 'Знаменатель не может быть нулём', it: 'Il denominatore non può essere zero');
      case CalcError.divisionByZero:
        return pick('División por cero', 'Division by zero', pt: 'Divisão por zero', fr: 'Division par zéro', ru: 'Деление на ноль', it: 'Divisione per zero');
      case CalcError.reciprocalOfZero:
        return pick('El recíproco de 0 no está definido',
            'The reciprocal of 0 is undefined', pt: 'O recíproco de 0 não está definido', fr: "L'inverse de 0 n'est pas défini", ru: 'Число, обратное 0, не определено', it: 'Il reciproco di 0 non è definito');
      case CalcError.zeroToNegativePower:
        return pick('0 elevado a un exponente negativo',
            '0 raised to a negative power', pt: '0 elevado a um expoente negativo', fr: '0 élevé à un exposant négatif', ru: '0 в отрицательной степени', it: '0 elevato a un esponente negativo');
      case CalcError.invalidFraction:
        return pick('Fracción inválida: "$v"', 'Invalid fraction: "$v"', pt: 'Fração inválida: "$v"', fr: 'Fraction invalide : « $v »', ru: 'Неверная дробь: «$v»', it: 'Frazione non valida: «$v»');
      case CalcError.invalidNumber:
        return pick('Número inválido: "$v"', 'Invalid number: "$v"', pt: 'Número inválido: "$v"', fr: 'Nombre invalide : « $v »', ru: 'Неверное число: «$v»', it: 'Numero non valido: «$v»');
      case CalcError.invalidInteger:
        return pick('Entero inválido: "$v"', 'Invalid integer: "$v"', pt: 'Inteiro inválido: "$v"', fr: 'Entier invalide : « $v »', ru: 'Неверное целое число: «$v»', it: 'Intero non valido: «$v»');
      case CalcError.emptyInput:
        return pick('Entrada vacía', 'Empty input', pt: 'Entrada vazia', fr: 'Saisie vide', ru: 'Пустой ввод', it: 'Input vuoto');
      case CalcError.negativeRadicand:
        return pick('Radicando negativo: no es un número real',
            'Negative radicand: not a real number', pt: 'Radicando negativo: não é um número real', fr: "Radicande négatif : ce n'est pas un nombre réel", ru: 'Отрицательное подкоренное выражение: это не вещественное число', it: 'Radicando negativo: non è un numero reale');
      case CalcError.evenRootOfNegative:
        return pick('Raíz de índice par de un número negativo',
            'Even-index root of a negative number', pt: 'Raiz de índice par de um número negativo', fr: "Racine d'indice pair d'un nombre négatif", ru: 'Корень чётной степени из отрицательного числа', it: 'Radice di indice pari di un numero negativo');
      case CalcError.rootIndexTooSmall:
        return pick('El índice de la raíz debe ser ≥ 2',
            'The root index must be ≥ 2', pt: 'O índice da raiz deve ser ≥ 2', fr: "L'indice de la racine doit être ≥ 2", ru: 'Показатель корня должен быть ≥ 2', it: "L'indice della radice deve essere ≥ 2");
      case CalcError.divisionByRootZero:
        return pick('División por √0', 'Division by √0', pt: 'Divisão por √0', fr: 'Division par √0', ru: 'Деление на √0', it: 'Divisione per √0');
      case CalcError.binomialVanishes:
        return pick('Denominador nulo: c² = d (el binomio se anula)',
            'Null denominator: c² = d (the binomial vanishes)', pt: 'Denominador nulo: c² = d (o binômio se anula)', fr: "Dénominateur nul : c² = d (le binôme s'annule)", ru: 'Нулевой знаменатель: c² = d (двучлен обращается в ноль)', it: 'Denominatore nullo: c² = d (il binomio si annulla)');
      case CalcError.invalidTriangle:
        return pick('Los lados no forman un triángulo válido',
            'The sides do not form a valid triangle', pt: 'Os lados não formam um triângulo válido', fr: 'Les côtés ne forment pas un triangle valide', ru: 'Стороны не образуют треугольник', it: 'I lati non formano un triangolo valido');
      case CalcError.needAtLeast3Vertices:
        return pick('Se requieren al menos 3 vértices',
            'At least 3 vertices are required', pt: 'São necessários pelo menos 3 vértices', fr: 'Au moins 3 sommets sont requis', ru: 'Нужно не менее 3 вершин', it: 'Servono almeno 3 vertici');
      case CalcError.invalidPoint:
        return pick('Punto inválido: "$v"', 'Invalid point: "$v"', pt: 'Ponto inválido: "$v"', fr: 'Point invalide : « $v »', ru: 'Неверная точка: «$v»', it: 'Punto non valido: «$v»');
      case CalcError.zeroPolynomialDivision:
        return pick('División entre el polinomio nulo',
            'Division by the zero polynomial', pt: 'Divisão pelo polinômio nulo', fr: 'Division par le polynôme nul', ru: 'Деление на нулевой многочлен', it: 'Divisione per il polinomio nullo');
      case CalcError.emptyExpression:
        return pick('Expresión vacía', 'Empty expression', pt: 'Expressão vazia', fr: 'Expression vide', ru: 'Пустое выражение', it: 'Espressione vuota');
      case CalcError.invalidTerm:
        return pick('Término inválido: "$v"', 'Invalid term: "$v"', pt: 'Termo inválido: "$v"', fr: 'Terme invalide : « $v »', ru: 'Неверный член: «$v»', it: 'Termine non valido: «$v»');
      case CalcError.degreeAtLeastOne:
        return pick('Se requiere grado ≥ 1', 'Degree ≥ 1 is required', pt: 'É necessário grau ≥ 1', fr: 'Un degré ≥ 1 est requis', ru: 'Требуется степень ≥ 1', it: 'È richiesto un grado ≥ 1');
      case CalcError.discriminantDegree:
        return pick('Discriminante disponible solo para grados 2 y 3',
            'Discriminant available only for degrees 2 and 3', pt: 'Discriminante disponível apenas para os graus 2 e 3', fr: 'Discriminant disponible uniquement pour les degrés 2 et 3', ru: 'Дискриминант доступен только для степеней 2 и 3', it: 'Discriminante disponibile solo per i gradi 2 e 3');
      case CalcError.zeroPolynomialRoots:
        return pick('El polinomio nulo tiene infinitas raíces',
            'The zero polynomial has infinitely many roots', pt: 'O polinômio nulo tem infinitas raízes', fr: 'Le polynôme nul possède une infinité de racines', ru: 'У нулевого многочлена бесконечно много корней', it: 'Il polinomio nullo ha infinite radici');
      case CalcError.notQuadratic:
        return pick('a = 0: no es una ecuación cuadrática',
            'a = 0: not a quadratic equation', pt: 'a = 0: não é uma equação quadrática', fr: "a = 0 : ce n'est pas une équation du second degré", ru: 'a = 0: это не квадратное уравнение', it: "a = 0: non è un'equazione di secondo grado");
      case CalcError.notCubic:
        return pick('a = 0: no es una ecuación cúbica',
            'a = 0: not a cubic equation', pt: 'a = 0: não é uma equação cúbica', fr: "a = 0 : ce n'est pas une équation du troisième degré", ru: 'a = 0: это не кубическое уравнение', it: "a = 0: non è un'equazione di terzo grado");
      case CalcError.modulusPositive:
        return pick('El módulo debe ser positivo',
            'The modulus must be positive', pt: 'O módulo deve ser positivo', fr: 'Le module doit être positif', ru: 'Модуль должен быть положительным', it: 'Il modulo deve essere positivo');
      case CalcError.nNonNegative:
        return pick('n debe ser ≥ 0', 'n must be ≥ 0', pt: 'n deve ser ≥ 0', fr: 'n doit être ≥ 0', ru: 'n должно быть ≥ 0', it: 'n deve essere ≥ 0');
      case CalcError.nPositive:
        return pick('n debe ser ≥ 1', 'n must be ≥ 1', pt: 'n deve ser ≥ 1', fr: 'n doit être ≥ 1', ru: 'n должно быть ≥ 1', it: 'n deve essere ≥ 1');
      case CalcError.positiveDRequired:
        return pick('D debe ser positivo', 'D must be positive', pt: 'D deve ser positivo', fr: 'D doit être positif', ru: 'D должно быть положительным', it: 'D deve essere positivo');
      case CalcError.perfectSquareD:
        return pick('D no debe ser un cuadrado perfecto',
            'D must not be a perfect square', pt: 'D não deve ser um quadrado perfeito', fr: 'D ne doit pas être un carré parfait', ru: 'D не должно быть точным квадратом', it: 'D non deve essere un quadrato perfetto');
      case CalcError.needPositiveValue:
        // The rule is that EVERY value must be positive; the old wording said
        // "at least one", contradicting the check that actually runs.
        return pick('Todos los valores deben ser positivos',
            'All values must be positive', pt: 'Todos os valores devem ser positivos', fr: 'Toutes les valeurs doivent être positives', ru: 'Все значения должны быть положительными', it: 'Tutti i valori devono essere positivi');
      case CalcError.nGreaterThanOne:
        return pick('n debe ser > 1', 'n must be > 1', pt: 'n deve ser > 1', fr: 'n doit être > 1', ru: 'n должно быть > 1', it: 'n deve essere > 1');
      case CalcError.needKInitialTerms:
        return pick('Se requieren $k términos iniciales',
            '$k initial terms are required', pt: 'São necessários $k termos iniciais', fr: '$k termes initiaux sont requis', ru: 'Нужно $k начальных членов', it: 'Servono $k termini iniziali');
      case CalcError.countNonNegative:
        return pick('La cantidad debe ser ≥ 0', 'count must be ≥ 0', pt: 'A quantidade deve ser ≥ 0', fr: 'La quantité doit être ≥ 0', ru: 'Количество должно быть ≥ 0', it: 'La quantità deve essere ≥ 0');
      case CalcError.partsNonNegative:
        return pick('Las partes deben ser no negativas',
            'Parts must be non-negative', pt: 'As partes devem ser não negativas', fr: 'Les parts doivent être positives ou nulles', ru: 'Части должны быть неотрицательными', it: 'Le parti devono essere non negative');
      case CalcError.invalidOperation:
        return pick('Operación no válida (use + - * /)',
            'Invalid operation (use + - * /)', pt: 'Operação inválida (use + - * /)', fr: 'Opération invalide (utilisez + - * /)', ru: 'Недопустимая операция (используйте + - * /)', it: 'Operazione non valida (usa + - * /)');
      case CalcError.listsSameSize:
        return pick('Las listas deben tener el mismo tamaño y no estar vacías',
            'The lists must have the same size and be non-empty', pt: 'As listas devem ter o mesmo tamanho e não estar vazias', fr: 'Les listes doivent avoir la même taille et ne pas être vides', ru: 'Списки должны быть одинаковой длины и непустыми', it: 'Le liste devono avere la stessa dimensione e non essere vuote');
      case CalcError.inputTooLarge:
        return pick('Entrada demasiado grande para este algoritmo (máx ${e.arg('max')})',
            'Input too large for this algorithm (max ${e.arg('max')})', pt: "Entrada grande demais para este algoritmo (máx ${e.arg('max')})", fr: "Saisie trop grande pour cet algorithme (max ${e.arg('max')})", ru: "Слишком большой ввод для этого алгоритма (макс. ${e.arg('max')})", it: "Input troppo grande per questo algoritmo (max ${e.arg('max')})");
      case CalcError.integerCoordinatesRequired:
        return pick('Se requieren coordenadas enteras',
            'Integer coordinates are required', pt: 'São necessárias coordenadas inteiras', fr: 'Des coordonnées entières sont requises', ru: 'Нужны целочисленные координаты', it: 'Servono coordinate intere');
      case CalcError.collinearPoints:
        return pick('Los puntos son colineales: no forman un triángulo',
            'The points are collinear: they do not form a triangle', pt: 'Os pontos são colineares: não formam um triângulo', fr: 'Les points sont alignés : ils ne forment pas un triangle', ru: 'Точки лежат на одной прямой: треугольника не получается', it: 'I punti sono allineati: non formano un triangolo');
      case CalcError.invalidSystem:
        return pick(
            'Sistema inválido: 2 o 3 filas "a,b,…,k" separadas por ";"',
            'Invalid system: 2 or 3 rows "a,b,…,k" separated by ";"', pt: 'Sistema inválido: 2 ou 3 linhas "a,b,…,k" separadas por ";"', fr: 'Système invalide : 2 ou 3 lignes « a,b,…,k » séparées par « ; »', ru: 'Неверная система: 2 или 3 строки «a,b,…,k», разделённые «;»', it: 'Sistema non valido: 2 o 3 righe «a,b,…,k» separate da «;»');
      case CalcError.primeRequired:
        return pick('p debe ser primo (${e.arg('value')} no lo es)',
            'p must be prime (${e.arg('value')} is not)', pt: "p deve ser primo (${e.arg('value')} não é)", fr: "p doit être premier (${e.arg('value')} ne l'est pas)", ru: "p должно быть простым (${e.arg('value')} не является)", it: "p deve essere primo (${e.arg('value')} non lo è)");
      case CalcError.moduliPositive:
        return pick('Los módulos deben ser positivos',
            'The moduli must be positive', pt: 'Os módulos devem ser positivos', fr: 'Les modules doivent être positifs', ru: 'Модули должны быть положительными', it: 'I moduli devono essere positivi');
      case CalcError.invalidAngle:
        return pick('Cada ángulo debe estar entre 0° y 180° (exclusive)',
            'Each angle must be between 0° and 180° (exclusive)', pt: 'Cada ângulo deve estar entre 0° e 180° (exclusive)', fr: 'Chaque angle doit être compris entre 0° et 180° (exclus)', ru: 'Каждый угол должен быть строго между 0° и 180°', it: 'Ogni angolo deve essere compreso tra 0° e 180° (esclusi)');
      case CalcError.angleSumTooLarge:
        return pick('Los dos ángulos suman 180° o más: no forman un triángulo',
            'The two angles add up to 180° or more: they cannot form a triangle', pt: 'Os dois ângulos somam 180° ou mais: não formam um triângulo', fr: 'Les deux angles totalisent 180° ou plus : ils ne forment pas un triangle', ru: 'Сумма двух углов не меньше 180°: треугольника не получается', it: 'I due angoli sommano 180° o più: non formano un triangolo');
      case CalcError.invalidExponent:
        return pick('El exponente debe ser un entero ≥ 0 (recibido: "$v")',
            'The exponent must be an integer ≥ 0 (got: "$v")', pt: 'O expoente deve ser um inteiro ≥ 0 (recebido: "$v")', fr: "L'exposant doit être un entier ≥ 0 (reçu : « $v »)", ru: 'Показатель должен быть целым ≥ 0 (получено: «$v»)', it: "L'esponente deve essere un intero ≥ 0 (ricevuto: «$v»)");
      case CalcError.unbalancedParentheses:
        return pick('Paréntesis desbalanceados', 'Unbalanced parentheses', pt: 'Parênteses desbalanceados', fr: 'Parenthèses non équilibrées', ru: 'Несогласованные скобки', it: 'Parentesi non bilanciate');
      case CalcError.unexpectedToken:
        // The parser reports the end of the input as an empty token: there is
        // no symbol to quote, the expression simply stops too early ("2a +").
        return v.isEmpty
            ? pick('Expresión incompleta', 'Incomplete expression', pt: 'Expressão incompleta', fr: 'Expression incomplète', ru: 'Незавершённое выражение', it: 'Espressione incompleta')
            : pick('Símbolo inesperado: "$v"', 'Unexpected symbol: "$v"', pt: 'Símbolo inesperado: "$v"', fr: 'Symbole inattendu : « $v »', ru: 'Неожиданный символ: «$v»', it: 'Simbolo inatteso: «$v»');
      case CalcError.divisionNotExact:
        return pick(
            'Solo se puede dividir entre un número o un monomio que divida a '
            'todos los términos',
            'Division is only allowed by a number or by a monomial that '
            'divides every term', pt: 'Só é possível dividir por um número ou por um monômio que divida todos os termos', fr: 'On ne peut diviser que par un nombre ou par un monôme qui divise tous les termes', ru: 'Делить можно только на число или на одночлен, который делит все члены', it: 'Si può dividere solo per un numero o per un monomio che divide tutti i termini');
      case CalcError.variableNotAssigned:
        return pick('Falta el valor de "$v"', 'Missing value for "$v"', pt: 'Falta o valor de "$v"', fr: 'Valeur manquante pour « $v »', ru: 'Не задано значение «$v»', it: 'Manca il valore di «$v»');
      case CalcError.invalidAssignment:
        return pick('Asignación inválida: "$v" (use "a=1, b=2")',
            'Invalid assignment: "$v" (use "a=1, b=2")', pt: 'Atribuição inválida: "$v" (use "a=1, b=2")', fr: 'Affectation invalide : « $v » (utilisez « a=1, b=2 »)', ru: 'Неверное присваивание: «$v» (используйте «a=1, b=2»)', it: 'Assegnazione non valida: «$v» (usa «a=1, b=2»)');
      case CalcError.expansionTooLarge:
        return pick(
            'El desarrollo tiene demasiados términos (máx ${e.arg('max')})',
            'The expansion has too many terms (max ${e.arg('max')})', pt: "O desenvolvimento tem termos demais (máx ${e.arg('max')})", fr: "Le développement comporte trop de termes (max ${e.arg('max')})", ru: "В разложении слишком много членов (макс. ${e.arg('max')})", it: "Lo sviluppo ha troppi termini (max ${e.arg('max')})");
      case CalcError.computationTooLong:
        return pick('El cálculo es demasiado costoso: simplifica la expresión',
            'The computation is too expensive: simplify the expression', pt: 'O cálculo é custoso demais: simplifique a expressão', fr: "Le calcul est trop coûteux : simplifiez l'expression", ru: 'Вычисление слишком трудоёмкое: упростите выражение', it: "Il calcolo è troppo oneroso: semplifica l'espressione");
      case CalcError.singleVariableOnly:
        return pick(
            'Esta herramienta solo admite polinomios en x (p. ej. x^2-5x+6). '
            'Para varias variables o paréntesis usa Álgebra → '
            'Expandir y simplificar',
            'This tool only takes polynomials in x (e.g. x^2-5x+6). For '
            'several variables or parentheses use Algebra → '
            'Expand and simplify', pt: 'Esta ferramenta só aceita polinômios em x (p. ex. x^2-5x+6). Para várias variáveis ou parênteses use Álgebra → Expandir e simplificar', fr: "Cet outil n'accepte que les polynômes en x (p. ex. x^2-5x+6). Pour plusieurs variables ou des parenthèses, utilisez Algèbre → Développer et simplifier", ru: 'Этот инструмент принимает только многочлены от x (напр. x^2-5x+6). Для нескольких переменных или скобок используйте Алгебру → Раскрыть и упростить', it: 'Questo strumento accetta solo polinomi in x (p. es. x^2-5x+6). Per più variabili o parentesi usa Algebra → Sviluppa e semplifica');
    }
  }
}
