import '../models/calc_exception.dart';
import '../models/fraction.dart';
import '../models/multi_polynomial.dart';

/// Result of pulling the greatest common term out of a polynomial:
/// `2a²b + 4ab² = 2ab·(a + 2b)`.
class CommonFactor {
  /// Rational content (gcd of the numerators / lcm of the denominators),
  /// negative when the leading term is negative.
  final Fraction coefficient;

  /// Greatest monomial dividing every term.
  final Monomial monomial;

  /// What is left inside the parentheses.
  final MultiPolynomial cofactor;

  const CommonFactor(this.coefficient, this.monomial, this.cofactor);

  /// The extracted factor as a polynomial (`2ab`).
  MultiPolynomial get factor => MultiPolynomial.term(monomial, coefficient);

  /// Whether there was nothing to extract.
  bool get isTrivial => coefficient == Fraction.one && monomial.isOne;

  /// `2ab(a + 2b)`, or the plain polynomial when nothing can be factored out.
  @override
  String toString() {
    if (cofactor.isZero) return '0';
    // A single term is already a product; parentheses would only add noise.
    if (cofactor.termCount <= 1) return (factor * cofactor).toString();
    if (isTrivial) return cofactor.toString();

    final String head;
    if (!monomial.isOne) {
      head = factor.toString(); // 2ab, -2ab, (3/2)ab …
    } else if (coefficient == -Fraction.one) {
      head = '-';
    } else if (coefficient.isInteger) {
      head = coefficient.toString();
    } else {
      // Bare "1/6(3x + 2y)" would read as 1/(6(3x+2y)).
      head = '($coefficient)';
    }
    return '$head($cofactor)';
  }
}

/// A notable product, kept language-neutral: the UI prints `formula = value`.
class NotableProduct {
  /// Identity written with A and B, e.g. `(A+B)²`.
  final String formula;

  /// The identity expanded for the given A and B.
  final MultiPolynomial value;

  const NotableProduct(this.formula, this.value);
}

/// Symbolic algebra over polynomials in several variables.
///
/// The parser produces an already-expanded [MultiPolynomial], because that is
/// the normal form the tools need: expanding, comparing two expressions and
/// collecting like terms are then the same operation.
///
/// Accepted syntax:
///   * numbers: `3`, `2.5`, and quotients such as `3/4`;
///   * variables: a letter with an optional numeric subscript (`a`, `x`, `x1`);
///   * operators `+ − × ÷ ^` (also `·`, `*`, `**`), parentheses, and implicit
///     multiplication (`2ab`, `(a+b)(a−b)`, `3(x+1)`);
///   * exponents written with `^` or with Unicode superscripts (`(a+b+c)²`).
class AlgebraService {
  /// Guard against pathological input before tokenising it.
  static const int maxInputLength = 2000;

  /// Runs [body] inside a single expansion budget (see
  /// [MultiPolynomial.maxWork]). Nested calls share the outer budget, so the
  /// cost of one user-level computation is bounded as a whole.
  static T _bounded<T>(T Function() body) {
    final bool owned = MultiPolynomial.beginWork();
    try {
      return body();
    } finally {
      MultiPolynomial.endWork(owned);
    }
  }

  /// Parses and expands an expression: `(a+b+c)^2` → `a²+b²+c²+2ab+2ac+2bc`.
  static MultiPolynomial parse(String input) {
    if (input.trim().isEmpty) {
      throw CalcException(CalcError.emptyExpression);
    }
    if (input.length > maxInputLength) {
      throw CalcException(CalcError.inputTooLarge, {'max': '$maxInputLength'});
    }
    return _bounded(() {
      final _Parser parser = _Parser(_tokenize(input));
      final MultiPolynomial result = parser.parseExpression();
      parser.expectEnd();
      return result;
    });
  }

  /// Alias that reads better at the call site.
  static MultiPolynomial expand(String input) => parse(input);

  /// Whether two expressions denote the same polynomial (`(a+b)²` vs
  /// `a²+2ab+b²`). Both are expanded first, so this is an exact identity test.
  static bool areEquivalent(String left, String right) =>
      _bounded(() => parse(left) == parse(right));

  /// Difference of two expressions; zero exactly when they are identical.
  static MultiPolynomial difference(String left, String right) =>
      _bounded(() => parse(left) - parse(right));

  /// Substitution under a budget, for callers that hand in polynomials that
  /// were parsed earlier (each `parse` closed its own budget).
  static MultiPolynomial substitute(
          MultiPolynomial p, Map<String, MultiPolynomial> images) =>
      _bounded(() => p.substitute(images));

