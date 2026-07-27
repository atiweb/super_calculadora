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

/// Main calculator service
class CalculatorService extends ChangeNotifier {
  String _display = '0';
  String _lastResult = '';
  Map<String, dynamic> _currentAnalysis = {};
  bool _hasError = false;
  String _errorMessage = '';
  Map<String, String> _errorArgs = {};
  bool _isCalculatingPrimes = false;
  // Analysis generation token: isolate analyses can finish
  // out of order and overwrite the current number's analysis with a stale one.
  int _analysisToken = 0;
  bool _isCalculatingOperation = false;
  String _operationProgress = '';
  bool _canCancelOperation = false;
  CalculatorType _calculatorType = CalculatorType.standard;
  bool _isRadianMode = false; // false = degrees, true = radians
  
  // New properties for full expressions and history
  final TextEditingController _expressionController = TextEditingController();
  List<OperationEntry> _history = [];
  bool _isHistoryVisible = false;
  
  // Memory variables for the MC, MR, M+, M-, MS functions
  BigDecimal _memoryValue = BigDecimal.zero;
  bool _hasMemoryValue = false;

  // Generic pending-operation system for N parameters
  PendingOperation? _pending;
  
  // Existing getters
  String get display => _display;
  // Make 'expression' reflect what the user sees on screen
  // to keep compatibility with tests that inspect this property.
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
  
  // New getters for expressions and history
  TextEditingController get expressionController => _expressionController;
  List<OperationEntry> get history => _history;
  bool get isHistoryVisible => _isHistoryVisible;
  
  // Getters for memory
  bool get hasMemoryValue => _hasMemoryValue;
  String get memoryValueDisplay => _hasMemoryValue ? _memoryValue.toString() : '0';

  // Getters for pending operation
  bool get hasPendingOperation => _pending != null;
  String get pendingDisplayLabel => _pending?.buildDisplayLabel() ?? '';
  PendingOperation? get pendingOperation => _pending;
  
  /// Gets the last operation performed
  OperationEntry? get lastOperation => _history.isNotEmpty ? _history.first : null;
  
  // Constructor
  CalculatorService() {
    _loadHistory();
    // The UI (expression tab buttons) derives its enabled state
    // from the controller's text; when typing directly into the TextField nobody
    // notified and the buttons were left with stale state.
    _expressionController.addListener(notifyListeners);
  }

  /// Changes the calculator type
  void setCalculatorType(CalculatorType type) {
    _calculatorType = type;
    CalculatorConfig.setCalculatorType(type);
    notifyListeners();
  }

  /// Toggles between degrees and radians
  void toggleAngleMode() {
    _isRadianMode = !_isRadianMode;
    notifyListeners();
  }

  /// Clears everything
  void clear() {
    _display = '0';
    _lastResult = '';
    _analysisToken++; // discard in-flight analysis
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

  /// Clears only the display
  void clearEntry() {
    _display = '0';
    _hasError = false;
    _errorMessage = '';
    _errorArgs = {};
    _isCalculatingPrimes = false;
    _isCalculatingOperation = false;
    _operationProgress = '';
    _canCancelOperation = false;
    // The display went back to '0': also clear the analysis so the panel
    // doesn't keep showing the previous number.
    _updateAnalysis();
    notifyListeners();
  }

  /// Gets the current number on the display (the last number without operators)
  String _getCurrentNumber() {
    if (_display.isEmpty || _display == '0') {
      return '0';
    }

    // Find the last number in the expression
    RegExp numberRegex = RegExp(r'(-?\d*\.?\d+)$');
    Match? match = numberRegex.firstMatch(_display);

    if (match != null) {
      return match.group(0)!;
    }

    return '0';
  }

  /// Parses the current number as BigInt, truncating the decimal part if any.
  /// This lets number theory functions be used after decimal calculations.
  BigInt _getCurrentAsBigInt() {
    return _parseStringAsBigInt(_getCurrentNumber());
  }

  /// Parses a string as BigInt, truncating decimals if any.
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

  /// Parses a string as int, truncating decimals if any.
  /// Throws if the value doesn't fit in an int: `BigInt.toInt()` wraps at 64 bits
  /// and would turn 2⁶⁴+2 into 2 without any error.
  static int _parseStringAsInt(String numStr) {
    final BigInt value = _parseStringAsBigInt(numStr);
    if (!value.isValidInt) {
      throw ArgumentError(trLocale('Número demasiado grande', 'Number too large'));
    }
    return value.toInt();
  }

  /// Current display number as int, with the same range validation.
  int _getCurrentAsInt() => _parseStringAsInt(_getCurrentNumber());

  /// Checks whether the display ends with an operator
  bool _endsWithOperator() {
    if (_display.isEmpty) return false;
    String trimmed = _display.trim();
    return trimmed.endsWith('+') || trimmed.endsWith('-') || 
           trimmed.endsWith('×') || trimmed.endsWith('÷') || 
           trimmed.endsWith('^') || trimmed.endsWith('(');
  }

  /// Checks whether the display ends with a number
  bool _endsWithNumber() {
    if (_display.isEmpty) return false;
    String trimmed = _display.trim();
    return RegExp(r'[\d.]$').hasMatch(trimmed);
  }

  /// Adds a digit to the display
  void addDigit(String digit) {
    if (_hasError) {
      clear();
    }
    
    // If the display is '0' and it's not a decimal point, replace it
    if (_display == '0' && digit != '.') {
      _display = digit;
    } else if (digit == '.' && _display.contains('.')) {
      // Check whether the current number already has a decimal point
      String currentNumber = _getCurrentNumber();
      if (currentNumber.contains('.')) {
        return; // Don't add a duplicate decimal point to the current number
      }
      _display += digit;
    } else {
      _display += digit;
    }
    
    _updateAnalysis();
    notifyListeners();
  }

  /// Adds an operator
  void addOperator(String operator) {
    if (_hasError) {
      clear();
    }
    
    // Empty display: only '-' can start one (negative number); ignore the rest.
    if (_display.isEmpty) {
      if (operator == '-') {
        _display = '-';
        notifyListeners();
      }
      return;
    }
    // Display '0': '-' starts a negative number; the other operators treat
    // 0 as a valid operand (e.g. 0×5 = 0, 0^3 = 0) and continue below.
    if (_display == '0' && operator == '-') {
      _display = '-';
      notifyListeners();
      return;
    }
    
    // If it already ends with an operator, replace the last operator
    if (_endsWithOperator()) {
      String trimmed = _display.trim();
      // Remove the last operator and spaces
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
        // Keep everything up to before the operator (excluding the preceding space)
        _display = trimmed.substring(0, lastOperatorIndex - 1);
      } else {
        // If the operator is at the start, keep everything except the operator
        _display = trimmed.substring(0, trimmed.length - 1);
      }
    }
    
    // Add the new operator
    _display += ' $operator ';
    
    notifyListeners();
  }

  /// Calculates the result of the expression
  void calculate() {
    // If there is a pending operation, add the parameter and execute if complete
    if (_pending != null) {
      _addParamAndMaybeExecute();
      return;
    }

    if (_display.isEmpty || _display == '0') return;

    try {
      // Use the new method that correctly handles parentheses and functions
      String result = evaluateCompleteExpression(_display);
      
      // Check whether the result contains an error
      if (result.startsWith('err:')) {
        String errPart = result.substring(4); // remove 'err:'
        if (errPart.startsWith('errGeneric:')) {
          _setError('errGeneric', {'error': errPart.substring(11)});
        } else {
          _setError(errPart);
        }
        _display = 'Error';
      } else {
        // Add to history
        OperationEntry entry = OperationEntry(
          expression: _display,
          result: result,
        );
        
        _history.insert(0, entry);
        if (_history.length > 100) {
          _history = _history.take(100).toList();
        }
        
        // Save to persistent storage
        HistoryService.addOperation(entry);
        
        // Show the result
        _display = _formatNumber(result);
        _lastResult = result;
        _hasError = false;
        _errorMessage = '';
        _errorArgs = {};
  // Clear the old expression (already reflected in the display)
        
        _updateAnalysis();
      }
      
    } catch (e) {
      _setError('errGeneric', {'error': e.toString()});
      _display = 'Error';
    }

    notifyListeners();
  }

