import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;
import 'big_decimal.dart';
import 'number_analysis_service.dart';
import '../constants/numeric_precision.dart';
import 'settings_service.dart';
import 'history_service.dart';
import 'precision_service.dart';
import 'special_functions_service.dart';
import '../models/calculator_config.dart';
import '../models/operation_entry.dart';
import '../models/pending_operation.dart';
import '../utils/app_locale.dart';

/// Servicio principal de la calculadora
class CalculatorService extends ChangeNotifier {
  String _display = '0';
  String _lastResult = '';
  Map<String, dynamic> _currentAnalysis = {};
  bool _hasError = false;
  String _errorMessage = '';
  Map<String, String> _errorArgs = {};
  bool _isCalculatingPrimes = false;
  // Token de generación del análisis: los análisis en isolate pueden terminar
  // fuera de orden y pisar el análisis del número actual con uno viejo.
  int _analysisToken = 0;
  bool _isCalculatingOperation = false;
  String _operationProgress = '';
  bool _canCancelOperation = false;
  CalculatorType _calculatorType = CalculatorType.standard;
  bool _isRadianMode = false; // false = degrees, true = radians
  
  // Nuevas propiedades para expresiones completas e historial
  final TextEditingController _expressionController = TextEditingController();
  List<OperationEntry> _history = [];
  bool _isHistoryVisible = false;
  
  // Variables de memoria para las funciones MC, MR, M+, M-, MS
  BigDecimal _memoryValue = BigDecimal.zero;
  bool _hasMemoryValue = false;

  // Sistema genérico de operación pendiente para N parámetros
  PendingOperation? _pending;
  
  // Getters existentes
  String get display => _display;
  // Hacer que 'expression' refleje lo que ve el usuario en pantalla
  // para mantener compatibilidad con tests que inspeccionan esta propiedad.
  String get expression => _display;
  String get lastResult => _lastResult;
  Map<String, dynamic> get currentAnalysis => _currentAnalysis;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  Map<String, String> get errorArgs => _errorArgs;
  bool get isCalculatingPrimes => _isCalculatingPrimes;
  bool get isCalculatingOperation => _isCalculatingOperation;
  String get operationProgress => _operationProgress;
  bool get canCancelOperation => _canCancelOperation;
  CalculatorType get calculatorType => _calculatorType;
  bool get isRadianMode => _isRadianMode;
  String get angleMode => _isRadianMode ? 'RAD' : 'DEG';
  
  // Nuevos getters para expresiones e historial
  TextEditingController get expressionController => _expressionController;
  List<OperationEntry> get history => _history;
  bool get isHistoryVisible => _isHistoryVisible;
  
  // Getters para memoria
  bool get hasMemoryValue => _hasMemoryValue;
  String get memoryValueDisplay => _hasMemoryValue ? _memoryValue.toString() : '0';

  // Getters para operación pendiente
  bool get hasPendingOperation => _pending != null;
  String get pendingDisplayLabel => _pending?.buildDisplayLabel() ?? '';
  PendingOperation? get pendingOperation => _pending;
  
  /// Obtiene la última operación realizada
  OperationEntry? get lastOperation => _history.isNotEmpty ? _history.first : null;
  
  // Constructor
  CalculatorService() {
    _loadHistory();
    // La UI (botones de la pestaña de expresiones) deriva su estado habilitado
    // del texto del controlador; al teclear directamente en el TextField nadie
    // notificaba y los botones quedaban con estado obsoleto.
    _expressionController.addListener(notifyListeners);
  }

  /// Cambia el tipo de calculadora
  void setCalculatorType(CalculatorType type) {
    _calculatorType = type;
    CalculatorConfig.setCalculatorType(type);
    notifyListeners();
  }

  /// Alterna entre grados y radianes
  void toggleAngleMode() {
    _isRadianMode = !_isRadianMode;
    notifyListeners();
  }

  /// Limpia todo
  void clear() {
    _display = '0';
    _lastResult = '';
    _analysisToken++; // descartar análisis en curso
    _currentAnalysis = {};
    _hasError = false;
    _errorMessage = '';
    _errorArgs = {};
    _isCalculatingPrimes = false;
    _isCalculatingOperation = false;
    _operationProgress = '';
    _canCancelOperation = false;
    _pending = null;
    notifyListeners();
  }

  /// Limpia solo el display
  void clearEntry() {
    _display = '0';
    _hasError = false;
    _errorMessage = '';
    _errorArgs = {};
    _isCalculatingPrimes = false;
    _isCalculatingOperation = false;
    _operationProgress = '';
    _canCancelOperation = false;
    // El display volvió a '0': limpiar también el análisis para que el panel
    // no quede mostrando el número anterior.
    _updateAnalysis();
    notifyListeners();
  }

  /// Obtiene el número actual en el display (el último número sin operadores)
  String _getCurrentNumber() {
    if (_display.isEmpty || _display == '0') {
      return '0';
    }

    // Buscar el último número en la expresión
    RegExp numberRegex = RegExp(r'(-?\d*\.?\d+)$');
    Match? match = numberRegex.firstMatch(_display);

    if (match != null) {
      return match.group(0)!;
    }

    return '0';
  }

  /// Parsea el número actual como BigInt, truncando la parte decimal si la hay.
  /// Esto permite que funciones de teoría de números se usen tras cálculos decimales.
  BigInt _getCurrentAsBigInt() {
    return _parseStringAsBigInt(_getCurrentNumber());
  }

  /// Parsea un string como BigInt, truncando decimales si los hay.
  static BigInt _parseStringAsBigInt(String numStr) {
    numStr = numStr.trim();
    if (numStr.contains('.')) {
      final parts = numStr.split('.');
      String intPart = parts[0].isEmpty ? '0' : parts[0];
      if (intPart == '-') intPart = '0';
      return BigInt.parse(intPart);
    }
    return BigInt.parse(numStr.isEmpty ? '0' : numStr);
  }

  /// Parsea un string como int, truncando decimales si los hay.
  /// Lanza si el valor no cabe en un int: `BigInt.toInt()` envuelve en 64 bits
  /// y convertiría 2⁶⁴+2 en 2 sin ningún error.
  static int _parseStringAsInt(String numStr) {
    final BigInt value = _parseStringAsBigInt(numStr);
    if (!value.isValidInt) {
      throw ArgumentError(trLocale('Número demasiado grande', 'Number too large'));
    }
    return value.toInt();
  }

  /// Número actual del display como int, con la misma validación de rango.
  int _getCurrentAsInt() => _parseStringAsInt(_getCurrentNumber());

  /// Verifica si el display termina en un operador
  bool _endsWithOperator() {
    if (_display.isEmpty) return false;
    String trimmed = _display.trim();
    return trimmed.endsWith('+') || trimmed.endsWith('-') || 
           trimmed.endsWith('×') || trimmed.endsWith('÷') || 
           trimmed.endsWith('^') || trimmed.endsWith('(');
  }

  /// Verifica si el display termina en un número
  bool _endsWithNumber() {
    if (_display.isEmpty) return false;
    String trimmed = _display.trim();
    return RegExp(r'[\d.]$').hasMatch(trimmed);
  }

  /// Agrega un dígito al display
  void addDigit(String digit) {
    if (_hasError) {
      clear();
    }
    
    // Si el display es '0' y no es punto decimal, reemplazar
    if (_display == '0' && digit != '.') {
      _display = digit;
    } else if (digit == '.' && _display.contains('.')) {
      // Verificar si ya hay un punto decimal en el número actual
      String currentNumber = _getCurrentNumber();
      if (currentNumber.contains('.')) {
        return; // No agregar punto decimal duplicado en el número actual
      }
      _display += digit;
    } else {
      _display += digit;
    }
    
    _updateAnalysis();
    notifyListeners();
  }

  /// Agrega un operador
  void addOperator(String operator) {
    if (_hasError) {
      clear();
    }
    
    // Display vacío: solo '-' puede iniciar (número negativo); ignorar el resto.
    if (_display.isEmpty) {
      if (operator == '-') {
        _display = '-';
        notifyListeners();
      }
      return;
    }
    // Display '0': '-' inicia un número negativo; los demás operadores tratan
    // el 0 como operando válido (p. ej. 0×5 = 0, 0^3 = 0) y continúan abajo.
    if (_display == '0' && operator == '-') {
      _display = '-';
      notifyListeners();
      return;
    }
    
    // Si ya termina en operador, reemplazar el último operador
    if (_endsWithOperator()) {
      String trimmed = _display.trim();
      // Eliminar el último operador y espacios
      int lastOperatorIndex = -1;
      for (int i = trimmed.length - 1; i >= 0; i--) {
        if (trimmed[i] == '+' || trimmed[i] == '-' || 
            trimmed[i] == '×' || trimmed[i] == '÷' || 
            trimmed[i] == '^' || trimmed[i] == '(') {
          lastOperatorIndex = i;
          break;
        }
      }
      
      if (lastOperatorIndex > 0) {
        // Conservar todo hasta antes del operador (sin incluir el espacio anterior)
        _display = trimmed.substring(0, lastOperatorIndex - 1);
      } else {
        // Si el operador está al principio, conservar todo excepto el operador
        _display = trimmed.substring(0, trimmed.length - 1);
      }
    }
    
    // Agregar el nuevo operador
    _display += ' $operator ';
    
    notifyListeners();
  }

  /// Calcula el resultado de la expresión
  void calculate() {
    // Si hay operación pendiente, agregar parámetro y ejecutar si está completa
    if (_pending != null) {
      _addParamAndMaybeExecute();
      return;
    }

    if (_display.isEmpty || _display == '0') return;

    try {
      // Usar el nuevo método que maneja correctamente paréntesis y funciones
      String result = evaluateCompleteExpression(_display);
      
      // Verificar si hay error en el resultado
      if (result.startsWith('err:')) {
        String errPart = result.substring(4); // remove 'err:'
        if (errPart.startsWith('errGeneric:')) {
          _setError('errGeneric', {'error': errPart.substring(11)});
        } else {
          _setError(errPart);
        }
        _display = 'Error';
      } else {
        // Agregar al historial
        OperationEntry entry = OperationEntry(
          expression: _display,
          result: result,
        );
        
        _history.insert(0, entry);
        if (_history.length > 100) {
          _history = _history.take(100).toList();
        }
        
        // Guardar en almacenamiento persistente
        HistoryService.addOperation(entry);
        
        // Mostrar el resultado
        _display = _formatNumber(result);
        _lastResult = result;
        _hasError = false;
        _errorMessage = '';
        _errorArgs = {};
  // Limpiar expresión antigua (ya reflejada en display)
        
        _updateAnalysis();
      }
      
    } catch (e) {
      _setError('errGeneric', {'error': e.toString()});
      _display = 'Error';
    }

    notifyListeners();
  }

