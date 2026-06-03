import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/duration_range.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:iced26/presentation/features/search/widgets/active_filter_chip.dart';
import 'package:iced26/presentation/features/search/widgets/clear_all_button.dart';
import 'package:iced26/presentation/features/search/widgets/filter_toggle_button.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';

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

    final l10n = AppLocalizations.of(context)!;
    final homeState = ref.watch(homeViewModelProvider);
    final rooms = homeState.value?.allRooms ?? [];
    final Map<String, String> zoneNames = {
      for (final r in rooms) r.id: r.name.resolve(l10n.localeName),
    };

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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding(context),
      ),
      child: Row(
        children: [
          FilterToggleButton(count: count, isExpanded: true, onTap: onToggle),
          const Spacer(),
          if (filters.isActive)
            ClearAllButton(onPressed: notifier.clearFilters),
        ],
      ),
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
    final l10n = AppLocalizations.of(context)!;
    final chips = _buildActiveChips(l10n);

    return AnimatedSize(
      duration: AppDuration.fast,
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppLayout.horizontalPadding(context),
            ),
            child: Row(
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
          ),
          if (chips.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s),
            _buildChipRow(context, chips),
          ],
        ],
      ),
    );
  }

  Widget _buildChipRow(BuildContext context, List<Widget> chips) {
    final hPad = AppLayout.horizontalPadding(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: hPad, right: hPad),
      child: Row(
        children: [
          for (final chip in chips) ...[
            chip,
            const SizedBox(width: AppSpacing.xs),
          ],
        ],
      ),
    );
  }

  // Collection literal — mismo patrón for/if que los widget trees de Flutter.
  // Sin lista mutable ni .add(): cada fuente de filtros contribuye sus chips directamente.
  List<Widget> _buildActiveChips(AppLocalizations l10n) {
    return [
      if (filters.selectedDay != null)
        ActiveFilterChip(
          label: DateHelper.formatShortDate(
            DateTime.parse(filters.selectedDay!),
            l10n.localeName,
          ),
          onRemove: () => notifier.toggleDay(filters.selectedDay!),
        ),
      for (final t in filters.selectedTypes)
        ActiveFilterChip(
          label: t.label,
          onRemove: () => notifier.toggleType(t),
        ),
      for (final lang in filters.selectedLanguages)
        ActiveFilterChip(
          label: lang.toUpperCase(),
          onRemove: () => notifier.toggleLanguage(lang),
        ),
      for (final id in filters.selectedRooms)
        ActiveFilterChip(
          label: zoneNames[id] ?? id,
          onRemove: () => notifier.toggleRoom(id),
        ),
      for (final range in filters.selectedDurations)
        ActiveFilterChip(
          label: switch (range) {
            DurationRange.short => l10n.searchDurationShort,
            DurationRange.medium => l10n.searchDurationMedium,
            DurationRange.long => l10n.searchDurationLong,
          },
          onRemove: () => notifier.toggleDuration(range),
        ),
      for (final s in filters.selectedStatuses)
        ActiveFilterChip(
          label: switch (s) {
            EventStatus.live => l10n.searchStatusLiveNow,
            EventStatus.next => l10n.searchStatusUpNext,
            EventStatus.ended => l10n.searchStatusEnded,
          },
          onRemove: () => notifier.toggleStatus(s),
        ),
      for (final tag in filters.selectedTags)
        ActiveFilterChip(
          label: '#$tag',
          onRemove: () => notifier.toggleTag(tag),
        ),
      for (final track in filters.selectedTracks)
        ActiveFilterChip(
          label: track,
          onRemove: () => notifier.toggleTrack(track),
        ),
    ];
  }
}