  /// Pulls out the greatest common term.
  static CommonFactor commonFactor(MultiPolynomial p) {
    if (p.isZero) {
      return CommonFactor(Fraction.one, Monomial.one, MultiPolynomial.zero);
    }
    // Rational content: gcd of the numerators over the lcm of the denominators
    // (so 1/2·x + 1/3·y factors as 1/6·(3x + 2y), with integer cofactors).
    BigInt num = BigInt.zero;
    BigInt den = BigInt.one;
    for (final c in p.terms.values) {
      num = _gcd(num, c.numerator);
      den = _lcm(den, c.denominator);
    }
    Fraction content = Fraction(num, den);
    // A leading minus is more readable outside the parentheses.
    if (p.terms[p.sortedMonomials.first]!.isNegative) content = -content;

    Monomial common = p.sortedMonomials.first;
    for (final m in p.terms.keys) {
      common = common.gcd(m);
    }

    final MultiPolynomial? cofactor = p.divideByTerm(common, content);
    // divideByTerm only fails on a non-divisor, and the content/gcd divide
    // every term by construction.
    return CommonFactor(content, common, cofactor!);
  }

  /// Whether the polynomial is unchanged by every permutation of its
  /// variables (`a²+b²+c²+ab+bc+ca` is). Adjacent transpositions generate the
  /// whole symmetric group, so checking those is enough.
  static bool isSymmetric(MultiPolynomial p) {
    final List<String> vars = p.variables;
    for (int i = 0; i + 1 < vars.length; i++) {
      final swap = {vars[i]: vars[i + 1], vars[i + 1]: vars[i]};
      if (p.rename(swap) != p) return false;
    }
    return true;
  }

  /// Parses `a=1, b=2/3, c=x+1` into variable → expression.
  ///
  /// The right-hand sides may be expressions, so a substitution can be
  /// numeric, symbolic, or a mix of both.
  static Map<String, MultiPolynomial> parseAssignments(String input) =>
      _bounded(() => _parseAssignments(input));

  static Map<String, MultiPolynomial> _parseAssignments(String input) {
    final Map<String, MultiPolynomial> result = {};
    for (final part in input.split(RegExp(r'[,;\n]'))) {
      final String piece = part.trim();
      if (piece.isEmpty) continue;
      final int eq = piece.indexOf('=');
      if (eq <= 0) {
        throw CalcException(CalcError.invalidAssignment, {'value': piece});
      }
      final String name = piece.substring(0, eq).trim();
      if (!RegExp(r'^[A-Za-z][0-9]*$').hasMatch(name)) {
        throw CalcException(CalcError.invalidAssignment, {'value': piece});
      }
      result[name] = parse(piece.substring(eq + 1));
    }
    if (result.isEmpty) {
      throw CalcException(CalcError.invalidAssignment, {'value': input.trim()});
    }
    return result;
  }

  /// Parses a single monomial (`a^2b`, `xy²`). Any numeric factor is dropped:
  /// what is asked for is the monomial, not the term.
  static Monomial parseMonomial(String input) {
    final MultiPolynomial m = parse(input);
    if (m.termCount != 1) {
      throw CalcException(CalcError.invalidTerm, {'value': input});
    }
    return m.terms.keys.first;
  }

  /// Coefficient of a monomial in the expansion: the coefficient of `a²b` in
  /// `(a+b+c)³` is 3.
  static Fraction coefficientOf(MultiPolynomial p, String monomial) =>
      p.coefficient(parseMonomial(monomial));

  /// The classic identities, expanded for the given A and B.
  static List<NotableProduct> notableProducts(
          MultiPolynomial a, MultiPolynomial b) =>
      _bounded(() => _notableProducts(a, b));

  static List<NotableProduct> _notableProducts(
      MultiPolynomial a, MultiPolynomial b) {
    final MultiPolynomial sum = a + b;
    final MultiPolynomial diff = a - b;
    return [
      NotableProduct('(A+B)²', sum.pow(2)),
      NotableProduct('(A−B)²', diff.pow(2)),
      NotableProduct('(A+B)(A−B)', sum * diff),
      NotableProduct('(A+B)³', sum.pow(3)),
      NotableProduct('(A−B)³', diff.pow(3)),
      NotableProduct('(A+B)(A²−AB+B²)', sum * (a.pow(2) - a * b + b.pow(2))),
      NotableProduct('(A−B)(A²+AB+B²)', diff * (a.pow(2) + a * b + b.pow(2))),
    ];
  }

  // ── Lexer ────────────────────────────────────────────────────────────────

