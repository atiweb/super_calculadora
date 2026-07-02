import 'dart:convert';

/// Modelo para representar una entrada en el historial de operaciones
class OperationEntry {
  final String expression;
  final String result;
  final DateTime timestamp;

  /// `false` para entradas del formato de almacenamiento antiguo, que no
  /// guardaba la marca de tiempo: la UI muestra «—» en vez de fingir que la
  /// operación acaba de ocurrir.
  final bool timestampKnown;

  /// Cadena original de almacenamiento (si la entrada viene de disco). La
  /// devuelve [toStorageString] tal cual para que borrar una entrada antigua
  /// siga encontrando su línea exacta en el almacenamiento.
  final String? _rawStorage;

  OperationEntry({
    required this.expression,
    required this.result,
    DateTime? timestamp,
  })  : timestamp = timestamp ?? DateTime.now(),
        timestampKnown = true,
        _rawStorage = null;

  OperationEntry._stored({
    required this.expression,
    required this.result,
    required this.timestamp,
    required this.timestampKnown,
    required String rawStorage,
  }) : _rawStorage = rawStorage;

  /// Convierte a Map para serialización
  Map<String, dynamic> toMap() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  /// Crea desde Map para deserialización
  factory OperationEntry.fromMap(Map<String, dynamic> map) {
    return OperationEntry(
      expression: map['expression'] ?? '',
      result: map['result'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    );
  }

  /// Convierte a string para almacenamiento. Formato JSON con marca de tiempo
  /// (el formato antiguo `expresión=resultado` la perdía y cada reinicio
  /// mostraba todo como «Ahora»). Las entradas leídas de disco devuelven su
  /// cadena original para que la eliminación por coincidencia exacta funcione.
  String toStorageString() {
    if (_rawStorage != null) return _rawStorage;
    return jsonEncode({
      'e': expression,
      'r': result,
      't': timestamp.millisecondsSinceEpoch,
    });
  }

  /// Crea desde string de almacenamiento. Acepta el formato JSON actual y el
  /// antiguo `expresión=resultado` (sin marca de tiempo).
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
        );
      }
    } catch (_) {
      // No es JSON: formato antiguo
    }

    final parts = str.split('=');
    final String expression = parts.length >= 2 ? parts[0] : str;
    final String result = parts.length >= 2
        ? parts.sublist(1).join('=') // En caso de que el resultado tenga '='
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
    // La marca de tiempo forma parte de la identidad: sin ella, borrar una de
    // dos entradas repetidas eliminaba siempre la primera coincidencia.
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
