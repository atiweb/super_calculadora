import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/calculator_service.dart';

class NumberAnalysisCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const NumberAnalysisCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  State<NumberAnalysisCard> createState() => _NumberAnalysisCardState();
}

class _NumberAnalysisCardState extends State<NumberAnalysisCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              widget.icon,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
        ],
      ),
    );
  }
}

class PropertyChip extends StatelessWidget {
  final String label;
  final bool isTrue;

  const PropertyChip({
    super.key,
    required this.label,
    required this.isTrue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: isTrue
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        labelStyle: TextStyle(
          color: isTrue
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
        side: BorderSide(
          color: isTrue
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
    );
  }
}

class QuickAnalysisWidget extends StatelessWidget {
  const QuickAnalysisWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        final analysis = calculator.currentAnalysis;

        if (analysis.isEmpty) {
          return const SizedBox.shrink();
        }

        List<Widget> properties = [];

        // Agregar propiedades booleanas como chips
        if (analysis['isPrime'] == true) {
          properties.add(PropertyChip(label: l.cardPrime, isTrue: true));
        }
        if (analysis['isPerfect'] == true) {
          properties.add(PropertyChip(label: l.cardPerfect, isTrue: true));
        }
        if (analysis['isPalindrome'] == true) {
          properties.add(PropertyChip(label: l.cardPalindrome, isTrue: true));
        }
        if (analysis['isFibonacci'] == true) {
          properties.add(PropertyChip(label: l.cardFibonacci, isTrue: true));
        }
        if (analysis['isTriangular'] == true) {
          properties.add(PropertyChip(label: l.cardTriangular, isTrue: true));
        }
        if (analysis['isEven'] == true) {
          properties.add(PropertyChip(label: l.cardEven, isTrue: true));
        } else if (analysis['isOdd'] == true) {
          properties.add(PropertyChip(label: l.cardOdd, isTrue: true));
        }

        if (properties.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.cardQuickProperties,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                children: properties,
              ),
            ],
          ),
        );
      },
    );
  }
}

class BinaryConverterWidget extends StatelessWidget {
  const BinaryConverterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.cardConvert,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: calculator.toggleBinaryDecimal,
                      icon: const Icon(Icons.transform),
                      label: Text(calculator.isBinaryNumber ? l.cardToDecimal : l.cardToBinary),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class AdvancedOperationsWidget extends StatelessWidget {
  const AdvancedOperationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.cardAdvancedOps,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: calculator.squareRoot,
                    icon: const Icon(Icons.square_foot),
                    label: const Text('√'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: calculator.cubeRoot,
                    icon: const Icon(Icons.crop_3_2),
                    label: const Text('∛'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => calculator.power('2'),
                    icon: const Icon(Icons.exposure_plus_2),
                    label: const Text('x²'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => calculator.power('3'),
                    icon: const Icon(Icons.exposure_plus_1),
                    label: const Text('x³'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class LargeNumberDisplay extends StatefulWidget {
  final String number;
  final String label;
  final bool allowScientific;

  const LargeNumberDisplay({
    super.key,
    required this.number,
    required this.label,
    this.allowScientific = true,
  });

  @override
  State<LargeNumberDisplay> createState() => _LargeNumberDisplayState();
}

class _LargeNumberDisplayState extends State<LargeNumberDisplay> {
  bool _useScientific = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (widget.number == 'N/A' || widget.number.isEmpty) {
      return ListTile(
        title: Text(widget.label),
        subtitle: const Text('N/A'),
      );
    }

    String displayNumber = widget.number;
    bool isLarge = widget.number.length > 20;

    if (_useScientific && isLarge) {
      displayNumber = _formatScientificNotation(widget.number);
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con controles
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (isLarge && widget.allowScientific) ...[
                  IconButton(
                    icon: Icon(
                      _useScientific ? Icons.expand_more : Icons.science,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _useScientific = !_useScientific;
                      });
                    },
                    tooltip: _useScientific
                        ? 'Mostrar número completo'
                        : 'Usar notación científica',
                  ),
                ],
                if (isLarge)
                  IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.unfold_less : Icons.unfold_more,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    tooltip: _isExpanded ? 'Contraer' : 'Expandir',
                  ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () => _copyToClipboard(context, widget.number),
                  tooltip: l.displayCopy,
                ),
              ],
            ),

            // Contenido del número
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: _buildNumberContent(displayNumber, isLarge),
            ),

            // Información adicional
            if (isLarge)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${widget.number.length} ${l.cardDigits}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberContent(String displayNumber, bool isLarge) {
    if (!isLarge || _useScientific) {
      return SelectableText(
        displayNumber,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
        ),
      );
    }

    // Para números largos, usar diferentes estrategias de visualización
    if (_isExpanded) {
      return SingleChildScrollView(
        child: SelectableText(
          displayNumber,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
      );
    } else {
      // Mostrar solo el inicio y el final
      int maxLength = 40;
      if (displayNumber.length > maxLength) {
        final l = AppLocalizations.of(context)!;
        String start = displayNumber.substring(0, 15);
        String end = displayNumber.substring(displayNumber.length - 15);
        return SelectableText(
          '$start...${displayNumber.length - 30} ${l.cardDigits}...$end',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        );
      } else {
        return SelectableText(
          displayNumber,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        );
      }
    }
  }

  String _formatScientificNotation(String number) {
    try {
      double value = double.parse(number);
      return value.toStringAsExponential(6);
    } catch (e) {
      // Para números extremadamente grandes
      if (number.length > 15 && !number.contains('.')) {
        String mantissa = number.substring(0, 1);
        if (number.length > 1) {
          mantissa += '.${number.substring(1, 7)}';
        }
        return '${mantissa}e+${number.length - 1}';
      }
      return number;
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    final l = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.displayCopied(widget.label)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
