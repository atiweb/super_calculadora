import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../models/theme_mode.dart' as app_theme;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _themeDisplayName(app_theme.ThemeMode mode, AppLocalizations l) {
    switch (mode) {
      case app_theme.ThemeMode.light:
        return l.themeLight;
      case app_theme.ThemeMode.dark:
        return l.themeDark;
      case app_theme.ThemeMode.system:
        return l.themeAuto;
    }
  }

  String _themeDescription(app_theme.ThemeMode mode, AppLocalizations l) {
    switch (mode) {
      case app_theme.ThemeMode.light:
        return l.themeLightDesc;
      case app_theme.ThemeMode.dark:
        return l.themeDarkDesc;
      case app_theme.ThemeMode.system:
        return l.themeAutoDesc;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.settingsTitle),
        elevation: 0,
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Tema Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.palette,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l.settingsTheme,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...app_theme.ThemeMode.values.map((themeMode) {
                        final selected = themeProvider.currentTheme == themeMode;
                        return ListTile(
                          title: Text(_themeDisplayName(themeMode, l)),
                          subtitle: Text(_themeDescription(themeMode, l)),
                          leading: Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).iconTheme.color,
                          ),
                          onTap: () {
                            themeProvider.setTheme(themeMode);
                            setState(() {});
                          },
                          contentPadding: EdgeInsets.zero,
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Idioma / Language Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.language,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l.settingsLanguage,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...[
                        {'code': '', 'label': l.settingsLangAuto, 'subtitle': l.settingsLangAutoDesc},
                        {'code': 'es', 'label': l.settingsLangEs, 'subtitle': null},
                        {'code': 'en', 'label': l.settingsLangEn, 'subtitle': null},
                      ].map((option) {
                        final code = option['code'] as String;
                        final selected = (themeProvider.locale == null && code.isEmpty) ||
                            (themeProvider.locale != null && themeProvider.locale!.languageCode == code);
                        return ListTile(
                          title: Text(option['label'] as String),
                          subtitle: option['subtitle'] != null ? Text(option['subtitle'] as String) : null,
                          leading: Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).iconTheme.color,
                          ),
                          onTap: () {
                            themeProvider.setLocale(code);
                            setState(() {});
                          },
                          contentPadding: EdgeInsets.zero,
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Formato de números Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.format_list_numbered,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l.settingsNumberFormat,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(l.settingsScientificNotation),
                        subtitle: Text(l.settingsScientificHint),
                        value: themeProvider.useScientificNotation,
                        onChanged: (bool value) {
                          themeProvider.setUseScientificNotation(value);
                        },
                        secondary: Icon(
                          themeProvider.useScientificNotation
                            ? Icons.functions
                            : Icons.format_list_numbered,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l.settingsFormatExamples,
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l.settingsLargeNumber,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${l.settingsNormal} 12345678901234567890',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${l.settingsScientific} 1.23456789012345678e+14',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l.settingsSmallNumber,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${l.settingsNormal} 0.000123',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${l.settingsScientific} 1.23e-4',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Informações do App
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l.settingsAboutApp,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.calculate),
                        title: Text(l.appTitle),
                        subtitle: Text(l.appVersion),
                        contentPadding: EdgeInsets.zero,
                      ),
                      ListTile(
                        leading: const Icon(Icons.code),
                        title: Text(l.appDeveloped),
                        subtitle: Text(l.appDynamicThemes),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
