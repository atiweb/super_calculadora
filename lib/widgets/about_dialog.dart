import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Diálogo "Acerca de" unificado para la aplicación
class AppAboutDialog {
  static void show(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.calculate,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(l.aboutTitle),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.appVersion,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l.aboutFeatures,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              ..._buildFeaturesList(l),
              const SizedBox(height: 16),
              Text(
                l.aboutDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.aboutClose),
          ),
        ],
      ),
    );
  }

  static List<Widget> _buildFeaturesList(AppLocalizations l) {
    final features = [
      '• ${l.aboutFeature1}',
      '• ${l.aboutFeature2}',
      '• ${l.aboutFeature3}',
      '• ${l.aboutFeature4}',
      '• ${l.aboutFeature5}',
      '• ${l.aboutFeature6}',
      '• ${l.aboutFeature7}',
      '• ${l.aboutFeature8}',
      '• ${l.aboutFeature9}',
      '• ${l.aboutFeature10}',
      '• ${l.aboutFeature11}',
      '• ${l.aboutFeature12}',
      '• ${l.aboutFeature13}',
      '• ${l.aboutFeature14}',
      '• ${l.aboutFeature15}',
      '• ${l.aboutFeature16}',
      '• ${l.aboutFeature17}',
      '• ${l.aboutFeature18}',
    ];

    return features.map((feature) => Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        feature,
        style: const TextStyle(fontSize: 14),
      ),
    )).toList();
  }
}
