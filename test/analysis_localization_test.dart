import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/number_analysis_service.dart';
import 'package:super_calculadora/services/special_functions_service.dart';
import 'package:super_calculadora/utils/app_locale.dart';

String _errText(void Function() fn) {
  try {
    fn();
    return '';
  } catch (e) {
    return e.toString();
  }
}

/// Regression from a tester's feedback: Spanish texts were showing up inside
/// the English version. The analysis fallback messages (huge numbers)
/// are generated in the service layer (no BuildContext); they now follow the
/// language published by the UI via [appIsSpanish].
void main() {
  // 151 digits → forces the "número muy grande / extremadamente
  // grande" messages in binary/factors/divisors/roots/square/cube/primes.
  final huge = BigInt.parse('1${'0' * 150}');

  tearDown(() => appIsSpanish = false);

  test('Los textos de reserva están en inglés cuando appIsSpanish=false', () {
    appIsSpanish = false;
    final a = NumberAnalysisService.completeAnalysis(huge);
    final joined = a.values.map((v) => v.toString()).join(' | ');
    expect(joined.contains('Not computed'), isTrue, reason: joined);
    expect(joined.contains('No calculado'), isFalse, reason: joined);
    expect(joined.contains('Calculando'), isFalse, reason: joined);
  });

  test('Los textos de reserva están en español cuando appIsSpanish=true', () {
    appIsSpanish = true;
    final a = NumberAnalysisService.completeAnalysis(huge);
    final joined = a.values.map((v) => v.toString()).join(' | ');
    expect(joined.contains('No calculado'), isTrue, reason: joined);
    expect(joined.contains('Not computed'), isFalse, reason: joined);
  });

  test('Los mensajes de excepción de dominio se localizan', () {
    appIsSpanish = false;
    final en = _errText(() => SpecialFunctionsService.eulerPhi(BigInt.zero));
    expect(en.contains('only defined'), isTrue, reason: en);

    appIsSpanish = true;
    final es = _errText(() => SpecialFunctionsService.eulerPhi(BigInt.zero));
    expect(es.contains('solo está definido'), isTrue, reason: es);
  });
}
