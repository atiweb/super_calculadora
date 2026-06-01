import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/calculator_service.dart';
import '../models/calculator_config.dart';
import '../screens/olympiad/olympiad_strings.dart';
import 'about_dialog.dart';

class CalculatorDrawer extends StatelessWidget {
  const CalculatorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorService>(
      builder: (context, calculator, child) {
        final l = AppLocalizations.of(context)!;
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.calculate,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.navCalculator,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l.navSelectType,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.calculate_outlined),
                title: Text(l.navStandard),
                subtitle: Text(l.navStandardSub),
                selected: calculator.calculatorType == CalculatorType.standard,
                onTap: () {
                  calculator.setCalculatorType(CalculatorType.standard);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.science),
                title: Text(l.navScientific),
                subtitle: Text(l.navScientificSub),
                selected: calculator.calculatorType == CalculatorType.scientific,
                onTap: () {
                  calculator.setCalculatorType(CalculatorType.scientific);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.functions),
                title: Text(l.navSpecial),
                subtitle: Text(l.navSpecialSub),
                selected: calculator.calculatorType == CalculatorType.special,
                onTap: () {
                  calculator.setCalculatorType(CalculatorType.special);
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              if (calculator.calculatorType == CalculatorType.scientific)
                ListTile(
                  leading: Icon(
                    calculator.isRadianMode ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  ),
                  title: Text(l.navAngleMode(calculator.angleMode)),
                  subtitle: Text(
                    calculator.isRadianMode ? l.navRadians : l.navDegrees,
                  ),
                  onTap: () {
                    calculator.toggleAngleMode();
                  },
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.history),
                title: Text(l.navHistory),
                subtitle: Text(l.navHistorySub),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/history');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(l.navSettings),
                subtitle: Text(l.navSettingsSub),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_events_outlined),
                title: Text(OlympiadStrings.of(context).title),
                subtitle: Text(OlympiadStrings.of(context).subtitle),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/olympiad');
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: Text(l.navHelp),
                subtitle: Text(l.navHelpSub),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/special-help');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l.navAbout),
                subtitle: Text(l.navAboutSub),
                onTap: () {
                  AppAboutDialog.show(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
