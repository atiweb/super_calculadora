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

/// Algoritmo probabilístico de Miller-Rabin simple (base fija)
bool isProbablyPrime(BigInt n, {int k = 10}) {
  if (n < BigInt.from(2)) return false;
  if (n == BigInt.two || n == BigInt.from(3)) return true;
  if (n.isEven) return false;

  BigInt d = n - BigInt.one;
  int s = 0;
  while (d.isEven) {
    d ~/= BigInt.two;
    s += 1;
  }

  final bases = [BigInt.from(2), BigInt.from(3), BigInt.from(5), BigInt.from(7)];

  for (var a in bases) {
    if (a >= n - BigInt.one) break;
    var x = a.modPow(d, n);
    if (x == BigInt.one || x == n - BigInt.one) continue;

    bool continueOuter = false;
    for (int r = 1; r < s; r++) {
      x = x.modPow(BigInt.two, n);
      if (x == n - BigInt.one) {
        continueOuter = true;
        break;
      }
    }
    if (continueOuter) continue;

    return false;
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
