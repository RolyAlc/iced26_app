import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_viewmodel.dart';

part 'search_provider.g.dart';

/// State de la búsqueda.
class SearchState {
  final String query;
  final List<Event> results;

  SearchState({this.query = '', this.results = const []});

  SearchState copyWith({String? query, List<Event>? results}) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
    );
  }
}

/// Provider para la búsqueda.
@riverpod
class Search extends _$Search {
  @override
  SearchState build() {
    return SearchState();
  }

  /// Realiza la búsqueda por texto.
  void performSearch(String text) {
    if (text == state.query) return;

    final homeData = ref.read(homeViewModelProvider).value;
    if (homeData == null) return;

    if (text.isEmpty) {
      state = state.copyWith(query: '', results: []);
      return;
    }

    final lowercaseQuery = text.toLowerCase();
    final filtered = homeData.allEvents.where((event) {
      final title = event.title.resolve('en').toLowerCase();
      final abstract_ = event.abstract_?.resolve('en').toLowerCase() ?? '';
      return title.contains(lowercaseQuery) ||
          abstract_.contains(lowercaseQuery);
    }).toList();

    state = state.copyWith(query: text, results: filtered);
  }

  /// Devuelve el nombre de una sala por su ID.
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

  /// Limpia la búsqueda.
  void clear() {
    state = SearchState();
  }
}
