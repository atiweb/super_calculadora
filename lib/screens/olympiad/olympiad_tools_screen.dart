import 'package:flutter/material.dart';
import 'olympiad_strings.dart';
import 'olympiad_tool_screens.dart';
import 'quiz_screen.dart';

/// Pantalla principal (hub) de las Herramientas de Olimpiada: una tarjeta por
/// categoría que abre la pantalla de herramientas correspondiente.
class OlympiadToolsScreen extends StatelessWidget {
  const OlympiadToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = OlympiadStrings.of(context);
    final theme = Theme.of(context);

    final categories = <_Category>[
      _Category(Icons.pie_chart_outline, s.catFractions, s.catFractionsSub,
          () => const FractionsToolScreen()),
      _Category(Icons.square_foot, s.catSurds, s.catSurdsSub,
          () => const SurdsToolScreen()),
      _Category(Icons.change_history, s.catGeometry, s.catGeometrySub,
          () => const GeometryToolScreen()),
      _Category(Icons.functions, s.catPolynomials, s.catPolynomialsSub,
          () => const PolynomialsToolScreen()),
      _Category(Icons.calculate, s.catNumberTheory, s.catNumberTheorySub,
          () => const NumberTheoryToolScreen()),
      _Category(Icons.list_alt, s.catSteps, s.catStepsSub,
          () => const StepsToolScreen()),
      _Category(Icons.auto_awesome, s.catComplexSeq, s.catComplexSeqSub,
          () => const ComplexSequencesToolScreen()),
      _Category(Icons.quiz_outlined, s.catQuiz, s.catQuizSub,
          () => const QuizScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(s.title), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(s.subtitle,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          for (final c in categories)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(c.icon, color: theme.colorScheme.onPrimaryContainer),
                ),
                title: Text(c.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(c.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => c.builder()),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Category {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget Function() builder;

  const _Category(this.icon, this.title, this.subtitle, this.builder);
}
