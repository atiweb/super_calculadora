import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/services/prime_utils.dart';
import 'package:super_calculadora/services/number_analysis_service.dart';
import 'package:super_calculadora/services/special_functions_service.dart';

BigInt bi(int v) => BigInt.from(v);

/// Regression for two number-theory bugs:
///  1. `isProbablyPrime` used fixed Miller–Rabin bases {2,3,5,7}. 3215031751
///     (= 151·751·28351) is a strong pseudoprime to all of them → it was
///     reported as prime.
///  2. `SpecialFunctionsService.mod` returned a NEGATIVE residue when the
///     modulus was negative (mod(7,-3) → -2), against the intent of the
///     function itself (non-negative residue).
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
      expect(isProbablyPrime(BigInt.parse('67280421310721')), isTrue); // prime
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
    // Cases with a positive modulus keep the same behavior.
    test('mod(17, 5) = 2', () {
      expect(SpecialFunctionsService.mod(bi(17), bi(5)), bi(2));
    });
    test('mod(-8, 3) = 1', () {
      expect(SpecialFunctionsService.mod(bi(-8), bi(3)), bi(1));
    });
  });
}
