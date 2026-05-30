import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/calculator_display.dart';
import '../widgets/calculator_keyboard.dart';
import '../widgets/scientific_calculator_keyboard.dart';
import '../widgets/special_calculator_keyboard.dart';
import '../widgets/calculator_drawer.dart';
import '../widgets/number_analysis_panel.dart';
import '../widgets/expression_input.dart';
import '../widgets/history_panel.dart';
import '../widgets/about_dialog.dart';
import '../services/calculator_service.dart';
import '../models/calculator_config.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          drawer: const CalculatorDrawer(),
          appBar: AppBar(
            title: Text(
              _getAppBarTitle(calculator, l),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            elevation: 0,
            actions: [
              if (calculator.calculatorType == CalculatorType.scientific)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    calculator.angleMode,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => AppAboutDialog.show(context),
                tooltip: l.navAbout,
              ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  // Mostrar ExpressionInput solo en la pestaña de expresiones
                  if (_currentPage == 2) const ExpressionInput(),

                  // Display de la calculadora (solo en páginas 0 y 1)
                  if (_currentPage != 2)
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: const CalculatorDisplay(),
                      ),
                    ),

                  // Navegación entre páginas
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTabButton(
                          context,
                          0,
                          Icons.calculate,
                          l.navCalculator,
                        ),
                        _buildTabButton(
                          context,
                          1,
                          Icons.analytics,
                          l.calcAnalysis,
                        ),
                        _buildTabButton(
                          context,
                          2,
                          Icons.functions,
                          l.calcExpressions,
                        ),
                      ],
                    ),
                  ),

                  // Contenido de las páginas
                  Expanded(
                    flex: _currentPage == 2 ? 3 : 4,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        // Página de calculadora
                        calculator.calculatorType == CalculatorType.scientific
                            ? const ScientificCalculatorKeyboard()
                            : calculator.calculatorType == CalculatorType.special
                                ? const SpecialCalculatorKeyboard()
                                : const CalculatorKeyboard(),

                        // Página de análisis
                        const NumberAnalysisPanel(),

                        // Página de expresiones matemáticas con historial
                        Column(
                          children: [
                            // Display del resultado actual
                            if (calculator.display != '0' && !calculator.hasError) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l.calcResult,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      calculator.display,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'monospace',
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // Panel de historial
                            const Expanded(child: HistoryPanel()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Overlay para operaciones pesadas
              if (calculator.isCalculatingOperation)
                _buildOperationLoadingOverlay(context, calculator, l),
            ],
          ),
        );
      },
    );
  }

  String _getAppBarTitle(CalculatorService calculator, AppLocalizations l) {
    switch (_currentPage) {
      case 0:
        if (calculator.calculatorType == CalculatorType.scientific) {
          return l.calcScientific;
        } else if (calculator.calculatorType == CalculatorType.special) {
          return l.calcSpecialFunctions;
        } else {
          return l.calcSuperCalculator;
        }
      case 1:
        return l.calcNumericAnalysis;
      case 2:
        return l.calcMathExpressions;
      default:
        return l.calcSuperCalculator;
    }
  }

  Widget _buildTabButton(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final bool isSelected = _currentPage == index;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el overlay de carga para operaciones pesadas
  Widget _buildOperationLoadingOverlay(BuildContext context, CalculatorService calculator, AppLocalizations l) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              Text(
                calculator.operationProgress,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l.calcProcessing,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (calculator.canCancelOperation)
                ElevatedButton.icon(
                  onPressed: () {
                    calculator.cancelCurrentOperation();
                  },
                  icon: const Icon(Icons.cancel),
                  label: Text(l.calcCancel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
