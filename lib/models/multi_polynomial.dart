import 'calc_exception.dart';
import 'fraction.dart';

/// Unicode superscript for an exponent (10 → "¹⁰").
String _sup(int n) {
  const map = {
    '0': '⁰', '1': '¹', '2': '²', '3': '³', '4': '⁴',
    '5': '⁵', '6': '⁶', '7': '⁷', '8': '⁸', '9': '⁹', '-': '⁻',
  };
  return n.toString().split('').map((d) => map[d] ?? d).join();
}

/// A monomial: a product of variables with non-negative integer exponents
/// (`a²bc³`), with no coefficient.
///
/// Canonical form: only strictly positive exponents are stored and the keys
/// are kept in alphabetical order, so two monomials that denote the same
/// product are always `==` and share a hash code. That is what lets a
/// polynomial use monomials as map keys and collect like terms for free.
class Monomial implements Comparable<Monomial> {
  /// Variable → exponent (all exponents > 0, keys sorted alphabetically).
  final Map<String, int> exponents;

  const Monomial._(this.exponents);

  factory Monomial(Map<String, int> exponents) {
    final List<String> names =
        exponents.keys.where((k) => exponents[k] != 0).toList()..sort();
    if (names.isEmpty) return one;
    final Map<String, int> canonical = {};
    for (final name in names) {
      final int e = exponents[name]!;
      if (e < 0) {
        throw CalcException(CalcError.invalidExponent, {'value': '$e'});
      }
      canonical[name] = e;
    }
    return Monomial._(Map.unmodifiable(canonical));
  }

  factory Monomial.variable(String name, [int exponent = 1]) =>
      Monomial({name: exponent});

  /// The empty product (1).
  static const Monomial one = Monomial._(<String, int>{});

  bool get isOne => exponents.isEmpty;

  /// Total degree (sum of the exponents).
  int get degree => exponents.values.fold(0, (a, b) => a + b);

  /// Exponent of [variable] (0 if it does not appear).
  int degreeIn(String variable) => exponents[variable] ?? 0;

  List<String> get variables => exponents.keys.toList();

  Monomial operator *(Monomial other) {
    final Map<String, int> result = Map.of(exponents);
    other.exponents.forEach((v, e) => result[v] = (result[v] ?? 0) + e);
    return Monomial(result);
  }

  /// Exact division, or null when [other] does not divide this monomial
  /// (which would need a negative exponent, i.e. leave polynomial land).
  Monomial? divide(Monomial other) {
    final Map<String, int> result = Map.of(exponents);
    for (final e in other.exponents.entries) {
      final int left = (result[e.key] ?? 0) - e.value;
      if (left < 0) return null;
      result[e.key] = left;
    }
    return Monomial(result);
  }

  /// Greatest common divisor: the minimum exponent of each shared variable.
  Monomial gcd(Monomial other) {
    final Map<String, int> result = {};
    for (final e in exponents.entries) {
      final int o = other.degreeIn(e.key);
      if (o > 0) result[e.key] = e.value < o ? e.value : o;
    }
    return Monomial(result);
  }

  /// Renames the variables (used to test symmetry under permutations).
  Monomial rename(Map<String, String> mapping) {
    final Map<String, int> result = {};
    exponents.forEach((v, e) {
      final String name = mapping[v] ?? v;
      result[name] = (result[name] ?? 0) + e;
    });
    return Monomial(result);
  }

  /// Graded lexicographic order for display: higher total degree first, then
  /// the higher exponent on the alphabetically earlier variable. This is the
  /// usual convention, so `(a+b)³` prints as `a³ + 3a²b + 3ab² + b³`.
  @override
  int compareTo(Monomial other) {
    final int byDegree = other.degree.compareTo(degree);
    if (byDegree != 0) return byDegree;
    final List<String> names =
        <String>{...exponents.keys, ...other.exponents.keys}.toList()..sort();
    for (final name in names) {
      final int byExponent = other.degreeIn(name).compareTo(degreeIn(name));
      if (byExponent != 0) return byExponent;
    }
    return 0;
  }

