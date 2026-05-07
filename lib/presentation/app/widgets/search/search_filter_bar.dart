import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/helpers/date_helper.dart';

/// Barra de filtros.
class FilterBar extends ConsumerWidget {
  final Search notifier;
  final bool isExpanded;
  final VoidCallback onToggle;

  const FilterBar({
    super.key,
    required this.notifier,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchProvider.select((s) => s.filters));
    final count = filters.activeCount;

    if (isExpanded) {
      return _ExpandedFilterBar(
        count: count,
        filters: filters,
        notifier: notifier,
        onToggle: onToggle,
      );
    }

    return _CollapsedFilterBar(
      count: count,
      filters: filters,
      notifier: notifier,
      onToggle: onToggle,
    );
  }
}

/// Filtros expandidos.
class _ExpandedFilterBar extends StatelessWidget {
  final int count;
  final SearchFilterState filters;
  final Search notifier;
  final VoidCallback onToggle;

  const _ExpandedFilterBar({
    required this.count,
    required this.filters,
    required this.notifier,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterToggleButton(count: count, isExpanded: true, onTap: onToggle),
        const Spacer(),
        if (filters.isActive)
          _ClearAllButton(onPressed: notifier.clearFilters, isErrorStyle: true),
      ],
    );
  }
}

/// Filtros colapsados.
class _CollapsedFilterBar extends StatelessWidget {
  final int count;
  final SearchFilterState filters;
  final Search notifier;
  final VoidCallback onToggle;

  const _CollapsedFilterBar({
    required this.count,
    required this.filters,
    required this.notifier,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterToggleButton(count: count, isExpanded: false, onTap: onToggle),
          ..._buildActiveChips(filters, notifier),
          if (filters.isActive)
            _ClearAllButton(
              onPressed: notifier.clearFilters,
              isErrorStyle: false,
            ),
        ],
      ),
    );
  }

  List<Widget> _buildActiveChips(SearchFilterState filters, Search notifier) {
    final List<Widget> chips = [];

    if (filters.selectedDay != null) {
      chips.add(_spacing());
      chips.add(
        _ActiveChip(
          label: DateHelper.formatShortDate(filters.selectedDay!),
          onRemove: () => notifier.toggleDay(filters.selectedDay!),
        ),
      );
    }

    for (final t in filters.selectedTypes) {
      chips.add(_spacing());
      chips.add(
        _ActiveChip(label: t.label, onRemove: () => notifier.toggleType(t)),
      );
    }

    for (final s in filters.selectedStatuses) {
      chips.add(_spacing());
      chips.add(
        _ActiveChip(
          label: _statusLabel(s),
          onRemove: () => notifier.toggleStatus(s),
        ),
      );
    }

    return chips;
  }

  Widget _spacing() => const SizedBox(width: AppSpacing.xs);

  String _statusLabel(EventStatus s) => switch (s) {
    EventStatus.live => 'Live now',
    EventStatus.next => 'Up next',
    EventStatus.ended => 'Ended',
  };
}

/// Botón de limpiar filtros
class _ClearAllButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isErrorStyle;

  const _ClearAllButton({required this.onPressed, required this.isErrorStyle});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(AppIcons.close, size: 14),
      label: const Text('Clear all'),
      style: TextButton.styleFrom(
        foregroundColor: isErrorStyle ? colors.error : colors.onSurfaceVariant,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
      ),
    );
  }
}

/// Botón principal de filtros
class _FilterToggleButton extends StatelessWidget {
  final int count;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FilterToggleButton({
    required this.count,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isActive = count > 0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.xs,
        ),
        decoration: _buildDecoration(colors, isActive),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(colors, isActive),
            const SizedBox(width: AppSpacing.xs),
            _buildText(theme.textTheme, colors, isActive),
            const SizedBox(width: AppSpacing.xs),
            _buildArrow(colors, isActive),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(ColorScheme colors, bool isActive) {
    return BoxDecoration(
      color: isActive
          ? colors.primary.withValues(alpha: 0.12)
          : colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.l),
      border: Border.all(
        color: isActive
            ? colors.primary.withValues(alpha: 0.4)
            : colors.outlineVariant,
      ),
    );
  }

  Widget _buildIcon(ColorScheme colors, bool isActive) {
    return Icon(
      AppIcons.filter,
      size: 16,
      color: isActive ? colors.primary : colors.onSurfaceVariant,
    );
  }

  Widget _buildText(TextTheme textTheme, ColorScheme colors, bool isActive) {
    return Text(
      isActive ? 'Filters ($count)' : 'Filters',
      style: textTheme.labelMedium?.copyWith(
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        color: isActive ? colors.primary : colors.onSurface,
      ),
    );
  }

  Widget _buildArrow(ColorScheme colors, bool isActive) {
    return Icon(
      isExpanded ? AppIcons.collapse : AppIcons.expand,
      size: 16,
      color: isActive ? colors.primary : colors.onSurfaceVariant,
    );
  }
}

/// Chip reutilizable
class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: colors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLabel(theme.textTheme, colors),
          const SizedBox(width: AppSpacing.xs),
          _buildRemoveIcon(colors),
        ],
      ),
    );
  }

  Widget _buildLabel(TextTheme textTheme, ColorScheme colors) {
    return Text(
      label,
      style: textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colors.primary,
      ),
    );
  }

  Widget _buildRemoveIcon(ColorScheme colors) {
    return GestureDetector(
      onTap: onRemove,
      child: Icon(AppIcons.close, size: 14, color: colors.primary),
    );
  }
}
