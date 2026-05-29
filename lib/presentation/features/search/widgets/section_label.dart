import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';

const _kIconSize = 16.0;
const _kBadgeRadius = 4.0;

/// Label que representa una sección, con icono opcional y badge de count.
class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.label, this.icon, this.count});
  final String label;
  final IconData? icon;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    final textStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w800,
      color: color,
      letterSpacing: AppTextStyle.labelLetterSpacing,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: _kIconSize, color: color),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(label, style: textStyle),
        if (count != null) ...[
          const SizedBox(width: AppSpacing.xs),
          _CountBadge(count: count!),
        ],
      ],
    );
  }
}

/// Badge con el número de elementos.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(_kBadgeRadius),
      ),
      child: Text(
        '$count',
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
