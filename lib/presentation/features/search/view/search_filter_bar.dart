import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:iced26/presentation/features/search/widgets/active_filter_chip.dart';
import 'package:iced26/presentation/features/search/widgets/clear_all_button.dart';
import 'package:iced26/presentation/features/search/widgets/filter_toggle_button.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';

// TODO: Muchos for

/// Barra de filtros.
class FilterBar extends ConsumerWidget {
  const FilterBar({
    super.key,
    required this.notifier,
    required this.isExpanded,
    required this.onToggle,
  });
  final Search notifier;
  final bool isExpanded;
  final VoidCallback onToggle;

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

    final zones = ref.watch(homeViewModelProvider).value?.allZones ?? [];
    final zoneNames = {for (final z in zones) z.id: z.name.resolve('und')};

    return _CollapsedFilterBar(
      count: count,
      filters: filters,
      notifier: notifier,
      onToggle: onToggle,
      zoneNames: zoneNames,
    );
  }
}

/// Filtros expandidos.
class _ExpandedFilterBar extends StatelessWidget {
  const _ExpandedFilterBar({
    required this.count,
    required this.filters,
    required this.notifier,
    required this.onToggle,
  });
  final int count;
  final SearchFilterState filters;
  final Search notifier;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterToggleButton(count: count, isExpanded: true, onTap: onToggle),
        const Spacer(),
        if (filters.isActive) ClearAllButton(onPressed: notifier.clearFilters),
      ],
    );
  }
}

/// Filtros colapsados.
class _CollapsedFilterBar extends StatelessWidget {
  const _CollapsedFilterBar({
    required this.count,
    required this.filters,
    required this.notifier,
    required this.onToggle,
    required this.zoneNames,
  });
  final int count;
  final SearchFilterState filters;
  final Search notifier;
  final VoidCallback onToggle;
  final Map<String, String> zoneNames;

  @override
  Widget build(BuildContext context) {
    final chips = _buildActiveChips();

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              FilterToggleButton(
                count: count,
                isExpanded: false,
                onTap: onToggle,
              ),
              const Spacer(),
              if (filters.isActive)
                ClearAllButton(onPressed: notifier.clearFilters),
            ],
          ),
          if (chips.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < chips.length; i++) ...[
                    chips[i],
                    if (i < chips.length - 1)
                      const SizedBox(width: AppSpacing.xs),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildActiveChips() {
    final List<Widget> chips = [];

    if (filters.selectedDay != null) {
      chips.add(
        ActiveFilterChip(
          label: DateHelper.formatShortDate(filters.selectedDay!),
          onRemove: () => notifier.toggleDay(filters.selectedDay!),
        ),
      );
    }

    for (final t in filters.selectedTypes) {
      chips.add(
        ActiveFilterChip(
          label: t.label,
          onRemove: () => notifier.toggleType(t),
        ),
      );
    }

    for (final id in filters.selectedZones) {
      chips.add(
        ActiveFilterChip(
          label: zoneNames[id] ?? id,
          onRemove: () => notifier.toggleZone(id),
        ),
      );
    }

    for (final d in filters.selectedDurations) {
      chips.add(
        ActiveFilterChip(
          label: AppStrings.searchDurationLabel(d),
          onRemove: () => notifier.toggleDuration(d),
        ),
      );
    }

    for (final s in filters.selectedStatuses) {
      chips.add(
        ActiveFilterChip(
          label: AppStrings.searchStatusLabel(s),
          onRemove: () => notifier.toggleStatus(s),
        ),
      );
    }

    return chips;
  }
}
