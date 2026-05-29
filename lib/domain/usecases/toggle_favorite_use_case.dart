import 'package:iced26/domain/repositories/favorites_repository.dart';

/// Caso de uso: alternar favorito de un evento.
class ToggleFavoriteUseCase {
  ToggleFavoriteUseCase(this._repo);
  final FavoritesRepository _repo;

  Future<void> execute(String eventId) => _repo.toggleFavorite(eventId);
}
