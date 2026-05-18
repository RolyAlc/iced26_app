import 'package:iced26/domain/repositories/favorites_repository.dart';
import 'package:iced26/domain/repositories/presentation_favorites_repository.dart';

/// Caso de uso: eliminar todos los items guardados por el usuario.
class ClearAllSavedItemsUseCase {
  ClearAllSavedItemsUseCase(this._eventsRepo, this._presentationsRepo);

  final FavoritesRepository _eventsRepo;
  final PresentationFavoritesRepository _presentationsRepo;

  Future<void> execute() async {
    await Future.wait([
      _eventsRepo.clearAllFavorites(),
      _presentationsRepo.clearAllFavorites(),
    ]);
  }
}
