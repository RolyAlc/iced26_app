import 'package:iced26/domain/repositories/presentation_favorites_repository.dart';

/// Caso de uso: cambiar el estado de favorito de una presentación.
class TogglePresentationFavoriteUseCase {
  TogglePresentationFavoriteUseCase(this._repo);

  /// Repositorio de presentaciones favoritas.
  final PresentationFavoritesRepository _repo;

  /// Ejecuta el caso de uso.
  Future<void> execute(String presentationId) =>
      _repo.toggleFavorite(presentationId);
}
