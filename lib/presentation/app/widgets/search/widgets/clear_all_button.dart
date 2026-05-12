import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Botón de limpiar filtros reutilizable
class ClearAllButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ClearAllButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: colors.errorContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(color: colors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.close, size: 12, color: colors.error),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Clear',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
