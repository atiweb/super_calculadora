import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../models/operation_entry.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<OperationEntry> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final history = await HistoryService.getHistory();
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.histErrorLoading(e.toString()))),
        );
      }
    }
  }

  Future<void> _clearHistory() async {
    final l = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.histClearAll),
        content: Text(l.histConfirmClear),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.calcCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.histDelete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await HistoryService.clearHistory();
        await _loadHistory();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.histCleared)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.histErrorClearing(e.toString()))),
          );
        }
      }
    }
  }

  Future<void> _removeOperation(OperationEntry operation) async {
    final l = AppLocalizations.of(context)!;
    try {
      await HistoryService.removeOperation(operation);
      await _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.histOperationDeleted)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.histErrorDeleting(e.toString()))),
        );
      }
    }
  }

  void _copyToClipboard(String text) {
    final l = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.histCopiedToClipboard)),
    );
  }

  void _showResultDialog(OperationEntry operation) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.histFullResult,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    tooltip: l.histClose,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.histExpression,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: SelectableText(
                          operation.expression,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l.histResult,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: SelectableText(
                          _formatNumberForDisplay(operation.result),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _copyToClipboard(operation.result),
                      icon: const Icon(Icons.copy),
                      label: Text(l.histCopyResult),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _copyToClipboard('${operation.expression} = ${operation.result}'),
                      icon: const Icon(Icons.copy_all),
                      label: Text(l.histCopyAll),
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} m';
    } else {
      final l = AppLocalizations.of(context)!;
      return l.histNow;
    }
  }

  bool _isResultTooLong(String result) {
    return result.length > 20;
  }

  String _formatNumberForDisplay(String number) {
    if (number.length <= 50) {
      return number;
    }

    StringBuffer formatted = StringBuffer();
    int lineLength = 0;
    const int maxLineLength = 50;

    for (int i = 0; i < number.length; i++) {
      String char = number[i];
      formatted.write(char);
      lineLength++;

      if (lineLength >= maxLineLength &&
          (char == ',' || char == '.' || char == ' ' ||
           (i < number.length - 1 && RegExp(r'\d').hasMatch(char) && RegExp(r'\d').hasMatch(number[i + 1])))) {
        formatted.write('\n');
        lineLength = 0;
      }
      else if (lineLength >= maxLineLength && i < number.length - 1) {
        formatted.write('\n');
        lineLength = 0;
      }
    }

    return formatted.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.histTitle),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        elevation: 0,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearHistory,
              tooltip: l.histClearAllTooltip,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l.histEmpty,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l.histEmptyHint,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final operation = _history[index];
                    final isResultLong = _isResultTooLong(operation.result);

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          operation.expression,
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (isResultLong)
                                        GestureDetector(
                                          onTap: () => _showResultDialog(operation),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primaryContainer,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  l.histViewResult,
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Icon(
                                                  Icons.visibility,
                                                  size: 16,
                                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      else
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            '= ${operation.result}',
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'monospace',
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'copy_expression':
                                        _copyToClipboard(operation.expression);
                                        break;
                                      case 'copy_result':
                                        _copyToClipboard(operation.result);
                                        break;
                                      case 'copy_all':
                                        _copyToClipboard('${operation.expression} = ${operation.result}');
                                        break;
                                      case 'delete':
                                        _removeOperation(operation);
                                        break;
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'copy_expression',
                                      child: Row(
                                        children: [
                                          const Icon(Icons.copy),
                                          const SizedBox(width: 8),
                                          Text(l.histCopyExpression),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'copy_result',
                                      child: Row(
                                        children: [
                                          const Icon(Icons.copy),
                                          const SizedBox(width: 8),
                                          Text(l.histCopyResult),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'copy_all',
                                      child: Row(
                                        children: [
                                          const Icon(Icons.copy_all),
                                          const SizedBox(width: 8),
                                          Text(l.histCopyAll),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuDivider(),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          const Icon(Icons.delete, color: Colors.red),
                                          const SizedBox(width: 8),
                                          Text(l.histDelete, style: const TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatTimestamp(operation.timestamp),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
