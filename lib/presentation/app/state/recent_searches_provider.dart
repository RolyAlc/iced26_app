import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/data_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_searches_provider.g.dart';

/// Notifier que gestiona el estado de las búsquedas recientes.
/// Ahora delega la persistencia al repositorio.
@Riverpod(keepAlive: true)
class RecentSearches extends _$RecentSearches {
  @override
  List<String> build() {
    // Iniciamos la carga asíncrona pero devolvemos un estado inicial vacío.
    _load();
    return [];
  }

  Future<void> _load() async {
    final repo = ref.read(recentSearchesRepositoryProvider);
    final result = await repo.getRecentSearches();

    if (result is Success<List<String>>) {
      state = result.data;
    }
  }

  Future<void> add(String query) async {
    final repo = ref.read(recentSearchesRepositoryProvider);
    final result = await repo.addSearch(query);

    if (result is Success) {
      // Recargamos el estado local para reflejar el cambio.
      _load();
    }
  }

  Future<void> remove(String query) async {
    final repo = ref.read(recentSearchesRepositoryProvider);
    final result = await repo.removeSearch(query);

    if (result is Success) {
      _load();
    }
  }

  Future<void> clearAll() async {
    final repo = ref.read(recentSearchesRepositoryProvider);
    final result = await repo.clearAll();

    if (result is Success) {
      state = [];
    }
  }
}
