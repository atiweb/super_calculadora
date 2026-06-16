import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/calc_exception.dart';
import 'olympiad_strings.dart';

/// Descripción de un campo de entrada de una herramienta.
class ToolField {
  final String label;
  final String? hint;
  final String initial;

  const ToolField(this.label, {this.hint, this.initial = ''});
}

/// Tarjeta de herramienta reutilizable: muestra una descripción, los campos de
/// entrada, un botón "Calcular" y el resultado (o el error) de forma legible.
///
/// [compute] recibe los valores de los campos y devuelve el resultado como
/// texto (puede ser multilínea). Si lanza una excepción, se muestra el mensaje
/// como error.
///
/// [visualize] es opcional: si se provee, se llama con las mismas entradas que
/// produjeron el último resultado exitoso y su Widget se muestra bajo el texto.
class CalcTool extends StatefulWidget {
  final String title;
  final String? description;
  final List<ToolField> fields;

  /// Cálculo síncrono (rápido). Usar para la mayoría de herramientas.
  final String Function(List<String> inputs)? compute;

  /// Cálculo asíncrono (p. ej. alta precisión en un isolate). Si se provee,
  /// el botón muestra un indicador de progreso y NO se bloquea la UI.
  final Future<String> Function(List<String> inputs)? computeAsync;

  final Widget? Function(BuildContext context, List<String> inputs)? visualize;

  const CalcTool({
    super.key,
    required this.title,
    this.description,
    required this.fields,
    this.compute,
    this.computeAsync,
    this.visualize,
  }) : assert(compute != null || computeAsync != null,
            'Provide compute or computeAsync');

  @override
  State<CalcTool> createState() => _CalcToolState();
}

class _CalcToolState extends State<CalcTool> {
  late final List<TextEditingController> _controllers;
  String? _result;
  String? _error;
  List<String>? _lastSuccessfulInputs;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _controllers = widget.fields
        .map((f) => TextEditingController(text: f.initial))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  /// Traduce una excepción a texto legible (CalcException por código, etc.).
  String _translate(Object e, OlympiadStrings s) {
    if (e is CalcException) return s.errorText(e);
    if (e is FormatException) return e.message;
    if (e is ArgumentError) return e.message?.toString() ?? e.toString();
    return e.toString();
  }

  Future<void> _run() async {
    final s = OlympiadStrings.of(context);
    final inputs = _controllers.map((c) => c.text.trim()).toList();

    // Ruta asíncrona (alta precisión en isolate): muestra progreso, sin congelar.
    if (widget.computeAsync != null) {
      setState(() {
        _busy = true;
        _error = null;
      });
      String? result;
      String? error;
      try {
        result = await widget.computeAsync!(inputs);
      } catch (e) {
        error = _translate(e, s);
      }
      if (!mounted) return;
      setState(() {
        _busy = false;
        if (error == null) {
          _result = result;
          _lastSuccessfulInputs = inputs;
          _error = null;
        } else {
          _error = '${s.errorPrefix}: $error';
          _result = null;
        }
      });
      return;
    }

    // Ruta síncrona (rápida).
    setState(() {
      try {
        _result = widget.compute!(inputs);
        _lastSuccessfulInputs = inputs;
        _error = null;
      } catch (e) {
        _error = '${s.errorPrefix}: ${_translate(e, s)}';
        _result = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = OlympiadStrings.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            if (widget.description != null) ...[
              const SizedBox(height: 4),
              Text(widget.description!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
            const SizedBox(height: 12),
            for (int i = 0; i < widget.fields.length; i++) ...[
              TextField(
                controller: _controllers[i],
                decoration: InputDecoration(
                  labelText: widget.fields[i].label,
                  hintText: widget.fields[i].hint,
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _run(),
              ),
              const SizedBox(height: 8),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _busy ? null : _run,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow, size: 18),
                label: Text(s.compute),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SelectableText(
                        _result!,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontFamily: 'monospace'),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Copy',
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _result!));
                      },
                    ),
                  ],
                ),
              ),
            ],
            if (_result != null &&
                widget.visualize != null &&
                _lastSuccessfulInputs != null) ...[
              const SizedBox(height: 12),
              Builder(builder: (context) {
                Widget? visual;
                try {
                  visual = widget.visualize!(context, _lastSuccessfulInputs!);
                } catch (_) {
                  visual = null;
                }
                if (visual == null) return const SizedBox.shrink();
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: 220,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: visual,
                  ),
                );
              }),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
