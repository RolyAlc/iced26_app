import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/zone.dart';
import 'package:iced26/presentation/app/state/search_provider.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:iced26/presentation/helpers/date_helper.dart';
import 'package:iced26/presentation/helpers/event_type_style.dart';

/// Panel de filtros completo.
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
    final data = _buildFilterData(homeData);

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
          const Divider(height: AppSpacing.l),
        ],
      ),
    );
  }
}

/// Datos para el panel de filtros.
class _FilterData {
  final List<({String date, String label})> days;
  final List<EventType> types;
  final List<Zone> zones;
  final List<int> durations;

  _FilterData({
    required this.days,
    required this.types,
    required this.zones,
    required this.durations,
  });
}

_FilterData _buildFilterData(HomeState homeData) {
  final events = homeData.allEvents;

  return _FilterData(
    days: _extractDays(events),
    types: _extractTypes(events),
    zones: _extractZones(homeData),
    durations: _extractDurations(events),
  );
}

/// Construye la sección de días.
List<Widget> _buildDaySection(
  List<({String date, String label})> days,
  SearchFilterState filters,
  Search notifier,
) {
  return _section(
    'Day',
    days.map<Widget>((d) {
      return _FilterChip(
        label: d.label,
        selected: filters.selectedDay == d.date,
        onTap: () => notifier.toggleDay(d.date),
      );
    }).toList(),
  );
}

/// Construye la sección de tipos.
List<Widget> _buildTypeSection(
  List<EventType> types,
  SearchFilterState filters,
  Search notifier,
) {
  return _section(
    'Type',
    types.map<Widget>((t) {
      return _TypeFilterChip(
        type: t,
        selected: filters.selectedTypes.contains(t),
        onTap: () => notifier.toggleType(t),
      );
    }).toList(),
  );
}

/// Construye la sección de zonas.
List<Widget> _buildZoneSection(
  List<Zone> zones,
  SearchFilterState filters,
  Search notifier,
) {
  return _section(
    'Zone',
    zones.map<Widget>((z) {
      return _FilterChip(
        label: z.name.resolve('und'),
        selected: filters.selectedZones.contains(z.id),
        onTap: () => notifier.toggleZone(z.id),
      );
    }).toList(),
  );
}

/// Construye la sección de duraciones.
List<Widget> _buildDurationSection(
  List<int> durations,
  SearchFilterState filters,
  Search notifier,
) {
  return _section(
    'Duration',
    durations.map<Widget>((d) {
      return _FilterChip(
        label: '$d min',
        selected: filters.selectedDurations.contains(d),
        onTap: () => notifier.toggleDuration(d),
      );
    }).toList(),
  );
}

/// Construye la sección de estados.
List<Widget> _buildStatusSection(SearchFilterState filters, Search notifier) {
  return _section('Status', [
    _FilterChip(
      label: 'Live now',
      selected: filters.selectedStatuses.contains(EventStatus.live),
      onTap: () => notifier.toggleStatus(EventStatus.live),
    ),
    _FilterChip(
      label: 'Up next',
      selected: filters.selectedStatuses.contains(EventStatus.next),
      onTap: () => notifier.toggleStatus(EventStatus.next),
    ),
    _FilterChip(
      label: 'Ended',
      selected: filters.selectedStatuses.contains(EventStatus.ended),
      onTap: () => notifier.toggleStatus(EventStatus.ended),
    ),
  ]);
}

/// Construye una sección.
List<Widget> _section(String label, List<Widget> chips) {
  if (chips.isEmpty) {
    return [];
  }

  return [
    _SectionLabel(label),
    const SizedBox(height: AppSpacing.xs),
    Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: chips),
    const SizedBox(height: AppSpacing.m),
  ];
}

/// Extrae los días de los eventos.
List<({String date, String label})> _extractDays(List<Event> events) {
  final seen = <String>{};
  final days = <({String date, String label})>[];

  for (final e in events) {
    if (e.startDate == null) continue;

    final dateStr = e.startDate!.toIso8601String().split('T').first;

    if (seen.add(dateStr)) {
      days.add((date: dateStr, label: DateHelper.formatShortDate(dateStr)));
    }
  }

  days.sort((a, b) => a.date.compareTo(b.date));
  return days;
}

/// Extrae los tipos de los eventos.
List<EventType> _extractTypes(List<Event> events) {
  final types = events.map((e) => e.type).toSet().toList();
  types.sort((a, b) => a.label.compareTo(b.label));
  return types;
}

/// Extrae las zonas de los eventos.
List<Zone> _extractZones(HomeState homeData) {
  final zones = homeData.allZones.toList();
  zones.sort((a, b) => a.name.resolve('und').compareTo(b.name.resolve('und')));
  return zones;
}

/// Extrae las duraciones de los eventos.
List<int> _extractDurations(List<Event> events) {
  final durations = events
      .map((e) => e.durationMin)
      .whereType<int>()
      .toSet()
      .toList();

  durations.sort();
  return durations;
}

/// Etiqueta de sección.
class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      label.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurfaceVariant,
        letterSpacing: 0.8,
      ),
    );
  }
}

/// Filtro genérico.
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      shape: const StadiumBorder(),
      side: selected
          ? BorderSide(color: colors.primary.withValues(alpha: 0.4))
          : BorderSide(color: colors.outlineVariant),
      backgroundColor: colors.surfaceContainerLow,
      selectedColor: colors.primary.withValues(alpha: 0.12),
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        color: selected ? colors.primary : colors.onSurface,
      ),
    );
  }
}

/// Chip para filtrar por tipo de evento.
class _TypeFilterChip extends StatelessWidget {
  final EventType type;
  final bool selected;
  final VoidCallback onTap;

  const _TypeFilterChip({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final style = resolveTypeStyle(context, type);

    return FilterChip(
      label: Text(type.label),
      avatar: Icon(
        style.icon,
        size: 16,
        color: selected ? style.color : colors.onSurfaceVariant,
      ),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      shape: const StadiumBorder(),
      side: selected
          ? BorderSide(color: style.color.withValues(alpha: 0.4))
          : BorderSide(color: colors.outlineVariant),
      backgroundColor: colors.surfaceContainerLow,
      selectedColor: style.color.withValues(alpha: 0.12),
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        color: selected ? style.color : colors.onSurface,
      ),
    );
  }
}
