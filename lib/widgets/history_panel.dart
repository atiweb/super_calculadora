import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/operation_entry.dart';
import '../services/calculator_service.dart';

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        if (!calculator.isHistoryVisible) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              // Header del historial
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.history,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l.histTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${calculator.history.length} ${l.histOperations}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: calculator.history.isNotEmpty
                          ? () => _showClearHistoryDialog(context, calculator)
                          : null,
                      icon: const Icon(Icons.delete_sweep),
                      iconSize: 20,
                      tooltip: l.histClearAll,
                    ),
                  ],
                ),
              ),

              // Lista del historial
              Expanded(
                child: calculator.history.isEmpty
                    ? _buildEmptyHistoryMessage(context)
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: calculator.history.length,
                        itemBuilder: (context, index) {
                          final entry = calculator.history[index];
                          return _buildHistoryItem(context, entry, calculator);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyHistoryMessage(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l.histEmpty,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.histEmptyHintAlt,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, OperationEntry entry, CalculatorService calculator) {
    final l = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      elevation: 1,
      child: InkWell(
        onTap: () => calculator.loadFromHistory(entry),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expresión
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        entry.expression,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'monospace',
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      switch (value) {
                        case 'copy_expression':
                          await _copyToClipboard(context, entry.expression);
                          break;
                        case 'copy_result':
                          await _copyToClipboard(context, entry.result);
                          break;
                        case 'copy_both':
                          await _copyToClipboard(context, '${entry.expression} = ${entry.result}');
                          break;
                        case 'use_result':
                          calculator.loadResultFromHistory(entry);
                          break;
                        case 'delete':
                          calculator.removeFromHistory(entry);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'copy_expression',
                        child: Row(
                          children: [
                            const Icon(Icons.content_copy, size: 18),
                            const SizedBox(width: 8),
                            Text(l.histCopyExpression),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'copy_result',
                        child: Row(
                          children: [
                            const Icon(Icons.content_copy, size: 18),
                            const SizedBox(width: 8),
                            Text(l.histCopyResult),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'copy_both',
                        child: Row(
                          children: [
                            const Icon(Icons.content_copy, size: 18),
                            const SizedBox(width: 8),
                            Text(l.histCopyAll),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'use_result',
                        child: Row(
                          children: [
                            const Icon(Icons.input, size: 18),
                            const SizedBox(width: 8),
                            Text(l.histUseResult),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, size: 18, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(l.histDelete, style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    child: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Separador
              Container(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),

              const SizedBox(height: 4),

              // Resultado
              Row(
                children: [
                  Text(
                    '= ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        entry.result,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Timestamp
                  Text(
                    _formatTimestamp(context, entry),
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(BuildContext context, OperationEntry entry) {
    // Entradas del formato antiguo, sin marca de tiempo persistida
    if (!entry.timestampKnown) return '—';
    final l = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(entry.timestamp);

    if (difference.inMinutes < 1) {
      return l.histNow;
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    final l = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: text));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.histCopiedClipboardText(text.length > 50 ? '${text.substring(0, 50)}...' : text)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showClearHistoryDialog(BuildContext context, CalculatorService calculator) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.histClearAll),
        content: Text(
          l.histConfirmClearN(calculator.history.length.toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.calcCancel),
          ),
          FilledButton(
            onPressed: () {
              calculator.clearHistory();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l.histDeleted),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(l.histDelete),
          ),
        ],
      ),
    );
  }
}
