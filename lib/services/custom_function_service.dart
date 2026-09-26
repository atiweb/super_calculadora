import 'package:shared_preferences/shared_preferences.dart';
import '../models/custom_function.dart';

/// A problem with a custom-function definition or expansion. [code] is a
/// localization key (resolved by the editor dialog or error_localizer);
/// [arg] carries the offending name/signature when the message needs it.
class CustomFunctionException implements Exception {
  final String code;
  final String arg;
  const CustomFunctionException(this.code, [this.arg = '']);

  @override
  String toString() => arg.isEmpty ? code : '$code:$arg';
}

/// Storage and expansion of user-defined functions.
///
/// Definitions are expanded textually into the expression BEFORE the normal
/// preparation pass (√→sqrt, constants, implicit ×…), so a body goes through
/// exactly the same pipeline as hand-typed input and may itself call other
/// custom functions.
class CustomFunctionService {
  static const String _storageKey = 'custom_functions';

  /// Expansion depth cap. Legitimate nesting never gets close; a definition
  /// that references itself (directly or through a cycle) hits it fast,
  /// before the expanded text can grow combinatorially.
  static const int maxExpansionDepth = 40;

  /// Expanded-text cap. Depth alone doesn't bound size: h2(x)=h1(h1(x)),
  /// h3(x)=h2(h2(x))… doubles the text per level, and a handful of such
  /// definitions ran the UI thread out of memory while saving.
  static const int maxExpandedLength = 100000;

  /// Names the expression engine already understands (or rewrites during
  /// preparation, like `mod` and `e`); a custom function or parameter may
  /// not shadow them.
  static const Set<String> reservedNames = {
    'sin', 'cos', 'tan', 'asin', 'acos', 'atan',
    'arcsin', 'arccos', 'arctan',
    'log', 'ln', 'sqrt', 'abs', 'ceil', 'floor', 'exp', 'sgn',
    'e', 'pi', 'mod',
  };

  static final RegExp _identifier = RegExp(r'^[A-Za-z][A-Za-z0-9]*$');
  static final RegExp _wordChar = RegExp(r'[A-Za-z0-9_]');
  static final RegExp _letter = RegExp(r'[A-Za-z]');

  // ===========================================================================
  // Parsing and expansion (pure, no storage)
  // ===========================================================================

  /// Parses "name(a, b) = expression" into a [CustomFunction].
  /// Throws [CustomFunctionException] with an editor error code on bad input.
  static CustomFunction parseDefinition(String text) {
    final match = RegExp(r'^\s*([A-Za-z][A-Za-z0-9]*)\s*\(([^()]*)\)\s*=([\s\S]*)$')
        .firstMatch(text);
    if (match == null) {
      throw const CustomFunctionException('cfErrBadSignature');
    }
    final String name = match.group(1)!;
    final String paramsRaw = match.group(2)!.trim();
    final String body = match.group(3)!.trim();

    if (reservedNames.contains(name.toLowerCase())) {
      throw CustomFunctionException('cfErrReservedName', name);
    }

    final List<String> params = paramsRaw.isEmpty
        ? <String>[]
        : paramsRaw.split(',').map((p) => p.trim()).toList();
    for (final p in params) {
      if (!_identifier.hasMatch(p) ||
          reservedNames.contains(p.toLowerCase()) ||
          p == name) {
        throw CustomFunctionException('cfErrBadParam', p);
      }
    }
    if (params.toSet().length != params.length) {
      final seen = <String>{};
      final dup = params.firstWhere((p) => !seen.add(p));
      throw CustomFunctionException('cfErrDupParam', dup);
    }

    if (body.isEmpty) {
      throw const CustomFunctionException('cfErrEmptyBody');
    }
    if (body.contains('=')) {
      throw const CustomFunctionException('cfErrBadSignature');
    }

    return CustomFunction(name: name, params: params, body: body);
  }

