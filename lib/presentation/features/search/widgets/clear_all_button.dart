import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

const _kClearIconSize = 16.0;

/// Botón de limpiar filtros reutilizable
class ClearAllButton extends StatelessWidget {
  const ClearAllButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          color: colors.errorContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(color: colors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.close, size: _kClearIconSize, color: colors.error),
            const SizedBox(width: AppSpacing.xs),
            Text(
              l10n.searchClearAll,
              style: theme.textTheme.labelMedium?.copyWith(
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
