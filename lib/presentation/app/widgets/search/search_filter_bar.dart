import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/widgets/search/widgets/active_filter_chip.dart';
import 'package:iced26/presentation/app/widgets/search/widgets/clear_all_button.dart';
import 'package:iced26/presentation/app/widgets/search/widgets/filter_toggle_button.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
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
        FilterToggleButton(count: count, isExpanded: true, onTap: onToggle),
        const Spacer(),
        if (filters.isActive) ClearAllButton(onPressed: notifier.clearFilters),
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
  final Map<String, String> zoneNames;

  const _CollapsedFilterBar({
    required this.count,
    required this.filters,
    required this.notifier,
    required this.onToggle,
    required this.zoneNames,
  });

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
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: chips,
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
          label: '$d min',
          onRemove: () => notifier.toggleDuration(d),
        ),
      );
    }

    for (final s in filters.selectedStatuses) {
      chips.add(
        ActiveFilterChip(
          label: _statusLabel(s),
          onRemove: () => notifier.toggleStatus(s),
        ),
      );
    }

    return chips;
  }

  String _statusLabel(EventStatus s) => switch (s) {
    EventStatus.live => 'Live now',
    EventStatus.next => 'Up next',
    EventStatus.ended => 'Ended',
  };
}