  /// Calculates power
  Future<void> power(String exponent) async {
    try {
      String originalValue = _display;
      BigDecimal base = BigDecimal.fromString(_display);
      int exp = int.parse(exponent);
      
      // Check whether the operation will be heavy
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
            
            // Record in history
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
        // Direct calculation for small operations
        BigDecimal result = base.pow(exp);
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        
        // Record in history
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

  /// Calculates square root
  Future<void> squareRoot() async {
    try {
      String originalValue = _display;
      BigDecimal number = BigDecimal.fromString(_display);

      // Root of a negative: clear localized message (don't leak the exception).
      if (number.isNegative) {
        _setError('errNegativeSqrt');
        _display = 'Error';
        notifyListeners();
        return;
      }

      // Check whether the operation will be heavy (very large numbers)
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
            
            // Record in history
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
        // Direct calculation for small/medium numbers
        BigDecimal result = number.sqrt();
        String resultStr = _formatNumber(result.toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        // Record in history
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

  /// Calculates cube root
  Future<void> cubeRoot() async {
    try {
      String originalValue = _display;
      BigDecimal number = BigDecimal.fromString(_display);
      
      // Check whether the operation will be heavy (very large numbers)
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
            
            // Record in history
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
        // Direct calculation for small/medium numbers (exact over
        // integers; the double approximation degraded from ~16 digits)
        String resultStr = _formatNumber(number.cbrt().toString());
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();

        // Record in history
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

  /// Converts to binary
  Future<void> toBinary() async {
    try {
      String originalValue = _display;
      BigDecimal number = BigDecimal.fromString(_display);
      String binary = number.toBinary();
      
      _display = binary;
      _lastResult = _display;
      
      // Record in history
  await _addDirectOperationToHistory('$originalValue → BIN', originalValue, binary);
      
    } catch (e) {
      _setError('errBinaryConversion', {'error': e.toString()});
      _display = 'Error';
    }

    notifyListeners();
  }

  /// Converts from binary to decimal
  Future<void> fromBinary() async {
    try {
      String originalValue = _display;
      String binary = _display;
      // Remove the 0b prefix if present
      if (binary.startsWith('0b')) {
        binary = binary.substring(2);
      }
      
      // Validate that the number is not empty
      if (binary.isEmpty) {
        _setError('errEmptyBinary');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      // Validate that the number contains only binary digits (0 and 1)
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
      
      // Record in history
  await _addDirectOperationToHistory('$originalValue → DEC', originalValue, decimalStr);
      
    } catch (e) {
      _setError('errBinaryFromConversion', {'error': e.toString()});
      _display = 'Error';
    }

    notifyListeners();
  }

  /// Deletes the last character or element
  void backspace() {
    if (_hasError) {
      clear();
      return;
    }
    
    if (_display.isEmpty || _display == '0') {
      return;
    }
    
    // If the display has more than one character
    if (_display.length > 1) {
      // If it ends with a space, remove the whole operator (e.g. " + ")
      if (_display.endsWith(' ')) {
        // Find the last operator and remove it
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
          // Remove starting at the space before the operator
          _display = _display.substring(0, lastOperatorIndex - 1);
        } else {
          _display = _display.substring(0, _display.length - 1);
        }
      } else {
        // Remove the last character
        _display = _display.substring(0, _display.length - 1);
        
        // If it is empty after removing, set '0'
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

  /// Toggles the sign of the number
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

  /// Adds an opening parenthesis
  void addOpenParenthesis() {
    if (_hasError) {
      clear();
    }

    // If the display is empty or '0', add an opening parenthesis
    if (_display == '0' || _display.isEmpty) {
      _display = '(';
    } else if (_endsWithNumber()) {
      // If it ends with a number, add implicit multiplication
      _display += ' × (';
    } else {
      // If it ends with an operator, add the parenthesis directly
      _display += '(';
    }

    notifyListeners();
  }

  /// Adds a closing parenthesis
  void addCloseParenthesis() {
    if (_hasError) {
      clear();
    }

    // Add a closing parenthesis
    if (_display == '0' || _display.isEmpty) {
      _display = ')';
    } else {
      _display += ')';
    }

    notifyListeners();
  }

  /// Updates the analysis of the current number
  void _updateAnalysis() {
    // Invalidate any in-flight analysis, even if we return early here:
    // a stale result must not overwrite the current state.
    _analysisToken++;
    if (_hasError || _display == '0' || _display.isEmpty || _display == 'Error') {
      _currentAnalysis = {};
      return;
    }

    // Only run the analysis if the display contains just a number
    String currentNumber = _getCurrentNumber();
    if (currentNumber == '0' || currentNumber.isEmpty || currentNumber.length < _display.length) {
      // The display contains more than just a number (operators, parentheses, etc.)
      _currentAnalysis = {};
      return;
    }

    // Mark the analysis as in progress
    _currentAnalysis = {'loading': true};
    notifyListeners();

    _performAnalysisAsync(_analysisToken);
  }

  /// Performs the analysis asynchronously. [token] identifies this request:
  /// if after each step it is no longer the current token, the result is
  /// discarded instead of overwriting the current number's analysis.
  Future<void> _performAnalysisAsync(int token) async {
    try {
      // Try to parse the number for analysis
      String numStr = _display.trim();
      
      bool isDecimal = numStr.contains('.');
      bool isNegative = numStr.startsWith('-');
      
      // For numeric property analysis, use integers only
      BigInt number;
      String analysisNote = '';
      
      if (isDecimal) {
        // Extract the integer part of the decimal number
        String integerPart;
        if (isNegative) {
          // For negatives, take the absolute value of the integer part
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
        // For integers, take the absolute value if negative
        if (isNegative) {
          number = BigInt.parse(numStr.substring(1));
          analysisNote = trLocale(
              'Análisis basado en el valor absoluto (${number.toString()})',
              'Analysis based on the absolute value (${number.toString()})');
        } else {
          number = BigInt.parse(numStr);
        }
      }
      
      // Validate that the number is valid for analysis
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
      
      // Perform basic analysis first
      Map<String, dynamic> analysis;

      if (number.toString().length > 10) {
        // The language travels in the payload: the isolate doesn't share the
        // main isolate's globals and `appIsSpanish` would fall back to its
        // default value (English).
        analysis = await compute(_analyzeNumberInIsolate, {
          'number': number,
          'isSpanish': appIsSpanish,
        });
      } else {
        analysis = NumberAnalysisService.completeAnalysis(number);
      }

      if (token != _analysisToken) return; // arrived late: discard

      // Add processing information if the original number was different
      if (analysisNote.isNotEmpty) {
        analysis['processingNote'] = analysisNote;
        analysis['originalInput'] = _display;
        analysis['processedNumber'] = number.toString();
      }

      // Update with basic analysis
      _currentAnalysis = analysis;
      notifyListeners();

      // Now compute primes asynchronously if the number is large
      if (number > BigInt.zero &&
          number.toString().length > 10 &&
          analysis['isPrime'] == false) {

        _isCalculatingPrimes = true;
        _currentAnalysis['calculatingPrimes'] = true;
        notifyListeners();

        try {
          // Compute the next prime asynchronously
          BigInt nextPrime = await NumberAnalysisService.nextPrimeAsync(number);
          if (token != _analysisToken) return;
          _currentAnalysis['nextPrime'] = nextPrime.toString();

          // Compute the previous prime asynchronously
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

      // Compute perfect squares and cubes asynchronously for large numbers
      if (number > BigInt.zero && number.toString().length > 100) {
        try {
          // Check asynchronously whether it is a perfect square
          bool isPerfectSquare = await NumberAnalysisService.isPerfectSquareAsync(number);
          if (token != _analysisToken) return;
          _currentAnalysis['isPerfectSquare'] = isPerfectSquare;

          // Check asynchronously whether it is a perfect cube
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

      // Debug: verify the analysis completed
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

  /// Static function to analyze numbers in an isolate.
  /// Receives `{number, isSpanish}`: the language must travel in the payload
  /// because globals don't cross isolates.
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

  /// Static function to compute powers in an isolate
  static Map<String, dynamic> _calculatePowerInIsolate(Map<String, dynamic> args) {
    appIsSpanish = args['isSpanish'] as bool? ?? appIsSpanish;
    try {
      BigDecimal base = BigDecimal.fromString(args['base']);
      int exponent = args['exponent'];
      
      // For very large powers, implement a cancellation check
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

  /// Static function to compute square root in an isolate.
  /// Receives `{value, isSpanish}` (the language doesn't cross isolates as a global).
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

  /// Static function to compute cube root in an isolate.
  /// Receives `{value, isSpanish}` (the language doesn't cross isolates as a global).
  static Map<String, dynamic> _calculateCubeRootInIsolate(Map<String, dynamic> args) {
    appIsSpanish = args['isSpanish'] as bool? ?? appIsSpanish;
    try {
      BigDecimal number = BigDecimal.fromString(args['value'] as String);
      // Exact over integers: the previous double-based path returned garbage
      // from ~16 digits on (and 0 for ≥ 1e21 due to scientific notation).
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

  /// Helper function to compute factorial in an isolate.
  /// Receives `{n, isSpanish}`.
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

  /// Loads a specific number for analysis
  void loadNumber(String number) {
    _display = _formatNumber(number);
  // Reset the expression (display already reset)
    _hasError = false;
    _errorMessage = '';
    _errorArgs = {};
    _updateAnalysis();
    notifyListeners();
  }

  /// Sets the display directly (for tests)
  void setDisplay(String value) {
    _display = _formatNumber(value);
    _hasError = false;
    _errorMessage = '';
    _errorArgs = {};
    _updateAnalysis();
    notifyListeners();
  }

  /// Gets specific information from the analysis
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

  /// Checks whether the current number has a given property
  bool hasProperty(String property) {
    return _currentAnalysis.containsKey(property) && 
           _currentAnalysis[property] == true;
  }

  /// Detects whether the current number is binary
  bool get isBinaryNumber {
    String current = _display;
    // Remove the 0b prefix if present
    if (current.startsWith('0b')) {
      current = current.substring(2);
    }
    
    // Check whether it contains only binary digits (0 and 1)
    return current.isNotEmpty && RegExp(r'^[01]+$').hasMatch(current);
  }

  /// Gets the appropriate text for the conversion button
  String get conversionButtonText {
    return isBinaryNumber ? 'DEC' : 'BIN';
  }

  /// Toggles between binary and decimal conversion
  void toggleBinaryDecimal() {
    if (isBinaryNumber) {
      fromBinary();
    } else {
      toBinary();
    }
  }

  // =========================
  // MEMORY FUNCTIONS
  // =========================

  /// MC (Memory Clear) - Clears the value stored in memory
  void memoryClear() {
    _memoryValue = BigDecimal.zero;
    _hasMemoryValue = false;
    notifyListeners();
  }

  /// MR (Memory Recall) - Recalls the value stored in memory to the display
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

  /// MS (Memory Store) - Stores the current display value in memory
  void memoryStore() {
    if (_hasError) return;
    
    try {
      // Get the current number from the display, preserving precision
      String currentNumber = _getCurrentNumber();
      _memoryValue = BigDecimal.fromString(currentNumber);
      _hasMemoryValue = true;
      notifyListeners();
    } catch (e) {
      // If the conversion fails, store nothing
  debugPrint('Error al almacenar en memoria: $e');
    }
  }

  /// M+ (Memory Plus) - Adds the current display value to the value in memory
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

  /// M- (Memory Minus) - Subtracts the current display value from the value in memory
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
  // SCIENTIFIC FUNCTIONS
  // =========================

  /// Converts degrees to radians
  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  /// Converts radians to degrees
  double _toDegrees(double radians) {
    return radians * 180 / math.pi;
  }

  /// Converts the input value according to the angle mode
  double _convertAngle(double value) {
    return _isRadianMode ? value : _toRadians(value);
  }

  /// Checks whether a number is safe for conversion to double (no precision loss)
  bool _isSafeForDouble(String numberStr) {
    // Allow numbers that can be parsed to double and are not infinite/NaN.
    // Only avoid magnitudes that would overflow in exp/10^x, etc.
    try {
      final v = double.parse(numberStr);
      if (v.isNaN || v.isInfinite) return false;
      // Conservative limits for exponential/trig/log operations.
      if (v.abs() > 1e12) return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Sine
  Future<void> sin() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Check whether the number is safe for conversion to double
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

      // Record in history
  await _addDirectOperationToHistory('sin($currentNumber$angleSuffixSin)', originalValue, resultStr);

    } catch (e) {
      _setError('errSin', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Cosine
  Future<void> cos() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Check whether the number is safe for conversion to double
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

      // Record in history
  await _addDirectOperationToHistory('cos($currentNumber$angleSuffixCos)', originalValue, resultStr);

    } catch (e) {
      _setError('errCos', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Tangent
  Future<void> tan() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Check whether the number is safe for conversion to double
      if (!_isSafeForDouble(currentNumber)) {
        _setError('errTrigTooLarge');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      double value = double.parse(currentNumber);
      double angleInRadians = _convertAngle(value);

      // tan(θ) = sin(θ)/cos(θ) has poles where cos(θ) = 0 (90°, 270°, −90°,
      // π/2 + kπ…). Due to π rounding, math.tan doesn't return exact
      // `Infinity` at those points but a huge number (e.g. 1.6e16 at 90°).
      // We detect the pole via the DENOMINATOR (cos ≈ 0): it is general for
      // all poles, not a special case for 90°. The 1e-12 threshold separates
      // the true pole from the (large but legitimate) value of a nearby angle
      // the user could actually have typed. This check goes BEFORE the
      // high-precision path to avoid the constructive reals' timeout (3 s)
      // at the exact pole.
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

        // Record in history
  await _addDirectOperationToHistory('tan($currentNumber$angleSuffixTan)', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errTan', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Arcsine
  Future<void> asin() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Check whether the number is safe for conversion to double
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

        // Record in history
  await _addDirectOperationToHistory('asin($currentNumber)', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errAsin', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Arccosine
  Future<void> acos() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Check whether the number is safe for conversion to double
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

        // Record in history
  await _addDirectOperationToHistory('acos($currentNumber)', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errAcos', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Arctangent
  Future<void> atan() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Check whether the number is safe for conversion to double
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

      // Record in history
  await _addDirectOperationToHistory('atan($currentNumber)', originalValue, resultStr);

    } catch (e) {
      _setError('errAtan', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Natural logarithm (ln)
  Future<void> ln() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // For logarithms, use BigDecimal to check whether it is positive
      BigDecimal bigValue = BigDecimal.fromString(currentNumber);
      
      if (bigValue.isNegative || bigValue.isZero) {
        _setError('errLnDomain');
        _display = 'Error';
      } else {
        // Check whether the number is safe for conversion to double
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

        // Record in history
  await _addDirectOperationToHistory('ln($currentNumber)', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errLn', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Base-10 logarithm (log)
  Future<void> log() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // For logarithms, use BigDecimal to check whether it is positive
      BigDecimal bigValue = BigDecimal.fromString(currentNumber);
      
      if (bigValue.isNegative || bigValue.isZero) {
        _setError('errLogDomain');
        _display = 'Error';
      } else {
        // Check whether the number is safe for conversion to double
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

        // Record in history
  await _addDirectOperationToHistory('log($currentNumber)', originalValue, resultStr);
      }
      
    } catch (e) {
      _setError('errLog', {'error': e.toString()});
      _display = 'Error';
    }
    
    notifyListeners();
  }

  /// Exponential (e^x)
  Future<void> exp() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      // Check whether the number is safe for conversion to double
      if (!_isSafeForDouble(currentNumber)) {
        _setError('errExpTooLarge');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      double value = double.parse(currentNumber);
      
      // Check whether the value is too large to avoid overflow
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

        // Record in history
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
      
      // Check whether the number is safe for conversion to double
      if (!_isSafeForDouble(currentNumber)) {
        _setError('errTenPowTooLarge');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      double value = double.parse(currentNumber);
      
      // Check whether the value is too large to avoid overflow
      if (value > 300) {
        _setError('errTenPowTooLarge');
        _display = 'Error';
      } else {
        double result = math.pow(10, value).toDouble();
        String resultStr = _formatScientificResult(result);
        _display = resultStr;
        _lastResult = resultStr;
        _updateAnalysis();
        
        // Record in history
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
      // Get the last number on the display
      String currentNumber = _getCurrentNumber();
      String originalValue = currentNumber;
      
      // Use BigDecimal to handle large numbers safely
      BigDecimal bigValue;
      try {
        bigValue = BigDecimal.fromString(currentNumber);
      } catch (e) {
        _setError('errFactorialInvalid');
        _display = 'Error';
        notifyListeners();
        return;
      }
      
      // Verify it is a non-negative integer
      if (bigValue.isNegative) {
        _setError('errFactorialNonNeg');
        _display = 'Error';
      } else {
        // Check whether it is an integer
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
              // Replace the last number with the factorial result
              String factorialResult = result['result'];
              
              // If the display contains more than just the number, replace only the last number
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
              
              // Record in history
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

  /// Adds the Pi constant
  void addPi() {
    if (_hasError) {
      clear();
    }
    
    String piValue = math.pi.toString();

    // If it is already Pi, do nothing
    if (_display == piValue) {
      return;
    }

    // In the middle of an expression ("2×"), π is the next operand; previously
    // the whole display was replaced and the "2×" was silently lost.
    if (_endsWithOperator()) {
      _display += piValue;
    } else {
      _display = piValue;
    }

    _updateAnalysis();
    notifyListeners();
  }

  /// Adds the e constant
  void addE() {
    if (_hasError) {
      clear();
    }
    
    String eValue = math.e.toString();

    // If it is already e, do nothing
    if (_display == eValue) {
      return;
    }

    // In the middle of an expression ("2×"), e is the next operand (see addPi)
    if (_endsWithOperator()) {
      _display += eValue;
    } else {
      _display = eValue;
    }

    _updateAnalysis();
    notifyListeners();
  }

  /// Cancels the current operation
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

  /// Determines whether a power operation will be heavy
  bool _isHeavyPowerOperation(BigDecimal base, int exponent) {
    // Heavy operations: large numbers or high exponents
    String baseStr = base.toString();
    int digits = baseStr.replaceAll('.', '').replaceAll('-', '').length;

    return digits > 100 || exponent > 100 || (digits > 10 && exponent > 10);
  }

  /// Estimates whether base^exp would produce an EXACT result with too many
  /// digits to compute (e.g. a non-integer base with a huge exponent explodes
  /// into billions of decimals). Avoids freezing the UI by rejecting the
  /// operation instantly, like calculators do with "overflow".
  bool _powerExceedsDigitLimit(BigDecimal base, int exponent,
      {int maxDigits = 100000}) {
    if (exponent <= 1) return false;
    final d = base.toDouble();
    if (d == 0 || d == 1 || d == -1) return false; // trivial cases
    // Significant digits of the base (integer part without leading zeros + decimals).
    final body = base.toString().replaceAll('-', '');
    final dot = body.indexOf('.');
    final intPart = (dot < 0 ? body : body.substring(0, dot))
        .replaceAll(RegExp(r'^0+'), '');
    final fracPlaces = dot < 0 ? 0 : body.length - dot - 1;
    final sigDigits = intPart.length + fracPlaces;
    // The exact result's digit count grows ~ exp × sigDigits.
    // We use BigInt to avoid overflows with huge exponents.
    return BigInt.from(exponent) * BigInt.from(sigDigits) >
        BigInt.from(maxDigits);
  }

  /// Detects power operations that may produce large numbers
  bool _hasPotentiallyLargePowerOperation(String expression) {
    // Look for power patterns like "number^exponent"
    RegExp powerRegex = RegExp(r'(\d+(?:\.\d+)?)\s*\^\s*(\d+(?:\.\d+)?)');
    Iterable<Match> matches = powerRegex.allMatches(expression);
    
    for (Match match in matches) {
      String baseStr = match.group(1)!;
      String expStr = match.group(2)!;
      
      try {
        double base = double.parse(baseStr);
        double exponent = double.parse(expStr);
        
        // Cases that typically produce large numbers:
        // 1. High exponent (>= 20)
        // 2. Large base with a moderate exponent
        // 3. Specific known cases like 2^68
        
        if (exponent >= 20) {
          return true;
        }
        
        if (base >= 10 && exponent >= 10) {
          return true;
        }
        
        // Specific case: powers of small numbers with medium-to-high exponents
        // that may produce large numbers (like 2^68)
        if (base >= 2 && exponent >= 50) {
          return true;
        }
        
        // Check whether the estimated result would be very large
        // To avoid overflow, use logarithms: log(base^exp) = exp * log(base)
        if (base > 1 && exponent > 0) {
          double logResult = exponent * math.log(base);
          // If log(result) > log(10^15), then the result > 10^15 (too large for double)
          if (logResult > 15 * math.log(10)) {
            return true;
          }
        }
        
      } catch (e) {
        // If parsing fails, assume it may be complex
        return true;
      }
    }
    
    return false;
  }

  /// Formats the result of scientific functions
  String _formatScientificResult(double result) {
    // Handle special cases
    if (result.isNaN) {
      return 'NaN';
    }
    if (result.isInfinite) {
      return result.isNegative ? '-∞' : '∞';
    }
    
    // Normalize very small floating-point errors
    // E.g.: sin(30°) -> 0.49999999999999994 should be 0.5
    if (result.abs() < 1e-15) {
      result = 0.0;
    }
  // Soft rounding to N decimals to stabilize scientific function results
  // This fixes artifacts like 0.4999999999999999 -> 0.5 and keeps the expected precision (e.g., e^2)
  result = double.parse(result.toStringAsFixed(NumericPrecision.decimals));
    
    // Check whether scientific notation should be used
    bool useScientificNotation = SettingsService.getUseScientificNotation();
    
    if (useScientificNotation) {
      // Format very small or very large numbers using scientific notation
      if (result.abs() < 1e-10 && result != 0) {
        return result.toStringAsExponential(10);
      }
      if (result.abs() > 1e10) {
        return result.toStringAsExponential(10);
      }
      
      // Format regular numbers
      String formatted = result.toString();
      if (formatted.length > 15) {
        return result.toStringAsExponential(10);
      }
      
      return formatted;
    } else {
      // Format without scientific notation (show full numbers)
      return _formatWithoutScientificNotation(result);
    }
  }
  
  /// Formats a number without using scientific notation
  String _formatWithoutScientificNotation(double result) {
    // Handle special cases
    if (result.isNaN) {
      return 'NaN';
    }
    if (result.isInfinite) {
      return result.isNegative ? '-∞' : '∞';
    }
    
  // Round to N decimals to clean floating-point noise while preserving precision
  result = double.parse(result.toStringAsFixed(NumericPrecision.decimals));
    
    // Convert to BigDecimal to keep precision
    BigDecimal bigResult = BigDecimal.fromDouble(result);
    
    // Format the full number
    String formatted = bigResult.toString();
    
    // Remove scientific notation if present
    if (formatted.contains('e') || formatted.contains('E')) {
      // Convert from scientific notation to full decimal
      try {
        BigDecimal expanded = BigDecimal.fromString(formatted);
        formatted = expanded.toString();
      } catch (e) {
        // If there is an error, keep the original format
        formatted = result.toString();
      }
    }
  // Remove leftover zeros and points if applicable
  formatted = _trimTrailingZeros(formatted);
  return formatted;
  }
  
  /// Formats any numeric result according to the settings
  String _formatNumber(String numberStr) {
    // Normalize input
    numberStr = numberStr.trim();

    // Special case: small-magnitude decimals with many digits (floating-point artifacts)
    // E.g.: 0.49999999999999994 -> 0.5, 1.0000000000000002 -> 1
    if (!numberStr.contains('e') && !numberStr.contains('E') && numberStr.contains('.')) {
      final parts = numberStr.split('.');
      final intPart = parts[0].replaceAll('-', '');
      final fracPart = parts.length > 1 ? parts[1] : '';
      // Only round automatically when:
      // - The integer part is short (|x| < 10)
      // - There are more decimals than the core precision
      if (intPart.length <= 1 && fracPart.length > NumericPrecision.decimals) {
        final v = double.tryParse(numberStr);
        if (v != null && v.isFinite && v.abs() < 1e6) {
          // We reuse the non-scientific formatting that already rounds and cleans zeros
          return _formatWithoutScientificNotation(v);
        }
      }
    }

    // PRECISION LOSS PREVENTION: For large numbers, NEVER convert to double
    // Numbers > 15 digits may lose precision in double conversions
  if (numberStr.length > NumericPrecision.decimals) {
      return numberStr; // Return the original string for very large numbers
    }
    
    // Check whether scientific notation should be used
    bool useScientificNotation = SettingsService.getUseScientificNotation();
    if (!useScientificNotation) {
      // To preserve decimal precision, avoid conversion to double
      // Only convert if necessary for special cases
      try {
        if (numberStr.contains('e') || numberStr.contains('E')) {
          // ONLY for short scientific notation (< 15 digits), try to expand
          // For long scientific notation, preserve as a string
          if (numberStr.length <= NumericPrecision.decimals) {
            double value = double.parse(numberStr);
            String result = _formatWithoutScientificNotation(value);
            // Trim leftover zeros and points
            result = _trimTrailingZeros(result);
            return result;
          } else {
            // For long scientific notation, preserve the string to avoid precision loss
            return numberStr;
          }
        } else {
          // For regular numbers, preserve the original string to keep precision
          return _trimTrailingZeros(numberStr);
        }
      } catch (e) {
        // If it can't be converted, return the original string
        return _trimTrailingZeros(numberStr);
      }
    }
    
    return numberStr;
  }

  /// Removes trailing zeros in the decimal part and the point if not needed
  String _trimTrailingZeros(String s) {
    if (!s.contains('.') || s.contains('e') || s.contains('E')) return s;
    // Safely strip zeros on the right
    s = s.replaceAll(RegExp(r'(\.\d*?[1-9])0+$'), r'$1');
    // If only zeros remain after the point, remove the decimal part
    s = s.replaceAll(RegExp(r'\.0+$'), '');
    // If it ends with a point, remove it
    if (s.endsWith('.')) s = s.substring(0, s.length - 1);
    // Normalize -0 to 0
    if (s == '-0') s = '0';
    return s;
  }
  
  // =========================
  // NEW METHODS FOR FULL EXPRESSIONS AND HISTORY
  // =========================
  
  /// Loads the history from local storage
  Future<void> _loadHistory() async {
    try {
      _history = await HistoryService.getHistory();
      notifyListeners();
    } catch (e) {
  debugPrint('Error cargando historial: $e');
    }
  }
  
  /// Toggles the history visibility
  void toggleHistoryVisibility() {
    _isHistoryVisible = !_isHistoryVisible;
    notifyListeners();
  }

  /// Reloads the history from storage. Needed when another screen
  /// (e.g. HistoryScreen) mutates HistoryService directly: this service's
  /// in-memory copy stayed stale until restart.
  Future<void> reloadHistory() => _loadHistory();
  
  /// Evaluates a full mathematical expression using math_expressions
  String evaluateCompleteExpression(String expression) {
    try {
      // Validate the expression before processing it
      if (expression.trim().isEmpty) {
        return 'err:errExprEmpty';
      }
      
      // Validate problematic patterns
      if (_hasInvalidPatterns(expression)) {
        return 'err:errExprMalformed';
      }
      
      // Clean up the expression
      String cleanExpression = _prepareExpression(expression);
      
      // Check for division by a literal zero (only zeros with no further
      // digits or point after; "8/02" is 8÷2, not a division by zero)
      if (RegExp(r'/\s*0+(?![\d.])').hasMatch(cleanExpression)) {
        return 'err:errExprDivZero';
      }
      
      // Check whether it has parentheses or functions - use math_expressions
      bool hasComplexStructure = cleanExpression.contains('(') || 
                                 cleanExpression.contains(')') ||
                                 cleanExpression.contains('sqrt') ||
                                 cleanExpression.contains('sin') ||
                                 cleanExpression.contains('cos') ||
                                 cleanExpression.contains('tan') ||
                                 cleanExpression.contains('log') ||
                                 cleanExpression.contains('ln') ||
                                 cleanExpression.contains('abs');
      
      // If it has a complex structure, math_expressions is mandatory
      if (hasComplexStructure) {
        return _evaluateWithMathExpressions(cleanExpression);
      }
      
      // For simple expressions, check whether there are large numbers
      if (_containsLargeNumbers(cleanExpression)) {
        return _evaluateBigDecimalExpression(cleanExpression);
      }
      
      // FIX: Check for power operations that may produce large numbers
      if (_hasPotentiallyLargePowerOperation(cleanExpression)) {
        return _evaluateBigDecimalExpression(cleanExpression);
      }
      
      // For simple expressions with normal numbers, use math_expressions
      return _evaluateWithMathExpressions(cleanExpression);
      
    } catch (e) {
      return 'err:errGeneric:${e.toString()}';
    }
  }

  /// Evaluates exclusively using math_expressions
  String _evaluateWithMathExpressions(String cleanExpression) {
    try {
      // Use math_expressions for standard expressions
  ShuntingYardParser parser = ShuntingYardParser();
      
      // Configure the context for trigonometric functions
      if (!_isRadianMode) {
        // Convert degrees to radians for trigonometric functions
        cleanExpression = _convertTrigFunctionsToRadians(cleanExpression);
      }
      
      Expression exp = parser.parse(cleanExpression);
      ContextModel context = ContextModel();
      
      double result = exp.evaluate(EvaluationType.REAL, context);
      
      // Check whether the result is valid
      if (result.isNaN || result.isInfinite) {
        return 'err:errResultInvalid';
      }
      
      // Format the result according to the settings
      return _formatNumber(result.toString());
      
    } catch (e) {
      throw Exception(trLocale('Error en evaluación: ${e.toString()}', 'Evaluation error: ${e.toString()}'));
    }
  }
  
  /// Checks whether the expression has invalid patterns
  bool _hasInvalidPatterns(String expression) {
    // Problematic consecutive operators
    if (RegExp(r'[\+\-\*\/\^]{2,}').hasMatch(expression)) {
      // Allow some valid cases like --x or ++x
      if (!RegExp(r'^[\+\-]*\d').hasMatch(expression.trim())) {
        return true;
      }
    }
    
    // Unbalanced parentheses
    int openParens = 0;
    for (int i = 0; i < expression.length; i++) {
      if (expression[i] == '(') openParens++;
      if (expression[i] == ')') openParens--;
      if (openParens < 0) return true;
    }
    if (openParens != 0) return true;
    
    // Functions without parentheses
    if (RegExp(r'\b(sin|cos|tan|log|ln|sqrt|abs)\s*[^(]').hasMatch(expression)) {
      return true;
    }
    
    return false;
  }
  
  /// Prepares the expression by replacing visual symbols with math_expressions ones
  String _prepareExpression(String expression) {
    String prepared = expression;
    
    // Replace visual operators
    prepared = prepared.replaceAll('×', '*');
    prepared = prepared.replaceAll('÷', '/');
    prepared = prepared.replaceAll('√', 'sqrt');
    
    // Replace constants. Only a standalone 'e' is Euler's constant:
    // replacing every 'e' corrupted scientific notation ("2e3" turned
    // into "2·2.718…·3" with no visible error).
    prepared = prepared.replaceAll('π', math.pi.toString());
    prepared = prepared.replaceAllMapped(
      RegExp(r'(?<![0-9A-Za-z.])e(?![0-9A-Za-z(])'),
      (_) => math.e.toString(),
    );
    
    // Add implicit multiplication where needed
    prepared = _addImplicitMultiplication(prepared);
    
    return prepared;
  }
  
  /// Adds implicit multiplication (e.g.: 2(3+4) → 2*(3+4))
  String _addImplicitMultiplication(String expression) {
    String result = expression;
    
    // Pattern for a number followed by a parenthesis: 2( → 2*(
    result = result.replaceAllMapped(
      RegExp(r'(\d)\('),
      (match) => '${match.group(1)}*(',
    );
    
    // Pattern for a parenthesis followed by a number: )2 → )*2
    result = result.replaceAllMapped(
      RegExp(r'\)(\d)'),
      (match) => ')*${match.group(1)}',
    );
    
    // Pattern for consecutive parentheses: )( → )*(
    result = result.replaceAll(')(', ')*(');
    
    return result;
  }
  
  /// Converts trigonometric functions from degrees to radians.
  /// Walks the expression respecting nested parentheses: the previous regex
  /// (`sin\(([^)]+)\)`) cut the argument at the first ')', converting
  /// only part of it in `sin((1+2)+27)`.
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
        // The preceding-letter guard avoids converting the 'sin(' in 'arcsin('.
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
          if (depth != 0) break; // unclosed: leave as is (the parser will fail)
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
  
  /// Evaluates the current expression and adds it to the history
  Future<void> evaluateAndAddToHistory() async {
    String expression = _expressionController.text.trim();
    
    if (expression.isEmpty) return;
    
    try {
      String result = evaluateCompleteExpression(expression);
      
      if (!result.startsWith('err:')) {
        // Update display
        _display = result;
        _lastResult = result;
        _hasError = false;
        _errorMessage = '';
        _errorArgs = {};
        
        // Create history entry
        OperationEntry entry = OperationEntry(
          expression: expression,
          result: result,
        );
        
        // Add to the local history
        _history.insert(0, entry);
        
        // Keep only the last 100 operations in memory
        if (_history.length > 100) {
          _history = _history.take(100).toList();
        }
        
        // Save to persistent storage
        await HistoryService.addOperation(entry);
        
        // Update the result's analysis
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

  /// Appends text to the current expression
  void addToExpression(String text) {
    _expressionController.text += text;
    _hasError = false;
    notifyListeners();
  }
  
  /// Inserts text at the current cursor position
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
  
  /// Deletes the last character of the expression
  void backspaceExpression() {
    final controller = _expressionController;
    final text = controller.text;
    
    if (text.isNotEmpty) {
      controller.text = text.substring(0, text.length - 1);
    }
    
    notifyListeners();
  }
  
  /// Clears the current expression
  void clearExpression() {
    _expressionController.clear();
    _hasError = false;
    _errorMessage = '';
    _errorArgs = {};
    notifyListeners();
  }
  
  /// Loads an expression from the history
  void loadFromHistory(OperationEntry entry) {
    _expressionController.text = entry.expression;
    notifyListeners();
  }
  
  /// Loads the result of an operation from the history
  void loadResultFromHistory(OperationEntry entry) {
    _display = entry.result;
    _lastResult = entry.result;
    _updateAnalysis();
    notifyListeners();
  }
  
  /// Clears the entire history
  Future<void> clearHistory() async {
    try {
      await HistoryService.clearHistory();
      _history.clear();
      notifyListeners();
    } catch (e) {
  debugPrint('Error limpiando historial: $e');
    }
  }
  
  /// Removes a specific entry from the history
  Future<void> removeFromHistory(OperationEntry entry) async {
    try {
      await HistoryService.removeOperation(entry);
      _history.remove(entry);
      notifyListeners();
    } catch (e) {
  debugPrint('Error eliminando entrada del historial: $e');
    }
  }
  
  /// Disposes the controller
  @override
  void dispose() {
    _expressionController.removeListener(notifyListeners);
    _expressionController.dispose();
    super.dispose();
  }
  
  /// Detects whether the expression contains large numbers that require BigDecimal
  bool _containsLargeNumbers(String expression) {
    // Look for numbers in the expression (including decimals)
    RegExp numberRegex = RegExp(r'\d+(?:\.\d+)?');
    Iterable<Match> matches = numberRegex.allMatches(expression);
    
    for (Match match in matches) {
      String number = match.group(0)!;
      // If the number has more than 10 digits (not counting the decimal point), use BigDecimal
      String digitsOnly = number.replaceAll('.', '');
      if (digitsOnly.length > 10) {
        return true;
      }
      
      // Also check whether the number is too large for double
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

  /// Evaluates expressions with BigDecimal for very large numbers.
  ///
  /// Recursive descent by precedence (+,− < ×,÷ < ^) over a flat expression
  /// (those with parentheses go through math_expressions). The previous
  /// version split at the FIRST operator found and only supported one
  /// operation: "2^68+1" returned 1.
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

  /// Is the character at [i] a binary operator? (If preceded by another
  /// operator or at the start, it is a unary sign of the right operand.)
  static bool _isBinaryOperatorAt(String s, int i) {
    return i > 0 && RegExp(r'[0-9.]').hasMatch(s[i - 1]);
  }

  /// +/− level. Split at the RIGHTMOST operator to respect left
  /// associativity (1-2-3 = (1-2)-3).
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

  /// ×/÷ level (left associativity).
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

  /// ^ level (right associativity: 2^3^2 = 2^(3^2)).
  BigDecimal _evalBigPower(String s) {
    final int i = s.indexOf('^');
    if (i <= 0) {
      return BigDecimal.fromString(s);
    }
    final BigDecimal base = BigDecimal.fromString(s.substring(0, i));
    final BigDecimal exp = _evalBigPower(s.substring(i + 1));

    if (exp.fractionalPart != BigInt.zero) {
      // Previously it was silently truncated (x^2.5 computed x^2).
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

  /// Helper method to add direct operations to the history
  Future<void> _addDirectOperationToHistory(String formattedExpression, String originalValue, String result) async {
    try {
      // Create history entry
      final entry = OperationEntry(
        expression: formattedExpression,
        result: result,
        timestamp: DateTime.now(),
      );
      
      // Add to the in-memory list
      _history.insert(0, entry);
      if (_history.length > 100) {
        _history = _history.take(100).toList();
      }
      
      // Save to persistent storage
      await HistoryService.addOperation(entry);
      
    } catch (e) {
      // If saving to history fails, don't interrupt the operation
  debugPrint('Error al guardar en historial: $e');
    }
  }

  // =========================
  // SPECIAL FUNCTIONS
  // =========================

  /// Euler's φ function
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

  /// Divisor count σ₀(n)
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

  /// Divisor sum σ(m,n) - requires two values
  Future<void> divisorSum() async {
    // This function requires a two-value input implementation
    // For simplicity, we will use σ(1,n) by default
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

  /// GCD function - requires multiple values (for simplicity, we use the current analysis)
  // ====================================================================
  // N-PARAMETER FUNCTIONS — Generic system
  // ====================================================================

  /// GCD of N numbers (variable, minimum 2)
  void gcdFunction() {
    _startPending(PendingOperation(
      name: 'gcd', symbol: trLocale('MCD', 'GCD'), minParams: 2,
      displayBuilder: (p) => trLocale(
          'MCD(${p.join(", ")}, _) [= agregar, MCD resolver]',
          'GCD(${p.join(", ")}, _) [= add, GCD solve]'),
    ));
  }

  /// LCM of N numbers (variable, minimum 2)
  void lcmFunction() {
    _startPending(PendingOperation(
      name: 'lcm', symbol: trLocale('MCM', 'LCM'), minParams: 2,
      displayBuilder: (p) => trLocale(
          'MCM(${p.join(", ")}, _) [= agregar, MCM resolver]',
          'LCM(${p.join(", ")}, _) [= add, LCM solve]'),
    ));
  }

  /// Diophantine equation ax + by = c (3 fixed parameters)
  void diophantineFunction() {
    _startPending(PendingOperation(
      name: 'dioph', symbol: trLocale('Diof', 'Dioph'), requiredParams: 3,
      displayBuilder: (p) {
        if (p.isEmpty) return trLocale('Diof: a=_', 'Dioph: a=_');
        if (p.length == 1) return '${p[0]}x + _y = ?';
        if (p.length == 2) return '${p[0]}x + ${p[1]}y = _';
        return '${p[0]}x + ${p[1]}y = ${p[2]}';
      },
    ));
  }

  /// CRT of N congruences (variable, aᵢ,mᵢ pairs, minimum 4 = 2 pairs)
  void crtFunction() {
    _startPending(PendingOperation(
      name: 'crt', symbol: trLocale('TCR', 'CRT'), minParams: 4,
      displayBuilder: (p) {
        List<String> pairs = [];
        for (int i = 0; i + 1 < p.length; i += 2) {
          pairs.add('x≡${p[i]}(mod ${p[i + 1]})');
        }
        String collected = pairs.join(', ');
        if (p.length.isEven) {
          return trLocale('$collected, x≡_(mod ?) [= agregar, TCR resolver]',
              '$collected, x≡_(mod ?) [= add, CRT solve]');
        } else {
          return '$collected, x≡${p.last}(mod _)';
        }
      },
    ));
  }

  /// Means of N numbers (variable, minimum 2)
  void arithmeticMeanN() {
    _startPending(PendingOperation(
      name: 'meanA', symbol: 'MedA', minParams: 2,
      displayBuilder: (p) => trLocale(
          'MedA(${p.join(", ")}, _) [= agregar, MedA resolver]',
          'MedA(${p.join(", ")}, _) [= add, MedA solve]'),
    ));
  }
  void geometricMeanN() {
    _startPending(PendingOperation(
      name: 'meanG', symbol: 'MedG', minParams: 2,
      displayBuilder: (p) => trLocale(
          'MedG(${p.join(", ")}, _) [= agregar, MedG resolver]',
          'MedG(${p.join(", ")}, _) [= add, MedG solve]'),
    ));
  }
  void harmonicMeanN() {
    _startPending(PendingOperation(
      name: 'meanH', symbol: 'MedH', minParams: 2,
      displayBuilder: (p) => trLocale(
          'MedH(${p.join(", ")}, _) [= agregar, MedH resolver]',
          'MedH(${p.join(", ")}, _) [= add, MedH solve]'),
    ));
  }
  void quadraticMeanN() {
    _startPending(PendingOperation(
      name: 'meanQ', symbol: 'MedQ', minParams: 2,
      displayBuilder: (p) => trLocale(
          'MedQ(${p.join(", ")}, _) [= agregar, MedQ resolver]',
          'MedQ(${p.join(", ")}, _) [= add, MedQ solve]'),
    ));
  }
  void minimumN() {
    _startPending(PendingOperation(
      name: 'minN', symbol: 'min', minParams: 2,
      displayBuilder: (p) => trLocale(
          'min(${p.join(", ")}, _) [= agregar, min resolver]',
          'min(${p.join(", ")}, _) [= add, min solve]'),
    ));
  }
  void maximumN() {
    _startPending(PendingOperation(
      name: 'maxN', symbol: 'max', minParams: 2,
      displayBuilder: (p) => trLocale(
          'max(${p.join(", ")}, _) [= agregar, max resolver]',
          'max(${p.join(", ")}, _) [= add, max solve]'),
    ));
  }

  /// Floor and ceiling function (alternates between both)
  Future<void> floorCeil() async {
    try {
      String originalValue = _display;
      String currentNumber = _getCurrentNumber();
      
      BigDecimal number = BigDecimal.fromString(currentNumber);
      
      // Alternate between floor and ceiling
      if (_lastResult.contains('⌊')) {
        // Compute ceiling
        BigInt result = SpecialFunctionsService.ceiling(number);
        _display = _formatNumber(result.toString());
        _lastResult = _display;
        _updateAnalysis();
        
        await _addDirectOperationToHistory('⌈⌉', originalValue, _display);
      } else {
        // Compute floor
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

  /// Möbius μ function
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

  /// mod function: a mod b (2 fixed params)
  void modFunction() {
    _startPending(PendingOperation(name: 'mod', symbol: 'mod', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'mod _' : '${p[0]} mod _'));
  }
  /// p-adic valuation Vp(n) (2 fixed params)
  void pAdicValuation() {
    _startPending(PendingOperation(name: 'Vp', symbol: 'Vₚ', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'Vₚ(_)' : 'V_(${p[0]}) p=_'));
  }
  /// Combinations C(n,k) (2 fixed params)
  void combinations() {
    _startPending(PendingOperation(name: 'C', symbol: 'C', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'C(_,_)' : 'C(${p[0]}, _)'));
  }
  /// Variations V(n,k) (2 fixed params)
  void variations() {
    _startPending(PendingOperation(name: 'V', symbol: 'V', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'V(_,_)' : 'V(${p[0]}, _)'));
  }
  /// Modular inverse a⁻¹ mod n (2 fixed params)
  void modularInverse() {
    _startPending(PendingOperation(name: 'modinv', symbol: 'a⁻¹mod', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'a⁻¹ mod _' : '${p[0]}⁻¹ mod _'));
  }
  /// Modular exponentiation a^b mod n (3 fixed params)
  void modPowFunction() {
    _startPending(PendingOperation(name: 'modpow', symbol: 'a%n', requiredParams: 3,
      displayBuilder: (p) {
        if (p.isEmpty) return 'a mod n: a=_';
        if (p.length == 1) return '${p[0]} mod _';
        if (p.length == 2) return '${p[0]}^${p[1]} mod _';
        return '${p[0]}^${p[1]} mod ${p[2]}';
      }));
  }
  /// Multiplicative order ord_n(a) (2 fixed params)
  void multiplicativeOrder() {
    _startPending(PendingOperation(name: 'ord', symbol: 'ord', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'ord: a=_' : 'ord_(${p[0]}) n=_'));
  }
  /// Legendre symbol (a/p) (2 fixed params)
  void legendreSymbol() {
    _startPending(PendingOperation(name: 'legendre', symbol: '(a/p)', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? '(a/p): a=_' : '(${p[0]}/_)'));
  }
  /// Jacobi symbol (a/n) (2 fixed params)
  void jacobiSymbol() {
    _startPending(PendingOperation(name: 'jacobi', symbol: '(a/n)ⱼ', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? '(a/n)ⱼ: a=_' : '(${p[0]}/_)ⱼ'));
  }
  /// Stirling numbers of the second kind S(n,k) (2 fixed params)
  void stirlingSecond() {
    _startPending(PendingOperation(name: 'stirling2', symbol: 'S₂', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 'S₂(_,_)' : 'S₂(${p[0]}, _)'));
  }
  /// Stirling numbers of the first kind |s(n,k)| (2 fixed params)
  void stirlingFirst() {
    _startPending(PendingOperation(name: 'stirling1', symbol: 's₁', requiredParams: 2,
      displayBuilder: (p) => p.isEmpty ? 's₁(_,_)' : 's₁(${p[0]}, _)'));
  }
  /// Digit sum in base b (2 fixed params)
  void digitSumBase() {
    _startPending(PendingOperation(name: 'digsum', symbol: trLocale('ΣdígB', 'ΣdigB'), requiredParams: 2,
      displayBuilder: (p) => p.isEmpty
          ? trLocale('ΣdígB: n=_', 'ΣdigB: n=_')
          : trLocale('Σdíg_b(${p[0]}) b=_', 'Σdig_b(${p[0]}) b=_')));
  }

  // ====================================================================
  // GENERIC PENDING-OPERATION SYSTEM (N parameters)
  // ====================================================================

  /// Starts a pending operation. The first param is the current number on display.
  void _startPending(PendingOperation op) {
    // If there is already a VARIABLE pending operation of the same type → add param and execute
    if (_pending != null && _pending!.isVariable && _pending!.name == op.name) {
      // Add the current number as an additional parameter
      String currentNumber = _getCurrentNumber();
      if (currentNumber == '0' && _lastResult.isNotEmpty) {
        currentNumber = _lastResult;
      }
      _pending = _pending!.addParam(currentNumber);
      if (_pending!.canExecute) {
        _executeOperation(_pending!);
        return;
      }
      // Not enough yet, keep waiting
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

  /// Adds a parameter and executes if the operation is complete (fixed).
  /// For variable-param, = adds the param; pressing the function again executes.
  void _addParamAndMaybeExecute() {
    if (_pending == null) return;

    String value = _getCurrentNumber();
    _pending = _pending!.addParam(value);

    if (_pending!.isComplete) {
      // Fixed parameters complete → execute automatically
      _executeOperation(_pending!);
    } else {
      // More parameters needed → reset display and wait
      _display = '0';
      notifyListeners();
    }
  }

  /// Executes the operation with the collected parameters.
  void _executeOperation(PendingOperation op) {
    List<String> p = op.params;
    _pending = null;

    try {
      String resultStr;
      String historyLabel;

      switch (op.name) {
        // --- 2 fixed params ---
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
          historyLabel = trLocale('Σdíg_${p[1]}(${p[0]})', 'Σdig_${p[1]}(${p[0]})');
          break;

        // --- 3 fixed params ---
        case 'modpow':
          resultStr = _fmt(SpecialFunctionsService.modPow(_parseStringAsBigInt(p[0]), _parseStringAsBigInt(p[1]), _parseStringAsBigInt(p[2])));
          historyLabel = '${p[0]}^${p[1]} mod ${p[2]}';
          break;
        case 'dioph':
          Map<String, dynamic> dr = SpecialFunctionsService.solveDiophantine(_parseStringAsBigInt(p[0]), _parseStringAsBigInt(p[1]), _parseStringAsBigInt(p[2]));
          if (dr['solvable'] != true) { _showError('errNoSolution'); return; }
          resultStr = dr['note'] ?? trLocale('Solución encontrada', 'Solution found');
          historyLabel = '${p[0]}x+${p[1]}y=${p[2]}';
          break;

        // --- Variable: GCD/LCM of N numbers ---
        case 'gcd':
          BigInt r = p.map(_parseStringAsBigInt).reduce(SpecialFunctionsService.gcd);
          resultStr = _fmt(r);
          historyLabel = '${trLocale('MCD', 'GCD')}(${p.join(",")})';
          break;
        case 'lcm':
          BigInt r = p.map(_parseStringAsBigInt).reduce(SpecialFunctionsService.lcm);
          resultStr = _fmt(r);
          historyLabel = '${trLocale('MCM', 'LCM')}(${p.join(",")})';
          break;

        // --- Variable: CRT with N pairs ---
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
          historyLabel = trLocale('TCR(${remainders.length} congruencias)',
              'CRT(${remainders.length} congruences)');
          _display = resultStr;
          _lastResult = cr['solution'].toString();
          _updateAnalysis();
          _addDirectOperationToHistory(historyLabel, p.join(','), resultStr);
          notifyListeners();
          return;

        // --- Variable: Means of N numbers ---
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

  /// Helper: formats a BigInt for display
  String _fmt(BigInt value) => _formatNumber(value.toString());

  /// Helper: shows the error and notifies
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

  /// High-precision path for transcendental functions. If the mode is
  /// enabled, runs the operation [op] in an **isolate** (via `compute`) to
  /// avoid freezing the UI, showing the loading overlay. Displays the result
  /// and records it; on failure (singularity/divergence) it shows the
  /// localized error key without leaking the exception. Returns `true` if it
  /// handled the operation (the caller must `return`), `false` if the mode is
  /// disabled (continue via the `double` path).
  Future<bool> _tryHighPrecision(String op, String value,
      {bool degrees = false,
      required String historyExpr,
      required String originalValue}) async {
    if (!PrecisionService.isEnabled) return false;

    _isCalculatingOperation = true;
    _operationProgress = ''; // the overlay uses the default localized text
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
  // NEW 1-PARAMETER FUNCTIONS
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

  /// Double factorial n!!
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

  /// n-th Fibonacci F(n)
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

  /// n-th Catalan number
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

  /// Partitions p(n)
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

  /// Bell numbers B(n)
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

  /// Digital root
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

  /// Find a primitive root
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

  /// Liouville function λ_L(n)
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

  /// π(n) - Prime-counting function
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

  // --- The old 2-parameter functions with fixed values, replaced above ---
  // modFunction(), pAdicValuation(), combinations(), variations(), modularInverse()
  // now use the pending-operation system

  // The arithmetic, geometric, harmonic and quadratic mean functions
  // now use the N-parameter system: arithmeticMeanN(), geometricMeanN(), etc.

  /// Radical (ABC function)
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

  /// ω(n) - Number of distinct prime factors
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

  /// Ω(n) - Number of prime factors with multiplicity
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

  /// λ(n) - Carmichael function
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

  /// sopfr(n) - Sum of prime factors with repetition
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

  /// sopf(n) - Sum of distinct prime factors
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

  // The minimum() and maximum() functions now use the N-parameter system:
  // minimumN() and maximumN()

  /// Percentage function - computes the percentage of the current value
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

  /// Reciprocal function - computes 1/x
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

/// Signals that an exact result (e.g. a power) would have too many
/// digits to compute; it translates to "errResultTooLarge".
class _ResultTooLargeException implements Exception {
  const _ResultTooLargeException();
}
