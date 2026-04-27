import 'package:iced26/domain/repositories/favorites_repository.dart';

/// Caso de uso: observar los IDs de eventos favoritos en tiempo real.
class WatchFavoritesUseCase {
  final FavoritesRepository _repo;

  WatchFavoritesUseCase(this._repo);

  Stream<Set<String>> execute() => _repo.watchFavoriteIds();
}
