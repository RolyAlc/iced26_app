import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// Widget auxiliar para mostrar información en la búsqueda.
class SearchHelper extends StatelessWidget {
  const SearchHelper({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: colors.primary.withValues(alpha: 0.15)),
          const SizedBox(height: AppSpacing.m),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
