import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

// Intencionalmente 5px (no AppSpacing.s = 8px): chip decorativo en sheet de texto denso.
const double _kChipVerticalPadding = 5.0;
const double _kChipIconSize = AppTextSize.chip;

/// Chip decorativo para Track, tiempo, duración y sala en el sheet de detalle.
/// Admite icono opcional a la izquierda del texto.
class PresentationChip extends StatelessWidget {
  const PresentationChip({
    super.key,
    required this.label,
    this.primary = false,
    this.icon,
  });
  final String label;
  final bool primary;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fgColor = primary
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurfaceVariant;

    final bool iconAdded = icon != null;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: _kChipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: primary
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconAdded) ...[
            Icon(icon, size: _kChipIconSize, color: fgColor),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Encapsula el color semitransparente del tema para no repetirlo en cada sección.
class PresentationDivider extends StatelessWidget {
  const PresentationDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }
}
