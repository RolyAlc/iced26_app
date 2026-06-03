import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/duration_range.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/room.dart';
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
      _buildTrackSection(l10n, data.tracks, filters),
      _buildRoomSection(l10n, data.rooms, filters, l10n.localeName),
      _buildLanguageSection(l10n, data.languages, filters),
      _buildTagsSection(l10n, data.tags, filters),
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

  List<Widget> _buildTrackSection(
    AppLocalizations l10n,
    List<String> tracks,
    SearchFilterState filters,
  ) {
    return _filterSection(
      l10n.searchFilterTrack,
      AppIcons.category,
      tracks.map<Widget>((t) {
        return AppFilterChip(
          label: t,
          selected: filters.selectedTracks.contains(t),
          onTap: () {
            notifier.toggleTrack(t);
          },
        );
      }).toList(),
    );
  }

  List<Widget> _buildRoomSection(
    AppLocalizations l10n,
    List<Room> rooms,
    SearchFilterState filters,
    String locale,
  ) {
    if (rooms.isEmpty) return [];
    return [
      SectionLabel(label: l10n.searchFilterRoom, icon: AppIcons.meetingRoom),
      const SizedBox(height: AppSpacing.s),
      _CappedFilterSection(
        items: rooms.map((r) {
          final isSelected = filters.selectedRooms.contains(r.id);
          return (
            chip: AppFilterChip(
              label: r.name.resolve(locale),
              selected: isSelected,
              onTap: () => notifier.toggleRoom(r.id),
            ) as Widget,
            selected: isSelected,
          );
        }).toList(),
      ),
      const SizedBox(height: AppSpacing.m),
    ];
  }

  List<Widget> _buildLanguageSection(
    AppLocalizations l10n,
    List<String> languages,
    SearchFilterState filters,
  ) {
    return _filterSection(
      l10n.searchFilterLanguage,
      AppIcons.translate,
      languages.map<Widget>((lang) {
        return AppFilterChip(
          label: lang.toUpperCase(),
          selected: filters.selectedLanguages.contains(lang),
          onTap: () {
            notifier.toggleLanguage(lang);
          },
        );
      }).toList(),
    );
  }

  List<Widget> _buildTagsSection(
    AppLocalizations l10n,
    List<String> tags,
    SearchFilterState filters,
  ) {
    if (tags.isEmpty) return [];
    return [
      SectionLabel(label: l10n.searchFilterTags, icon: AppIcons.tag),
      const SizedBox(height: AppSpacing.s),
      _CappedFilterSection(
        items: tags.map((tag) {
          return (
            chip: AppFilterChip(
              label: '#$tag',
              selected: filters.selectedTags.contains(tag),
              onTap: () => notifier.toggleTag(tag),
            ) as Widget,
            selected: filters.selectedTags.contains(tag),
          );
        }).toList(),
      ),
      const SizedBox(height: AppSpacing.m),
    ];
  }

  List<Widget> _buildDurationSection(
    AppLocalizations l10n,
    List<DurationRange> durations,
    SearchFilterState filters,
  ) {
    return _filterSection(
      l10n.searchFilterDuration,
      AppIcons.duration,
      durations.map<Widget>((range) {
        return AppFilterChip(
          label: _durationRangeLabel(l10n, range),
          selected: filters.selectedDurations.contains(range),
          onTap: () {
            notifier.toggleDuration(range);
          },
        );
      }).toList(),
    );
  }

  String _durationRangeLabel(AppLocalizations l10n, DurationRange range) {
    return switch (range) {
      DurationRange.short => l10n.searchDurationShort,
      DurationRange.medium => l10n.searchDurationMedium,
      DurationRange.long => l10n.searchDurationLong,
    };
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

const _kChipCap = 8;

typedef _ChipItem = ({Widget chip, bool selected});

class _CappedFilterSection extends StatefulWidget {
  const _CappedFilterSection({required this.items});

  final List<_ChipItem> items;

  @override
  State<_CappedFilterSection> createState() => _CappedFilterSectionState();
}

class _CappedFilterSectionState extends State<_CappedFilterSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selected = widget.items.where((i) => i.selected).toList();
    final unselected = widget.items.where((i) => !i.selected).toList();
    final visibleUnselected = _expanded
        ? unselected
        : unselected.take((_kChipCap - selected.length).clamp(0, _kChipCap)).toList();
    final hiddenCount = unselected.length - visibleUnselected.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.s,
          runSpacing: AppSpacing.s,
          children: [
            for (final item in [...selected, ...visibleUnselected]) item.chip,
          ],
        ),
        if (hiddenCount > 0 || _expanded)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s),
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded
                    ? l10n.searchFilterTagsShowLess
                    : l10n.searchFilterTagsShowMore(hiddenCount),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
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
