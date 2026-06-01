import 'dart:math';
import '../models/quiz_problem.dart';
import 'special_functions_service.dart';

/// Genera problemas de práctica de teoría de números y combinatoria, con
/// respuesta numérica conocida. La fuente de aleatoriedad es inyectable para
/// poder escribir pruebas deterministas.
class QuizService {
  /// Genera un problema aleatorio. [spanish] controla el idioma del enunciado.
  static QuizProblem generate({Random? rng, bool spanish = false}) {
    final r = rng ?? Random();
    final generators = <QuizProblem Function(Random, bool)>[
      _phi,
      _gcd,
      _factorial,
      _combinations,
      _divisorCount,
      _digitSum,
      _mod,
      _fibonacci,
    ];
    return generators[r.nextInt(generators.length)](r, spanish);
  }

  static String _t(bool es, String spanish, String english) =>
      es ? spanish : english;

  static QuizProblem _phi(Random r, bool es) {
    final n = 2 + r.nextInt(59); // 2..60
    return QuizProblem(
      topic: 'φ(n)',
      prompt: _t(es, 'Calcula φ($n) (función totiente de Euler)',
          'Compute φ($n) (Euler\'s totient)'),
      answer: SpecialFunctionsService.eulerPhi(BigInt.from(n)).toString(),
    );
  }

  static QuizProblem _gcd(Random r, bool es) {
    final a = 2 + r.nextInt(98);
    final b = 2 + r.nextInt(98);
    return QuizProblem(
      topic: 'mcd',
      prompt: _t(es, 'Calcula mcd($a, $b)', 'Compute gcd($a, $b)'),
      answer:
          SpecialFunctionsService.gcd(BigInt.from(a), BigInt.from(b)).toString(),
    );
  }

  static QuizProblem _factorial(Random r, bool es) {
    final n = 2 + r.nextInt(7); // 2..8
    return QuizProblem(
      topic: 'n!',
      prompt: _t(es, 'Calcula $n!', 'Compute $n!'),
      answer: SpecialFunctionsService.factorial(n).toString(),
    );
  }

  static QuizProblem _combinations(Random r, bool es) {
    final n = 4 + r.nextInt(8); // 4..11
    final k = 1 + r.nextInt(n - 1);
    return QuizProblem(
      topic: 'C(n,k)',
      prompt: _t(es, 'Calcula C($n, $k) (combinaciones)',
          'Compute C($n, $k) (combinations)'),
      answer: SpecialFunctionsService.combinations(n, k).toString(),
    );
  }

  static QuizProblem _divisorCount(Random r, bool es) {
    final n = 2 + r.nextInt(98);
    return QuizProblem(
      topic: 'σ₀(n)',
      prompt: _t(es, '¿Cuántos divisores positivos tiene $n?',
          'How many positive divisors does $n have?'),
      answer:
          SpecialFunctionsService.divisorCount(BigInt.from(n)).toString(),
    );
  }

  static QuizProblem _digitSum(Random r, bool es) {
    final n = 100 + r.nextInt(99900);
    int s = 0;
    for (final ch in n.toString().split('')) {
      s += int.parse(ch);
    }
    return QuizProblem(
      topic: 'Σ díg',
      prompt: _t(es, 'Suma de los dígitos de $n', 'Digit sum of $n'),
      answer: s.toString(),
    );
  }

  static QuizProblem _mod(Random r, bool es) {
    final a = 10 + r.nextInt(990);
    final b = 2 + r.nextInt(48);
    return QuizProblem(
      topic: 'mod',
      prompt: _t(es, 'Calcula $a mod $b', 'Compute $a mod $b'),
      answer: (a % b).toString(),
    );
  }

  static QuizProblem _fibonacci(Random r, bool es) {
    final n = 5 + r.nextInt(16); // 5..20
    return QuizProblem(
      topic: 'F(n)',
      prompt: _t(es, 'Calcula el $n-ésimo número de Fibonacci F($n)',
          'Compute the $n-th Fibonacci number F($n)'),
      answer: SpecialFunctionsService.fibonacci(n).toString(),
    );
  }
}
