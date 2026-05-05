import 'package:iced26/domain/repositories/favorites_repository.dart';

/// Caso de uso: eliminar todos los favoritos del usuario.
class ClearFavoritesUseCase {
  final FavoritesRepository _repo;

  ClearFavoritesUseCase(this._repo);

  /// Ejecuta el caso de uso.
  Future<void> execute() => _repo.clearAllFavorites();
}
