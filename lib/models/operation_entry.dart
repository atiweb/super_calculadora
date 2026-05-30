/// Modelo para representar una entrada en el historial de operaciones
class OperationEntry {
  final String expression;
  final String result;
  final DateTime timestamp;

  OperationEntry({
    required this.expression,
    required this.result,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

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

  /// Convierte a string para almacenamiento simple
  String toStorageString() {
    return '$expression=$result';
  }

  /// Crea desde string de almacenamiento
  factory OperationEntry.fromStorageString(String str) {
    final parts = str.split('=');
    if (parts.length >= 2) {
      return OperationEntry(
        expression: parts[0],
        result: parts.sublist(1).join('='), // En caso de que el resultado tenga '='
      );
    }
    return OperationEntry(expression: str, result: '');
  }

  @override
  String toString() {
    return '$expression = $result';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OperationEntry &&
        other.expression == expression &&
        other.result == result;
  }

  @override
  int get hashCode => expression.hashCode ^ result.hashCode;
}
