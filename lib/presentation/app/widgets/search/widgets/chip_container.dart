import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iced26/core/constants/design_tokens.dart';

/// Contenedor reutilizable para chips.
class ChipContainer extends StatelessWidget {
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;
  final Widget child;

  const ChipContainer({
    super.key,
    required this.selected,
    required this.accentColor,
    required this.onTap,
    required this.child,
  });

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
              : colors.surfaceContainerLow,
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
