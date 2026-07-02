import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/calculator_service.dart';
import '../services/settings_service.dart';
import '../services/special_functions_service.dart';
import '../utils/error_localizer.dart';

class NumberAnalysisPanel extends StatelessWidget {
  const NumberAnalysisPanel({super.key});

  /// El servicio marca "no aplica" con un texto localizado; comparar contra
  /// ambos idiomas (comparar solo el literal español dejaba pasar 'Not prime'
  /// como si fuera un valor).
  static bool _isNotPrimeMarker(dynamic value) =>
      value == 'No es primo' || value == 'Not prime';

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        final l = AppLocalizations.of(context)!;
        final analysis = calculator.currentAnalysis;

        if (analysis.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  l.analysisEnterNumber,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          );
        }
        
        // Mostrar indicador de carga si el análisis está en progreso
        if (analysis.containsKey('loading') && analysis['loading'] == true) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  l.analysisLoading,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.analysisLoadingHint,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        // Mostrar error si existe
        if (analysis.containsKey('error')) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  l.analysisLimited,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  // El servicio a veces guarda una clave ('errAnalysisFail');
                  // localizeError la traduce y deja pasar el texto libre.
                  localizeError(context, analysis['error'].toString()),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (analysis.containsKey('errorNote'))
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      analysis['errorNote'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (analysis.containsKey('originalNumber'))
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${l.analysisValue}: ${_formatLargeNumber(analysis['originalNumber'])}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner especial para números extremadamente grandes
                if (analysis.containsKey('largeNumberNote'))
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.memory,
                              size: 16,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l.analysisExtremelyLarge,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          analysis['largeNumberNote'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.analysisDigitsCount(_formatNumberWithCommas(analysis['digitCount'] ?? 0)),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onTertiaryContainer.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                // Mostrar nota de procesamiento si existe
                if (analysis.containsKey('processingNote'))
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l.analysisPrimalityNote,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          analysis['processingNote'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        if (analysis.containsKey('originalInput'))
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              l.analysisOriginalInput(analysis['originalInput'], analysis['processedNumber']),
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'monospace',
                                color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                
                // Mostrar indicador de cálculo de primos si está en progreso
                if (analysis.containsKey('calculatingPrimes') && analysis['calculatingPrimes'] == true)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.analysisCalculatingPrimes,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l.analysisSearchingPrimes,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Información básica
                _buildAnalysisCard(
                  context,
                  l.analysisBasicProperties,
                  Icons.info_outline,
                  [
                    // 1. Valor
                    _buildInfoRow(l.analysisValue, analysis['value'] ?? 'N/A'),

                    // 2. Es primo
                    _buildInfoRow(l.analysisIsPrime, _formatPrimeStatus(analysis['isPrime'], l)),

                    // 3. Dígitos
                    _buildInfoRow(l.analysisDigits, analysis['digitCount']?.toString() ?? 'N/A'),

                    // 4. Siguiente primo
                    if (analysis['nextPrime'] != null && !_isNotPrimeMarker(analysis['nextPrime']))
                      _buildInfoRow(l.analysisNextPrime, analysis['nextPrime']),

                    // 5. Anterior primo
                    if (analysis['previousPrime'] != null && !_isNotPrimeMarker(analysis['previousPrime']))
                      _buildInfoRow(l.analysisPrevPrime, analysis['previousPrime']),

                    // 6. Suma de dígitos
                    _buildInfoRow(l.analysisDigitSum, analysis['digitSum']?.toString() ?? 'N/A'),

                    // Factorización prima
                    if (analysis['primeFactors'] != null &&
                        (analysis['primeFactors'] as List).isNotEmpty)
                      _buildPrimeFactorsRow(
                        l.analysisPrimeFactorsLabel,
                        analysis['primeFactors'] as List,
                      ),

                    // Potencia perfecta
                    if (analysis['perfectPower'] != null &&
                        analysis['perfectPower']['isPower'] == true)
                      _buildInfoRow(
                        l.analysisExpression,
                        analysis['perfectPower']['expression'] ?? 'N/A',
                      ),
                  ],
                ),
              
              // Representaciones numéricas
              _buildAnalysisCard(
                context,
                l.analysisRepresentations,
                Icons.transform,
                [
                  _buildInfoRow(l.analysisBinary, analysis['binary'] ?? 'N/A'),
                  _buildInfoRow(l.analysisOctal, analysis['octal'] ?? 'N/A'),
                  _buildInfoRow(l.analysisHex, analysis['hexadecimal'] ?? 'N/A'),
                ],
              ),
              
              // Análisis matemático
              if (analysis['isPrime'] != null)
                _buildAnalysisCard(
                  context,
                  l.analysisMathAnalysis,
                  Icons.calculate,
                  [
                    _buildInfoRow(l.analysisIsPrime, _formatPrimeStatus(analysis['isPrime'], l)),

                    // Mostrar estado de cálculo de primos o resultados
                    if (analysis.containsKey('calculatingPrimes') && analysis['calculatingPrimes'] == true)
                      _buildLoadingRow(l.analysisNextPrime, l.analysisCalculatingPrimes)
                    else if (analysis['nextPrime'] != null && !_isNotPrimeMarker(analysis['nextPrime']))
                      _buildInfoRow(l.analysisNextPrime, analysis['nextPrime']),

                    if (analysis.containsKey('calculatingPrimes') && analysis['calculatingPrimes'] == true)
                      _buildLoadingRow(l.analysisPrevPrime, l.analysisCalculatingPrimes)
                    else if (analysis['previousPrime'] != null && !_isNotPrimeMarker(analysis['previousPrime']))
                      _buildInfoRow(l.analysisPrevPrime, analysis['previousPrime']),

                    _buildInfoRow(l.analysisIsPerfect, _formatBooleanStatus(analysis['isPerfect'], l)),
                    _buildInfoRow(l.analysisIsPalindrome, _formatBooleanStatus(analysis['isPalindrome'], l)),
                    _buildInfoRow(l.analysisIsFibonacci, _formatBooleanStatus(analysis['isFibonacci'], l)),
                    _buildInfoRow(l.analysisIsTriangular, _formatBooleanStatus(analysis['isTriangular'], l)),
                  ],
                ),
              
              // Factorización
              if (analysis['primeFactors'] != null && 
                  (analysis['primeFactors'] as List).isNotEmpty)
                _buildAnalysisCard(
                  context,
                  l.analysisPrimeFactors,
                  Icons.scatter_plot,
                  [
                    _buildInfoRow(
                      l.analysisPrimeFactorsLabel,
                      formatPrimeFactorsAsPowers(analysis['primeFactors'] as List),
                      maxLines: 3,
                    ),
                  ],
                ),
              
              // Divisores
              if (analysis['divisors'] != null && 
                  (analysis['divisors'] as List).isNotEmpty)
                _buildAnalysisCard(
                  context,
                  l.analysisDivisors,
                  Icons.grid_view,
                  [
                    _buildInfoRow(
                      l.analysisAllDivisors,
                      (analysis['divisors'] as List).join(', '),
                      maxLines: 5,
                    ),
                    _buildInfoRow(
                      l.analysisDivisorCount,
                      (analysis['divisors'] as List).length.toString(),
                    ),
                  ],
                ),
              
              // Funciones aritméticas (nuevas)
              if (analysis.containsKey('value') &&
                  analysis['isPositive'] == true &&
                  (analysis['digitCount'] ?? 0) <= 15)
                _buildAnalysisCard(
                  context,
                  l.analysisArithmeticFunctions,
                  Icons.functions,
                  _buildArithmeticFunctions(analysis, l),
                ),

              // Potencia perfecta
              if (analysis['perfectPower'] != null &&
                  analysis['perfectPower']['isPower'] == true)
                _buildAnalysisCard(
                  context,
                  l.analysisPerfectPower,
                  Icons.trending_up,
                  [
                    _buildInfoRow(
                      l.analysisExpression,
                      analysis['perfectPower']['expression'] ?? 'N/A',
                    ),
                    _buildInfoRow(
                      l.analysisBase,
                      analysis['perfectPower']['base']?.toString() ?? 'N/A',
                    ),
                    _buildInfoRow(
                      l.analysisExponent,
                      analysis['perfectPower']['exponent']?.toString() ?? 'N/A',
                    ),
                  ],
                ),
              
              // Operaciones matemáticas
              _buildAnalysisCard(
                context,
                l.analysisOperations,
                Icons.functions,
                [
                  if (analysis['square'] != null)
                    _buildInfoRow(l.analysisSquare, analysis['square']),
                  if (analysis['cube'] != null)
                    _buildInfoRow(l.analysisCube, analysis['cube']),
                  if (analysis['squareRoot'] != null)
                    _buildInfoRow(l.analysisSquareRootLabel, analysis['squareRoot']),
                  _buildInfoRow(l.analysisIsPerfectSquare, _formatBooleanStatus(analysis['isPerfectSquare'], l)),
                  if (analysis['cubeRoot'] != null)
                    _buildInfoRow(l.analysisCubeRoot, analysis['cubeRoot']),
                  _buildInfoRow(l.analysisIsPerfectCube, _formatBooleanStatus(analysis['isPerfectCube'], l)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalysisCard(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {int? maxLines}) {
    // Verificar la configuración del usuario para notación científica
    bool shouldUseScientific = SettingsService.getUseScientificNotation();
    
    // Formatear valor para notación científica si es necesario
    String displayValue = value;
    if (shouldUseScientific && value.length > 15 && value != 'N/A') {
      if (value.contains('e') || value.contains('E')) {
        displayValue = value; // Ya está en notación científica
      } else if (RegExp(r'^-?\d+$').hasMatch(value)) {
        // Notación manual sobre los dígitos: double da Infinity con >308
        // dígitos, y así no se redondea la mantisa.
        final bool neg = value.startsWith('-');
        final String digits = neg ? value.substring(1) : value;
        String mantissa = digits[0];
        if (digits.length > 1) {
          final int end = digits.length < 7 ? digits.length : 7;
          mantissa += '.${digits.substring(1, end)}';
        }
        displayValue = '${neg ? '-' : ''}${mantissa}e+${digits.length - 1}';
      } else {
        // Decimales largos por double; la prosa ("No calculado (muy grande)")
        // se deja intacta: antes se mutilaba a "N.o calce+24".
        final double? numValue = double.tryParse(value);
        if (numValue != null && numValue.isFinite) {
          displayValue = numValue.toStringAsExponential(6);
        }
      }
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _copyToClipboard(label, value),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.transparent,
                ),
                child: SelectableText(
                  displayValue,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                  maxLines: maxLines,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Método especializado para mostrar factores primos con exponentes estilizados
  Widget _buildPrimeFactorsRow(String label, List<dynamic> factors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _copyToClipboard(label, formatPrimeFactorsAsPowers(factors)),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _buildPrimeFactorsRichText(factors),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Construye un RichText con exponentes estilizados
  Widget _buildPrimeFactorsRichText(List<dynamic> factors) {
    if (factors.isEmpty) {
      return const Text(
        'N/A',
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
        ),
      );
    }
    
    // Contar la frecuencia de cada factor
    Map<String, int> factorCounts = {};
    for (var factor in factors) {
      String factorStr = factor.toString();
      factorCounts[factorStr] = (factorCounts[factorStr] ?? 0) + 1;
    }
    
    // Crear lista de widgets para mostrar los factores
    List<Widget> factorWidgets = [];
    bool isFirst = true;
    
    factorCounts.forEach((factor, count) {
      // Agregar separador
      if (!isFirst) {
        factorWidgets.add(const Text(
          ' × ',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
          ),
        ));
      }
      
      // Agregar factor con exponente
      if (count == 1) {
        factorWidgets.add(Text(
          factor,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
          ),
        ));
      } else {
        factorWidgets.add(_buildFactorWithExponent(factor, count));
      }
      
      isFirst = false;
    });
    
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: factorWidgets,
    );
  }
  
  // Construye un widget para mostrar un factor con su exponente
  Widget _buildFactorWithExponent(String factor, int exponent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          factor,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            exponent.toString(),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
        ),
      ],
    );
  }
  
  void _copyToClipboard(String label, String value) {
    // Implementar copia al portapapeles si es necesario
    // Por ahora, el SelectableText ya permite seleccionar y copiar
  }

  /// Formatea el estado de primalidad
  String _formatPrimeStatus(dynamic value, AppLocalizations l) {
    if (value == true) return l.analysisYes;
    if (value == false) return l.analysisNo;
    if (value is String) return value;
    return 'N/A';
  }

  /// Formatea estados booleanos genéricos
  String _formatBooleanStatus(dynamic value, AppLocalizations l) {
    if (value == true) return l.analysisYes;
    if (value == false) return l.analysisNo;
    if (value is String) return value;
    return 'N/A';
  }

  /// Construye una fila con loader para mostrar cálculos en progreso
  Widget _buildLoadingRow(String label, String loadingText) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    loadingText,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formatea números muy grandes para visualización
  String _formatLargeNumber(String number) {
    if (number.length <= 30) {
      return number;
    }
    
    // Para números muy grandes, mostrar primeros y últimos dígitos
    return '${number.substring(0, 15)}...${number.substring(number.length - 15)}';
  }

  /// Formatea números con comas separadoras
  String _formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }
  
  /// Formatea una lista de factores primos agrupándolos en potencias
  String formatPrimeFactorsAsPowers(List<dynamic> factors) {
    if (factors.isEmpty) return 'N/A';
    
    // Contar la frecuencia de cada factor
    Map<String, int> factorCounts = {};
    for (var factor in factors) {
      String factorStr = factor.toString();
      factorCounts[factorStr] = (factorCounts[factorStr] ?? 0) + 1;
    }
    
    // Formatear como potencias
    List<String> formattedFactors = [];
    factorCounts.forEach((factor, count) {
      if (count == 1) {
        formattedFactors.add(factor);
      } else {
        // Usar superíndices Unicode para los exponentes
        String exponent = _toSuperscript(count);
        formattedFactors.add('$factor$exponent');
      }
    });
    
    return formattedFactors.join(' × ');
  }
  
  /// Convierte un número a superíndice usando caracteres Unicode con fallbacks
  String _toSuperscript(int number) {
    // Mapeo primario con Unicode
    const Map<String, String> superscripts = {
      '0': '⁰',
      '1': '¹',
      '2': '²',
      '3': '³',
      '4': '⁴',
      '5': '⁵',
      '6': '⁶',
      '7': '⁷',
      '8': '⁸',
      '9': '⁹',
    };
    
    // Mapeo alternativo con caracteres más comunes
    const Map<String, String> superscriptsAlt = {
      '0': '⁰',
      '1': '¹',
      '2': '²',
      '3': '³',
      '4': '⁴',
      '5': '⁵',
      '6': '⁶',
      '7': '⁷',
      '8': '⁸',
      '9': '⁹',
    };
    
    String result = number.toString().split('').map((digit) {
      return superscripts[digit] ?? superscriptsAlt[digit] ?? digit;
    }).join('');

    return result;
  }

  /// Construye las filas de funciones aritméticas para el panel de análisis
  List<Widget> _buildArithmeticFunctions(Map<String, dynamic> analysis, AppLocalizations l) {
    List<Widget> rows = [];
    try {
      String? valueStr = analysis['value']?.toString();
      if (valueStr == null || valueStr.isEmpty) return rows;

      BigInt n = BigInt.parse(valueStr);
      if (n <= BigInt.zero) return rows;

      // Limitar cálculos a números razonables
      int digits = n.toString().length;
      if (digits > 15) return rows;

      rows.add(_buildInfoRow(l.analysisEulerPhi, SpecialFunctionsService.eulerPhi(n).toString()));
      rows.add(_buildInfoRow(l.analysisCarmichael, SpecialFunctionsService.carmichaelLambda(n).toString()));
      rows.add(_buildInfoRow(l.analysisMobius, SpecialFunctionsService.moebiusMu(n).toString()));
      rows.add(_buildInfoRow(l.analysisSmallOmega, SpecialFunctionsService.smallOmega(n).toString()));
      rows.add(_buildInfoRow(l.analysisBigOmega, SpecialFunctionsService.bigOmega(n).toString()));
      rows.add(_buildInfoRow(l.analysisSopfr, SpecialFunctionsService.sopfr(n).toString()));
      rows.add(_buildInfoRow(l.analysisSopf, SpecialFunctionsService.sopf(n).toString()));
      rows.add(_buildInfoRow(l.analysisRadical, SpecialFunctionsService.radical(n).toString()));
      rows.add(_buildInfoRow(l.analysisDigitalRoot, SpecialFunctionsService.digitalRoot(n).toString()));

      // Clasificaciones
      List<String> classifications = [];
      if (SpecialFunctionsService.isSquareFree(n)) classifications.add(l.analysisSquareFree);
      if (SpecialFunctionsService.isPowerful(n) && n > BigInt.one) classifications.add(l.analysisPowerful);
      if (SpecialFunctionsService.isHarshad(n)) classifications.add(l.analysisHarshad);
      if (SpecialFunctionsService.isSemiprime(n)) classifications.add(l.analysisSemiprime);
      if (SpecialFunctionsService.isAbundant(n)) {
        classifications.add(l.analysisAbundant);
      } else if (SpecialFunctionsService.isDeficient(n)) {
        classifications.add(l.analysisDeficient);
      }

      if (classifications.isNotEmpty) {
        rows.add(_buildInfoRow(l.analysisClassification, classifications.join(', '), maxLines: 3));
      }
    } catch (_) {
      // Si hay error en cálculos, simplemente no mostrar
    }
    return rows;
  }
}