  @override
  String toString() {
    if (isOne) return '1';
    final sb = StringBuffer();
    exponents.forEach((v, e) {
      sb.write(v);
      if (e != 1) sb.write(_sup(e));
    });
    return sb.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Monomial || exponents.length != other.exponents.length) {
      return false;
    }
    for (final e in exponents.entries) {
      if (other.exponents[e.key] != e.value) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(
      [for (final e in exponents.entries) ...[e.key, e.value]]);
}

/// Polynomial in any number of variables with exact rational coefficients.
///
/// Stored as a map monomial → coefficient with no zero coefficients, which
/// keeps it permanently expanded and collected: building `(a+b+c)²` through
/// [operator *] already yields `a² + b² + c² + 2ab + 2ac + 2bc`.
class MultiPolynomial {
  /// Monomial → coefficient. Never contains a zero coefficient.
  final Map<Monomial, Fraction> terms;

  /// Ceiling on the number of terms of a result. An expansion such as
  /// `(a+b+c+d+e+f)^30` has millions of terms; refusing early keeps a typo
  /// from freezing the UI thread. The limit is also well past what anyone can
  /// read in a result box — `(a+b+c)^30` fits inside it four times over.
  static const int maxTerms = 2000;

  /// Ceiling on the monomial products a single multiplication may perform.
  /// Together with [maxTerms] this bounds an expansion to a fraction of a
  /// second, so the refusal is immediate rather than after a long freeze.
  static const int maxProducts = 100000;

  /// Ceiling for an exponent, mirroring the univariate parser's limit.
  static const int maxExponent = 1000;

  /// Ceiling on the monomial products a whole computation may perform.
  ///
  /// The two limits above bound one multiplication, but not a chain of them:
  /// `(a+b)^1000` stays under both (its result is a mere 1001 terms) and still
  /// took 3 s, and summing fifty of those took minutes — on the UI isolate,
  /// since `CalcTool` runs these synchronously. Everything `AlgebraService`
  /// exposes therefore runs inside one budget.
  static const int maxWork = 60000;

  /// Products left in the current budget; null when no budget is open.
  static int? _workLeft;

  /// Opens a budget if none is open. Returns whether this call owns it, which
  /// must be handed back to [endWork] in a `finally`. Nested calls share the
  /// outer budget instead of silently resetting it.
  static bool beginWork() {
    if (_workLeft != null) return false;
    _workLeft = maxWork;
    return true;
  }

  static void endWork(bool owned) {
    if (owned) _workLeft = null;
  }

  static void _spendWork(int units) {
    final int? left = _workLeft;
    if (left == null) return;
    if (units > left) {
      _workLeft = 0;
      throw CalcException(CalcError.computationTooLong);
    }
    _workLeft = left - units;
  }

  const MultiPolynomial._(this.terms);

  factory MultiPolynomial(Map<Monomial, Fraction> terms) {
    final Map<Monomial, Fraction> canonical = {};
    terms.forEach((m, c) {
      if (!c.isZero) canonical[m] = c;
    });
    return MultiPolynomial._(Map.unmodifiable(canonical));
  }

  factory MultiPolynomial.constant(Fraction value) =>
      value.isZero ? zero : MultiPolynomial._(Map.unmodifiable({Monomial.one: value}));

  factory MultiPolynomial.fromInt(int value) =>
      MultiPolynomial.constant(Fraction.fromInt(value));

  factory MultiPolynomial.variable(String name, [int exponent = 1]) =>
      MultiPolynomial.term(Monomial.variable(name, exponent), Fraction.one);

  factory MultiPolynomial.term(Monomial m, Fraction coefficient) =>
      coefficient.isZero
          ? zero
          : MultiPolynomial._(Map.unmodifiable({m: coefficient}));

  static const MultiPolynomial zero =
      MultiPolynomial._(<Monomial, Fraction>{});

  static final MultiPolynomial one = MultiPolynomial.fromInt(1);

  // ── Properties ───────────────────────────────────────────────────────────

  bool get isZero => terms.isEmpty;

  bool get isConstant => terms.isEmpty || (terms.length == 1 && terms.keys.first.isOne);

