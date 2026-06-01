import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/zone.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:iced26/presentation/features/search/models/filter_panel_data.dart';
import 'package:iced26/presentation/features/search/widgets/filter_chip.dart';
import 'package:iced26/presentation/features/search/widgets/section_label.dart';
import 'package:iced26/presentation/features/search/widgets/type_filter_chip.dart';

/// Panel de filtros.
class FilterPanel extends ConsumerWidget {
  const FilterPanel({super.key, required this.notifier});
  final Search notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(homeViewModelProvider).value;
    if (homeData == null) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final filters = ref.watch(searchProvider.select((s) => s.filters));
    final data = FilterPanelData.fromHomeState(homeData, l10n.localeName);
    final dividerColor = Theme.of(context).colorScheme.outlineVariant;

    final sections = [
      _buildDaySection(l10n, data.days, filters),
      _buildTypeSection(l10n, data.types, filters),
      _buildZoneSection(l10n, data.zones, filters),
      _buildDurationSection(l10n, data.durations, filters),
      _buildStatusSection(l10n, filters),
    ].where((s) => s.isNotEmpty).toList();

    final children = <Widget>[];
    for (int i = 0; i < sections.length; i++) {
      if (i > 0) {
        children.add(Divider(color: dividerColor, height: 1));
        children.add(const SizedBox(height: AppSpacing.m));
      }
      children.addAll(sections[i]);
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  List<Widget> _buildDaySection(
    AppLocalizations l10n,
    List<({String date, String label})> days,
    SearchFilterState filters,
  ) {
    return _filterSection(
      l10n.searchFilterDay,
      AppIcons.calendarOutline,
      days.map<Widget>((d) {
        return AppFilterChip(
          label: d.label,
          selected: filters.selectedDay == d.date,
          onTap: () {
            notifier.toggleDay(d.date);
          },
        );
      }).toList(),
    );
  }

  List<Widget> _buildTypeSection(
    AppLocalizations l10n,
    List<EventType> types,
    SearchFilterState filters,
  ) {
    return _filterSection(
      l10n.searchFilterType,
      AppIcons.category,
      types.map<Widget>((t) {
        return TypeFilterChip(
          type: t,
          selected: filters.selectedTypes.contains(t),
          onTap: () {
            notifier.toggleType(t);
          },
        );
      }).toList(),
    );
  }

  List<Widget> _buildZoneSection(
    AppLocalizations l10n,
    List<Zone> zones,
    SearchFilterState filters,
  ) {
    return _filterSection(
      l10n.searchFilterZone,
      AppIcons.locationOn,
      zones.map<Widget>((z) {
        return AppFilterChip(
          label: z.name.resolve('und'),
          selected: filters.selectedZones.contains(z.id),
          onTap: () {
            notifier.toggleZone(z.id);
          },
        );
      }).toList(),
    );
  }

  List<Widget> _buildDurationSection(
    AppLocalizations l10n,
    List<int> durations,
    SearchFilterState filters,
  ) {
    return _filterSection(
      l10n.searchFilterDuration,
      AppIcons.duration,
      durations.map<Widget>((d) {
        return AppFilterChip(
          label: l10n.searchDurationLabel(d),
          selected: filters.selectedDurations.contains(d),
          onTap: () {
            notifier.toggleDuration(d);
          },
        );
      }).toList(),
    );
  }

  List<Widget> _buildStatusSection(
    AppLocalizations l10n,
    SearchFilterState filters,
  ) {
    return _filterSection(l10n.searchFilterStatus, AppIcons.liveIndicator, [
      AppFilterChip(
        label: l10n.searchStatusLiveNow,
        selected: filters.selectedStatuses.contains(EventStatus.live),
        onTap: () {
          notifier.toggleStatus(EventStatus.live);
        },
      ),
      AppFilterChip(
        label: l10n.searchStatusUpNext,
        selected: filters.selectedStatuses.contains(EventStatus.next),
        onTap: () {
          notifier.toggleStatus(EventStatus.next);
        },
      ),
      AppFilterChip(
        label: l10n.searchStatusEnded,
        selected: filters.selectedStatuses.contains(EventStatus.ended),
        onTap: () {
          notifier.toggleStatus(EventStatus.ended);
        },
      ),
    ]);
  }
}

List<Widget> _filterSection(String label, IconData icon, List<Widget> chips) {
  if (chips.isEmpty) {
    return [];
  }
  return [
    SectionLabel(label: label, icon: icon),
    const SizedBox(height: AppSpacing.s),
    Wrap(spacing: AppSpacing.s, runSpacing: AppSpacing.s, children: chips),
    const SizedBox(height: AppSpacing.m),
  ];
}
