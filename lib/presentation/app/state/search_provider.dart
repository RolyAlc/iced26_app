import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

/// Filtros activos en la búsqueda.
class SearchFilterState {
  const SearchFilterState({
    this.selectedDay,
    this.selectedTypes = const {},
    this.selectedLanguages = const {},
    this.selectedStatuses = const {},
    this.selectedZones = const {},
    this.selectedDurations = const {},
  });
  final String? selectedDay;
  final Set<EventType> selectedTypes;
  final Set<String> selectedLanguages;
  final Set<EventStatus> selectedStatuses;
  final Set<String> selectedZones;
  final Set<int> selectedDurations;

  /// True si hay algún filtro activo.
  bool get isActive =>
      selectedDay != null ||
      selectedTypes.isNotEmpty ||
      selectedLanguages.isNotEmpty ||
      selectedStatuses.isNotEmpty ||
      selectedZones.isNotEmpty ||
      selectedDurations.isNotEmpty;

  /// Número de filtros activos.
  int get activeCount =>
      (selectedDay != null ? 1 : 0) +
      selectedTypes.length +
      selectedLanguages.length +
      selectedStatuses.length +
      selectedZones.length +
      selectedDurations.length;

  /// Activa o desactiva el filtro de día.
  SearchFilterState withToggledDay(String date) {
    return SearchFilterState(
      selectedDay: selectedDay == date ? null : date,
      selectedTypes: selectedTypes,
      selectedLanguages: selectedLanguages,
      selectedStatuses: selectedStatuses,
      selectedZones: selectedZones,
      selectedDurations: selectedDurations,
    );
  }

  /// Activa o desactiva un tipo de evento.
  SearchFilterState withToggledType(EventType type) {
    return SearchFilterState(
      selectedDay: selectedDay,
      selectedTypes: _toggleSet(selectedTypes, type),
      selectedLanguages: selectedLanguages,
      selectedStatuses: selectedStatuses,
      selectedZones: selectedZones,
      selectedDurations: selectedDurations,
    );
  }

  /// Activa o desactiva un idioma.
  SearchFilterState withToggledLanguage(String lang) {
    return SearchFilterState(
      selectedDay: selectedDay,
      selectedTypes: selectedTypes,
      selectedLanguages: _toggleSet(selectedLanguages, lang),
      selectedStatuses: selectedStatuses,
      selectedZones: selectedZones,
      selectedDurations: selectedDurations,
    );
  }

  /// Activa o desactiva un estado de evento.
  SearchFilterState withToggledStatus(EventStatus status) {
    return SearchFilterState(
      selectedDay: selectedDay,
      selectedTypes: selectedTypes,
      selectedLanguages: selectedLanguages,
      selectedStatuses: _toggleSet(selectedStatuses, status),
      selectedZones: selectedZones,
      selectedDurations: selectedDurations,
    );
  }

  /// Activa o desactiva una zona.
  SearchFilterState withToggledZone(String zoneId) {
    return SearchFilterState(
      selectedDay: selectedDay,
      selectedTypes: selectedTypes,
      selectedLanguages: selectedLanguages,
      selectedStatuses: selectedStatuses,
      selectedZones: _toggleSet(selectedZones, zoneId),
      selectedDurations: selectedDurations,
    );
  }

  /// Activa o desactiva una duración.
  SearchFilterState withToggledDuration(int minutes) {
    return SearchFilterState(
      selectedDay: selectedDay,
      selectedTypes: selectedTypes,
      selectedLanguages: selectedLanguages,
      selectedStatuses: selectedStatuses,
      selectedZones: selectedZones,
      selectedDurations: _toggleSet(selectedDurations, minutes),
    );
  }
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

/// State de la búsqueda — los resultados de personas se computan en la UI para poder watchear el provider async.
class SearchState {
  SearchState({
    this.query = '',
    this.results = const [],
    SearchFilterState? filters,
  }) : filters = filters ?? const SearchFilterState();
  final String query;
  final List<Event> results;
  final SearchFilterState filters;
}

/// Provider para la búsqueda.
@riverpod
class Search extends _$Search {
  @override
  SearchState build() {
    return SearchState();
  }

  /// Ejecuta la búsqueda por texto.
  void performSearch(String text) {
    if (text == state.query) {
      return;
    }
    state = SearchState(
      query: text,
      results: _computeEvents(text, state.filters),
      filters: state.filters,
    );
  }

  /// Actualiza los filtros de la búsqueda.
  void updateFilters(SearchFilterState filters) {
    state = SearchState(
      query: state.query,
      results: _computeEvents(state.query, filters),
      filters: filters,
    );
  }

  /// Cambia el filtro de día.
  void toggleDay(String date) {
    updateFilters(state.filters.withToggledDay(date));
  }

  /// Cambia el filtro de tipo.
  void toggleType(EventType type) {
    updateFilters(state.filters.withToggledType(type));
  }

  /// Cambia el filtro de idioma.
  void toggleLanguage(String lang) {
    updateFilters(state.filters.withToggledLanguage(lang));
  }

  /// Cambia el filtro de estado.
  void toggleStatus(EventStatus status) {
    updateFilters(state.filters.withToggledStatus(status));
  }

  /// Cambia el filtro de zona.
  void toggleZone(String zoneId) {
    updateFilters(state.filters.withToggledZone(zoneId));
  }

  /// Cambia el filtro de duración.
  void toggleDuration(int minutes) {
    updateFilters(state.filters.withToggledDuration(minutes));
  }

  /// Limpia todos los filtros.
  void clearFilters() {
    updateFilters(const SearchFilterState());
  }

  /// Limpia la búsqueda completa.
  void clear() {
    state = SearchState();
  }

  List<Event> _computeEvents(String query, SearchFilterState filters) {
    final homeData = ref.read(homeViewModelProvider).value;
    if (homeData == null) {
      return [];
    }

    var events = homeData.allEvents;

    if (query.isNotEmpty) {
      events = _applyTextSearch(events, query);
    }

    if (filters.isActive) {
      events = events.where((e) => _matchesFilters(e, filters)).toList();
    }

    return events;
  }

  /// Busca en todos los valores i18n del título para no depender del locale del dispositivo.
  List<Event> _applyTextSearch(List<Event> events, String query) {
    final q = query.toLowerCase();
    return events
        .where(
          (e) => e.title.values.values.any((v) => v.toLowerCase().contains(q)),
        )
        .toList();
  }

  /// Filtra los eventos según los filtros activos.
  bool _matchesFilters(Event e, SearchFilterState f) {
    if (f.selectedDay != null) {
      if (e.startDate == null) {
        return false;
      }
      if (!e.startDate!.toIso8601String().startsWith(f.selectedDay!)) {
        return false;
      }
    }

    if (f.selectedTypes.isNotEmpty && !f.selectedTypes.contains(e.type)) {
      return false;
    }

    if (f.selectedLanguages.isNotEmpty &&
        !f.selectedLanguages.contains(e.defaultLang ?? '')) {
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
