import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/custom_function.dart';
import '../services/calculator_service.dart';
import '../services/custom_function_service.dart';

/// Management screen for user-defined functions: list, add, edit, delete.
class CustomFunctionsScreen extends StatelessWidget {
  const CustomFunctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.cfTitle)),
      body: SafeArea(
        child: Consumer<CalculatorService>(
          builder: (context, calculator, child) {
            final functions = calculator.customFunctions;
            if (functions.isEmpty) {
              return _buildEmptyState(context, l);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: functions.length,
              itemBuilder: (context, index) {
                final fn = functions[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      Icons.functions,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      fn.definition,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 15,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: l.cfDelete,
                      onPressed: () => _confirmDelete(context, fn),
                    ),
                    onTap: () => _openEditor(context, original: fn),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: Text(l.cfAdd),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.functions,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l.cfEmpty,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l.cfEmptyHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEditor(BuildContext context, {CustomFunction? original}) {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<CalculatorService>(),
        child: _FunctionEditorDialog(original: original),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, CustomFunction fn) async {
    final l = AppLocalizations.of(context)!;
    final calculator = context.read<CalculatorService>();

    // Deleting a function another one builds on would leave that other
    // definition broken at evaluation time.
    final List<String> usedBy =
        calculator.customFunctionsBrokenByRemoval(fn.name);
    if (usedBy.isNotEmpty) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l.cfDeleteTitle),
          content: Text(l.cfErrInUse(fn.name, usedBy.join(', '))),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                  MaterialLocalizations.of(dialogContext).okButtonLabel),
            ),
          ],
        ),
      );
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.cfDeleteTitle),
        content: Text(l.cfDeleteMessage(fn.signature)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cfCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.cfDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await CustomFunctionService.remove(fn.name);
      await calculator.reloadCustomFunctions();
    }
  }
}

/// Single-field editor, matching how the definition is read back:
/// "name(params) = expression".
class _FunctionEditorDialog extends StatefulWidget {
  final CustomFunction? original;

  const _FunctionEditorDialog({this.original});

  @override
  State<_FunctionEditorDialog> createState() => _FunctionEditorDialogState();
}

class _FunctionEditorDialogState extends State<_FunctionEditorDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  /// Set while a save is in flight: a second Enter/click passed the
  /// name-taken check before the list reloaded and stored a duplicate.
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.original?.definition ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
          widget.original == null ? l.cfEditorTitleNew : l.cfEditorTitleEdit),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            minLines: 1,
            maxLines: 3,
            // Multiline fields turn Enter into a newline (which ended up in
            // the saved body); Enter saves instead.
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
            decoration: InputDecoration(
              hintText: l.cfEditorHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              errorText: _errorText,
              errorMaxLines: 3,
            ),
            onChanged: (_) {
              if (_errorText != null) setState(() => _errorText = null);
            },
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 12),
          Text(
            l.cfEditorHelp,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cfCancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(l.cfSave),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (_saving) return;
    final l = AppLocalizations.of(context)!;
    final calculator = context.read<CalculatorService>();
    final navigator = Navigator.of(context);

    final CustomFunction fn;
    try {
      fn = CustomFunctionService.parseDefinition(_controller.text);
    } on CustomFunctionException catch (e) {
      setState(() => _errorText = _localizeProblem(l, e.code, e.arg));
      return;
    }

    final bool nameTaken = calculator.customFunctions
        .any((f) => f.name == fn.name && f.name != widget.original?.name);
    if (nameTaken) {
      setState(() => _errorText = l.cfErrNameTaken(fn.name));
      return;
    }

    final String? problem = calculator.validateCustomFunction(fn,
        replacesName: widget.original?.name);
    if (problem != null) {
      final int sep = problem.indexOf(':');
      final String code = sep < 0 ? problem : problem.substring(0, sep);
      final String arg = sep < 0 ? '' : problem.substring(sep + 1);
      setState(() => _errorText = _localizeProblem(l, code, arg));
      return;
    }

    // Renaming or changing the parameter list must not break functions
    // that call this one.
    final List<String> broken = calculator.customFunctionsBrokenBy(fn,
        replacesName: widget.original?.name);
    if (broken.isNotEmpty) {
      setState(() => _errorText = l.cfErrBreaksOthers(broken.join(', ')));
      return;
    }

    setState(() => _saving = true);
    if (widget.original == null) {
      await CustomFunctionService.add(fn);
    } else {
      await CustomFunctionService.update(widget.original!.name, fn);
    }
    await calculator.reloadCustomFunctions();
    // Only close the dialog if it is still there (a tap outside may have
    // dismissed it meanwhile; popping then closed the whole screen).
    if (mounted) navigator.pop();
  }

  String _localizeProblem(AppLocalizations l, String code, String arg) {
    switch (code) {
      case 'cfErrBadSignature':
        return l.cfErrBadSignature;
      case 'cfErrReservedName':
        return l.cfErrReservedName(arg);
      case 'cfErrBadParam':
        return l.cfErrBadParam(arg);
      case 'cfErrDupParam':
        return l.cfErrDupParam(arg);
      case 'cfErrNameTaken':
        return l.cfErrNameTaken(arg);
      case 'cfErrEmptyBody':
        return l.cfErrEmptyBody;
      case 'cfErrBodyInvalid':
        return l.cfErrBodyInvalid;
      case 'cfErrUnknownName':
        return l.cfErrUnknownName(arg);
      case 'errCustomFnArgs':
        return l.errCustomFnArgs(arg);
      case 'errCustomFnRecursion':
        return l.errCustomFnRecursion;
      case 'errExprMalformed':
        return l.cfErrBodyInvalid;
      case 'errResultTooLarge':
        return l.errResultTooLarge;
      default:
        return code;
    }
  }
}
