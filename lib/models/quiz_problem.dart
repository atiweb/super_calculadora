/// Un problema de práctica con su respuesta canónica.
///
/// Las respuestas son numéricas (un entero) para que la verificación sea
/// independiente del idioma y tolere espacios o ceros a la izquierda.
class QuizProblem {
  /// Etiqueta breve del tema (notación matemática, neutral al idioma).
  final String topic;

  /// Enunciado mostrado al estudiante.
  final String prompt;

  /// Respuesta correcta en forma canónica.
  final String answer;

  const QuizProblem({
    required this.topic,
    required this.prompt,
    required this.answer,
  });

  /// Compara la entrada del usuario con la respuesta. Intenta una comparación
  /// numérica (BigInt) y, si no aplica, compara texto normalizado.
  bool isCorrect(String input) {
    final a = input.trim();
    if (a.isEmpty) return false;
    final ua = BigInt.tryParse(a);
    final ca = BigInt.tryParse(answer);
    if (ua != null && ca != null) return ua == ca;
    return a.replaceAll(' ', '') == answer.replaceAll(' ', '');
  }
}
