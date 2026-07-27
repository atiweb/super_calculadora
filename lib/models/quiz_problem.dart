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
    final ua = BigInt.tryParse(_dropTrailingZeroDecimals(a));
    final ca = BigInt.tryParse(answer);
    if (ua != null && ca != null) return ua == ca;
    return a.replaceAll(' ', '') == answer.replaceAll(' ', '');
  }

  /// Strips a purely decorative decimal part ("6.0", "6,00" → "6").
  ///
  /// The answer field uses a numeric keyboard that offers a decimal point, so
  /// typing the right value as "6.0" was being marked wrong.
  static String _dropTrailingZeroDecimals(String s) {
    final m = RegExp(r'^([+-]?\d+)[.,]0+$').firstMatch(s);
    return m != null ? m.group(1)! : s;
  }
}
