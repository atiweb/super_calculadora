import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/number_analysis_service.dart';

/// Regresión: números perfectos grandes y potencias perfectas de muchos
/// dígitos. Antes:
///   - `isPerfectNumber` devolvía `false` para cualquier número de más de
///     10 dígitos (tope de rendimiento), clasificando mal el 7.º número
///     perfecto 137438691328.
///   - `_nthRoot` (usado por `isPerfectPower`) usaba una aproximación
///     logarítmica basada solo en el nº de dígitos para números de >100
///     dígitos, perdiendo potencias perfectas grandes reales (p. ej. 10^120).
void main() {
  group('isPerfectNumber', () {
    for (final p in [6, 28, 496, 8128, 33550336, 8589869056]) {
      test('$p es perfecto', () {
        expect(NumberAnalysisService.isPerfectNumber(BigInt.from(p)), isTrue);
      });
    }

    test('137438691328 (7.º número perfecto, 12 dígitos) es perfecto', () {
      expect(
        NumberAnalysisService.isPerfectNumber(BigInt.parse('137438691328')),
        isTrue,
      );
    });

    test('2305843008139952128 (8.º perfecto, 19 dígitos) es perfecto', () {
      expect(
        NumberAnalysisService.isPerfectNumber(
            BigInt.parse('2305843008139952128')),
        isTrue,
      );
    });

    test('no perfectos', () {
      for (final n in [
        '12',
        '100',
        '33550335',
        '137438691327',
        '1000000000000',
        '2305843008139952127',
      ]) {
        expect(NumberAnalysisService.isPerfectNumber(BigInt.parse(n)), isFalse,
            reason: '$n no debería ser perfecto');
      }
    });
  });

  group('isPerfectPower (números grandes)', () {
    test('10^120 es potencia perfecta', () {
      final n = BigInt.parse('1${'0' * 120}');
      final r = NumberAnalysisService.isPerfectPower(n);
      expect(r['isPower'], isTrue);
      expect((r['base'] as BigInt).pow(r['exponent'] as int), equals(n));
    });

    test('6^140 (109 dígitos) es potencia perfecta', () {
      final n = BigInt.from(6).pow(140);
      final r = NumberAnalysisService.isPerfectPower(n);
      expect(r['isPower'], isTrue);
      expect((r['base'] as BigInt).pow(r['exponent'] as int), equals(n));
    });

    test('10^120 + 1 no es potencia perfecta', () {
      final n = BigInt.parse('1${'0' * 120}') + BigInt.one;
      expect(NumberAnalysisService.isPerfectPower(n)['isPower'], isFalse);
    });
  });
}