  /// Replaces every call to a function in [fns] with its parenthesized body,
  /// arguments substituted. Recursive: arguments and bodies are expanded too.
  ///
  /// Throws [CustomFunctionException] `errCustomFnArgs` on an arity mismatch
  /// and `errCustomFnRecursion` when expansion exceeds [maxExpansionDepth]
  /// (a self-referencing or circular definition).
  static String expandCalls(String s, Map<String, CustomFunction> fns,
      [int depth = 0]) {
    if (fns.isEmpty) return s;
    if (depth > maxExpansionDepth) {
      throw const CustomFunctionException('errCustomFnRecursion');
    }
    final StringBuffer out = StringBuffer();
    int i = 0;
    while (i < s.length) {
      // An identifier only starts a call if not glued to the tail of another
      // identifier: the 'g' inside 'log(' must not match a function named 'g'.
      if (_letter.hasMatch(s[i]) && _startsIdentifier(s, i)) {
        int j = i;
        while (j < s.length && _wordChar.hasMatch(s[j])) {
          j++;
        }
        final String ident = s.substring(i, j);
        final CustomFunction? fn = fns[ident];
        int k = j;
        while (k < s.length && s[k] == ' ') {
          k++;
        }
        if (fn != null && k < s.length && s[k] == '(') {
          int parens = 1;
          int m = k + 1;
          while (m < s.length && parens > 0) {
            if (s[m] == '(') parens++;
            if (s[m] == ')') parens--;
            m++;
          }
          if (parens != 0) {
            // Unclosed call: same complaint the raw evaluator would make.
            throw const CustomFunctionException('errExprMalformed');
          }
          final List<String> rawArgs =
              _splitTopLevel(s.substring(k + 1, m - 1));
          final List<String> args =
              (fn.params.isEmpty && rawArgs.length == 1 && rawArgs[0].trim().isEmpty)
                  ? <String>[]
                  : rawArgs;
          if (args.length != fn.params.length ||
              args.any((a) => a.trim().isEmpty)) {
            throw CustomFunctionException('errCustomFnArgs', fn.signature);
          }
          String body = fn.body;
          for (int p = 0; p < fn.params.length; p++) {
            final String expanded = expandCalls(args[p].trim(), fns, depth + 1);
            body = _substituteParam(body, fn.params[p], '($expanded)');
            _checkLength(body.length);
          }
          out.write('(${expandCalls(body, fns, depth + 1)})');
          _checkLength(out.length);
          i = m;
          continue;
        }
        out.write(ident);
        i = j;
        continue;
      }
      out.write(s[i]);
      i++;
    }
    return out.toString();
  }

  static void _checkLength(int length) {
    if (length > maxExpandedLength) {
      throw const CustomFunctionException('errResultTooLarge');
    }
  }

  /// Whether the letter at [i] starts a fresh identifier.A preceding NUMBER
  /// does not glue: '2f(3)' is the implicit product 2*f(3), which
  /// _addImplicitMultiplication resolves once the call expands to '2(…)'.
  /// But in 'x2f(' the digit is itself the tail of the identifier 'x2f',
  /// so the 'f' there is not a call.
  static bool _startsIdentifier(String s, int i) {
    if (i == 0) return true;
    if (!_wordChar.hasMatch(s[i - 1])) return true;
    if (!_digitOrDot.hasMatch(s[i - 1])) return false;
    int j = i - 1;
    while (j >= 0 && _digitOrDot.hasMatch(s[j])) {
      j--;
    }
    return j < 0 || !_wordChar.hasMatch(s[j]);
  }

  static final RegExp _digitOrDot = RegExp(r'[0-9.]');

  /// Whether [body] contains a call to the function named [name].
  /// Used to protect saved functions from losing a definition they build on.
  ///
  /// Uses the same identifier rule as [expandCalls], so '2g(x)' counts as a
  /// call (it used to be missed, letting 'g' be deleted from under it).
  static bool referencesFunction(String body, String name) {
    int i = 0;
    while (i < body.length) {
      if (_letter.hasMatch(body[i]) && _startsIdentifier(body, i)) {
        int j = i;
        while (j < body.length && _wordChar.hasMatch(body[j])) {
          j++;
        }
        if (body.substring(i, j) == name) {
          int k = j;
          while (k < body.length && body[k] == ' ') {
            k++;
          }
          if (k < body.length && body[k] == '(') return true;
        }
        i = j;
      } else {
        i++;
      }
    }
    return false;
  }

