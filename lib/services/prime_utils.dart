import 'dart:isolate';

/// Punto de entrada para el isolate
void nextPrimeIsolate(Map<String, dynamic> message) {
  final SendPort sendPort = message['sendPort'];
  final BigInt start = message['start'];

  BigInt candidate = start + BigInt.one;
  while (!isProbablyPrime(candidate)) {
    candidate += BigInt.one;
  }

  sendPort.send(candidate.toString());
}

/// Las 12 primeras bases primas. Con este conjunto de testigos, el test de
/// Miller–Rabin es DETERMINISTA (sin falsos positivos) para todo n menor que
/// 3.317 × 10^24. Por encima de esa cota sigue siendo un test probabilístico
/// extraordinariamente fiable (prob. de error < 4^-12 por compuesto).
///
/// Nota: la versión anterior usaba solo {2,3,5,7}, con la cual 3215031751
/// (= 151·751·28351) —pseudoprimo fuerte a esas cuatro bases— se clasificaba
/// erróneamente como primo.
const List<int> _millerRabinBases = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37];

/// Test de primalidad de Miller–Rabin.
///
/// [k] se mantiene por compatibilidad de firma pero ya no limita el número de
/// testigos: siempre se usan las bases de [_millerRabinBases].
bool isProbablyPrime(BigInt n, {int k = 10}) {
  if (n < BigInt.two) return false;

  // Criba rápida por las bases primas: resuelve además el caso n == base.
  for (final p in _millerRabinBases) {
    final bp = BigInt.from(p);
    if (n == bp) return true;
    if (n % bp == BigInt.zero) return false;
  }
  // Aquí n > 37 y no es divisible por ninguna base, así que toda base < n-1.

  BigInt d = n - BigInt.one;
  int s = 0;
  while (d.isEven) {
    d ~/= BigInt.two;
    s += 1;
  }

  final BigInt nMinus1 = n - BigInt.one;
  for (final p in _millerRabinBases) {
    BigInt x = BigInt.from(p).modPow(d, n);
    if (x == BigInt.one || x == nMinus1) continue;

    bool probablePrime = false;
    for (int r = 1; r < s; r++) {
      x = x.modPow(BigInt.two, n);
      if (x == nMinus1) {
        probablePrime = true;
        break;
      }
    }
    if (!probablePrime) return false; // testigo de composición
  }

  return true;
}

/// Lanza el isolate y devuelve el siguiente primo
Future<String> findNextPrime(BigInt number) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(
    nextPrimeIsolate,
    {
      'sendPort': receivePort.sendPort,
      'start': number,
    },
  );

  return await receivePort.first;
}
