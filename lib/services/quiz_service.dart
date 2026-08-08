import 'dart:math';
import '../utils/app_locale.dart';
import '../models/quiz_problem.dart';
import 'special_functions_service.dart';

/// Generates number theory and combinatorics practice problems, with
/// a known numeric answer. The randomness source is injectable so that
/// deterministic tests can be written.
class QuizService {
  /// Generates a random problem. [spanish] controls the language of the statement.
  static QuizProblem generate({Random? rng, String lang = 'en'}) {
    final r = rng ?? Random();
    final generators = <QuizProblem Function(Random, String)>[
      _phi,
      _gcd,
      _factorial,
      _combinations,
      _divisorCount,
      _digitSum,
      _mod,
      _fibonacci,
    ];
    return generators[r.nextInt(generators.length)](r, lang);
  }

  static String _t(String lang, String spanish, String english,
          {String? pt}) =>
      trLang(lang, spanish, english, pt: pt);

  static QuizProblem _phi(Random r, String lang) {
    final n = 2 + r.nextInt(59); // 2..60
    return QuizProblem(
      topic: 'φ(n)',
      prompt: _t(lang, 'Calcula φ($n) (función totiente de Euler)',
          'Compute φ($n) (Euler\'s totient)', pt: 'Calcule φ($n) (função totiente de Euler)'),
      answer: SpecialFunctionsService.eulerPhi(BigInt.from(n)).toString(),
    );
  }

  static QuizProblem _gcd(Random r, String lang) {
    final a = 2 + r.nextInt(98);
    final b = 2 + r.nextInt(98);
    return QuizProblem(
      topic: _t(lang, 'mcd', 'gcd', pt: 'mdc'),
      prompt: _t(lang, 'Calcula mcd($a, $b)', 'Compute gcd($a, $b)', pt: 'Calcule mdc($a, $b)'),
      answer:
          SpecialFunctionsService.gcd(BigInt.from(a), BigInt.from(b)).toString(),
    );
  }

  static QuizProblem _factorial(Random r, String lang) {
    final n = 2 + r.nextInt(7); // 2..8
    return QuizProblem(
      topic: 'n!',
      prompt: _t(lang, 'Calcula $n!', 'Compute $n!', pt: 'Calcule $n!'),
      answer: SpecialFunctionsService.factorial(n).toString(),
    );
  }

  static QuizProblem _combinations(Random r, String lang) {
    final n = 4 + r.nextInt(8); // 4..11
    final k = 1 + r.nextInt(n - 1);
    return QuizProblem(
      topic: 'C(n,k)',
      prompt: _t(lang, 'Calcula C($n, $k) (combinaciones)',
          'Compute C($n, $k) (combinations)', pt: 'Calcule C($n, $k) (combinações)'),
      answer: SpecialFunctionsService.combinations(n, k).toString(),
    );
  }

  static QuizProblem _divisorCount(Random r, String lang) {
    final n = 2 + r.nextInt(98);
    return QuizProblem(
      topic: 'σ₀(n)',
      prompt: _t(lang, '¿Cuántos divisores positivos tiene $n?',
          'How many positive divisors does $n have?', pt: 'Quantos divisores positivos $n tem?'),
      answer:
          SpecialFunctionsService.divisorCount(BigInt.from(n)).toString(),
    );
  }

  static QuizProblem _digitSum(Random r, String lang) {
    final n = 100 + r.nextInt(99900);
    int s = 0;
    for (final ch in n.toString().split('')) {
      s += int.parse(ch);
    }
    return QuizProblem(
      topic: _t(lang, 'Σ díg', 'Σ dig', pt: 'Σ díg'),
      prompt: _t(lang, 'Suma de los dígitos de $n', 'Digit sum of $n', pt: 'Soma dos dígitos de $n'),
      answer: s.toString(),
    );
  }

  static QuizProblem _mod(Random r, String lang) {
    final a = 10 + r.nextInt(990);
    final b = 2 + r.nextInt(48);
    return QuizProblem(
      topic: 'mod',
      prompt: _t(lang, 'Calcula $a mod $b', 'Compute $a mod $b', pt: 'Calcule $a mod $b'),
      answer: (a % b).toString(),
    );
  }

  static QuizProblem _fibonacci(Random r, String lang) {
    final n = 5 + r.nextInt(16); // 5..20
    return QuizProblem(
      topic: 'F(n)',
      prompt: _t(lang, 'Calcula el $n-ésimo número de Fibonacci F($n)',
          'Compute the $n-th Fibonacci number F($n)', pt: 'Calcule o $n-ésimo número de Fibonacci F($n)'),
      answer: SpecialFunctionsService.fibonacci(n).toString(),
    );
  }
}
