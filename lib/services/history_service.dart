import 'package:shared_preferences/shared_preferences.dart';
import '../models/operation_entry.dart';

/// Servicio para gestionar el historial de operaciones
class HistoryService {
  static const String _historyKey = 'operation_history';
  static const int _maxHistorySize = 100;

  // In-memory fallback when SharedPreferences is unavailable (e.g., in tests)
  static bool _useMemoryStore = false;
  static final List<String> _memoryHistory = <String>[];

  /// Internal: Try to obtain SharedPreferences, else enable memory fallback
  static Future<SharedPreferences?> _getPrefsOrNull() async {
    if (_useMemoryStore) return null;
    try {
      return await SharedPreferences.getInstance();
    } catch (_) {
      // Plugin not available (tests or missing binding). Switch to memory store.
      _useMemoryStore = true;
      return null;
    }
  }

  /// Obtiene el historial de operaciones
  static Future<List<OperationEntry>> getHistory() async {
    final prefs = await _getPrefsOrNull();
    final historyStrings = prefs?.getStringList(_historyKey) ?? _memoryHistory;

    return historyStrings
        .map((str) => OperationEntry.fromStorageString(str))
        .toList()
        .reversed
        .toList(); // Mostrar los más recientes primero
  }

  /// Agrega una nueva operación al historial
  static Future<void> addOperation(OperationEntry operation) async {
    final prefs = await _getPrefsOrNull();
    final List<String> currentHistory = List<String>.from(
        prefs?.getStringList(_historyKey) ?? _memoryHistory);

    // Agregar la nueva operación al final
    currentHistory.add(operation.toStorageString());

    // Mantener solo las últimas operaciones
    if (currentHistory.length > _maxHistorySize) {
      currentHistory.removeRange(0, currentHistory.length - _maxHistorySize);
    }

    if (prefs != null) {
      await prefs.setStringList(_historyKey, currentHistory);
    } else {
      _memoryHistory
        ..clear()
        ..addAll(currentHistory);
    }
  }

  /// Limpia todo el historial
  static Future<void> clearHistory() async {
    final prefs = await _getPrefsOrNull();
    if (prefs != null) {
      await prefs.remove(_historyKey);
    } else {
      _memoryHistory.clear();
    }
  }

  /// Elimina una operación específica del historial
  static Future<void> removeOperation(OperationEntry operation) async {
    final prefs = await _getPrefsOrNull();
    final List<String> currentHistory = List<String>.from(
        prefs?.getStringList(_historyKey) ?? _memoryHistory);

    currentHistory.remove(operation.toStorageString());

    if (prefs != null) {
      await prefs.setStringList(_historyKey, currentHistory);
    } else {
      _memoryHistory
        ..clear()
        ..addAll(currentHistory);
    }
  }

  /// Obtiene el número de operaciones en el historial
  static Future<int> getHistoryCount() async {
    final prefs = await _getPrefsOrNull();
    final historyStrings = prefs?.getStringList(_historyKey) ?? _memoryHistory;
    return historyStrings.length;
  }
}
