import 'dart:math' as math;
import '../models/calc_exception.dart';
import '../models/fraction.dart';

/// Estadística descriptiva exacta sobre listas de racionales.
///
/// Media, mediana y varianza se calculan como [Fraction] exactas; la
/// desviación estándar y la media geométrica (que involucran raíces) se
/// devuelven aproximadas en double.
class StatisticsService {
  /// Resumen descriptivo de la lista (no vacía).
  static ({
    int count,
    Fraction mean,
    Fraction median,
    List<Fraction> modes,
    Fraction variancePopulation,
    Fraction? varianceSample,
    double stdDevPopulation,
    Fraction min,
    Fraction max,
    Fraction range,
  }) descriptive(List<Fraction> data) {
    if (data.isEmpty) throw CalcException(CalcError.emptyInput);
    final int n = data.length;
    final sorted = List<Fraction>.of(data)..sort();

    Fraction sum = Fraction.zero;
    for (final x in data) {
      sum = sum + x;
    }
    final Fraction mean = sum / Fraction.fromInt(n);

    final Fraction median = n.isOdd
        ? sorted[n ~/ 2]
        : (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / Fraction.fromInt(2);

    // Moda(s): valores con frecuencia máxima > 1.
    final Map<Fraction, int> freq = {};
    for (final x in data) {
      freq[x] = (freq[x] ?? 0) + 1;
    }
    final int maxFreq = freq.values.reduce(math.max);
    final List<Fraction> modes = maxFreq <= 1
        ? const []
        : (freq.entries
            .where((e) => e.value == maxFreq)
            .map((e) => e.key)
            .toList()
          ..sort());

    Fraction sqSum = Fraction.zero;
    for (final x in data) {
      final d = x - mean;
      sqSum = sqSum + d * d;
    }
    final Fraction variancePop = sqSum / Fraction.fromInt(n);
    final Fraction? varianceSample =
        n > 1 ? sqSum / Fraction.fromInt(n - 1) : null;

    return (
      count: n,
      mean: mean,
      median: median,
      modes: modes,
      variancePopulation: variancePop,
      varianceSample: varianceSample,
      stdDevPopulation: math.sqrt(variancePop.toDouble()),
      min: sorted.first,
      max: sorted.last,
      range: sorted.last - sorted.first,
    );
  }

  /// Las cuatro medias clásicas de una lista de positivos, para verificar
  /// la cadena QM ≥ AM ≥ GM ≥ HM. AM y HM exactas; QM y GM aproximadas.
  static ({
    Fraction arithmetic,
    double geometric,
    Fraction harmonic,
    double quadratic,
  }) means(List<Fraction> data) {
    if (data.isEmpty) throw CalcException(CalcError.emptyInput);
    for (final x in data) {
      if (!x.isPositive) throw CalcException(CalcError.needPositiveValue);
    }
    final int n = data.length;
    final Fraction nf = Fraction.fromInt(n);

    Fraction sum = Fraction.zero;
    Fraction recipSum = Fraction.zero;
    Fraction sqSum = Fraction.zero;
    double logSum = 0;
    for (final x in data) {
      sum = sum + x;
      recipSum = recipSum + x.reciprocal();
      sqSum = sqSum + x * x;
      logSum += math.log(x.toDouble());
    }

    return (
      arithmetic: sum / nf,
      geometric: math.exp(logSum / n),
      harmonic: nf / recipSum,
      quadratic: math.sqrt((sqSum / nf).toDouble()),
    );
  }
}
