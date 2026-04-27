import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';

part 'search_provider.g.dart';

/// Filtros activos en la búsqueda.
class SearchFilterState {
  final String? selectedDay;
  final Set<EventType> selectedTypes;
  final Set<String> selectedLanguages;
  final Set<EventStatus> selectedStatuses;
  final Set<String> selectedZones;
  final Set<int> selectedDurations;

  const SearchFilterState({
    this.selectedDay,
    this.selectedTypes = const {},
    this.selectedLanguages = const {},
    this.selectedStatuses = const {},
    this.selectedZones = const {},
    this.selectedDurations = const {},
  });

  bool get isActive =>
      selectedDay != null ||
      selectedTypes.isNotEmpty ||
      selectedLanguages.isNotEmpty ||
      selectedStatuses.isNotEmpty ||
      selectedZones.isNotEmpty ||
      selectedDurations.isNotEmpty;

  int get activeCount =>
      (selectedDay != null ? 1 : 0) +
      selectedTypes.length +
      selectedLanguages.length +
      selectedStatuses.length +
      selectedZones.length +
      selectedDurations.length;
}

/// State de la búsqueda.
class SearchState {
  final String query;
  final List<Event> results;
  final SearchFilterState filters;

  SearchState({
    this.query = '',
    this.results = const [],
    SearchFilterState? filters,
  }) : filters = filters ?? const SearchFilterState();
}

@riverpod
class Search extends _$Search {
  @override
  SearchState build() => SearchState();

  void performSearch(String text) {
    if (text == state.query) return;

    state = SearchState(
      query: text,
      results: _computeResults(text, state.filters),
      filters: state.filters,
    );
  }

  void updateFilters(SearchFilterState filters) {
    state = SearchState(
      query: state.query,
      results: _computeResults(state.query, filters),
      filters: filters,
    );
  }

  void toggleDay(String date) {
    final f = state.filters;
    updateFilters(
      SearchFilterState(
        selectedDay: f.selectedDay == date ? null : date,
        selectedTypes: f.selectedTypes,
        selectedLanguages: f.selectedLanguages,
        selectedStatuses: f.selectedStatuses,
        selectedZones: f.selectedZones,
        selectedDurations: f.selectedDurations,
      ),
    );
  }

  void toggleType(EventType type) {
    final f = state.filters;
    updateFilters(
      SearchFilterState(
        selectedDay: f.selectedDay,
        selectedTypes: _toggleSet(f.selectedTypes, type),
        selectedLanguages: f.selectedLanguages,
        selectedStatuses: f.selectedStatuses,
        selectedZones: f.selectedZones,
        selectedDurations: f.selectedDurations,
      ),
    );
  }

  void toggleLanguage(String lang) {
    final f = state.filters;
    updateFilters(
      SearchFilterState(
        selectedDay: f.selectedDay,
        selectedTypes: f.selectedTypes,
        selectedLanguages: _toggleSet(f.selectedLanguages, lang),
        selectedStatuses: f.selectedStatuses,
        selectedZones: f.selectedZones,
        selectedDurations: f.selectedDurations,
      ),
    );
  }

  void toggleStatus(EventStatus status) {
    final f = state.filters;
    updateFilters(
      SearchFilterState(
        selectedDay: f.selectedDay,
        selectedTypes: f.selectedTypes,
        selectedLanguages: f.selectedLanguages,
        selectedStatuses: _toggleSet(f.selectedStatuses, status),
        selectedZones: f.selectedZones,
        selectedDurations: f.selectedDurations,
      ),
    );
  }

  void toggleZone(String zoneId) {
    final f = state.filters;
    updateFilters(
      SearchFilterState(
        selectedDay: f.selectedDay,
        selectedTypes: f.selectedTypes,
        selectedLanguages: f.selectedLanguages,
        selectedStatuses: f.selectedStatuses,
        selectedZones: _toggleSet(f.selectedZones, zoneId),
        selectedDurations: f.selectedDurations,
      ),
    );
  }

  void toggleDuration(int minutes) {
    final f = state.filters;
    updateFilters(
      SearchFilterState(
        selectedDay: f.selectedDay,
        selectedTypes: f.selectedTypes,
        selectedLanguages: f.selectedLanguages,
        selectedStatuses: f.selectedStatuses,
        selectedZones: f.selectedZones,
        selectedDurations: _toggleSet(f.selectedDurations, minutes),
      ),
    );
  }

  void clearFilters() => updateFilters(const SearchFilterState());

  void clear() {
    state = SearchState();
  }

  Set<T> _toggleSet<T>(Set<T> original, T value) {
    final result = Set<T>.from(original);

    if (result.contains(value)) {
      result.remove(value);
    } else {
      result.add(value);
    }

    return Set.unmodifiable(result);
  }

  String getRoomName(String? roomId) {
    if (roomId == null) return 'No room';

    final rooms = ref.read(homeViewModelProvider).value?.allRooms ?? [];

    final room = rooms.firstWhere(
      (r) => r.id == roomId,
      orElse: () => Room(
        id: '',
        name: I18nStr({'en': 'Room $roomId'}),
        capacity: null,
        zoneId: '',
        sessionStyle: '',
      ),
    );

    return room.name.resolve('en');
  }

  List<Event> _computeResults(String query, SearchFilterState filters) {
    final homeData = ref.read(homeViewModelProvider).value;
    if (homeData == null) return [];

    List<Event> events = homeData.allEvents;

    if (query.isNotEmpty) {
      events = _applyTextSearch(events, query);
    }

    if (!filters.isActive) return events;

    return events.where((e) => _matchesFilters(e, filters)).toList();
  }

  List<Event> _applyTextSearch(List<Event> events, String query) {
    final q = query.toLowerCase();

    final List<Event> result = [];

    for (final e in events) {
      final title = e.title.resolve('en').toLowerCase();
      final abstract_ = e.abstract_?.resolve('en').toLowerCase() ?? '';

      if (title.contains(q) || abstract_.contains(q)) {
        result.add(e);
      }
    }

    return result;
  }

  bool _matchesFilters(Event e, SearchFilterState f) {
    if (f.selectedDay != null) {
      if (e.startDate == null) return false;

      if (!e.startDate!.toIso8601String().startsWith(f.selectedDay!)) {
        return false;
      }
    }

    if (f.selectedTypes.isNotEmpty && !f.selectedTypes.contains(e.type)) {
      return false;
    }

    if (f.selectedLanguages.isNotEmpty &&
        !f.selectedLanguages.contains(e.lang ?? '')) {
      return false;
    }

    if (f.selectedStatuses.isNotEmpty &&
        !f.selectedStatuses.contains(EventStatusResolver.resolve(e))) {
      return false;
    }

    if (f.selectedZones.isNotEmpty &&
        !f.selectedZones.contains(e.zoneId ?? '')) {
      return false;
    }

    if (f.selectedDurations.isNotEmpty &&
        !f.selectedDurations.contains(e.durationMin)) {
      return false;
    }

    return true;
  }
}
