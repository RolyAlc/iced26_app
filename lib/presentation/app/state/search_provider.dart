import 'package:iced26/domain/entities/duration_range.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

// Sentinel para el copyWith de SearchFilterState: permite distinguir
// selectedDay: null (borrar el filtro) de selectedDay no pasado (mantener).
const _kUnset = Object();

/// Filtros activos en la búsqueda.
class SearchFilterState {
  const SearchFilterState({
    this.selectedDay,
    this.selectedTypes = const {},
    this.selectedLanguages = const {},
    this.selectedStatuses = const {},
    this.selectedRooms = const {},
    this.selectedDurations = const {},
    this.selectedTags = const {},
    this.selectedTracks = const {},
  });
  final String? selectedDay;
  final Set<EventType> selectedTypes;
  final Set<String> selectedLanguages;
  final Set<EventStatus> selectedStatuses;
  final Set<String> selectedRooms;
  final Set<DurationRange> selectedDurations;
  final Set<String> selectedTags;
  final Set<String> selectedTracks;

  /// True si hay algún filtro activo.
  bool get isActive =>
      selectedDay != null ||
      selectedTypes.isNotEmpty ||
      selectedLanguages.isNotEmpty ||
      selectedStatuses.isNotEmpty ||
      selectedRooms.isNotEmpty ||
      selectedDurations.isNotEmpty ||
      selectedTags.isNotEmpty ||
      selectedTracks.isNotEmpty;

  /// Número de filtros activos.
  int get activeCount =>
      (selectedDay != null ? 1 : 0) +
      selectedTypes.length +
      selectedLanguages.length +
      selectedStatuses.length +
      selectedRooms.length +
      selectedDurations.length +
      selectedTags.length +
      selectedTracks.length;

  SearchFilterState copyWith({
    // Sentinel para distinguir "poner null" de "no cambiar".
    Object? selectedDay = _kUnset,
    Set<EventType>? selectedTypes,
    Set<String>? selectedLanguages,
    Set<EventStatus>? selectedStatuses,
    Set<String>? selectedRooms,
    Set<DurationRange>? selectedDurations,
    Set<String>? selectedTags,
    Set<String>? selectedTracks,
  }) {
    return SearchFilterState(
      selectedDay: selectedDay == _kUnset
          ? this.selectedDay
          : selectedDay as String?,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      selectedLanguages: selectedLanguages ?? this.selectedLanguages,
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
      selectedRooms: selectedRooms ?? this.selectedRooms,
      selectedDurations: selectedDurations ?? this.selectedDurations,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedTracks: selectedTracks ?? this.selectedTracks,
    );
  }

  /// Activa o desactiva el filtro de día.
  SearchFilterState withToggledDay(String date) {
    return copyWith(selectedDay: selectedDay == date ? null : date);
  }

  /// Activa o desactiva un tipo de evento.
  SearchFilterState withToggledType(EventType type) {
    return copyWith(selectedTypes: _toggleSet(selectedTypes, type));
  }

  /// Activa o desactiva un idioma.
  SearchFilterState withToggledLanguage(String lang) {
    return copyWith(selectedLanguages: _toggleSet(selectedLanguages, lang));
  }

  /// Activa o desactiva un estado de evento.
  SearchFilterState withToggledStatus(EventStatus status) {
    return copyWith(selectedStatuses: _toggleSet(selectedStatuses, status));
  }

  /// Activa o desactiva una sala.
  SearchFilterState withToggledRoom(String roomId) {
    return copyWith(selectedRooms: _toggleSet(selectedRooms, roomId));
  }

  /// Activa o desactiva un rango de duración.
  SearchFilterState withToggledDuration(DurationRange range) {
    return copyWith(selectedDurations: _toggleSet(selectedDurations, range));
  }

  /// Activa o desactiva un tag.
  SearchFilterState withToggledTag(String tag) {
    return copyWith(selectedTags: _toggleSet(selectedTags, tag));
  }

  /// Activa o desactiva un track.
  SearchFilterState withToggledTrack(String track) {
    return copyWith(selectedTracks: _toggleSet(selectedTracks, track));
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
@Riverpod(keepAlive: true)
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
  void toggleRoom(String roomId) {
    updateFilters(state.filters.withToggledRoom(roomId));
  }

  /// Cambia el filtro de rango de duración.
  void toggleDuration(DurationRange range) {
    updateFilters(state.filters.withToggledDuration(range));
  }

  /// Cambia el filtro de tag.
  void toggleTag(String tag) {
    updateFilters(state.filters.withToggledTag(tag));
  }

  /// Cambia el filtro de track.
  void toggleTrack(String track) {
    updateFilters(state.filters.withToggledTrack(track));
  }

  /// Limpia todos los filtros.
  void clearFilters() {
    updateFilters(const SearchFilterState());
  }

  /// Limpia la query pero mantiene los filtros activos y recomputa los resultados.
  void clearQuery() {
    state = SearchState(
      results: _computeEvents('', state.filters),
      filters: state.filters,
    );
  }

  /// Limpia la búsqueda completa — query y filtros.
  void clear() {
    state = SearchState();
  }

  List<Event> _computeEvents(String query, SearchFilterState filters) {
    // ref.read es intencional: este método se llama desde acciones del notifier,
    // no desde build(). Usar ref.watch aquí lanzaría una excepción en Riverpod.
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

    if (f.selectedRooms.isNotEmpty &&
        !f.selectedRooms.contains(e.roomId ?? '')) {
      return false;
    }

    if (f.selectedDurations.isNotEmpty) {
      final d = e.durationMin;
      if (d == null || !f.selectedDurations.any((r) => r.matches(d))) {
        return false;
      }
    }

    if (f.selectedTags.isNotEmpty && !f.selectedTags.any(e.tags.contains)) {
      return false;
    }

    if (f.selectedTracks.isNotEmpty &&
        !f.selectedTracks.contains(e.track ?? '')) {
      return false;
    }

    return true;
  }
}
