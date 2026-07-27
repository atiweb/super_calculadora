import 'dart:isolate';

/// Entry point for the isolate
void nextPrimeIsolate(Map<String, dynamic> message) {
  final SendPort sendPort = message['sendPort'];
  final BigInt start = message['start'];

  BigInt candidate = start + BigInt.one;
  while (!isProbablyPrime(candidate)) {
    candidate += BigInt.one;
  }

  sendPort.send(candidate.toString());
}

/// The first 12 prime bases. With this set of witnesses, the Miller–Rabin
/// test is DETERMINISTIC (no false positives) for every n less than
/// 3.317 × 10^24. Above that bound it remains an extraordinarily reliable
/// probabilistic test (error prob. < 4^-12 per composite).
///
/// Note: the previous version used only {2,3,5,7}, with which 3215031751
/// (= 151·751·28351) —a strong pseudoprime to those four bases— was
/// wrongly classified as prime.
const List<int> _millerRabinBases = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37];

/// Miller–Rabin primality test.
///
/// [k] is kept for signature compatibility but no longer limits the number of
/// witnesses: the bases from [_millerRabinBases] are always used.
bool isProbablyPrime(BigInt n, {int k = 10}) {
  if (n < BigInt.two) return false;

  // Quick sieve by the prime bases: also handles the case n == base.
  for (final p in _millerRabinBases) {
    final bp = BigInt.from(p);
    if (n == bp) return true;
    if (n % bp == BigInt.zero) return false;
  }
  // Here n > 37 and not divisible by any base, so every base < n-1.

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
    if (!probablePrime) return false; // witness of compositeness
  }

  return true;
}

/// Spawns the isolate and returns the next prime
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
