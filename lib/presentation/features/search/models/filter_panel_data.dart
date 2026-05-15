import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/zone.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';

/// Datos usados por el panel de filtros.
class FilterPanelData {
  FilterPanelData({
    required this.days,
    required this.types,
    required this.zones,
    required this.durations,
  });

  /// Crea un [FilterPanelData] a partir de [HomeState].
  factory FilterPanelData.fromHomeState(HomeState homeData) {
    final events = homeData.allEvents;
    return FilterPanelData(
      days: _extractDays(events),
      types: _extractTypes(events),
      zones: _extractZones(homeData),
      durations: _extractDurations(events),
    );
  }
  final List<({String date, String label})> days;
  final List<EventType> types;
  final List<Zone> zones;
  final List<int> durations;

  /// Extrae los días de los eventos.
  static List<({String date, String label})> _extractDays(List<Event> events) {
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

  /// Extrae los tipos de eventos.
  static List<EventType> _extractTypes(List<Event> events) {
    final types = events.map((e) => e.type).toSet().toList();
    types.sort((a, b) => a.label.compareTo(b.label));
    return types;
  }

  /// Extrae las zonas de los eventos.
  static List<Zone> _extractZones(HomeState homeData) {
    final zones = homeData.allZones.toList();
    zones.sort(
      (a, b) => a.name.resolve('und').compareTo(b.name.resolve('und')),
    );
    return zones;
  }

  /// Extrae las duraciones de los eventos.
  static List<int> _extractDurations(List<Event> events) {
    final durations = events
        .map((e) => e.durationMin)
        .whereType<int>()
        .toSet()
        .toList();

    durations.sort();
    return durations;
  }
}
