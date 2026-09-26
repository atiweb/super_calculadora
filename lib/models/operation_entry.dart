import 'dart:convert';

/// Model representing an entry in the operation history
class OperationEntry {
  final String expression;
  final String result;
  final DateTime timestamp;

  /// For expressions that call user-defined functions: the same expression
  /// with every call expanded, i.e. what actually produced [result]. Lets
  /// the entry be reused faithfully after a function is edited or deleted.
  final String? expanded;

  /// `false` for entries from the old storage format, which did not
  /// save the timestamp: the UI shows «—» instead of pretending the
  /// operation just happened.
  final bool timestampKnown;

  /// Original storage string (if the entry comes from disk). It is
  /// returned as-is by [toStorageString] so that deleting an old entry
  /// still finds its exact line in storage.
  final String? _rawStorage;

  OperationEntry({
    required this.expression,
    required this.result,
    DateTime? timestamp,
    this.expanded,
  })  : timestamp = timestamp ?? DateTime.now(),
        timestampKnown = true,
        _rawStorage = null;

  OperationEntry._stored({
    required this.expression,
    required this.result,
    required this.timestamp,
    required this.timestampKnown,
    required String rawStorage,
    this.expanded,
  }) : _rawStorage = rawStorage;

  /// Converts to a Map for serialization
  Map<String, dynamic> toMap() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.millisecondsSinceEpoch,
      if (expanded != null) 'expanded': expanded,
    };
  }

  /// Creates from a Map for deserialization
  factory OperationEntry.fromMap(Map<String, dynamic> map) {
    return OperationEntry(
      expression: map['expression'] ?? '',
      result: map['result'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      expanded: map['expanded'] as String?,
    );
  }

  /// Converts to a string for storage. JSON format with a timestamp
  /// (the old `expression=result` format lost it and every restart
  /// showed everything as «Now»). Entries read from disk return their
  /// original string so that exact-match deletion works.
  String toStorageString() {
    if (_rawStorage != null) return _rawStorage;
    return jsonEncode({
      'e': expression,
      'r': result,
      't': timestamp.millisecondsSinceEpoch,
      if (expanded != null) 'x': expanded,
    });
  }

  /// Creates from a storage string. Accepts the current JSON format and the
  /// old `expression=result` one (no timestamp).
  factory OperationEntry.fromStorageString(String str) {
    try {
      final dynamic decoded = jsonDecode(str);
      if (decoded is Map<String, dynamic> &&
          decoded['e'] is String &&
          decoded['r'] is String) {
        final bool hasTime = decoded['t'] is int;
        return OperationEntry._stored(
          expression: decoded['e'] as String,
          result: decoded['r'] as String,
          timestamp: hasTime
              ? DateTime.fromMillisecondsSinceEpoch(decoded['t'] as int)
              : DateTime.fromMillisecondsSinceEpoch(0),
          timestampKnown: hasTime,
          rawStorage: str,
          expanded: decoded['x'] is String ? decoded['x'] as String : null,
        );
      }
    } catch (_) {
      // Not JSON: old format
    }

    final parts = str.split('=');
    final String expression = parts.length >= 2 ? parts[0] : str;
    final String result = parts.length >= 2
        ? parts.sublist(1).join('=') // In case the result contains '='
        : '';
    return OperationEntry._stored(
      expression: expression,
      result: result,
      timestamp: DateTime.fromMillisecondsSinceEpoch(0),
      timestampKnown: false,
      rawStorage: str,
    );
  }

  @override
  String toString() {
    return '$expression = $result';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    // The timestamp is part of the identity: without it, deleting one of
    // two duplicate entries always removed the first match.
    return other is OperationEntry &&
        other.expression == expression &&
        other.result == result &&
        other.timestampKnown == timestampKnown &&
        (!timestampKnown || other.timestamp == timestamp);
  }

  @override
  int get hashCode =>
      expression.hashCode ^
      result.hashCode ^
      (timestampKnown ? timestamp.hashCode : 0);
}
