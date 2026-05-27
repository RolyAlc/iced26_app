import 'package:iced26/domain/repositories/favorites_repository.dart';

/// Caso de uso: eliminar todos los items guardados por el usuario.
class ClearAllSavedItemsUseCase {
  ClearAllSavedItemsUseCase(this._favoritesRepo);

  final FavoritesRepository _favoritesRepo;

  Future<void> execute() async {
    await _favoritesRepo.clearAllFavorites();
  }
}
