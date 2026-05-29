import 'package:flutter/material.dart';

import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Pantalla de error genérica para mostrar mensajes de error de forma amigable.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.error, this.onRetry});

  final String error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppIcons.error, color: theme.colorScheme.error, size: 60),
              const SizedBox(height: 16),
              Text(
                l10n.errorScreenTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                FilledButton.tonal(onPressed: onRetry, child: Text(l10n.retry)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