  /// Value of a constant polynomial (0 for the zero polynomial).
  Fraction get constantValue => terms[Monomial.one] ?? Fraction.zero;

  /// Total degree; the zero polynomial has degree −1, as in [Polynomial].
  int get degree =>
      isZero ? -1 : terms.keys.map((m) => m.degree).reduce((a, b) => a > b ? a : b);

  /// Degree in a single variable.
  int degreeIn(String variable) => isZero
      ? -1
      : terms.keys
          .map((m) => m.degreeIn(variable))
          .reduce((a, b) => a > b ? a : b);

  /// All variables that actually occur, in alphabetical order.
  List<String> get variables {
    final Set<String> names = {};
    for (final m in terms.keys) {
      names.addAll(m.exponents.keys);
    }
    return names.toList()..sort();
  }

  int get termCount => terms.length;

  /// Whether every term has the same total degree (`a²+ab+b²` is, `a²+a` is not).
  bool get isHomogeneous {
    if (terms.length <= 1) return true;
    final int d = terms.keys.first.degree;
    return terms.keys.every((m) => m.degree == d);
  }

  /// Coefficient of a monomial (zero when the term is absent).
  Fraction coefficient(Monomial m) => terms[m] ?? Fraction.zero;

  /// Monomials in display order (graded lexicographic).
  List<Monomial> get sortedMonomials => terms.keys.toList()..sort();

  // ── Arithmetic ───────────────────────────────────────────────────────────

  MultiPolynomial operator +(MultiPolynomial other) {
    final Map<Monomial, Fraction> result = Map.of(terms);
    other.terms.forEach((m, c) {
      final Fraction sum = (result[m] ?? Fraction.zero) + c;
      if (sum.isZero) {
        result.remove(m);
      } else {
        result[m] = sum;
      }
    });
    return MultiPolynomial._(Map.unmodifiable(result));
  }

  MultiPolynomial operator -(MultiPolynomial other) => this + (-other);

  MultiPolynomial operator -() => MultiPolynomial._(Map.unmodifiable(
      {for (final e in terms.entries) e.key: -e.value}));

  MultiPolynomial operator *(MultiPolynomial other) {
    if (isZero || other.isZero) return zero;
    final int products = terms.length * other.terms.length;
    if (products > maxProducts) {
      throw CalcException(CalcError.expansionTooLarge, {'max': '$maxTerms'});
    }
    _spendWork(products);
    final Map<Monomial, Fraction> result = {};
    for (final a in terms.entries) {
      for (final b in other.terms.entries) {
        final Monomial m = a.key * b.key;
        final Fraction c = (result[m] ?? Fraction.zero) + a.value * b.value;
        if (c.isZero) {
          result.remove(m);
        } else {
          result[m] = c;
        }
      }
      if (result.length > maxTerms) {
        throw CalcException(CalcError.expansionTooLarge, {'max': '$maxTerms'});
      }
    }
    return MultiPolynomial._(Map.unmodifiable(result));
  }

  MultiPolynomial scale(Fraction factor) => factor.isZero
      ? zero
      : MultiPolynomial._(Map.unmodifiable(
          {for (final e in terms.entries) e.key: e.value * factor}));

  /// Exact division by a single term (`c·m`).
  ///
  /// Returns null when some term is not divisible, which would require a
  /// negative exponent and therefore stop being a polynomial.
  MultiPolynomial? divideByTerm(Monomial divisor, Fraction coefficient) {
    if (coefficient.isZero) {
      throw CalcException(CalcError.divisionByZero);
    }
    final Map<Monomial, Fraction> result = {};
    for (final e in terms.entries) {
      final Monomial? m = e.key.divide(divisor);
      if (m == null) return null;
      result[m] = e.value / coefficient;
    }
    return MultiPolynomial._(Map.unmodifiable(result));
  }

  /// Non-negative integer power.
  MultiPolynomial pow(int exponent) {
    if (exponent < 0) {
      throw CalcException(CalcError.invalidExponent, {'value': '$exponent'});
    }
    if (exponent > maxExponent) {
      throw CalcException(CalcError.inputTooLarge, {'max': '$maxExponent'});
    }
    if (exponent == 0) return one;
    // Repeated multiplication rather than binary powering: each step is
    // guarded by [operator *], so an explosive expansion is refused after a
    // few cheap products instead of after one huge squaring.
    MultiPolynomial result = this;
    for (int i = 1; i < exponent; i++) {
      result = result * this;
    }
    return result;
  }

