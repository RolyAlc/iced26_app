import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/search/widgets/chip_container.dart';

/// Botón reutilizable para activar y desactivar filtros
class FilterToggleButton extends StatelessWidget {
  const FilterToggleButton({
    super.key,
    required this.count,
    required this.isExpanded,
    required this.onTap,
  });
  final int count;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isActive = count > 0;

    return ChipContainer(
      selected: isActive,
      accentColor: colors.primary,
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcons.filter,
            size: 16,
            color: isActive ? colors.primary : colors.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            isActive ? 'Filters ($count)' : 'Filters',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? colors.primary : colors.onSurface,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(
            isExpanded ? AppIcons.collapse : AppIcons.expand,
            size: 16,
            color: isActive ? colors.primary : colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
