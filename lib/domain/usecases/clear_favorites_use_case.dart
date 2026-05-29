import 'package:iced26/domain/repositories/favorites_repository.dart';

/// Caso de uso: eliminar todos los favoritos del usuario.
class ClearEventFavoritesUseCase {
  ClearEventFavoritesUseCase(this._repo);
  final FavoritesRepository _repo;

  /// Ejecuta el caso de uso.
  Future<void> execute() => _repo.clearAllFavorites();
}
