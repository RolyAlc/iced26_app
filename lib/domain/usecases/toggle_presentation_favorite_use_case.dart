import 'package:iced26/domain/repositories/presentation_favorites_repository.dart';

/// Caso de uso: cambiar el estado de favorito de una presentación.
class TogglePresentationFavoriteUseCase {
  /// Repositorio de presentaciones favoritas.
  final PresentationFavoritesRepository _repo;

  TogglePresentationFavoriteUseCase(this._repo);

  /// Ejecuta el caso de uso.
  Future<void> execute(String presentationId) =>
      _repo.toggleFavorite(presentationId);
}
