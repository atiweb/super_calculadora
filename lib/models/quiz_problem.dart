/// A practice problem with its canonical answer.
///
/// Answers are numeric (an integer) so that checking is
/// language-independent and tolerates spaces or leading zeros.
class QuizProblem {
  /// Short topic label (mathematical notation, language-neutral).
  final String topic;

  /// Statement shown to the student.
  final String prompt;

  /// Correct answer in canonical form.
  final String answer;

  const QuizProblem({
    required this.topic,
    required this.prompt,
    required this.answer,
  });

  /// Compares the user's input against the answer. Tries a numeric
  /// comparison (BigInt) and, if not applicable, compares normalized text.
  bool isCorrect(String input) {
    final a = input.trim();
    if (a.isEmpty) return false;
    final ua = BigInt.tryParse(a);
    final ca = BigInt.tryParse(answer);
    if (ua != null && ca != null) return ua == ca;
    return a.replaceAll(' ', '') == answer.replaceAll(' ', '');
  }
}
