import 'package:flutter/material.dart';
import '../../models/quiz_problem.dart';
import '../../services/quiz_service.dart';
import 'olympiad_strings.dart';

/// Modo de práctica: presenta problemas con respuesta numérica, verifica la
/// entrada del estudiante y lleva el puntaje.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextEditingController _controller = TextEditingController();
  QuizProblem? _problem;
  bool? _lastCorrect;
  int _correct = 0;
  int _total = 0;
  bool _answered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _problem ??= QuizService.generate(
        spanish: Localizations.localeOf(context).languageCode == 'es');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() {
    if (_answered || _problem == null) return;
    final ok = _problem!.isCorrect(_controller.text);
    setState(() {
      _answered = true;
      _lastCorrect = ok;
      _total++;
      if (ok) _correct++;
    });
  }

  void _next() {
    setState(() {
      _problem = QuizService.generate(
          spanish: Localizations.localeOf(context).languageCode == 'es');
      _controller.clear();
      _answered = false;
      _lastCorrect = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    final theme = Theme.of(context);
    final p = _problem!;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.catQuiz),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(s.quizScore(_correct, _total),
                  style: theme.textTheme.titleSmall),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(p.topic),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(height: 12),
                  Text(p.prompt, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    enabled: !_answered,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: s.quizAnswer,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _answered ? _next() : _check(),
                  ),
                  const SizedBox(height: 16),
                  if (_answered && _lastCorrect != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: _lastCorrect!
                            ? Colors.green.withValues(alpha: 0.15)
                            : theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _lastCorrect! ? Icons.check_circle : Icons.cancel,
                            color: _lastCorrect!
                                ? Colors.green
                                : theme.colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _lastCorrect!
                                  ? s.quizCorrect
                                  : s.quizIncorrect(p.answer),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _answered
                        ? FilledButton.icon(
                            onPressed: _next,
                            icon: const Icon(Icons.arrow_forward, size: 18),
                            label: Text(s.quizNext),
                          )
                        : FilledButton.icon(
                            onPressed: _check,
                            icon: const Icon(Icons.check, size: 18),
                            label: Text(s.quizCheck),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
