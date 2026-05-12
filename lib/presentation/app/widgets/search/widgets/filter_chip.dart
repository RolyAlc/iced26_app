import 'package:flutter/material.dart';

import 'package:iced26/presentation/app/widgets/search/widgets/chip_container.dart';

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

/// Chip que representa un filtro.
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ChipContainer(
      selected: selected,
      accentColor: colors.primary,
      onTap: onTap,
      child: Text(
        label,
        style: chipLabelStyle(
          theme.textTheme,
          selected: selected,
          color: selected ? colors.primary : colors.onSurface,
        ),
      ),
    );
  }
}
