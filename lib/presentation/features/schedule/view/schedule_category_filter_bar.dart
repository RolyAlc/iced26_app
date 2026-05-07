import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/helpers/event_type_style.dart';

/// Barra de filtros de categoria para la pantalla Schedule.
class ScheduleCategoryFilterBar extends StatelessWidget {
  const ScheduleCategoryFilterBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  final List<EventType> categories;
  final EventType? selected;
  final ValueChanged<EventType?> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: Row(children: _buildChips(context, colors)),
    );
  }

  /// Construye los chips de filtro.
  List<Widget> _buildChips(BuildContext context, ColorScheme colors) {
    return [
      _CategoryChip(
        label: 'All',
        icon: AppIcons.apps,
        color: colors.primary,
        selected: selected == null,
        onTap: () => onSelect(null),
      ),
      ...categories.expand((cat) {
        final style = resolveTypeStyle(context, cat);
        return [
          const SizedBox(width: AppSpacing.xs),
          _CategoryChip(
            label: cat.label,
            icon: style.icon,
            color: style.color,
            selected: selected == cat,
            onTap: () => onSelect(cat),
          ),
        ];
      }),
    ];
  }
}

/// Chip con icono y color por categoria (tipo de evento).
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return FilterChip(
      label: Text(label),
      avatar: Icon(
        icon,
        size: 16,
        color: selected ? color : colors.onSurfaceVariant,
      ),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      shape: const StadiumBorder(),
      side: selected
          ? BorderSide(color: color.withValues(alpha: 0.4))
          : BorderSide(color: colors.outlineVariant),
      backgroundColor: colors.surfaceContainerLow,
      selectedColor: color.withValues(alpha: 0.12),
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        color: selected ? color : colors.onSurface,
      ),
    );
  }
}
