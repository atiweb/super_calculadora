import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/calculator_service.dart';
import '../services/settings_service.dart';
import '../utils/error_localizer.dart';

class CalculatorDisplay extends StatefulWidget {
  const CalculatorDisplay({super.key});

  @override
  State<CalculatorDisplay> createState() => _CalculatorDisplayState();
}

class _CalculatorDisplayState extends State<CalculatorDisplay> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Última operación (historial)
              _buildLastOperationDisplay(context, calculator),
              const SizedBox(height: 2),

              // Indicador de operación pendiente (2 parámetros)
              if (calculator.hasPendingOperation)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      calculator.pendingDisplayLabel,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),

              // Expresión actual
              if (calculator.expression.isNotEmpty && !calculator.hasPendingOperation)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    calculator.expression,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: 'monospace',
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),

              // Botones de control
              const SizedBox(height: 4),
              _buildControlsRow(context, calculator),

              // Display principal (altura fija pequeña para evitar overflows en tests)
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _copyToClipboard(context, calculator.display),
                onLongPress: () => _showContextMenu(context, calculator),
                child: _buildDisplayContent(context, calculator),
              ),
            ],
          ),
        );
      },
    );
  }



  Widget _buildControlsRow(BuildContext context, CalculatorService calculator) {
    final l = AppLocalizations.of(context)!;
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (calculator.hasMemoryValue)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.memory,
                    size: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'M',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox.shrink(),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _pasteFromClipboard(context, calculator),
                icon: Icon(
                  Icons.paste,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                tooltip: l.displayPaste,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 28, height: 24),
              ),
              IconButton(
                onPressed: () => _copyToClipboard(context, calculator.display),
                icon: Icon(
                  Icons.copy,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                tooltip: l.displayCopy,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 28, height: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayContent(BuildContext context, CalculatorService calculator) {
    // Obtener la configuración del usuario
    bool useScientificNotation = SettingsService.getUseScientificNotation();

    String displayText = calculator.hasError
        ? localizeError(context, calculator.errorMessage, calculator.errorArgs)
        : _cleanDecimalDisplay(calculator.display);

    if (useScientificNotation && !calculator.hasError) {
      displayText = _formatScientificNotation(calculator.display);
    }

    bool isLargeNumber = displayText.length > 20 && !useScientificNotation && !calculator.hasError;

  if (isLargeNumber) {
      return _buildScrollableDisplay(context, displayText, calculator);
    } else {
      return _buildSingleLineDisplay(context, displayText, calculator);
    }
  }

  String _cleanDecimalDisplay(String number) {
    try {
      if (!number.contains('.')) return number;
      final parts = number.split('.');
      if (parts.length == 2 && RegExp(r'^0+$').hasMatch(parts[1])) {
        return parts[0];
      }
      return number;
    } catch (_) {
      return number;
    }
  }

  Widget _buildScrollableDisplay(BuildContext context, String displayText, CalculatorService calculator) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });

    return Container(
      width: double.infinity,
  constraints: const BoxConstraints(maxHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: SelectableText(
            displayText,
            style: TextStyle(
              fontSize: _calculateFontSize(displayText),
              fontWeight: FontWeight.bold,
              color: calculator.hasError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.onSurface,
              fontFamily: 'monospace',
              height: 1.2,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }

  double _calculateFontSize(String text) {
    final length = text.length;
    if (length <= 10) return 24;
    if (length <= 20) return 20;
    if (length <= 40) return 18;
    if (length <= 80) return 16;
    return 14;
  }

  Widget _buildSingleLineDisplay(BuildContext context, String displayText, CalculatorService calculator) {
    return Container(
      width: double.infinity,
  constraints: const BoxConstraints(maxHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: SelectableText(
          displayText,
          style: TextStyle(
            fontSize: _calculateFontSize(displayText),
            fontWeight: FontWeight.bold,
            color: calculator.hasError
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.onSurface,
            fontFamily: 'monospace',
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _buildLastOperationDisplay(BuildContext context, CalculatorService calculator) {
    final lastOperation = calculator.lastOperation;
    if (lastOperation == null) return const SizedBox.shrink();

    final operationText = '${lastOperation.expression} = ${_formatResultForHistory(lastOperation.result)}';

    return Row(
      children: [
        Icon(
      Icons.history,
      size: 12,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            operationText,
            style: TextStyle(
        fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              fontFamily: 'monospace',
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  String _formatResultForHistory(String result) {
    if (result.length > 15) {
      return '${result.substring(0, 12)}...';
    }
    return result;
  }

  String _formatScientificNotation(String number) {
    try {
      if (number.length <= 15) {
        final value = double.parse(number);
        return value.toStringAsExponential(6);
      }
      if (number.contains('.')) return number;
      final length = number.length;
      String mantissa = number.substring(0, 1);
      if (length > 1) {
        final digitsToTake = length > 8 ? 8 : length - 1;
        mantissa += '.${number.substring(1, 1 + digitsToTake)}';
      }
      return '${mantissa}e+${length - 1}';
    } catch (_) {
      return number;
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    final l = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.displayCopied(text.length > 20 ? '${text.substring(0, 20)}...' : text)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showContextMenu(BuildContext context, CalculatorService calculator) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: Text(l.displayCopyResult),
                onTap: () {
                  Navigator.pop(context);
                  _copyToClipboard(context, calculator.display);
                },
              ),
              ListTile(
                leading: const Icon(Icons.paste),
                title: Text(l.displayPasteNumber),
                onTap: () {
                  Navigator.pop(context);
                  _pasteFromClipboard(context, calculator);
                },
              ),
              ListTile(
                leading: const Icon(Icons.clear),
                title: Text(l.displayClearDisplay),
                onTap: () {
                  Navigator.pop(context);
                  calculator.clear();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pasteFromClipboard(BuildContext context, CalculatorService calculator) async {
    final l = AppLocalizations.of(context)!;
    try {
      final data = await Clipboard.getData('text/plain');
  if (!context.mounted) return;
      if (data != null && data.text != null) {
        final clipboardText = data.text!.trim();
        if (_isValidNumber(clipboardText)) {
          calculator.setDisplay(clipboardText);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.displayPasted(clipboardText.length > 20 ? '${clipboardText.substring(0, 20)}...' : clipboardText)),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.displayInvalidNumber),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.displayNothingToPaste),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
  if (!context.mounted) return;
      final l2 = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l2.displayPasteError(e.toString())),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool _isValidNumber(String text) {
    if (text.isEmpty) return false;
    text = text.replaceAll(' ', '');
    if (text.startsWith('0b')) {
      final binaryPart = text.substring(2);
      return RegExp(r'^[01]+$').hasMatch(binaryPart);
    }
    return RegExp(r'^-?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?$').hasMatch(text);
  }
}
