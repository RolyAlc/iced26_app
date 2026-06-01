import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iced26/core/constants/design_tokens.dart';

TextStyle? chipLabelStyle(
  TextTheme textTheme, {
  required bool selected,
  required Color color,
}) {
  return textTheme.labelMedium?.copyWith(
    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
    color: color,
  );
}

/// Contenedor reutilizable para chips.
class ChipContainer extends StatelessWidget {
  const ChipContainer({
    super.key,
    required this.selected,
    required this.accentColor,
    required this.onTap,
    required this.child,
  });
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: AppDuration.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          color: selected
              ? accentColor.withValues(alpha: 0.12)
              : colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(
            color: selected
                ? accentColor.withValues(alpha: 0.4)
                : colors.outlineVariant,
          ),
        ),
        child: child,
      ),
    );
  }
}
