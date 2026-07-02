import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/prime_utils.dart';
import 'package:super_calculadora/services/number_analysis_service.dart';
import 'package:super_calculadora/services/special_functions_service.dart';

BigInt bi(int v) => BigInt.from(v);

/// Regresión de dos bugs de teoría de números:
///  1. `isProbablyPrime` usaba bases Miller–Rabin fijas {2,3,5,7}. 3215031751
///     (= 151·751·28351) es pseudoprimo fuerte a todas ellas → se reportaba
///     como primo.
///  2. `SpecialFunctionsService.mod` devolvía un residuo NEGATIVO cuando el
///     módulo era negativo (mod(7,-3) → -2), en contra de la intención de la
///     propia función (residuo no negativo).
void main() {
  group('isProbablyPrime — pseudoprimos fuertes', () {
    test('3215031751 (spsp a bases 2,3,5,7) es COMPUESTO', () {
      expect(isProbablyPrime(BigInt.parse('3215031751')), isFalse);
      expect(
          NumberAnalysisService.isPrime(BigInt.parse('3215031751')), isFalse);
    });

    test('2047 = 23·89 (spsp base 2) es compuesto', () {
      expect(isProbablyPrime(bi(2047)), isFalse);
    });

    test('primos verdaderos siguen siendo primos', () {
      for (final p in [2, 3, 5, 7, 41, 97, 7919, 104729, 1000003]) {
        expect(isProbablyPrime(bi(p)), isTrue, reason: '$p es primo');
      }
      expect(isProbablyPrime(BigInt.parse('2147483647')), isTrue); // 2^31−1
      expect(isProbablyPrime(BigInt.parse('67280421310721')), isTrue); // primo
    });

    test('compuestos comunes son compuestos', () {
      for (final c in [0, 1, 4, 9, 15, 21, 100]) {
        expect(isProbablyPrime(bi(c)), isFalse, reason: '$c es compuesto');
      }
    });
  });

  group('mod — módulo negativo normaliza a no negativo', () {
    test('mod(7, -3) = 1', () {
      expect(SpecialFunctionsService.mod(bi(7), bi(-3)), bi(1));
    });
    test('mod(-7, -3) = 2', () {
      expect(SpecialFunctionsService.mod(bi(-7), bi(-3)), bi(2));
    });
    // Casos con módulo positivo no cambian de comportamiento.
    test('mod(17, 5) = 2', () {
      expect(SpecialFunctionsService.mod(bi(17), bi(5)), bi(2));
    });
    test('mod(-8, 3) = 1', () {
      expect(SpecialFunctionsService.mod(bi(-8), bi(3)), bi(1));
    });
  });
}