  static const Map<String, String> _superscripts = {
    '⁰': '0', '¹': '1', '²': '2', '³': '3', '⁴': '4',
    '⁵': '5', '⁶': '6', '⁷': '7', '⁸': '8', '⁹': '9',
  };

  /// Characters that mean the same as an ASCII operator. Users paste `−`
  /// (U+2212) and `·` from textbooks and web pages all the time.
  static const Map<String, String> _aliases = {
    '−': '-', '–': '-', '—': '-',
    '·': '*', '×': '*', '⋅': '*', '∙': '*',
    '÷': '/',
    '[': '(', '{': '(', ']': ')', '}': ')',
  };

  static List<_Token> _tokenize(String input) {
    final List<_Token> tokens = [];
    int i = 0;
    while (i < input.length) {
      final String raw = input[i];

      if (raw.trim().isEmpty) {
        i++;
        continue;
      }

      // Unicode superscripts: a² is exactly a^2.
      if (_superscripts.containsKey(raw) || raw == '⁻') {
        final StringBuffer digits = StringBuffer();
        bool negative = false;
        while (i < input.length &&
            (_superscripts.containsKey(input[i]) || input[i] == '⁻')) {
          if (input[i] == '⁻') {
            negative = true;
          } else {
            digits.write(_superscripts[input[i]]);
          }
          i++;
        }
        if (digits.isEmpty) {
          throw CalcException(CalcError.unexpectedToken, {'value': raw});
        }
        tokens.add(const _Token(_T.caret, '^'));
        if (negative) tokens.add(const _Token(_T.minus, '-'));
        tokens.add(_Token(_T.number, digits.toString(),
            Fraction.parse(digits.toString())));
        continue;
      }

      final String c = _aliases[raw] ?? raw;

      if (_isDigit(c) || c == '.') {
        final int start = i;
        bool dot = false;
        while (i < input.length &&
            (_isDigit(input[i]) || (input[i] == '.' && !dot))) {
          if (input[i] == '.') dot = true;
          i++;
        }
        final String text = input.substring(start, i);
        tokens.add(_Token(_T.number, text, Fraction.parse(text)));
        continue;
      }

      if (_isLetter(c)) {
        // A variable is one letter plus an optional numeric subscript, so
        // `x1` is a variable while `2ab` stays an implicit product 2·a·b.
        final int start = i;
        i++;
        while (i < input.length && _isDigit(input[i])) {
          i++;
        }
        tokens.add(_Token(_T.variable, input.substring(start, i)));
        continue;
      }

      switch (c) {
        case '+':
          tokens.add(const _Token(_T.plus, '+'));
          i++;
        case '-':
          tokens.add(const _Token(_T.minus, '-'));
          i++;
        case '*':
          // `**` is the power operator in several calculators.
          if (i + 1 < input.length && input[i + 1] == '*') {
            tokens.add(const _Token(_T.caret, '^'));
            i += 2;
          } else {
            tokens.add(const _Token(_T.times, '*'));
            i++;
          }
        case '/':
          tokens.add(const _Token(_T.divide, '/'));
          i++;
        case '^':
          tokens.add(const _Token(_T.caret, '^'));
          i++;
        case '(':
          tokens.add(const _Token(_T.lparen, '('));
          i++;
        case ')':
          tokens.add(const _Token(_T.rparen, ')'));
          i++;
        default:
          throw CalcException(CalcError.unexpectedToken, {'value': raw});
      }
    }
    tokens.add(const _Token(_T.end, ''));
    return tokens;
  }

  static bool _isDigit(String c) {
    final int u = c.codeUnitAt(0);
    return u >= 0x30 && u <= 0x39;
  }

