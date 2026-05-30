import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/calculator_service.dart';
import '../utils/error_localizer.dart';

class ExpressionInput extends StatelessWidget {
  const ExpressionInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y botones de acción
              Row(
                children: [
                  Icon(
                    Icons.calculate_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l.exprMathExpression,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),

                  // Botón de historial
                  IconButton(
                    onPressed: calculator.toggleHistoryVisibility,
                    icon: Icon(
                      calculator.isHistoryVisible ? Icons.history : Icons.history_outlined,
                      size: 20,
                    ),
                    tooltip: calculator.isHistoryVisible ? l.exprHideHistory : l.exprShowHistory,
                    style: IconButton.styleFrom(
                      backgroundColor: calculator.isHistoryVisible
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      foregroundColor: calculator.isHistoryVisible
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : null,
                    ),
                  ),

                  // Botón para limpiar
                  IconButton(
                    onPressed: calculator.expressionController.text.isNotEmpty
                        ? calculator.clearExpression
                        : null,
                    icon: const Icon(Icons.clear, size: 20),
                    tooltip: l.exprClearExpression,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Campo de entrada de expresión
              TextField(
                controller: calculator.expressionController,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: l.exprHint,
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón de borrar último carácter
                      IconButton(
                        onPressed: calculator.expressionController.text.isNotEmpty
                            ? calculator.backspaceExpression
                            : null,
                        icon: const Icon(Icons.backspace_outlined, size: 18),
                        tooltip: l.exprDelete,
                      ),

                      // Botón de evaluar
                      IconButton(
                        onPressed: calculator.expressionController.text.isNotEmpty
                            ? calculator.evaluateAndAddToHistory
                            : null,
                        icon: Icon(
                          Icons.play_arrow,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        tooltip: l.exprEvaluate,
                        style: IconButton.styleFrom(
                          backgroundColor: calculator.expressionController.text.isNotEmpty
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                onSubmitted: (_) {
                  if (calculator.expressionController.text.isNotEmpty) {
                    calculator.evaluateAndAddToHistory();
                  }
                },
                maxLines: 2,
                minLines: 1,
              ),

              const SizedBox(height: 8),

              // Botones de funciones matemáticas comunes
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  _buildFunctionButton(context, calculator, '(', l.exprParenthesis),
                  _buildFunctionButton(context, calculator, ')', l.exprParenthesis),
                  _buildFunctionButton(context, calculator, 'sqrt(', l.exprSquareRoot),
                  _buildFunctionButton(context, calculator, '^', l.exprPower),
                  _buildFunctionButton(context, calculator, 'sin(', l.exprSin),
                  _buildFunctionButton(context, calculator, 'cos(', l.exprCos),
                  _buildFunctionButton(context, calculator, 'tan(', l.exprTan),
                  _buildFunctionButton(context, calculator, 'log(', l.exprLog),
                  _buildFunctionButton(context, calculator, 'ln(', l.exprLn),
                  _buildFunctionButton(context, calculator, 'π', l.exprPi),
                  _buildFunctionButton(context, calculator, 'e', l.exprEuler),
                ],
              ),

              // Mostrar error si existe
              if (calculator.hasError) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          localizeError(context, calculator.errorMessage, calculator.errorArgs),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildFunctionButton(BuildContext context, CalculatorService calculator, String function, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => calculator.insertInExpression(function),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            function,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
