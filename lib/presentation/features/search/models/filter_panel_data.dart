import 'package:iced26/domain/entities/duration_range.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';

/// Datos usados por el panel de filtros.
class FilterPanelData {
  FilterPanelData({
    required this.days,
    required this.types,
    required this.rooms,
    required this.durations,
    required this.tracks,
    required this.languages,
    required this.tags,
  });

  /// Crea un [FilterPanelData] a partir de [HomeState].
  factory FilterPanelData.fromHomeState(HomeState homeData, String locale) {
    final events = homeData.allEvents;
    return FilterPanelData(
      days: _extractDays(events, locale),
      types: _extractTypes(events),
      rooms: _extractRooms(homeData, locale),
      durations: _extractDurations(events),
      tracks: _extractTracks(events),
      languages: _extractLanguages(events),
      tags: _extractTags(events),
    );
  }
  final List<({String date, String label})> days;
  final List<EventType> types;
  final List<Room> rooms;
  final List<DurationRange> durations;
  final List<String> tracks;
  final List<String> languages;
  final List<String> tags;

  static List<({String date, String label})> _extractDays(
    List<Event> events,
    String locale,
  ) {
    final seen = <String>{};
    final days = <({String date, String label})>[];

    for (final e in events) {
      if (e.startDate == null) continue;

      final dateStr = e.startDate!.toIso8601String().split('T').first;

      if (seen.add(dateStr)) {
        days.add((
          date: dateStr,
          label: DateHelper.formatShortDate(e.startDate!, locale),
        ));
      }
    }

    days.sort((a, b) => a.date.compareTo(b.date));
    return days;
  }

  static List<EventType> _extractTypes(List<Event> events) {
    final types = events.map((e) => e.type).toSet().toList();
    types.sort((a, b) => a.label.compareTo(b.label));
    return types;
  }

  static List<Room> _extractRooms(HomeState homeData, String locale) {
    final rooms = homeData.allRooms.toList();
    rooms.sort(
      (a, b) => a.name.resolve(locale).compareTo(b.name.resolve(locale)),
    );
    return rooms;
  }

  static List<DurationRange> _extractDurations(List<Event> events) {
    return DurationRange.values.where((range) {
      return events.any(
        (e) => e.durationMin != null && range.matches(e.durationMin!),
      );
    }).toList();
  }

  static List<String> _extractTracks(List<Event> events) {
    final tracks = events
        .map((e) => e.track)
        .whereType<String>()
        .toSet()
        .toList();

    tracks.sort();
    return tracks;
  }

  static List<String> _extractLanguages(List<Event> events) {
    final languages = events
        .map((e) => e.defaultLang)
        .whereType<String>()
        .where((l) => l.isNotEmpty)
        .toSet()
        .toList();

    languages.sort();
    return languages;
  }

  static List<String> _extractTags(List<Event> events) {
    final tags = events.expand((e) => e.tags).toSet().toList();
    tags.sort();
    return tags;
  }
}