  static bool _isLetter(String c) {
    final int u = c.codeUnitAt(0);
    return (u >= 0x41 && u <= 0x5A) || (u >= 0x61 && u <= 0x7A);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static BigInt _gcd(BigInt a, BigInt b) {
    a = a.abs();
    b = b.abs();
    while (b != BigInt.zero) {
      final BigInt t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  static BigInt _lcm(BigInt a, BigInt b) =>
      (a * b).abs() ~/ _gcd(a, b);
}

// ── Parser ─────────────────────────────────────────────────────────────────

enum _T { number, variable, plus, minus, times, divide, caret, lparen, rparen, end }

class _Token {
  final _T type;
  final String text;
  final Fraction? value;

  const _Token(this.type, this.text, [this.value]);
}

/// Recursive-descent parser:
///
///   expression := term (('+' | '-') term)*
///   term       := factor (('*' | '/')? factor)*      // implicit product
///   factor     := ('+' | '-') factor | primary ('^' factor)?
///   primary    := number | variable | '(' expression ')'
///
/// Unary minus binds looser than `^` (so `-a^2` is −(a²)) and the exponent is
/// parsed as a whole factor, which makes `x^2y` mean (x²)·y as expected.
class _Parser {
  final List<_Token> tokens;
  int _pos = 0;

  _Parser(this.tokens);

  _Token get _current => tokens[_pos];

  MultiPolynomial parseExpression() {
    MultiPolynomial result = _parseTerm();
    while (_current.type == _T.plus || _current.type == _T.minus) {
      final bool add = _current.type == _T.plus;
      _pos++;
      final MultiPolynomial rhs = _parseTerm();
      result = add ? result + rhs : result - rhs;
    }
    return result;
  }

  void expectEnd() {
    if (_current.type != _T.end) {
      throw CalcException(
          CalcError.unexpectedToken, {'value': _current.text});
    }
  }

  MultiPolynomial _parseTerm() {
    MultiPolynomial result = _parseFactor();
    while (true) {
      if (_current.type == _T.times) {
        _pos++;
        result = result * _parseFactor();
      } else if (_current.type == _T.divide) {
        _pos++;
        result = _divide(result, _parseFactor());
      } else if (_startsFactor(_current.type)) {
        // Two number literals in a row are a typo, never an implicit product.
        // Without this, a malformed decimal splits into two numbers that get
        // multiplied together and yield a silently wrong answer: `2.5.3` was
        // read as 2.5·0.3, and a thousands separator turned `1.000.000` into
        // 1.000·0.000 = 0.
        if (_current.type == _T.number && tokens[_pos - 1].type == _T.number) {
          throw CalcException(
              CalcError.unexpectedToken, {'value': _current.text});
        }
        // Implicit multiplication. Signs are deliberately excluded: `a - b` is
        // a subtraction, never a product with a negative factor.
        result = result * _parseFactor();
      } else {
        break;
      }
    }
    return result;
  }

  static bool _startsFactor(_T type) =>
      type == _T.number || type == _T.variable || type == _T.lparen;

  MultiPolynomial _parseFactor() {
    if (_current.type == _T.minus) {
      _pos++;
      return -_parseFactor();
    }
    if (_current.type == _T.plus) {
      _pos++;
      return _parseFactor();
    }
    final MultiPolynomial base = _parsePrimary();
    if (_current.type == _T.caret) {
      _pos++;
      return base.pow(_asExponent(_parseFactor()));
    }
    return base;
  }

  MultiPolynomial _parsePrimary() {
    final _Token token = _current;
    switch (token.type) {
      case _T.number:
        _pos++;
        return MultiPolynomial.constant(token.value!);
      case _T.variable:
        _pos++;
        return MultiPolynomial.variable(token.text);
      case _T.lparen:
        _pos++;
        final MultiPolynomial inner = parseExpression();
        if (_current.type != _T.rparen) {
          throw CalcException(CalcError.unbalancedParentheses);
        }
        _pos++;
        return inner;
      case _T.rparen:
        throw CalcException(CalcError.unbalancedParentheses);
      default:
        throw CalcException(CalcError.unexpectedToken, {'value': token.text});
    }
  }

  /// An exponent has to be a plain non-negative integer.
  static int _asExponent(MultiPolynomial p) {
    if (!p.isConstant) {
      throw CalcException(CalcError.invalidExponent, {'value': p.toString()});
    }
    final Fraction value = p.constantValue;
    if (!value.isInteger || value.isNegative) {
      throw CalcException(CalcError.invalidExponent, {'value': value.toString()});
    }
    if (value.numerator > BigInt.from(MultiPolynomial.maxExponent)) {
      throw CalcException(
          CalcError.inputTooLarge, {'max': '${MultiPolynomial.maxExponent}'});
    }
    return value.numerator.toInt();
  }

  /// Division stays inside polynomial land only when the divisor is a single
  /// term that divides every term of the dividend.
  static MultiPolynomial _divide(MultiPolynomial a, MultiPolynomial b) {
    if (b.isZero) {
      throw CalcException(CalcError.divisionByZero);
    }
    if (b.termCount != 1) {
      throw CalcException(CalcError.divisionNotExact);
    }
    final Monomial divisor = b.terms.keys.first;
    final MultiPolynomial? result = a.divideByTerm(divisor, b.terms[divisor]!);
    if (result == null) {
      throw CalcException(CalcError.divisionNotExact);
    }
    return result;
  }
}
