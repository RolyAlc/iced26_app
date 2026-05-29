import 'package:iced26/domain/repositories/favorites_repository.dart';

/// Caso de uso: observar los IDs de eventos favoritos en tiempo real.
class WatchFavoritesUseCase {
  WatchFavoritesUseCase(this._repo);
  final FavoritesRepository _repo;

  Stream<Set<String>> execute() => _repo.watchFavoriteIds();
}