  /// Partial derivative with respect to [variable].
  MultiPolynomial derivative(String variable) {
    final Map<Monomial, Fraction> result = {};
    for (final e in terms.entries) {
      final int k = e.key.degreeIn(variable);
      if (k == 0) continue;
      final Map<String, int> exps = Map.of(e.key.exponents);
      if (k == 1) {
        exps.remove(variable);
      } else {
        exps[variable] = k - 1;
      }
      final Monomial m = Monomial(exps);
      final Fraction c =
          (result[m] ?? Fraction.zero) + e.value * Fraction.fromInt(k);
      if (c.isZero) {
        result.remove(m);
      } else {
        result[m] = c;
      }
    }
    return MultiPolynomial._(Map.unmodifiable(result));
  }

  // ── Evaluation and substitution ──────────────────────────────────────────

  /// Exact value once every variable has a rational value.
  Fraction evaluate(Map<String, Fraction> values) {
    Fraction total = Fraction.zero;
    for (final e in terms.entries) {
      Fraction term = e.value;
      for (final v in e.key.exponents.entries) {
        final Fraction? value = values[v.key];
        if (value == null) {
          throw CalcException(CalcError.variableNotAssigned, {'value': v.key});
        }
        term = term * value.pow(v.value);
      }
      total = total + term;
    }
    return total;
  }

  /// Simultaneous substitution: every variable is replaced by its image at
  /// once, so `{a: b, b: a}` swaps them instead of collapsing both to `a`.
  /// Variables missing from [images] are left alone.
  MultiPolynomial substitute(Map<String, MultiPolynomial> images) {
    MultiPolynomial total = zero;
    for (final e in terms.entries) {
      MultiPolynomial term = MultiPolynomial.constant(e.value);
      for (final v in e.key.exponents.entries) {
        final MultiPolynomial base =
            images[v.key] ?? MultiPolynomial.variable(v.key);
        term = term * base.pow(v.value);
      }
      total = total + term;
    }
    return total;
  }

  /// Renames variables (a permutation, for symmetry tests).
  MultiPolynomial rename(Map<String, String> mapping) {
    final Map<Monomial, Fraction> result = {};
    for (final e in terms.entries) {
      final Monomial m = e.key.rename(mapping);
      final Fraction c = (result[m] ?? Fraction.zero) + e.value;
      if (c.isZero) {
        result.remove(m);
      } else {
        result[m] = c;
      }
    }
    return MultiPolynomial._(Map.unmodifiable(result));
  }

  // ── Formatting ───────────────────────────────────────────────────────────

  /// Expanded form with Unicode superscripts: `a² + 2ab + b²`.
  @override
  String toString() {
    if (isZero) return '0';
    final sb = StringBuffer();
    bool first = true;
    for (final m in sortedMonomials) {
      final Fraction c = terms[m]!;
      if (first) {
        if (c.isNegative) sb.write('-');
      } else {
        sb.write(c.isNegative ? ' - ' : ' + ');
      }
      sb.write(_termBody(c.abs(), m));
      first = false;
    }
    return sb.toString();
  }

  /// One term without its sign. A non-integer coefficient is parenthesised so
  /// that `(3/2)ab` cannot be misread as `3/(2ab)` — and so that the printed
  /// result parses back into the same polynomial.
  static String _termBody(Fraction magnitude, Monomial m) {
    if (m.isOne) return magnitude.toString();
    if (magnitude == Fraction.one) return m.toString();
    if (magnitude.isInteger) return '$magnitude$m';
    return '($magnitude)$m';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MultiPolynomial || terms.length != other.terms.length) {
      return false;
    }
    for (final e in terms.entries) {
      if (other.terms[e.key] != e.value) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAllUnordered(
      [for (final e in terms.entries) Object.hash(e.key, e.value)]);
}
