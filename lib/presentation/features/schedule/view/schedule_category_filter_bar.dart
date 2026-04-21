import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/schedule/view/helpers/event_type_style.dart';

/// Barra de filtros de categoria para la pantalla Schedule.
/// El chip "My Schedule" aparece primero si se proveen los callbacks de favoritos.
class ScheduleCategoryFilterBar extends StatelessWidget {
  const ScheduleCategoryFilterBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelect,
    this.showFavorites = false,
    this.onFavoritesToggle,
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelect;
  final bool showFavorites;
  final VoidCallback? onFavoritesToggle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          if (onFavoritesToggle != null) ...[
            _CategoryChip(
              label: 'My Schedule',
              icon: showFavorites ? Icons.bookmark : Icons.bookmark_border,
              color: colors.tertiary,
              selected: showFavorites,
              onTap: onFavoritesToggle!,
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          _CategoryChip(
            label: 'All',
            icon: Icons.apps_rounded,
            color: colors.primary,
            // "All" solo aparece activo si no estamos en modo favoritos
            selected: !showFavorites && selected == null,
            onTap: () {
              if (showFavorites) onFavoritesToggle?.call();
              onSelect(null);
            },
          ),
          ...categories.map((cat) {
            final style = resolveTypeStyle(context, cat);
            return Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: _CategoryChip(
                label: cat,
                icon: style.icon,
                color: style.color,
                selected: !showFavorites && selected == cat,
                onTap: () {
                  if (showFavorites) onFavoritesToggle?.call();
                  onSelect(selected == cat ? null : cat);
                },
              ),
            );
          }),
        ],
      ),
    );
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
