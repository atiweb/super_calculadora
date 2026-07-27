/// Result of a computation along with the readable steps that produce it.
///
/// Intended for the didactic mode: besides the final result, the sequence
/// of steps is returned so the student can follow the procedure.
class StepResult {
  final String result;
  final List<String> steps;

  const StepResult(this.result, this.steps);

  @override
  String toString() => '${steps.join('\n')}\n= $result';
}
