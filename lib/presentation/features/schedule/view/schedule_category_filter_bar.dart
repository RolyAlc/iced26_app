import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/category.dart';
import 'package:iced26/presentation/features/home/viewmodel/mappers/category_ui_mapper.dart';

/// Barra de filtros de categoria para la pantalla Schedule.
/// Chips M3 con icono y color por categoria. `null` = sin filtro.
class ScheduleCategoryFilterBar extends StatelessWidget {
  const ScheduleCategoryFilterBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _CategoryChip(
            label: 'All',
            icon: Icons.apps_rounded,
            color: Theme.of(context).colorScheme.primary,
            selected: selected == null,
            onTap: () => onSelect(null),
          ),
          ...categories.map((cat) {
            final style = CategoryUiMapper.resolve(Category(name: cat));
            return Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: _CategoryChip(
                label: cat,
                icon: style.icon,
                color: style.color,
                selected: selected == cat,
                onTap: () => onSelect(selected == cat ? null : cat),
              ),
            );
          }),
        ],
      ),
    );
  }
}

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
    final colors = Theme.of(context).colorScheme;

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
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        color: selected ? color : colors.onSurface,
      ),
    );
  }
}