  /// Calcula potencia
  Future<void> power(String exponent) async {
    try {
      String originalValue = _display;
      BigDecimal base = BigDecimal.fromString(_display);
      int exp = int.parse(exponent);
      
      // Verificar si la operación será pesada
      bool isHeavyOperation = _isHeavyPowerOperation(base, exp);
      
      if (isHeavyOperation) {
        _isCalculatingOperation = true;
        _operationProgress = trLocale('Calculando potencia...', 'Calculating power...');
        _canCancelOperation = true;
        notifyListeners();
        
        try {
          Map<String, dynamic> result = await compute(_calculatePowerInIsolate, {
            'base': base.toString(),
            'exponent': exp,
            'isSpanish': appIsSpanish,
          });
          
          if (result['success']) {
            String resultStr = _formatNumber(result['result']);
            _display = resultStr;
            _lastResult = resultStr;
            _updateAnalysis();
            
            // Registrar en historial
            await _addDirectOperationToHistory('$originalValue^$exponent', originalValue, resultStr);
          } else {
            _setError('errPower', {'error': result['error'].toString()});
            _display = 'Error';
          }
        } catch (e) {
          _setError('errPower', {'error': e.toString()});
          _display = 'Error';
        } finally {
          _isCalculatingOperation = false;
          _operationProgress = '';
          _canCancelOperation = false;
        }
      } else {
        // Cálculo directo para operaciones pequeñas
        BigDecimal result = base.pow(exp);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        
        // Registrar en historial
  await _addDirectOperationToHistory('$originalValue^$exponent', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errPower', {'error': e.toString()});
      _display = 'Error';
      _isCalculatingOperation = false;
      _operationProgress = '';
      _canCancelOperation = false;
    }
    
    notifyListeners();
  }

  /// Calcula raíz cuadrada
  Future<void> squareRoot() async {
    try {
      String originalValue = _display;
      BigDecimal number = BigDecimal.fromString(_display);

      // Raíz de un negativo: mensaje localizado claro (no filtrar la excepción).
      if (number.isNegative) {
        _setError('errNegativeSqrt');
        _display = 'Error';
        notifyListeners();
        return;
      }

      // Verificar si la operación será pesada (números muy grandes)
      bool isHeavyOperation = _display.replaceAll('.', '').replaceAll('-', '').length > 1000;
      
      if (isHeavyOperation) {
        _isCalculatingOperation = true;
        _operationProgress = trLocale('Calculando raíz cuadrada...', 'Calculating square root...');
        _canCancelOperation = true;
        notifyListeners();
        
        try {
          Map<String, dynamic> result = await compute(_calculateSqrtInIsolate,
              {'value': _display, 'isSpanish': appIsSpanish});
          
          if (result['success']) {
            String resultStr = _formatNumber(result['result']);
            _display = resultStr;
            _lastResult = resultStr;
            _updateAnalysis();
            
            // Registrar en historial
            await _addDirectOperationToHistory('√$originalValue', originalValue, resultStr);
          } else {
            _setError('errSquareRoot', {'error': result['error'].toString()});
            _display = 'Error';
          }
        } catch (e) {
          _setError('errSquareRoot', {'error': e.toString()});
          _display = 'Error';
        } finally {
          _isCalculatingOperation = false;
          _operationProgress = '';
          _canCancelOperation = false;
        }
      } else if (await _tryHighPrecision('sqrt', originalValue,
          historyExpr: '√$originalValue', originalValue: originalValue)) {
        return;
      } else {
        // Cálculo directo para números pequeños/medianos
        BigDecimal result = number.sqrt();
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        // Registrar en historial
  await _addDirectOperationToHistory('√$originalValue', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errSquareRoot', {'error': e.toString()});
      _display = 'Error';
      _isCalculatingOperation = false;
      _operationProgress = '';
      _canCancelOperation = false;
    }
    
    notifyListeners();
  }

  /// Calcula raíz cúbica
  Future<void> cubeRoot() async {
    try {
      String originalValue = _display;
      BigDecimal number = BigDecimal.fromString(_display);
      
      // Verificar si la operación será pesada (números muy grandes)
      bool isHeavyOperation = _display.replaceAll('.', '').replaceAll('-', '').length > 1000;
      
      if (isHeavyOperation) {
        _isCalculatingOperation = true;
        _operationProgress = trLocale('Calculando raíz cúbica...', 'Calculating cube root...');
        _canCancelOperation = true;
        notifyListeners();
        
        try {
          Map<String, dynamic> result = await compute(_calculateCubeRootInIsolate,
              {'value': _display, 'isSpanish': appIsSpanish});
          
          if (result['success']) {
            String resultStr = _formatNumber(result['result']);
            _display = resultStr;
            _lastResult = resultStr;
            _updateAnalysis();
            
            // Registrar en historial
            await _addDirectOperationToHistory('∛$originalValue', originalValue, resultStr);
          } else {
            _setError('errCubeRoot', {'error': result['error'].toString()});
            _display = 'Error';
          }
        } catch (e) {
          _setError('errCubeRoot', {'error': e.toString()});
          _display = 'Error';
        } finally {
          _isCalculatingOperation = false;
          _operationProgress = '';
          _canCancelOperation = false;
        }
      } else if (await _tryHighPrecision('cbrt', originalValue,
          historyExpr: '∛$originalValue', originalValue: originalValue)) {
        return;
      } else {
        // Cálculo directo para números pequeños/medianos (exacto sobre
        // enteros; la aproximación por double degradaba desde ~16 dígitos)
        String resultStr = _formatNumber(number.cbrt().toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        // Registrar en historial
  await _addDirectOperationToHistory('∛$originalValue', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errCubeRoot', {'error': e.toString()});
      _display = 'Error';
      _isCalculatingOperation = false;
      _operationProgress = '';
      _canCancelOperation = false;
    }
    
    notifyListeners();
  }

  /// Convierte a binario
  Future<void> toBinary() async {
    try {
      String originalValue = _display;
      BigDecimal number = BigDecimal.fromString(_display);
      String binary = number.toBinary();
      
      _display = binary;
      _lastResult = _display;
      
      // Registrar en historial
  await _addDirectOperationToHistory('$originalValue → BIN', originalValue, binary);
      
    } catch (e) {
      _setError('errBinaryConversion', {'error': e.toString()});
      _display = 'Error';
    }

    notifyListeners();
  }

  /// Convierte de binario a decimal
  Future<void> fromBinary() async {
    try {
      String originalValue = _display;
      String binary = _display;
      // Remover prefijo 0b si existe
      if (binary.startsWith('0b')) {
        binary = binary.substring(2);
      }
      
      // Validar que el número no esté vacío
      if (binary.isEmpty) {
        _setError('errEmptyBinary');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      // Validar que el número contenga solo dígitos binarios (0 y 1)
      if (!RegExp(r'^[01]+$').hasMatch(binary)) {
        _setError('errInvalidBinary');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      BigInt decimal = BigInt.parse(binary, radix: 2);
      String decimalStr = _formatNumber(decimal.toString());
      _display = decimalStr;
      _lastResult = decimalStr;
      _updateAnalysis();
      
      // Registrar en historial
  await _addDirectOperationToHistory('$originalValue → DEC', originalValue, decimalStr);
      
    } catch (e) {
      _setError('errBinaryFromConversion', {'error': e.toString()});
      _display = 'Error';
    }

    notifyListeners();
  }

  /// Borra el último carácter o elemento
  void backspace() {
    if (_hasError) {
      clear();
      return;
    }
    
    if (_display.isEmpty || _display == '0') {
      return;
    }
    
    // Si el display tiene más de un carácter
    if (_display.length > 1) {
      // Si termina en espacio, eliminar el operador completo (ej: " + ")
      if (_display.endsWith(' ')) {
        // Buscar el último operador y eliminarlo
        int lastOperatorIndex = -1;
        for (int i = _display.length - 1; i >= 0; i--) {
          if (_display[i] == '+' || _display[i] == '-' || 
              _display[i] == '×' || _display[i] == '÷' || 
              _display[i] == '^') {
            lastOperatorIndex = i;
            break;
          }
        }
        
        if (lastOperatorIndex > 0) {
          // Eliminar desde el espacio antes del operador
          _display = _display.substring(0, lastOperatorIndex - 1);
        } else {
          _display = _display.substring(0, _display.length - 1);
        }
      } else {
        // Eliminar el último carácter
        _display = _display.substring(0, _display.length - 1);
        
        // Si después de eliminar queda vacío, poner '0'
        if (_display.trim().isEmpty) {
          _display = '0';
        }
      }
    } else {
      _display = '0';
    }
    
    _updateAnalysis();
    notifyListeners();
  }

  /// Cambia el signo del número
  void toggleSign() {
    if (_hasError) return;
    
    if (_display.startsWith('-')) {
      _display = _display.substring(1);
    } else if (_display != '0') {
      _display = '-$_display';
    }
    
    _updateAnalysis();
    notifyListeners();
  }

  /// Agrega paréntesis de apertura
  void addOpenParenthesis() {
    if (_hasError) {
      clear();
    }

    // Si el display está vacío o es '0', agregar paréntesis de apertura
    if (_display == '0' || _display.isEmpty) {
      _display = '(';
    } else if (_endsWithNumber()) {
      // Si termina en número, agregar multiplicación implícita
      _display += ' × (';
    } else {
      // Si termina en operador, agregar paréntesis directamente
      _display += '(';
    }

    notifyListeners();
  }

  /// Agrega paréntesis de cierre
  void addCloseParenthesis() {
    if (_hasError) {
      clear();
    }

    // Agregar paréntesis de cierre
    if (_display == '0' || _display.isEmpty) {
      _display = ')';
    } else {
      _display += ')';
    }

    notifyListeners();
  }

  /// Actualiza el análisis del número actual
  void _updateAnalysis() {
    // Invalidar cualquier análisis en curso, incluso si aquí salimos temprano:
    // un resultado viejo no debe pisar el estado actual.
    _analysisToken++;
    if (_hasError || _display == '0' || _display.isEmpty || _display == 'Error') {
      _currentAnalysis = {};
      return;
    }

    // Solo hacer análisis si el display contiene solo un número
    String currentNumber = _getCurrentNumber();
    if (currentNumber == '0' || currentNumber.isEmpty || currentNumber.length < _display.length) {
      // El display contiene más que solo un número (tiene operadores, paréntesis, etc.)
      _currentAnalysis = {};
      return;
    }

    // Marcar que el análisis está en progreso
    _currentAnalysis = {'loading': true};
    notifyListeners();

    _performAnalysisAsync(_analysisToken);
  }

  /// Realiza el análisis de forma asíncrona. [token] identifica esta petición:
  /// si al terminar cada paso ya no es el token vigente, el resultado se
  /// descarta en vez de sobrescribir el análisis del número actual.
  Future<void> _performAnalysisAsync(int token) async {
    try {
      // Intentar parsear el número para análisis
      String numStr = _display.trim();
      
      bool isDecimal = numStr.contains('.');
      bool isNegative = numStr.startsWith('-');
      
      // Para análisis de propiedades numéricas, usar solo números enteros
      BigInt number;
      String analysisNote = '';
      
      if (isDecimal) {
        // Extraer parte entera del número decimal
        String integerPart;
        if (isNegative) {
          // Para negativos, tomar valor absoluto de la parte entera
          String withoutSign = numStr.substring(1);
          integerPart = withoutSign.split('.')[0];
          if (integerPart.isEmpty) integerPart = '0';
          number = BigInt.parse(integerPart);
          analysisNote = trLocale(
              'Análisis basado en la parte entera del valor absoluto ($integerPart)',
              'Analysis based on the integer part of the absolute value ($integerPart)');
        } else {
          integerPart = numStr.split('.')[0];
          if (integerPart.isEmpty) integerPart = '0';
          number = BigInt.parse(integerPart);
          analysisNote = trLocale('Análisis basado en la parte entera ($integerPart)',
              'Analysis based on the integer part ($integerPart)');
        }
      } else {
        // Para enteros, tomar valor absoluto si es negativo
        if (isNegative) {
          number = BigInt.parse(numStr.substring(1));
          analysisNote = trLocale(
              'Análisis basado en el valor absoluto (${number.toString()})',
              'Analysis based on the absolute value (${number.toString()})');
        } else {
          number = BigInt.parse(numStr);
        }
      }
      
      // Validar que el número sea válido para análisis
      if (number < BigInt.zero) {
        _currentAnalysis = {
          'error': 'errAnalysisInvalid',
          'originalNumber': _display
        };
        notifyListeners();
        return;
      }
      
  debugPrint('Iniciando análisis para número: $number (${number.toString().length} dígitos)');
      if (analysisNote.isNotEmpty) {
  debugPrint('Nota: $analysisNote');
      }
      
      // Realizar análisis básico primero
      Map<String, dynamic> analysis;

      if (number.toString().length > 10) {
        // El idioma viaja en el payload: el isolate no comparte los globales
        // del isolate principal y `appIsSpanish` volvería a su valor por
        // defecto (inglés).
        analysis = await compute(_analyzeNumberInIsolate, {
          'number': number,
          'isSpanish': appIsSpanish,
        });
      } else {
        analysis = NumberAnalysisService.completeAnalysis(number);
      }

      if (token != _analysisToken) return; // llegó tarde: descartar

      // Agregar información sobre el procesamiento si el número original era diferente
      if (analysisNote.isNotEmpty) {
        analysis['processingNote'] = analysisNote;
        analysis['originalInput'] = _display;
        analysis['processedNumber'] = number.toString();
      }

      // Actualizar con análisis básico
      _currentAnalysis = analysis;
      notifyListeners();

      // Ahora calcular primos de forma asíncrona si el número es grande
      if (number > BigInt.zero &&
          number.toString().length > 10 &&
          analysis['isPrime'] == false) {

        _isCalculatingPrimes = true;
        _currentAnalysis['calculatingPrimes'] = true;
        notifyListeners();

        try {
          // Calcular siguiente primo de forma asíncrona
          BigInt nextPrime = await NumberAnalysisService.nextPrimeAsync(number);
          if (token != _analysisToken) return;
          _currentAnalysis['nextPrime'] = nextPrime.toString();

          // Calcular primo anterior de forma asíncrona
          BigInt previousPrime = await NumberAnalysisService.previousPrimeAsync(number);
          if (token != _analysisToken) return;
          _currentAnalysis['previousPrime'] = previousPrime.toString();

          _isCalculatingPrimes = false;
          _currentAnalysis.remove('calculatingPrimes');

          debugPrint('Cálculo de primos completado: anterior=$previousPrime, siguiente=$nextPrime');

        } catch (e) {
          debugPrint('Error calculando primos: $e');
          if (token != _analysisToken) return;
          _currentAnalysis['nextPrime'] = trLocale('Error en cálculo', 'Calculation error');
          _currentAnalysis['previousPrime'] = trLocale('Error en cálculo', 'Calculation error');
          _isCalculatingPrimes = false;
          _currentAnalysis.remove('calculatingPrimes');
        }

        notifyListeners();
      }

      // Calcular cuadrados y cubos perfectos de forma asíncrona para números grandes
      if (number > BigInt.zero && number.toString().length > 100) {
        try {
          // Calcular si es cuadrado perfecto de forma asíncrona
          bool isPerfectSquare = await NumberAnalysisService.isPerfectSquareAsync(number);
          if (token != _analysisToken) return;
          _currentAnalysis['isPerfectSquare'] = isPerfectSquare;

          // Calcular si es cubo perfecto de forma asíncrona
          bool isPerfectCube = await NumberAnalysisService.isPerfectCubeAsync(number);
          if (token != _analysisToken) return;
          _currentAnalysis['isPerfectCube'] = isPerfectCube;

          debugPrint('Cálculo de potencias perfectas completado: cuadrado=$isPerfectSquare, cubo=$isPerfectCube');

        } catch (e) {
          debugPrint('Error calculando potencias perfectas: $e');
          if (token != _analysisToken) return;
          _currentAnalysis['isPerfectSquare'] = false;
          _currentAnalysis['isPerfectCube'] = false;
        }

        notifyListeners();
      }

      // Debug: verificar que el análisis se completó
  debugPrint('Análisis completado para: $number');
  debugPrint('Propiedades encontradas: ${_currentAnalysis.keys.toList()}');

    } catch (e) {
  debugPrint('Error en análisis: $e');
  debugPrint('Número original: $_display');
      if (token != _analysisToken) return;
      _currentAnalysis = {
        'error': 'errAnalysisFail',
        'errorDetail': e.toString(),
        'originalNumber': _display
      };
      _isCalculatingPrimes = false;
      notifyListeners();
    }
  }

  /// Función estática para analizar números en un isolate.
  /// Recibe `{number, isSpanish}`: el idioma debe viajar en el payload porque
  /// los globales no cruzan isolates.
  static Map<String, dynamic> _analyzeNumberInIsolate(Map<String, dynamic> args) {
    appIsSpanish = args['isSpanish'] as bool;
    final BigInt number = args['number'] as BigInt;
    try {
      return NumberAnalysisService.completeAnalysis(number);
    } catch (e) {
      return {
        'error': trLocale('Error en análisis: ${e.toString()}', 'Analysis error: ${e.toString()}'),
        'originalNumber': number.toString()
      };
    }
  }

  /// Función estática para calcular potencias en un isolate
  static Map<String, dynamic> _calculatePowerInIsolate(Map<String, dynamic> args) {
    appIsSpanish = args['isSpanish'] as bool? ?? appIsSpanish;
    try {
      BigDecimal base = BigDecimal.fromString(args['base']);
      int exponent = args['exponent'];
      
      // Para potencias muy grandes, implementar una verificación de cancelación
      BigDecimal result = base.pow(exponent);
      
      return {
        'success': true,
        'result': result.toString(),
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Función estática para calcular raíz cuadrada en un isolate.
  /// Recibe `{value, isSpanish}` (el idioma no cruza isolates como global).
  static Map<String, dynamic> _calculateSqrtInIsolate(Map<String, dynamic> args) {
    appIsSpanish = args['isSpanish'] as bool? ?? appIsSpanish;
    try {
      BigDecimal number = BigDecimal.fromString(args['value'] as String);
      BigDecimal result = number.sqrt();
      
      return {
        'success': true,
        'result': result.toString(),
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Función estática para calcular raíz cúbica en un isolate.
  /// Recibe `{value, isSpanish}` (el idioma no cruza isolates como global).
  static Map<String, dynamic> _calculateCubeRootInIsolate(Map<String, dynamic> args) {
    appIsSpanish = args['isSpanish'] as bool? ?? appIsSpanish;
    try {
      BigDecimal number = BigDecimal.fromString(args['value'] as String);
      // Exacta sobre enteros: la ruta anterior por double devolvía basura a
      // partir de ~16 dígitos (y 0 para ≥ 1e21 por la notación científica).
      BigDecimal result = number.cbrt();

      return {
        'success': true,
        'result': result.toString(),
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Función auxiliar para calcular factorial en isolate.
  /// Recibe `{n, isSpanish}`.
  static Map<String, dynamic> _calculateFactorialInIsolate(Map<String, dynamic> args) {
    appIsSpanish = args['isSpanish'] as bool? ?? appIsSpanish;
    final int n = args['n'] as int;
    try {
      if (n < 0) {
        return {'success': false, 'error': trLocale('Factorial no definido para números negativos', 'Factorial is not defined for negative numbers')};
      }
      
      if (n == 0 || n == 1) {
        return {'success': true, 'result': '1'};
      }
      
      BigInt result = BigInt.one;
      for (int i = 2; i <= n; i++) {
        result *= BigInt.from(i);
      }
      
      return {'success': true, 'result': result.toString()};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Carga un número específico para análisis
  void loadNumber(String number) {
    _display = _formatNumber(number);
  // Resetear expresión (display ya reseteado)
    _hasError = false;
    _errorMessage = '';
    _errorArgs = {};
    _updateAnalysis();
    notifyListeners();
  }

  /// Establece el display directamente (para pruebas)
  void setDisplay(String value) {
    _display = _formatNumber(value);
    _hasError = false;
    _errorMessage = '';
    _errorArgs = {};
    _updateAnalysis();
    notifyListeners();
  }

  /// Obtiene información específica del análisis
  String getAnalysisInfo(String key) {
    if (_currentAnalysis.containsKey(key)) {
      var value = _currentAnalysis[key];
      if (value is List) {
        return value.join(', ');
      } else if (value is Map) {
        return value.toString();
      }
      return value.toString();
    }
    return 'N/A';
  }

  /// Verifica si el número actual tiene cierta propiedad
  bool hasProperty(String property) {
    return _currentAnalysis.containsKey(property) && 
           _currentAnalysis[property] == true;
  }

  /// Detecta si el número actual es binario
  bool get isBinaryNumber {
    String current = _display;
    // Remover prefijo 0b si existe
    if (current.startsWith('0b')) {
      current = current.substring(2);
    }
    
    // Verificar si contiene solo dígitos binarios (0 y 1)
    return current.isNotEmpty && RegExp(r'^[01]+$').hasMatch(current);
  }

  /// Obtiene el texto apropiado para el botón de conversión
  String get conversionButtonText {
    return isBinaryNumber ? 'DEC' : 'BIN';
  }

  /// Alterna entre conversión binaria y decimal
  void toggleBinaryDecimal() {
    if (isBinaryNumber) {
      fromBinary();
    } else {
      toBinary();
    }
  }

  // =========================
  // FUNCIONES DE MEMORIA
  // =========================

  /// MC (Memory Clear) - Borra el valor almacenado en memoria
  void memoryClear() {
    _memoryValue = BigDecimal.zero;
    _hasMemoryValue = false;
    notifyListeners();
  }

  /// MR (Memory Recall) - Recupera el valor almacenado en memoria al display
  void memoryRecall() {
    if (_hasError) {
      clear();
    }
    
    if (_hasMemoryValue) {
      _display = _formatNumber(_memoryValue.toString());
      _updateAnalysis();
    } else {
      _display = '0';
    }
    notifyListeners();
  }

  /// MS (Memory Store) - Guarda el valor actual del display en memoria
  void memoryStore() {
    if (_hasError) return;
    
    try {
      // Obtener el número actual del display, preservando la precisión
      String currentNumber = _getCurrentNumber();
      _memoryValue = BigDecimal.fromString(currentNumber);
      _hasMemoryValue = true;
      notifyListeners();
    } catch (e) {
      // Si hay error en la conversión, no almacenar nada
  debugPrint('Error al almacenar en memoria: $e');
    }
  }

  /// M+ (Memory Plus) - Suma el valor actual del display al valor en memoria
  void memoryPlus() {
    if (_hasError) return;
    
    try {
      String currentNumber = _getCurrentNumber();
      BigDecimal currentValue = BigDecimal.fromString(currentNumber);
      
      if (_hasMemoryValue) {
        _memoryValue = _memoryValue + currentValue;
      } else {
        _memoryValue = currentValue;
        _hasMemoryValue = true;
      }
      notifyListeners();
    } catch (e) {
  debugPrint('Error en M+: $e');
    }
  }

  /// M- (Memory Minus) - Resta el valor actual del display del valor en memoria
  void memoryMinus() {
    if (_hasError) return;
    
    try {
      String currentNumber = _getCurrentNumber();
      BigDecimal currentValue = BigDecimal.fromString(currentNumber);
      
      if (_hasMemoryValue) {
        _memoryValue = _memoryValue - currentValue;
      } else {
        _memoryValue = BigDecimal.zero - currentValue;
        _hasMemoryValue = true;
      }
      notifyListeners();
    } catch (e) {
  debugPrint('Error en M-: $e');
    }
  }

  // =========================
  // FUNCIONES CIENTÍFICAS
  // =========================

  /// Convierte grados a radianes
  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  /// Convierte radianes a grados
  double _toDegrees(double radians) {
    return radians * 180 / math.pi;
  }

  /// Convierte el valor de entrada según el modo de ángulo
  double _convertAngle(double value) {
    return _isRadianMode ? value : _toRadians(value);
  }

  /// Verifica si un número es seguro para conversión a double (sin pérdida de precisión)
  bool _isSafeForDouble(String numberStr) {
    // Permitir números que se puedan parsear a double y no sean infinitos/NaN.
    // Evitar solo magnitudes que provocarían overflow en exp/10^x, etc.
    try {
      final v = double.parse(numberStr);
      if (v.isNaN || v.isInfinite) return false;
      // Límites conservadores para operaciones exponenciales/trig/log.
      if (v.abs() > 1e12) return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Seno
  Future<void> sin() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Verificar si el número es seguro para conversión a double
      if (!_isSafeForDouble(currentNumber)) {
        _setError('errTrigTooLarge');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      final angleSuffixSin = _isRadianMode ? '' : '°';
      if (await _tryHighPrecision('sin', currentNumber,
          degrees: !_isRadianMode,
          historyExpr: 'sin($currentNumber$angleSuffixSin)',
          originalValue: originalValue)) {
        return;
      }

      double value = double.parse(currentNumber);
      double angleInRadians = _convertAngle(value);
      double result = math.sin(angleInRadians);

      String resultStr = _formatScientificResult(result);
      _display = resultStr;
      _lastResult = resultStr;
      _updateAnalysis();

      // Registrar en historial
  await _addDirectOperationToHistory('sin($currentNumber$angleSuffixSin)', originalValue, resultStr);

    } catch (e) {
      _setError('errSin', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Coseno
  Future<void> cos() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Verificar si el número es seguro para conversión a double
      if (!_isSafeForDouble(currentNumber)) {
        _setError('errTrigTooLarge');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      final angleSuffixCos = _isRadianMode ? '' : '°';
      if (await _tryHighPrecision('cos', currentNumber,
          degrees: !_isRadianMode,
          historyExpr: 'cos($currentNumber$angleSuffixCos)',
          originalValue: originalValue)) {
        return;
      }

      double value = double.parse(currentNumber);
      double angleInRadians = _convertAngle(value);
      double result = math.cos(angleInRadians);

      String resultStr = _formatScientificResult(result);
      _display = resultStr;
      _lastResult = resultStr;
      _updateAnalysis();

      // Registrar en historial
  await _addDirectOperationToHistory('cos($currentNumber$angleSuffixCos)', originalValue, resultStr);

    } catch (e) {
      _setError('errCos', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Tangente
  Future<void> tan() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Verificar si el número es seguro para conversión a double
      if (!_isSafeForDouble(currentNumber)) {
        _setError('errTrigTooLarge');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      double value = double.parse(currentNumber);
      double angleInRadians = _convertAngle(value);

      // tan(θ) = sin(θ)/cos(θ) tiene polos donde cos(θ) = 0 (90°, 270°, −90°,
      // π/2 + kπ…). Por el redondeo de π, math.tan no devuelve `Infinity`
      // exacto en esos puntos sino un número enorme (p. ej. 1.6e16 en 90°).
      // Detectamos el polo por el DENOMINADOR (cos ≈ 0): es general para todos
      // los polos, no un caso particular de 90°. El umbral 1e-12 separa el polo
      // real del valor (grande pero legítimo) de un ángulo cercano que el
      // usuario sí pudo escribir. Esta verificación va ANTES de la ruta de alta
      // precisión para evitar el timeout (3 s) de los reales constructivos en
      // el polo exacto.
      final bool atPole = math.cos(angleInRadians).abs() < 1e-12;
      if (atPole) {
        _setError('errTanUndefined');
        _display = 'Error';
        notifyListeners();
        return;
      }

      final angleSuffixTan = _isRadianMode ? '' : '°';
      if (await _tryHighPrecision('tan', currentNumber,
          degrees: !_isRadianMode,
          historyExpr: 'tan($currentNumber$angleSuffixTan)',
          originalValue: originalValue)) {
        return;
      }

      double result = math.tan(angleInRadians);
      if (result.isInfinite || result.isNaN) {
        _setError('errTanUndefined');
        _display = 'Error';
      } else {
        String resultStr = _formatScientificResult(result);
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        // Registrar en historial
  await _addDirectOperationToHistory('tan($currentNumber$angleSuffixTan)', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errTan', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Arcoseno
  Future<void> asin() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Verificar si el número es seguro para conversión a double
      if (!_isSafeForDouble(currentNumber)) {
        _setError('errTrigTooLarge');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      double value = double.parse(currentNumber);
      
      if (value < -1 || value > 1) {
        _setError('errAsinDomain');
        _display = 'Error';
      } else if (await _tryHighPrecision('asin', currentNumber,
          degrees: !_isRadianMode,
          historyExpr: 'asin($currentNumber)',
          originalValue: originalValue)) {
        return;
      } else {
        double result = math.asin(value);
        if (!_isRadianMode) {
          result = _toDegrees(result);
        }

        String resultStr = _formatScientificResult(result);
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        // Registrar en historial
  await _addDirectOperationToHistory('asin($currentNumber)', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errAsin', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Arcocoseno
  Future<void> acos() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Verificar si el número es seguro para conversión a double
      if (!_isSafeForDouble(currentNumber)) {
        _setError('errTrigTooLarge');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      double value = double.parse(currentNumber);
      
      if (value < -1 || value > 1) {
        _setError('errAcosDomain');
        _display = 'Error';
      } else if (await _tryHighPrecision('acos', currentNumber,
          degrees: !_isRadianMode,
          historyExpr: 'acos($currentNumber)',
          originalValue: originalValue)) {
        return;
      } else {
        double result = math.acos(value);
        if (!_isRadianMode) {
          result = _toDegrees(result);
        }

        String resultStr = _formatScientificResult(result);
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        // Registrar en historial
  await _addDirectOperationToHistory('acos($currentNumber)', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errAcos', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Arcotangente
  Future<void> atan() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Verificar si el número es seguro para conversión a double
      if (!_isSafeForDouble(currentNumber)) {
        _setError('errTrigTooLarge');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      if (await _tryHighPrecision('atan', currentNumber,
          degrees: !_isRadianMode,
          historyExpr: 'atan($currentNumber)',
          originalValue: originalValue)) {
        return;
      }

      double value = double.parse(currentNumber);
      double result = math.atan(value);

      if (!_isRadianMode) {
        result = _toDegrees(result);
      }

      String resultStr = _formatScientificResult(result);
      _display = resultStr;
      _lastResult = resultStr;
      _updateAnalysis();

      // Registrar en historial
  await _addDirectOperationToHistory('atan($currentNumber)', originalValue, resultStr);

    } catch (e) {
      _setError('errAtan', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Logaritmo natural (ln)
  Future<void> ln() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Para logaritmos, usar BigDecimal para verificar si es positivo
      BigDecimal bigValue = BigDecimal.fromString(currentNumber);
      
      if (bigValue.isNegative || bigValue.isZero) {
        _setError('errLnDomain');
        _display = 'Error';
      } else {
        // Verificar si el número es seguro para conversión a double
        if (!_isSafeForDouble(currentNumber)) {
          _setError('errLnTooLarge');
          _display = 'Error';
          notifyListeners();
          return;
        }
        
        if (await _tryHighPrecision('ln', currentNumber,
            historyExpr: 'ln($currentNumber)', originalValue: originalValue)) {
          return;
        }

        double value = double.parse(currentNumber);
        double result = math.log(value);
        String resultStr = _formatScientificResult(result);
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        // Registrar en historial
  await _addDirectOperationToHistory('ln($currentNumber)', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errLn', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Logaritmo base 10 (log)
  Future<void> log() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Para logaritmos, usar BigDecimal para verificar si es positivo
      BigDecimal bigValue = BigDecimal.fromString(currentNumber);
      
      if (bigValue.isNegative || bigValue.isZero) {
        _setError('errLogDomain');
        _display = 'Error';
      } else {
        // Verificar si el número es seguro para conversión a double
        if (!_isSafeForDouble(currentNumber)) {
          _setError('errLogTooLarge');
          _display = 'Error';
          notifyListeners();
          return;
        }
        
        if (await _tryHighPrecision('log10', currentNumber,
            historyExpr: 'log($currentNumber)', originalValue: originalValue)) {
          return;
        }

        double value = double.parse(currentNumber);
        double result = math.log(value) / math.log(10);
        String resultStr = _formatScientificResult(result);
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        // Registrar en historial
  await _addDirectOperationToHistory('log($currentNumber)', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errLog', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Exponencial (e^x)
  Future<void> exp() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Verificar si el número es seguro para conversión a double
      if (!_isSafeForDouble(currentNumber)) {
        _setError('errExpTooLarge');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      double value = double.parse(currentNumber);
      
      // Verificar si el valor es muy grande para evitar overflow
      if (value > 700) {
        _setError('errExpTooLarge');
        _display = 'Error';
      } else if (await _tryHighPrecision('exp', currentNumber,
          historyExpr: 'e^$currentNumber', originalValue: originalValue)) {
        return;
      } else {
        double result = math.exp(value);
        String resultStr = _formatScientificResult(result);
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        // Registrar en historial
  await _addDirectOperationToHistory('e^$currentNumber', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errExp', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// 10^x
  Future<void> pow10() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Verificar si el número es seguro para conversión a double
      if (!_isSafeForDouble(currentNumber)) {
        _setError('errTenPowTooLarge');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      double value = double.parse(currentNumber);
      
      // Verificar si el valor es muy grande para evitar overflow
      if (value > 300) {
        _setError('errTenPowTooLarge');
        _display = 'Error';
      } else {
        double result = math.pow(10, value).toDouble();
        String resultStr = _formatScientificResult(result);
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        
        // Registrar en historial
  await _addDirectOperationToHistory('10^$currentNumber', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errTenPow', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Factorial
  Future<void> factorial() async {
    try {
      // Obtener el último número del display
      String currentNumber = _getCurrentNumber();
      String originalValue = currentNumber;
      
      // Usar BigDecimal para manejar números grandes de forma segura
      BigDecimal bigValue;
      try {
        bigValue = BigDecimal.fromString(currentNumber);
      } catch (e) {
        _setError('errFactorialInvalid');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      // Verificar que sea un número entero no negativo
      if (bigValue.isNegative) {
        _setError('errFactorialNonNeg');
        _display = 'Error';
      } else {
        // Verificar si es un entero
        BigInt intValue = bigValue.integerPart;
        if (bigValue.fractionalPart != BigInt.zero) {
          _setError('errFactorialNonNeg');
          _display = 'Error';
        } else if (intValue > BigInt.from(170)) {
          _setError('errFactorialTooLarge');
          _display = 'Error';
        } else {
          _isCalculatingOperation = true;
          _operationProgress = trLocale('Calculando factorial...', 'Calculating factorial...');
          _canCancelOperation = false;
          notifyListeners();
          
          try {
            Map<String, dynamic> result = await compute(_calculateFactorialInIsolate,
                {'n': intValue.toInt(), 'isSpanish': appIsSpanish});
            
            if (result['success']) {
              // Reemplazar el último número con el resultado del factorial
              String factorialResult = result['result'];
              
              // Si el display contiene más que solo el número, reemplazar solo el último número
              if (_display.length > currentNumber.length) {
                int lastNumberIndex = _display.lastIndexOf(currentNumber);
                if (lastNumberIndex >= 0) {
                  _display = _display.substring(0, lastNumberIndex) + factorialResult;
                } else {
                  _display = factorialResult;
                }
              } else {
                _display = factorialResult;
              }
              
              _lastResult = factorialResult;
              _updateAnalysis();
              
              // Registrar en historial
              await _addDirectOperationToHistory('$originalValue!', originalValue, factorialResult);
            } else {
              _setError('errFactorial', {'error': result['error'].toString()});
              _display = 'Error';
            }
          } finally {
            _isCalculatingOperation = false;
            _operationProgress = '';
            _canCancelOperation = false;
          }
        }
      }
      
    } catch (e) {
      _setError('errFactorial', {'error': e.toString()});
      _display = 'Error';
      _isCalculatingOperation = false;
      _operationProgress = '';
      _canCancelOperation = false;
    }
    
    notifyListeners();
  }

  /// Agrega constante Pi
  void addPi() {
    if (_hasError) {
      clear();
    }
    
    String piValue = math.pi.toString();

    // Si ya es Pi, no hacer nada
    if (_display == piValue) {
      return;
    }

    // En medio de una expresión ("2×"), π es el siguiente operando; antes se
    // reemplazaba todo el display y el "2×" se perdía en silencio.
    if (_endsWithOperator()) {
      _display += piValue;
    } else {
      _display = piValue;
    }

    _updateAnalysis();
    notifyListeners();
  }

  /// Agrega constante e
  void addE() {
    if (_hasError) {
      clear();
    }
    
    String eValue = math.e.toString();

    // Si ya es e, no hacer nada
    if (_display == eValue) {
      return;
    }

    // En medio de una expresión ("2×"), e es el siguiente operando (ver addPi)
    if (_endsWithOperator()) {
      _display += eValue;
    } else {
      _display = eValue;
    }

    _updateAnalysis();
    notifyListeners();
  }

  /// Cancela la operación actual
  void cancelCurrentOperation() {
    if (_canCancelOperation) {
      _isCalculatingOperation = false;
      _isCalculatingPrimes = false;
      _operationProgress = '';
      _canCancelOperation = false;
      _setError('errOperationCancelled');
      _display = 'Error';
      notifyListeners();
    }
  }

  /// Determina si una operación de potencia será pesada
  bool _isHeavyPowerOperation(BigDecimal base, int exponent) {
    // Operaciones pesadas: números grandes o exponentes altos
    String baseStr = base.toString();
    int digits = baseStr.replaceAll('.', '').replaceAll('-', '').length;

    return digits > 100 || exponent > 100 || (digits > 10 && exponent > 10);
  }

  /// Estima si base^exp produciría un resultado EXACTO con demasiados dígitos
  /// para computarse (p. ej. una base no entera con exponente enorme explota
  /// a miles de millones de decimales). Evita el bloqueo de la UI rechazando
  /// la operación al instante, como hacen las calculadoras con "overflow".
  bool _powerExceedsDigitLimit(BigDecimal base, int exponent,
      {int maxDigits = 100000}) {
    if (exponent <= 1) return false;
    final d = base.toDouble();
    if (d == 0 || d == 1 || d == -1) return false; // casos triviales
    // Dígitos significativos de la base (parte entera sin ceros líderes + decimales).
    final body = base.toString().replaceAll('-', '');
    final dot = body.indexOf('.');
    final intPart = (dot < 0 ? body : body.substring(0, dot))
        .replaceAll(RegExp(r'^0+'), '');
    final fracPlaces = dot < 0 ? 0 : body.length - dot - 1;
    final sigDigits = intPart.length + fracPlaces;
    // El número de dígitos del resultado exacto crece ~ exp × sigDigits.
    // Usamos BigInt para evitar desbordes con exponentes enormes.
    return BigInt.from(exponent) * BigInt.from(sigDigits) >
        BigInt.from(maxDigits);
  }

  /// Detecta operaciones de potencia que pueden producir números grandes
  bool _hasPotentiallyLargePowerOperation(String expression) {
    // Buscar patrones de potencia como "número^exponente"
    RegExp powerRegex = RegExp(r'(\d+(?:\.\d+)?)\s*\^\s*(\d+(?:\.\d+)?)');
    Iterable<Match> matches = powerRegex.allMatches(expression);
    
    for (Match match in matches) {
      String baseStr = match.group(1)!;
      String expStr = match.group(2)!;
      
      try {
        double base = double.parse(baseStr);
        double exponent = double.parse(expStr);
        
        // Casos que típicamente producen números grandes:
        // 1. Exponente alto (>= 20)
        // 2. Base grande con exponente moderado
        // 3. Casos específicos conocidos como 2^68
        
        if (exponent >= 20) {
          return true;
        }
        
        if (base >= 10 && exponent >= 10) {
          return true;
        }
        
        // Caso específico: potencias de números pequeños con exponentes medianos-altos
        // que pueden producir números grandes (como 2^68)
        if (base >= 2 && exponent >= 50) {
          return true;
        }
        
        // Verificar si el resultado estimado sería muy grande
        // Para evitar overflow, usar logaritmos: log(base^exp) = exp * log(base)
        if (base > 1 && exponent > 0) {
          double logResult = exponent * math.log(base);
          // Si log(resultado) > log(10^15), entonces el resultado > 10^15 (muy grande para double)
          if (logResult > 15 * math.log(10)) {
            return true;
          }
        }
        
      } catch (e) {
        // Si hay error parsing, asumir que puede ser complejo
        return true;
      }
    }
    
    return false;
  }

  /// Formatea el resultado de funciones científicas
  String _formatScientificResult(double result) {
    // Manejar casos especiales
    if (result.isNaN) {
      return 'NaN';
    }
    if (result.isInfinite) {
      return result.isNegative ? '-∞' : '∞';
    }
    
    // Normalizar errores de punto flotante muy pequeños
    // Ej.: sin(30°) -> 0.49999999999999994 debe ser 0.5
    if (result.abs() < 1e-15) {
      result = 0.0;
    }
  // Redondeo suave a N decimales para estabilizar resultados de funciones científicas
  // Esto corrige artefactos como 0.4999999999999999 -> 0.5 y mantiene precisión esperada (e.g., e^2)
  result = double.parse(result.toStringAsFixed(NumericPrecision.decimals));
    
    // Verificar si se debe usar notación científica
    bool useScientificNotation = SettingsService.getUseScientificNotation();
    
    if (useScientificNotation) {
      // Formatear números muy pequeños o muy grandes usando notación científica
      if (result.abs() < 1e-10 && result != 0) {
        return result.toStringAsExponential(10);
      }
      if (result.abs() > 1e10) {
        return result.toStringAsExponential(10);
      }
      
      // Formatear números regulares
      String formatted = result.toString();
      if (formatted.length > 15) {
        return result.toStringAsExponential(10);
      }
      
      return formatted;
    } else {
      // Formatear sin notación científica (mostrar números completos)
      return _formatWithoutScientificNotation(result);
    }
  }
  
  /// Formatea un número sin usar notación científica
  String _formatWithoutScientificNotation(double result) {
    // Manejar casos especiales
    if (result.isNaN) {
      return 'NaN';
    }
    if (result.isInfinite) {
      return result.isNegative ? '-∞' : '∞';
    }
    
  // Redondear a N decimales para limpiar ruido de coma flotante preservando precisión
  result = double.parse(result.toStringAsFixed(NumericPrecision.decimals));
    
    // Convertir a BigDecimal para mantener precisión
    BigDecimal bigResult = BigDecimal.fromDouble(result);
    
    // Formatear el número completo
    String formatted = bigResult.toString();
    
    // Eliminar notación científica si la hay
    if (formatted.contains('e') || formatted.contains('E')) {
      // Convertir de notación científica a decimal completo
      try {
        BigDecimal expanded = BigDecimal.fromString(formatted);
        formatted = expanded.toString();
      } catch (e) {
        // Si hay error, mantener el formato original
        formatted = result.toString();
      }
    }
  // Eliminar ceros y puntos sobrantes si aplica
  formatted = _trimTrailingZeros(formatted);
  return formatted;
  }
  
  /// Formatea cualquier resultado numérico según la configuración
  String _formatNumber(String numberStr) {
    // Normalizar entrada
    numberStr = numberStr.trim();

    // Caso especial: decimales de magnitud pequeña con muchos dígitos (artefactos de coma flotante)
    // Ej.: 0.49999999999999994 -> 0.5, 1.0000000000000002 -> 1
    if (!numberStr.contains('e') && !numberStr.contains('E') && numberStr.contains('.')) {
      final parts = numberStr.split('.');
      final intPart = parts[0].replaceAll('-', '');
      final fracPart = parts.length > 1 ? parts[1] : '';
      // Solo redondear automáticamente cuando:
      // - La parte entera es corta (|x| < 10)
      // - Hay más decimales que la precisión central
      if (intPart.length <= 1 && fracPart.length > NumericPrecision.decimals) {
        final v = double.tryParse(numberStr);
        if (v != null && v.isFinite && v.abs() < 1e6) {
          // Reutilizamos el formateo sin notación científica que ya redondea y limpia ceros
          return _formatWithoutScientificNotation(v);
        }
      }
    }

    // PREVENCIÓN DE PÉRDIDA DE PRECISIÓN: Para números grandes, NUNCA convertir a double
    // Números > 15 dígitos pueden perder precisión en conversiones double
  if (numberStr.length > NumericPrecision.decimals) {
      return numberStr; // Devolver el string original para números muy grandes
    }
    
    // Verificar si se debe usar notación científica
    bool useScientificNotation = SettingsService.getUseScientificNotation();
    if (!useScientificNotation) {
      // Para preservar la precisión de decimales, evitar conversión a double
      // Solo hacer conversión si es necesario para casos especiales
      try {
        if (numberStr.contains('e') || numberStr.contains('E')) {
          // SOLO para notación científica corta (< 15 dígitos), intentar expandir
          // Para notación científica larga, preservar como string
          if (numberStr.length <= NumericPrecision.decimals) {
            double value = double.parse(numberStr);
            String result = _formatWithoutScientificNotation(value);
            // Recortar ceros y puntos sobrantes
            result = _trimTrailingZeros(result);
            return result;
          } else {
            // Para notación científica larga, preservar el string para evitar pérdida de precisión
            return numberStr;
          }
        } else {
          // Para números regulares, preservar el string original para mantener precisión
          return _trimTrailingZeros(numberStr);
        }
      } catch (e) {
        // Si no se puede convertir, devolver el string original
        return _trimTrailingZeros(numberStr);
      }
    }
    
    return numberStr;
  }

  /// Elimina ceros al final de la parte decimal y el punto si no es necesario
  String _trimTrailingZeros(String s) {
    if (!s.contains('.') || s.contains('e') || s.contains('E')) return s;
    // Quitar ceros a la derecha de manera segura
    s = s.replaceAll(RegExp(r'(\.\d*?[1-9])0+$'), r'$1');
    // Si quedan solo ceros después del punto, quitar la parte decimal
    s = s.replaceAll(RegExp(r'\.0+$'), '');
    // Si termina en punto, quitarlo
    if (s.endsWith('.')) s = s.substring(0, s.length - 1);
    // Normalizar -0 a 0
    if (s == '-0') s = '0';
    return s;
  }
  
  // =========================
  // NUEVOS MÉTODOS PARA EXPRESIONES COMPLETAS E HISTORIAL
  // =========================
  
  /// Carga el historial desde el almacenamiento local
  Future<void> _loadHistory() async {
    try {
      _history = await HistoryService.getHistory();
      notifyListeners();
    } catch (e) {
  debugPrint('Error cargando historial: $e');
    }
  }
  
  /// Alterna la visibilidad del historial
  void toggleHistoryVisibility() {
    _isHistoryVisible = !_isHistoryVisible;
    notifyListeners();
  }

  /// Recarga el historial desde el almacenamiento. Necesario cuando otra
  /// pantalla (p. ej. HistoryScreen) muta HistoryService directamente: la
  /// copia en memoria de este servicio quedaba desactualizada hasta reiniciar.
  Future<void> reloadHistory() => _loadHistory();
  
  /// Evalúa una expresión matemática completa usando math_expressions
  String evaluateCompleteExpression(String expression) {
    try {
      // Validar la expresión antes de procesarla
      if (expression.trim().isEmpty) {
        return 'err:errExprEmpty';
      }
      
      // Validar patrones problemáticos
      if (_hasInvalidPatterns(expression)) {
        return 'err:errExprMalformed';
      }
      
      // Limpiar la expresión
      String cleanExpression = _prepareExpression(expression);
      
      // Verificar división por un cero literal (solo ceros y sin más dígitos
      // ni punto detrás; "8/02" es 8÷2, no una división por cero)
      if (RegExp(r'/\s*0+(?![\d.])').hasMatch(cleanExpression)) {
        return 'err:errExprDivZero';
      }
      
      // Verificar si tiene paréntesis o funciones - usar math_expressions
      bool hasComplexStructure = cleanExpression.contains('(') || 
                                 cleanExpression.contains(')') ||
                                 cleanExpression.contains('sqrt') ||
                                 cleanExpression.contains('sin') ||
                                 cleanExpression.contains('cos') ||
                                 cleanExpression.contains('tan') ||
                                 cleanExpression.contains('log') ||
                                 cleanExpression.contains('ln') ||
                                 cleanExpression.contains('abs');
      
      // Si tiene estructura compleja, usar math_expressions obligatoriamente
      if (hasComplexStructure) {
        return _evaluateWithMathExpressions(cleanExpression);
      }
      
      // Para expresiones simples, verificar si hay números grandes
      if (_containsLargeNumbers(cleanExpression)) {
        return _evaluateBigDecimalExpression(cleanExpression);
      }
      
      // CORRECCIÓN: Verificar operaciones de potencia que pueden producir números grandes
      if (_hasPotentiallyLargePowerOperation(cleanExpression)) {
        return _evaluateBigDecimalExpression(cleanExpression);
      }
      
      // Para expresiones simples con números normales, usar math_expressions
      return _evaluateWithMathExpressions(cleanExpression);
      
    } catch (e) {
      return 'err:errGeneric:${e.toString()}';
    }
  }

  /// Evalúa usando math_expressions exclusivamente
  String _evaluateWithMathExpressions(String cleanExpression) {
    try {
      // Usar math_expressions para expresiones estándar
  ShuntingYardParser parser = ShuntingYardParser();
      
      // Configurar contexto para funciones trigonométricas
      if (!_isRadianMode) {
        // Convertir grados a radianes para funciones trigonométricas
        cleanExpression = _convertTrigFunctionsToRadians(cleanExpression);
      }
      
      Expression exp = parser.parse(cleanExpression);
      ContextModel context = ContextModel();
      
      double result = exp.evaluate(EvaluationType.REAL, context);
      
      // Verificar si el resultado es válido
      if (result.isNaN || result.isInfinite) {
        return 'err:errResultInvalid';
      }
      
      // Formatear el resultado según la configuración
      return _formatNumber(result.toString());
      
    } catch (e) {
      throw Exception(trLocale('Error en evaluación: ${e.toString()}', 'Evaluation error: ${e.toString()}'));
    }
  }
  
  /// Verifica si la expresión tiene patrones inválidos
  bool _hasInvalidPatterns(String expression) {
    // Operadores consecutivos problemáticos
    if (RegExp(r'[\+\-\*\/\^]{2,}').hasMatch(expression)) {
      // Permitir algunos casos válidos como --x o ++x
      if (!RegExp(r'^[\+\-]*\d').hasMatch(expression.trim())) {
        return true;
      }
    }
    
    // Paréntesis no balanceados
    int openParens = 0;
    for (int i = 0; i < expression.length; i++) {
      if (expression[i] == '(') openParens++;
      if (expression[i] == ')') openParens--;
      if (openParens < 0) return true;
    }
    if (openParens != 0) return true;
    
    // Funciones sin paréntesis
    if (RegExp(r'\b(sin|cos|tan|log|ln|sqrt|abs)\s*[^(]').hasMatch(expression)) {
      return true;
    }
    
    return false;
  }
  
  /// Prepara la expresión reemplazando símbolos visuales por los de math_expressions
  String _prepareExpression(String expression) {
    String prepared = expression;
    
    // Reemplazar operadores visuales
    prepared = prepared.replaceAll('×', '*');
    prepared = prepared.replaceAll('÷', '/');
    prepared = prepared.replaceAll('√', 'sqrt');
    
    // Reemplazar constantes. Solo la 'e' suelta es la constante de Euler:
    // reemplazar toda 'e' corrompía la notación científica ("2e3" pasaba a
    // ser "2·2.718…·3" sin error visible).
    prepared = prepared.replaceAll('π', math.pi.toString());
    prepared = prepared.replaceAllMapped(
      RegExp(r'(?<![0-9A-Za-z.])e(?![0-9A-Za-z(])'),
      (_) => math.e.toString(),
    );
    
    // Agregar multiplicación implícita donde sea necesario
    prepared = _addImplicitMultiplication(prepared);
    
    return prepared;
  }
  
  /// Agrega multiplicación implícita (ej: 2(3+4) → 2*(3+4))
  String _addImplicitMultiplication(String expression) {
    String result = expression;
    
    // Patrón para número seguido de paréntesis: 2( → 2*(
    result = result.replaceAllMapped(
      RegExp(r'(\d)\('),
      (match) => '${match.group(1)}*(',
    );
    
    // Patrón para paréntesis seguido de número: )2 → )*2
    result = result.replaceAllMapped(
      RegExp(r'\)(\d)'),
      (match) => ')*${match.group(1)}',
    );
    
    // Patrón para paréntesis consecutivos: )( → )*(
    result = result.replaceAll(')(', ')*(');
    
    return result;
  }
  
  /// Convierte funciones trigonométricas de grados a radianes.
  /// Recorre la expresión respetando paréntesis anidados: el regex anterior
  /// (`sin\(([^)]+)\)`) cortaba el argumento en el primer ')', convirtiendo
  /// solo una parte de él en `sin((1+2)+27)`.
  String _convertTrigFunctionsToRadians(String expression) {
    if (_isRadianMode) return expression;
    return _degreesToRadiansCalls(expression);
  }

  static String _degreesToRadiansCalls(String s) {
    final StringBuffer out = StringBuffer();
    final RegExp letter = RegExp(r'[A-Za-z]');
    int i = 0;
    while (i < s.length) {
      bool converted = false;
      for (final String name in const ['sin', 'cos', 'tan']) {
        // El guardia de letra previa evita convertir el 'sin(' de 'arcsin('.
        if (s.startsWith('$name(', i) &&
            (i == 0 || !letter.hasMatch(s[i - 1]))) {
          final int open = i + name.length;
          int depth = 1;
          int j = open + 1;
          while (j < s.length && depth > 0) {
            if (s[j] == '(') depth++;
            if (s[j] == ')') depth--;
            j++;
          }
          if (depth != 0) break; // sin cerrar: dejar tal cual (fallará el parser)
          final String arg = _degreesToRadiansCalls(s.substring(open + 1, j - 1));
          out.write('$name((($arg)*${math.pi}/180))');
          i = j;
          converted = true;
          break;
        }
      }
      if (!converted) {
        out.write(s[i]);
        i++;
      }
    }
    return out.toString();
  }
  
  /// Evalúa la expresión actual y la agrega al historial
  Future<void> evaluateAndAddToHistory() async {
    String expression = _expressionController.text.trim();
    
    if (expression.isEmpty) return;
    
    try {
      String result = evaluateCompleteExpression(expression);
      
      if (!result.startsWith('err:')) {
        // Actualizar display
        _display = result;
        _lastResult = result;
        _hasError = false;
        _errorMessage = '';
        _errorArgs = {};
        
        // Crear entrada de historial
        OperationEntry entry = OperationEntry(
          expression: expression,
          result: result,
        );
        
        // Agregar al historial local
        _history.insert(0, entry);
        
        // Mantener solo las últimas 100 operaciones en memoria
        if (_history.length > 100) {
          _history = _history.take(100).toList();
        }
        
        // Guardar en almacenamiento persistente
        await HistoryService.addOperation(entry);
        
        // Actualizar análisis del resultado
        _updateAnalysis();
        
      } else {
        String errPart = result.substring(4); // remove 'err:'
        if (errPart.startsWith('errGeneric:')) {
          _setError('errGeneric', {'error': errPart.substring(11)});
        } else {
          _setError(errPart);
        }
        _display = 'Error';
      }

    } catch (e) {
      _setError('errGeneric', {'error': e.toString()});
      _display = 'Error';
    }

    notifyListeners();
  }

  /// Agrega texto a la expresión actual
  void addToExpression(String text) {
    _expressionController.text += text;
    _hasError = false;
    notifyListeners();
  }
  
  /// Inserta texto en la posición actual del cursor
  void insertInExpression(String text) {
    final controller = _expressionController;
    final currentPosition = controller.selection.start;
    
    if (currentPosition >= 0) {
      final currentText = controller.text;
      final newText = currentText.substring(0, currentPosition) + 
                     text + 
                     currentText.substring(currentPosition);
      
      controller.text = newText;
      controller.selection = TextSelection.collapsed(
        offset: currentPosition + text.length,
      );
    } else {
      controller.text += text;
    }
    
    _hasError = false;
    notifyListeners();
  }
  
  /// Borra el último carácter de la expresión
  void backspaceExpression() {
    final controller = _expressionController;
    final text = controller.text;
    
    if (text.isNotEmpty) {
      controller.text = text.substring(0, text.length - 1);
    }
    
    notifyListeners();
  }
  
  /// Limpia la expresión actual
  void clearExpression() {
    _expressionController.clear();
    _hasError = false;
    _errorMessage = '';
    _errorArgs = {};
    notifyListeners();
  }
  
  /// Carga una expresión del historial
  void loadFromHistory(OperationEntry entry) {
    _expressionController.text = entry.expression;
    notifyListeners();
  }
  
  /// Carga el resultado de una operación del historial
  void loadResultFromHistory(OperationEntry entry) {
    _display = entry.result;
    _lastResult = entry.result;
    _updateAnalysis();
    notifyListeners();
  }
  
  /// Limpia todo el historial
  Future<void> clearHistory() async {
    try {
      await HistoryService.clearHistory();
      _history.clear();
      notifyListeners();
    } catch (e) {
  debugPrint('Error limpiando historial: $e');
    }
  }
  
  /// Elimina una entrada específica del historial
  Future<void> removeFromHistory(OperationEntry entry) async {
    try {
      await HistoryService.removeOperation(entry);
      _history.remove(entry);
      notifyListeners();
    } catch (e) {
  debugPrint('Error eliminando entrada del historial: $e');
    }
  }
  
  /// Dispose del controlador
  @override
  void dispose() {
    _expressionController.removeListener(notifyListeners);
    _expressionController.dispose();
    super.dispose();
  }
  
  /// Detecta si la expresión contiene números grandes que requieren BigDecimal
  bool _containsLargeNumbers(String expression) {
    // Buscar números en la expresión (incluyendo decimales)
    RegExp numberRegex = RegExp(r'\d+(?:\.\d+)?');
    Iterable<Match> matches = numberRegex.allMatches(expression);
    
    for (Match match in matches) {
      String number = match.group(0)!;
      // Si el número tiene más de 10 dígitos (sin contar el punto decimal), usar BigDecimal
      String digitsOnly = number.replaceAll('.', '');
      if (digitsOnly.length > 10) {
        return true;
      }
      
      // También verificar si el número es muy grande para double
      try {
        double value = double.parse(number);
        if (value.isInfinite || value.isNaN) {
          return true;
        }
      } catch (e) {
        return true;
      }
    }
    
    return false;
  }

  /// Evalúa expresiones con BigDecimal para números muy grandes.
  ///
  /// Descenso recursivo por precedencia (+,− < ×,÷ < ^) sobre una expresión
  /// plana (las que tienen paréntesis van por math_expressions). La versión
  /// anterior partía por el PRIMER operador encontrado y solo soportaba una
  /// operación: "2^68+1" devolvía 1.
  String _evaluateBigDecimalExpression(String expression) {
    try {
      expression = expression.replaceAll(' ', '');
      if (expression.isEmpty) {
        throw ArgumentError(trLocale('Expresión inválida: operandos vacíos', 'Invalid expression: empty operands'));
      }
      return _evalBigAdditive(expression).toString();
    } on _ResultTooLargeException {
      return 'err:errResultTooLarge';
    } catch (e) {
      throw ArgumentError(trLocale('Error evaluando expresión: $e', 'Error evaluating expression: $e'));
    }
  }

  /// ¿El carácter en [i] es un operador binario? (Si lo precede otro operador
  /// o está al inicio, es un signo unario del operando derecho.)
  static bool _isBinaryOperatorAt(String s, int i) {
    return i > 0 && RegExp(r'[0-9.]').hasMatch(s[i - 1]);
  }

  /// Nivel +/−. Se parte por el operador de MÁS a la derecha para respetar la
  /// asociatividad izquierda (1-2-3 = (1-2)-3).
  BigDecimal _evalBigAdditive(String s) {
    for (int i = s.length - 1; i > 0; i--) {
      final String c = s[i];
      if ((c == '+' || c == '-') && _isBinaryOperatorAt(s, i)) {
        final BigDecimal left = _evalBigAdditive(s.substring(0, i));
        final BigDecimal right = _evalBigMultiplicative(s.substring(i + 1));
        return c == '+' ? left + right : left - right;
      }
    }
    return _evalBigMultiplicative(s);
  }

  /// Nivel ×/÷ (asociatividad izquierda).
  BigDecimal _evalBigMultiplicative(String s) {
    for (int i = s.length - 1; i > 0; i--) {
      final String c = s[i];
      if ((c == '*' || c == '/') && _isBinaryOperatorAt(s, i)) {
        final BigDecimal left = _evalBigMultiplicative(s.substring(0, i));
        final BigDecimal right = _evalBigPower(s.substring(i + 1));
        if (c == '*') return left * right;
        if (right == BigDecimal.zero) {
          throw ArgumentError(trLocale('División por cero', 'Division by zero'));
        }
        return left / right;
      }
    }
    return _evalBigPower(s);
  }

  /// Nivel ^ (asociatividad derecha: 2^3^2 = 2^(3^2)).
  BigDecimal _evalBigPower(String s) {
    final int i = s.indexOf('^');
    if (i <= 0) {
      return BigDecimal.fromString(s);
    }
    final BigDecimal base = BigDecimal.fromString(s.substring(0, i));
    final BigDecimal exp = _evalBigPower(s.substring(i + 1));

    if (exp.fractionalPart != BigInt.zero) {
      // Antes se truncaba en silencio (x^2.5 calculaba x^2).
      throw ArgumentError(trLocale('Exponente no entero no soportado en modo de números grandes',
          'Non-integer exponent not supported in big-number mode'));
    }
    if (exp.isNegative) {
      throw ArgumentError(trLocale('Exponente negativo no soportado', 'Negative exponent not supported'));
    }
    final BigInt expInt = exp.integerPart;
    if (!expInt.isValidInt) {
      throw const _ResultTooLargeException();
    }
    final int exponent = expInt.toInt();
    if (_powerExceedsDigitLimit(base, exponent)) {
      throw const _ResultTooLargeException();
    }
    return base.pow(exponent);
  }

  /// Método auxiliar para agregar operaciones directas al historial
  Future<void> _addDirectOperationToHistory(String formattedExpression, String originalValue, String result) async {
    try {
      // Crear entrada de historial
      final entry = OperationEntry(
        expression: formattedExpression,
        result: result,
        timestamp: DateTime.now(),
      );
      
      // Agregar a la lista en memoria
      _history.insert(0, entry);
      if (_history.length > 100) {
        _history = _history.take(100).toList();
      }
      
      // Guardar en almacenamiento persistente
      await HistoryService.addOperation(entry);
      
    } catch (e) {
      // Si hay error al guardar en historial, no interrumpir la operación
  debugPrint('Error al guardar en historial: $e');
    }
  }

  // =========================
  // FUNCIONES ESPECIALES
  // =========================

  /// Función φ de Euler
  Future<void> eulerPhi() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.zero) {
        _setError('errPhiDomain');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.eulerPhi(number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        
        await _addDirectOperationToHistory('φ', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errPhi', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Primorial
  Future<void> primorial() async {
    try {
      String originalValue = _display;
      int number = _getCurrentAsBigInt().toInt();
      if (number < 0) {
        _setError('errPrimorialDomain');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.primorial(number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        
        await _addDirectOperationToHistory('#', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errPrimorial', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Cantidad de divisores σ₀(n)
  Future<void> divisorCount() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.zero) {
        _setError('errSigma0Domain');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.divisorCount(number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        
        await _addDirectOperationToHistory('σ₀', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errSigma0', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Suma de divisores σ(m,n) - requiere dos valores
  Future<void> divisorSum() async {
    // Esta función requiere implementación de entrada de dos valores
    // Por simplicidad, usaremos σ(1,n) por defecto
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.zero) {
        _setError('errSigmaDomain');
        _display = 'Error';
      } else {
        BigDecimal result = SpecialFunctionsService.divisorSum(1, number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        
        await _addDirectOperationToHistory('σ(1,n)', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errSigma', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// MCD función - requiere múltiples valores (por simplicidad, usamos el análisis actual)
  // ====================================================================
  // FUNCIONES DE N PARÁMETROS — Sistema genérico
  // ====================================================================

  /// MCD de N números (variable, mínimo 2)
  void gcdFunction() {
    _startPending(PendingOperation(
      name: 'gcd', symbol: 'MCD', minParams: 2,
      displayBuilder: (p) => 'MCD(${p.join(", ")}, _) [= agregar, MCD resolver]',
    ));
  }

  /// MCM de N números (variable, mínimo 2)
  void lcmFunction() {
    _startPending(PendingOperation(
      name: 'lcm', symbol: 'MCM', minParams: 2,
      displayBuilder: (p) => 'MCM(${p.join(", ")}, _) [= agregar, MCM resolver]',
    ));
  }

  /// Ecuación diofántica ax + by = c (3 parámetros fijos)
  void diophantineFunction() {
    _startPending(PendingOperation(
      name: 'dioph', symbol: 'Diof', requiredParams: 3,
      displayBuilder: (p) {
        if (p.isEmpty) return 'Diof: a=_';
        if (p.length == 1) return '${p[0]}x + _y = ?';
        if (p.length == 2) return '${p[0]}x + ${p[1]}y = _';
        return '${p[0]}x + ${p[1]}y = ${p[2]}';
      },
    ));
  }

  /// TCR de N congruencias (variable, pares aᵢ,mᵢ, mínimo 4 = 2 pares)
  void crtFunction() {
    _startPending(PendingOperation(
      name: 'crt', symbol: 'TCR', minParams: 4,
      displayBuilder: (p) {
        List<String> pairs = [];
        for (int i = 0; i + 1 < p.length; i += 2) {
          pairs.add('x≡${p[i]}(mod ${p[i + 1]})');
        }
        String collected = pairs.join(', ');
        if (p.length.isEven) {
          return '$collected, x≡_(mod ?) [= agregar, TCR resolver]';
        } else {
          return '$collected, x≡${p.last}(mod _)';
        }
      },
    ));
  }

  /// Medias de N números (variable, mínimo 2)
  void arithmeticMeanN() {
    _startPending(PendingOperation(
      name: 'meanA', symbol: 'MedA', minParams: 2,
      displayBuilder: (p) => 'MedA(${p.join(", ")}, _) [= agregar, MedA resolver]',
    ));
  }
  void geometricMeanN() {
    _startPending(PendingOperation(
      name: 'meanG', symbol: 'MedG', minParams: 2,
      displayBuilder: (p) => 'MedG(${p.join(", ")}, _) [= agregar, MedG resolver]',
    ));
  }
  void harmonicMeanN() {
    _startPending(PendingOperation(
      name: 'meanH', symbol: 'MedH', minParams: 2,
      displayBuilder: (p) => 'MedH(${p.join(", ")}, _) [= agregar, MedH resolver]',
    ));
  }
  void quadraticMeanN() {
    _startPending(PendingOperation(
      name: 'meanQ', symbol: 'MedQ', minParams: 2,
      displayBuilder: (p) => 'MedQ(${p.join(", ")}, _) [= agregar, MedQ resolver]',
    ));
  }
  void minimumN() {
    _startPending(PendingOperation(
      name: 'minN', symbol: 'min', minParams: 2,
      displayBuilder: (p) => 'min(${p.join(", ")}, _) [= agregar, min resolver]',
    ));
  }
  void maximumN() {
    _startPending(PendingOperation(
      name: 'maxN', symbol: 'max', minParams: 2,
      displayBuilder: (p) => 'max(${p.join(", ")}, _) [= agregar, max resolver]',
    ));
  }

  /// Función piso y techo (alternará entre ambas)
  Future<void> floorCeil() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      BigDecimal number = BigDecimal.fromString(currentNumber);
      
      // Alternar entre piso y techo
      if (_lastResult.contains('⌊')) {
        // Calcular techo
        BigInt result = SpecialFunctionsService.ceiling(number);
        _display = _formatNumber(result.toString());
        _lastResult = _display;
        _updateAnalysis();
        
        await _addDirectOperationToHistory('⌈⌉', originalValue, _display);
      } else {
        // Calcular piso
        BigInt result = SpecialFunctionsService.floor(number);
        _display = _formatNumber(result.toString());
        _lastResult = _display;
        _updateAnalysis();
        
        await _addDirectOperationToHistory('⌊⌋', originalValue, _display);
      }
    } catch (e) {
      _setError('errFloorCeil', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Función μ de Möbius
  Future<void> moebiusMu() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.zero) {
        _setError('errMobiusDomain');
        _display = 'Error';
      } else {
        int result = SpecialFunctionsService.moebiusMu(number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        
        await _addDirectOperationToHistory('μ', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errMobius', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Función mod: a mod b (2 params fijos)
  void modFunction() {
    _startPending(PendingOperation(name: 'mod', symbol: 'mod', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'mod _' : '${p[0]} mod _'));
  }
  /// Valuación p-ádica Vp(n) (2 params fijos)
  void pAdicValuation() {
    _startPending(PendingOperation(name: 'Vp', symbol: 'Vₚ', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'Vₚ(_)' : 'V_(${p[0]}) p=_'));
  }
  /// Combinaciones C(n,k) (2 params fijos)
  void combinations() {
    _startPending(PendingOperation(name: 'C', symbol: 'C', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'C(_,_)' : 'C(${p[0]}, _)'));
  }
  /// Variaciones V(n,k) (2 params fijos)
  void variations() {
    _startPending(PendingOperation(name: 'V', symbol: 'V', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'V(_,_)' : 'V(${p[0]}, _)'));
  }
  /// Inverso modular a⁻¹ mod n (2 params fijos)
  void modularInverse() {
    _startPending(PendingOperation(name: 'modinv', symbol: 'a⁻¹mod', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'a⁻¹ mod _' : '${p[0]}⁻¹ mod _'));
  }
  /// Exponenciación modular a^b mod n (3 params fijos)
  void modPowFunction() {
    _startPending(PendingOperation(name: 'modpow', symbol: 'a%n', requiredParams: 3,
      displayBuilder: (p) {
        if (p.isEmpty) return 'a mod n: a=_';
        if (p.length == 1) return '${p[0]} mod _';
        if (p.length == 2) return '${p[0]}^${p[1]} mod _';
        return '${p[0]}^${p[1]} mod ${p[2]}';
      }));
  }
  /// Orden multiplicativo ord_n(a) (2 params fijos)
  void multiplicativeOrder() {
    _startPending(PendingOperation(name: 'ord', symbol: 'ord', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'ord: a=_' : 'ord_(${p[0]}) n=_'));
  }
  /// Símbolo de Legendre (a/p) (2 params fijos)
  void legendreSymbol() {
    _startPending(PendingOperation(name: 'legendre', symbol: '(a/p)', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? '(a/p): a=_' : '(${p[0]}/_)'));
  }
  /// Símbolo de Jacobi (a/n) (2 params fijos)
  void jacobiSymbol() {
    _startPending(PendingOperation(name: 'jacobi', symbol: '(a/n)ⱼ', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? '(a/n)ⱼ: a=_' : '(${p[0]}/_)ⱼ'));
  }
  /// Stirling segunda especie S(n,k) (2 params fijos)
  void stirlingSecond() {
    _startPending(PendingOperation(name: 'stirling2', symbol: 'S₂', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'S₂(_,_)' : 'S₂(${p[0]}, _)'));
  }
  /// Stirling primera especie |s(n,k)| (2 params fijos)
  void stirlingFirst() {
    _startPending(PendingOperation(name: 'stirling1', symbol: 's₁', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 's₁(_,_)' : 's₁(${p[0]}, _)'));
  }
  /// Suma de dígitos en base b (2 params fijos)
  void digitSumBase() {
    _startPending(PendingOperation(name: 'digsum', symbol: 'ΣdígB', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'ΣdígB: n=_' : 'Σdíg_b(${p[0]}) b=_'));
  }

  // ====================================================================
  // SISTEMA GENÉRICO DE OPERACIÓN PENDIENTE (N parámetros)
  // ====================================================================

  /// Inicia una operación pendiente. El primer param es el número actual en display.
  void _startPending(PendingOperation op) {
    // Si ya hay una operación pendiente VARIABLE del mismo tipo → agregar param y ejecutar
    if (_pending != null && _pending!.isVariable && _pending!.name == op.name) {
      // Agregar el número actual como parámetro adicional
      String currentNumber = _getCurrentNumber();
      if (currentNumber == '0' && _lastResult.isNotEmpty) {
        currentNumber = _lastResult;
      }
      _pending = _pending!.addParam(currentNumber);
      if (_pending!.canExecute) {
        _executeOperation(_pending!);
        return;
      }
      // Aún no hay suficientes, seguir esperando
      _display = '0';
      notifyListeners();
      return;
    }

    String currentNumber = _getCurrentNumber();
    if (currentNumber == '0' && _lastResult.isNotEmpty) {
      currentNumber = _lastResult;
    }

    _pending = op.addParam(currentNumber);
    _display = '0';
    _hasError = false;
    _errorMessage = '';
    _errorArgs = {};
    notifyListeners();
  }

  /// Agrega un parámetro y ejecuta si la operación está completa (fija).
  /// Para variable-param, = agrega el param; presionar la función otra vez ejecuta.
  void _addParamAndMaybeExecute() {
    if (_pending == null) return;

    String value = _getCurrentNumber();
    _pending = _pending!.addParam(value);

    if (_pending!.isComplete) {
      // Parámetros fijos completos → ejecutar automáticamente
      _executeOperation(_pending!);
    } else {
      // Más parámetros necesarios → resetear display y esperar
      _display = '0';
      notifyListeners();
    }
  }

  /// Ejecuta la operación con los parámetros recolectados.
  void _executeOperation(PendingOperation op) {
    List<String> p = op.params;
    _pending = null;

    try {
      String resultStr;
      String historyLabel;

      switch (op.name) {
        // --- 2 params fijos ---
        case 'mod':
          resultStr = _fmt(SpecialFunctionsService.mod(_parseStringAsBigInt(p[0]), _parseStringAsBigInt(p[1])));
          historyLabel = '${p[0]} mod ${p[1]}';
          break;
        case 'Vp':
          resultStr = _fmt(BigInt.from(SpecialFunctionsService.pAdicValuation(_parseStringAsBigInt(p[0]), _parseStringAsBigInt(p[1]))));
          historyLabel = 'V${p[1]}(${p[0]})';
          break;
        case 'C':
          resultStr = _fmt(SpecialFunctionsService.combinations(_parseStringAsInt(p[0]), _parseStringAsInt(p[1])));
          historyLabel = 'C(${p[0]},${p[1]})';
          break;
        case 'V':
          resultStr = _fmt(SpecialFunctionsService.variations(_parseStringAsInt(p[0]), _parseStringAsInt(p[1])));
          historyLabel = 'V(${p[0]},${p[1]})';
          break;
        case 'modinv':
          BigInt? inv = SpecialFunctionsService.modularInverse(_parseStringAsBigInt(p[0]), _parseStringAsBigInt(p[1]));
          if (inv == null) { _showError('errNoInverse', {'a': p[0], 'n': p[1]}); return; }
          resultStr = _fmt(inv);
          historyLabel = '${p[0]}⁻¹ mod ${p[1]}';
          break;
        case 'ord':
          resultStr = _fmt(SpecialFunctionsService.multiplicativeOrder(_parseStringAsBigInt(p[0]), _parseStringAsBigInt(p[1])));
          historyLabel = 'ord${p[1]}(${p[0]})';
          break;
        case 'legendre':
          resultStr = _fmt(BigInt.from(SpecialFunctionsService.legendreSymbol(_parseStringAsBigInt(p[0]), _parseStringAsBigInt(p[1]))));
          historyLabel = '(${p[0]}/${p[1]})';
          break;
        case 'jacobi':
          resultStr = _fmt(BigInt.from(SpecialFunctionsService.jacobiSymbol(_parseStringAsBigInt(p[0]), _parseStringAsBigInt(p[1]))));
          historyLabel = '(${p[0]}/${p[1]})ⱼ';
          break;
        case 'stirling2':
          resultStr = _fmt(SpecialFunctionsService.stirlingSecond(_parseStringAsInt(p[0]), _parseStringAsInt(p[1])));
          historyLabel = 'S₂(${p[0]},${p[1]})';
          break;
        case 'stirling1':
          resultStr = _fmt(SpecialFunctionsService.stirlingFirst(_parseStringAsInt(p[0]), _parseStringAsInt(p[1])));
          historyLabel = 's₁(${p[0]},${p[1]})';
          break;
        case 'digsum':
          resultStr = _fmt(SpecialFunctionsService.digitSumInBase(_parseStringAsBigInt(p[0]), _parseStringAsInt(p[1])));
          historyLabel = 'Σdíg_${p[1]}(${p[0]})';
          break;

        // --- 3 params fijos ---
        case 'modpow':
          resultStr = _fmt(SpecialFunctionsService.modPow(_parseStringAsBigInt(p[0]), _parseStringAsBigInt(p[1]), _parseStringAsBigInt(p[2])));
          historyLabel = '${p[0]}^${p[1]} mod ${p[2]}';
          break;
        case 'dioph':
          Map<String, dynamic> dr = SpecialFunctionsService.solveDiophantine(_parseStringAsBigInt(p[0]), _parseStringAsBigInt(p[1]), _parseStringAsBigInt(p[2]));
          if (dr['solvable'] != true) { _showError('errNoSolution'); return; }
          resultStr = dr['note'] ?? 'Solución encontrada';
          historyLabel = '${p[0]}x+${p[1]}y=${p[2]}';
          break;

        // --- Variable: MCD/MCM de N números ---
        case 'gcd':
          BigInt r = p.map(_parseStringAsBigInt).reduce(SpecialFunctionsService.gcd);
          resultStr = _fmt(r);
          historyLabel = 'MCD(${p.join(",")})';
          break;
        case 'lcm':
          BigInt r = p.map(_parseStringAsBigInt).reduce(SpecialFunctionsService.lcm);
          resultStr = _fmt(r);
          historyLabel = 'MCM(${p.join(",")})';
          break;

        // --- Variable: TCR con N pares ---
        case 'crt':
          if (p.length < 4 || p.length.isOdd) { _showError('errCRTNeedPairs'); return; }
          List<BigInt> remainders = [];
          List<BigInt> moduli = [];
          for (int i = 0; i < p.length; i += 2) {
            remainders.add(_parseStringAsBigInt(p[i]));
            moduli.add(_parseStringAsBigInt(p[i + 1]));
          }
          Map<String, dynamic> cr = SpecialFunctionsService.chineseRemainderTheorem(remainders, moduli);
          if (cr['solvable'] != true) { _showError('errIncompatibleSystem'); return; }
          resultStr = cr['note'] ?? cr['solution'].toString();
          historyLabel = 'TCR(${remainders.length} congruencias)';
          _display = resultStr;
          _lastResult = cr['solution'].toString();
          _updateAnalysis();
          _addDirectOperationToHistory(historyLabel, p.join(','), resultStr);
          notifyListeners();
          return;

        // --- Variable: Medias de N números ---
        case 'meanA':
          List<BigDecimal> nums = p.map((s) => BigDecimal.fromString(s)).toList();
          resultStr = _formatNumber(SpecialFunctionsService.arithmeticMean(nums).toString());
          historyLabel = 'MedA(${p.join(",")})';
          break;
        case 'meanG':
          List<BigDecimal> nums = p.map((s) => BigDecimal.fromString(s)).toList();
          resultStr = _formatNumber(SpecialFunctionsService.geometricMean(nums).toString());
          historyLabel = 'MedG(${p.join(",")})';
          break;
        case 'meanH':
          List<BigDecimal> nums = p.map((s) => BigDecimal.fromString(s)).toList();
          resultStr = _formatNumber(SpecialFunctionsService.harmonicMean(nums).toString());
          historyLabel = 'MedH(${p.join(",")})';
          break;
        case 'meanQ':
          List<BigDecimal> nums = p.map((s) => BigDecimal.fromString(s)).toList();
          resultStr = _formatNumber(SpecialFunctionsService.quadraticMean(nums).toString());
          historyLabel = 'MedQ(${p.join(",")})';
          break;
        case 'minN':
          List<BigDecimal> nums = p.map((s) => BigDecimal.fromString(s)).toList();
          resultStr = _formatNumber(SpecialFunctionsService.minimum(nums).toString());
          historyLabel = 'min(${p.join(",")})';
          break;
        case 'maxN':
          List<BigDecimal> nums = p.map((s) => BigDecimal.fromString(s)).toList();
          resultStr = _formatNumber(SpecialFunctionsService.maximum(nums).toString());
          historyLabel = 'max(${p.join(",")})';
          break;

        default:
          _showError('errUnknownOp', {'op': op.name});
          return;
      }

      _display = resultStr;
      _lastResult = resultStr;
      _updateAnalysis();
      _addDirectOperationToHistory(historyLabel, p.join(','), resultStr);
    } catch (e) {
      _showError('errGeneric', {'error': e.toString()});
    }
    notifyListeners();
  }

  /// Helper: formatea un BigInt para display
  String _fmt(BigInt value) => _formatNumber(value.toString());

  /// Helper: muestra error y notifica
  void _showError(String key, [Map<String, String> args = const {}]) {
    _hasError = true;
    _errorMessage = key;
    _errorArgs = args;
    _display = 'Error';
    notifyListeners();
  }

  void _setError(String key, [Map<String, String> args = const {}]) {
    _hasError = true;
    _errorMessage = key;
    _errorArgs = args;
  }

  /// Ruta de alta precisión para funciones transcendentes. Si el modo está
  /// activo, ejecuta la operación [op] en un **isolate** (vía `compute`) para no
  /// congelar la UI, mostrando el overlay de carga. Muestra el resultado y lo
  /// registra; ante un fallo (singularidad/divergencia) muestra la clave de
  /// error localizada sin filtrar la excepción. Devuelve `true` si manejó la
  /// operación (el llamador debe `return`), `false` si el modo está desactivado
  /// (seguir por la ruta `double`).
  Future<bool> _tryHighPrecision(String op, String value,
      {bool degrees = false,
      required String historyExpr,
      required String originalValue}) async {
    if (!PrecisionService.isEnabled) return false;

    _isCalculatingOperation = true;
    _operationProgress = ''; // el overlay usa el texto localizado por defecto
    _canCancelOperation = false;
    notifyListeners();

    try {
      final Map<String, dynamic> res =
          await compute(precisionWorker, <String, dynamic>{
        'op': op,
        'value': value,
        'degrees': degrees,
        'digits': SettingsService.getPrecisionDigits(),
      });

      if (res['ok'] == true) {
        final String resultStr = res['result'] as String;
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        await _addDirectOperationToHistory(historyExpr, originalValue, resultStr);
      } else {
        _setError(res['errorKey'] as String);
        _display = 'Error';
      }
    } catch (_) {
      _setError('errResultInvalid');
      _display = 'Error';
    } finally {
      _isCalculatingOperation = false;
      _operationProgress = '';
      notifyListeners();
    }
    return true;
  }

  // ====================================================================
  // FUNCIONES DE 1 PARÁMETRO NUEVAS
  // ====================================================================

  /// Factorial n!
  Future<void> factorialFunction() async {
    try {
      String originalValue = _display;
      int n = _getCurrentAsInt();
      if (n < 0) {
        _setError('errFactorialNeg');
        _display = 'Error';
      } else if (n > 10000) {
        _setError('errFactorialMax');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.factorial(n);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        await _addDirectOperationToHistory('!', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errFactorialN', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Doble factorial n!!
  Future<void> doubleFactorialFunction() async {
    try {
      String originalValue = _display;
      int n = _getCurrentAsInt();
      if (n < 0) {
        _setError('errDoubleFactorialNeg');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.doubleFactorial(n);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        await _addDirectOperationToHistory('!!', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errDoubleFactorial', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// n-ésimo Fibonacci F(n)
  Future<void> fibonacciN() async {
    try {
      String originalValue = _display;
      int n = _getCurrentAsInt();
      if (n < 0) {
        _setError('errFibonacciNeg');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.fibonacci(n);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        await _addDirectOperationToHistory('F', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errFibonacci', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// n-ésimo número de Catalan
  Future<void> catalanNumber() async {
    try {
      String originalValue = _display;
      int n = _getCurrentAsInt();
      if (n < 0) {
        _setError('errCatalanNeg');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.catalanNumber(n);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        await _addDirectOperationToHistory('Cat', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errCatalan', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Derangements D(n)
  Future<void> derangementFunction() async {
    try {
      String originalValue = _display;
      int n = _getCurrentAsInt();
      if (n < 0) {
        _setError('errDerangementNeg');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.derangement(n);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        await _addDirectOperationToHistory('D', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errDerangement', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Particiones p(n)
  Future<void> partitionFunction() async {
    try {
      String originalValue = _display;
      int n = _getCurrentAsInt();
      if (n < 0) {
        _setError('errPartitionNeg');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.partition(n);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        await _addDirectOperationToHistory('p', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errPartition', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Números de Bell B(n)
  Future<void> bellNumber() async {
    try {
      String originalValue = _display;
      int n = _getCurrentAsInt();
      if (n < 0) {
        _setError('errBellNeg');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.bellNumber(n);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        await _addDirectOperationToHistory('Bell', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errBell', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Raíz digital
  Future<void> digitalRoot() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      int result = SpecialFunctionsService.digitalRoot(number);
      String resultStr = _formatNumber(result.toString());
      _display = resultStr;
      _lastResult = resultStr;
      _updateAnalysis();
      await _addDirectOperationToHistory('dr', originalValue, resultStr);
    } catch (e) {
      _setError('errDigitalRoot', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Encontrar raíz primitiva
  Future<void> primitiveRoot() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.one) {
        _setError('errPrimitiveRootDomain');
        _display = 'Error';
      } else {
        BigInt? result = SpecialFunctionsService.findPrimitiveRoot(number);
        if (result == null) {
          _setError('errNoPrimitiveRoot', {'n': number.toString()});
          _display = 'Error';
        } else {
          String resultStr = _formatNumber(result.toString());
          _display = resultStr;
          _lastResult = resultStr;
          _updateAnalysis();
          await _addDirectOperationToHistory('g mod', originalValue, resultStr);
        }
      }
    } catch (e) {
      _setError('errGeneric', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Función de Liouville λ_L(n)
  Future<void> liouvilleFunction() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.zero) {
        _setError('errLiouvilleDomain');
        _display = 'Error';
      } else {
        int result = SpecialFunctionsService.liouvilleFunction(number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        await _addDirectOperationToHistory('λL', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errLiouville', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// π(n) - Función contadora de primos
  Future<void> primeCountingFunction() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number < BigInt.two) {
        _display = '0';
        _lastResult = '0';
      } else {
        var result = SpecialFunctionsService.primeCountingFunction(number);
        String resultStr = result['count'].toString();
        String suffix = result['exact'] == true ? '' : ' (aprox)';
        _display = _formatNumber(resultStr);
        _lastResult = resultStr;
        _updateAnalysis();
        await _addDirectOperationToHistory('π$suffix', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errPrimeCounting', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  // --- Las funciones antiguas de 2 parámetros con valores fijos, reemplazadas arriba ---
  // modFunction(), pAdicValuation(), combinations(), variations(), modularInverse()
  // ahora usan el sistema de operación pendiente

  // Las funciones de media aritmética, geométrica, armónica y cuadrática
  // ahora usan el sistema N-parámetros: arithmeticMeanN(), geometricMeanN(), etc.

  /// Radical (función ABC)
  Future<void> radical() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.zero) {
        _setError('errRadDomain');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.radical(number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        
        await _addDirectOperationToHistory('rad', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errRad', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// ω(n) - Número de factores primos distintos
  Future<void> smallOmega() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.zero) {
        _setError('errOmegaDomain');
        _display = 'Error';
      } else {
        int result = SpecialFunctionsService.smallOmega(number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        await _addDirectOperationToHistory('ω', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errOmega', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Ω(n) - Número de factores primos con multiplicidad
  Future<void> bigOmega() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.zero) {
        _setError('errBigOmegaDomain');
        _display = 'Error';
      } else {
        int result = SpecialFunctionsService.bigOmega(number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        await _addDirectOperationToHistory('Ω', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errBigOmega', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// λ(n) - Función de Carmichael
  Future<void> carmichaelLambda() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.zero) {
        _setError('errCarmichaelDomain');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.carmichaelLambda(number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        await _addDirectOperationToHistory('λ', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errCarmichael', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// sopfr(n) - Suma de factores primos con repetición
  Future<void> sopfrFunction() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.zero) {
        _setError('errSopfrDomain');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.sopfr(number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        await _addDirectOperationToHistory('sopfr', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errSopfr', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// sopf(n) - Suma de factores primos distintos
  Future<void> sopfFunction() async {
    try {
      String originalValue = _display;
      BigInt number = _getCurrentAsBigInt();
      if (number <= BigInt.zero) {
        _setError('errSopfDomain');
        _display = 'Error';
      } else {
        BigInt result = SpecialFunctionsService.sopf(number);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        await _addDirectOperationToHistory('sopf', originalValue, resultStr);
      }
    } catch (e) {
      _setError('errSopf', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  // Las funciones minimum() y maximum() ahora usan el sistema N-parámetros:
  // minimumN() y maximumN()

  /// Función porcentaje - calcula el porcentaje del valor actual
  Future<void> percentage() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      if (currentNumber.isEmpty || currentNumber == '0') {
        _display = '0';
        return;
      }
      
      BigDecimal value = BigDecimal.fromString(currentNumber);
      BigDecimal result = value / BigDecimal.fromString('100');
      String resultStr = _formatNumber(result.toString());
      
      _display = resultStr;
      _lastResult = resultStr;
      _updateAnalysis();
      
      await _addDirectOperationToHistory('%', originalValue, resultStr);
    } catch (e) {
      _setError('errPercentage', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }

  /// Función recíproco - calcula 1/x
  Future<void> reciprocal() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      if (currentNumber.isEmpty || currentNumber == '0') {
        _setError('errDivisionByZero');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      BigDecimal value = BigDecimal.fromString(currentNumber);
      if (value.isZero) {
        _setError('errDivisionByZero');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      BigDecimal result = BigDecimal.one / value;
      String resultStr = _formatNumber(result.toString());
      
      _display = resultStr;
      _lastResult = resultStr;
      _updateAnalysis();
      
      await _addDirectOperationToHistory('1/x', originalValue, resultStr);
    } catch (e) {
      _setError('errReciprocal', {'error': e.toString()});
      _display = 'Error';
    }
    notifyListeners();
  }
}

/// Señala que un resultado exacto (p. ej. una potencia) tendría demasiados
/// dígitos para computarse; se traduce a "errResultTooLarge".
class _ResultTooLargeException implements Exception {
  const _ResultTooLargeException();
}
