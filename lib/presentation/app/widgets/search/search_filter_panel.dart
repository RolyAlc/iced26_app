import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/zone.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/widgets/search/models/filter_panel_data.dart';
import 'package:iced26/presentation/app/widgets/search/widgets/filter_chip.dart';
import 'package:iced26/presentation/app/widgets/search/widgets/section_label.dart';
import 'package:iced26/presentation/app/widgets/search/widgets/type_filter_chip.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';

class FilterPanel extends ConsumerWidget {
  final Search notifier;

  const FilterPanel({super.key, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(homeViewModelProvider).value;
    if (homeData == null) {
      return const SizedBox.shrink();
    }

    final filters = ref.watch(searchProvider.select((s) => s.filters));
    final data = FilterPanelData.fromHomeState(homeData);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._buildDaySection(data.days, filters, notifier),
          ..._buildTypeSection(data.types, filters, notifier),
          ..._buildZoneSection(data.zones, filters, notifier),
          ..._buildDurationSection(data.durations, filters, notifier),
          ..._buildStatusSection(filters, notifier),
          const SizedBox(height: AppSpacing.m),
        ],
      ),
    );
  }

  static List<Widget> _buildDaySection(
    List<({String date, String label})> days,
    SearchFilterState filters,
    Search notifier,
  ) {
    return _section(
      'Day',
      days.map<Widget>((d) {
        return AppFilterChip(
          label: d.label,
          selected: filters.selectedDay == d.date,
          onTap: () => notifier.toggleDay(d.date),
        );
      }).toList(),
    );
  }

  static List<Widget> _buildTypeSection(
    List<EventType> types,
    SearchFilterState filters,
    Search notifier,
  ) {
    return _section(
      'Type',
      types.map<Widget>((t) {
        return TypeFilterChip(
          type: t,
          selected: filters.selectedTypes.contains(t),
          onTap: () => notifier.toggleType(t),
        );
      }).toList(),
    );
  }

  static List<Widget> _buildZoneSection(
    List<Zone> zones,
    SearchFilterState filters,
    Search notifier,
  ) {
    return _section(
      'Zone',
      zones.map<Widget>((z) {
        return AppFilterChip(
          label: z.name.resolve('und'),
          selected: filters.selectedZones.contains(z.id),
          onTap: () => notifier.toggleZone(z.id),
        );
      }).toList(),
    );
  }

  static List<Widget> _buildDurationSection(
    List<int> durations,
    SearchFilterState filters,
    Search notifier,
  ) {
    return _section(
      'Duration',
      durations.map<Widget>((d) {
        return AppFilterChip(
          label: '$d min',
          selected: filters.selectedDurations.contains(d),
          onTap: () => notifier.toggleDuration(d),
        );
      }).toList(),
    );
  }

  static List<Widget> _buildStatusSection(
    SearchFilterState filters,
    Search notifier,
  ) {
    return _section('Status', [
      AppFilterChip(
        label: 'Live now',
        selected: filters.selectedStatuses.contains(EventStatus.live),
        onTap: () => notifier.toggleStatus(EventStatus.live),
      ),
      AppFilterChip(
        label: 'Up next',
        selected: filters.selectedStatuses.contains(EventStatus.next),
        onTap: () => notifier.toggleStatus(EventStatus.next),
      ),
      AppFilterChip(
        label: 'Ended',
        selected: filters.selectedStatuses.contains(EventStatus.ended),
        onTap: () => notifier.toggleStatus(EventStatus.ended),
      ),
    ]);
  }

  static List<Widget> _section(String label, List<Widget> chips) {
    if (chips.isEmpty) {
      return [];
    }

    return [
      SectionLabel(label: label),
      const SizedBox(height: AppSpacing.xs),
      Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: chips),
      const SizedBox(height: AppSpacing.m),
    ];
  }
}