  /// Splits an argument list on commas that are not nested inside parentheses.
  static List<String> _splitTopLevel(String s) {
    final List<String> parts = [];
    int depth = 0;
    int start = 0;
    for (int i = 0; i < s.length; i++) {
      final String c = s[i];
      if (c == '(') depth++;
      if (c == ')') depth--;
      if (c == ',' && depth == 0) {
        parts.add(s.substring(start, i));
        start = i + 1;
      }
    }
    parts.add(s.substring(start));
    return parts;
  }

  /// Replaces whole-identifier occurrences of [param] in [body]: the 'x'
  /// inside 'exp(' stays intact when the parameter is named 'x'. Uses the
  /// same rule as calls, so a leading number is a coefficient: in 2x the x
  /// is the parameter (2x used to be rejected as an unknown name "x").
  static String _substituteParam(String body, String param, String replacement) {
    final StringBuffer out = StringBuffer();
    int i = 0;
    while (i < body.length) {
      if (_letter.hasMatch(body[i]) && _startsIdentifier(body, i)) {
        int j = i;
        while (j < body.length && _wordChar.hasMatch(body[j])) {
          j++;
        }
        final String ident = body.substring(i, j);
        out.write(ident == param ? replacement : ident);
        i = j;
        continue;
      }
      out.write(body[i]);
      i++;
    }
    return out.toString();
  }

  // ===========================================================================
  // Persistence (same pattern as HistoryService: prefs with memory fallback)
  // ===========================================================================

  static bool _useMemoryStore = false;
  static final List<String> _memoryStore = <String>[];

  static Future<SharedPreferences?> _getPrefsOrNull() async {
    if (_useMemoryStore) return null;
    try {
      return await SharedPreferences.getInstance();
    } catch (_) {
      // Plugin not available (tests or missing binding). Switch to memory.
      _useMemoryStore = true;
      return null;
    }
  }

  /// All saved functions, in creation order.
  static Future<List<CustomFunction>> getAll() async {
    final prefs = await _getPrefsOrNull();
    final List<String> stored =
        prefs?.getStringList(_storageKey) ?? _memoryStore;
    final List<CustomFunction> result = [];
    for (final s in stored) {
      try {
        final CustomFunction fn = CustomFunction.fromStorageString(s);
        // Re-validate what was stored: an entry named like a builtin (sin)
        // would otherwise take the builtin over.
        result.add(parseDefinition(fn.definition));
      } catch (_) {
        // A corrupt entry should not take the whole list down with it.
      }
    }
    return result;
  }

  static Future<void> saveAll(List<CustomFunction> fns) async {
    final List<String> encoded =
        fns.map((f) => f.toStorageString()).toList();
    final prefs = await _getPrefsOrNull();
    if (prefs != null) {
      await prefs.setStringList(_storageKey, encoded);
    } else {
      _memoryStore
        ..clear()
        ..addAll(encoded);
    }
  }

  static Future<void> add(CustomFunction fn) async {
    final all = await getAll();
    all.add(fn);
    await saveAll(all);
  }

  /// Replaces the function previously named [oldName] with [fn] (the name
  /// itself may have changed), keeping its position in the list.
  static Future<void> update(String oldName, CustomFunction fn) async {
    final all = await getAll();
    final int idx = all.indexWhere((f) => f.name == oldName);
    if (idx >= 0) {
      all[idx] = fn;
    } else {
      all.add(fn);
    }
    await saveAll(all);
  }

  static Future<void> remove(String name) async {
    final all = await getAll();
    all.removeWhere((f) => f.name == name);
    await saveAll(all);
  }
}
