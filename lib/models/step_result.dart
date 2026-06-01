/// Resultado de un cálculo acompañado de los pasos legibles que lo producen.
///
/// Pensado para el modo didáctico: además del resultado final, se devuelve la
/// secuencia de pasos para que el estudiante siga el procedimiento.
class StepResult {
  final String result;
  final List<String> steps;

  const StepResult(this.result, this.steps);

  @override
  String toString() => '${steps.join('\n')}\n= $result';
}
