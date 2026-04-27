import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/presentation/helpers/event_type_style.dart';

/// Barra de filtros de categoria para la pantalla Schedule.
class ScheduleCategoryFilterBar extends StatelessWidget {
  const ScheduleCategoryFilterBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelect,
    required this.onFavoritesTap,
    required this.isFavoritesMode,
  });

  final List<EventType> categories;
  final EventType? selected;
  final ValueChanged<EventType?> onSelect;
  final VoidCallback onFavoritesTap;
  final bool isFavoritesMode;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: Row(children: _buildChips(context, colors)),
    );
  }

  List<Widget> _buildChips(BuildContext context, ColorScheme colors) {
    return [
      _favoritesChip(colors),
      const SizedBox(width: AppSpacing.xs),
      _allChip(colors),
      ..._categoryChips(context, colors),
    ];
  }

  Widget _favoritesChip(ColorScheme colors) {
    return _CategoryChip(
      label: 'My Schedule',
      icon: isFavoritesMode ? Icons.bookmark : Icons.bookmark_border,
      color: colors.tertiary,
      selected: isFavoritesMode,
      onTap: onFavoritesTap,
    );
  }

  Widget _allChip(ColorScheme colors) {
    return _CategoryChip(
      label: 'All',
      icon: Icons.apps_rounded,
      color: colors.primary,
      selected: !isFavoritesMode && selected == null,
      onTap: () => onSelect(null),
    );
  }

  List<Widget> _categoryChips(BuildContext context, ColorScheme colors) {
    return categories.map((cat) {
      final style = resolveTypeStyle(context, cat);

      return Padding(
        padding: const EdgeInsets.only(left: AppSpacing.xs),
        child: _CategoryChip(
          label: cat.label,
          icon: style.icon,
          color: style.color,
          selected: !isFavoritesMode && selected == cat,
          onTap: () => _handleCategoryTap(cat),
        ),
      );
    }).toList();
  }

  void _handleCategoryTap(EventType cat) {
    if (selected == cat) {
      onSelect(null);
    } else {
      onSelect(cat);
    }
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
