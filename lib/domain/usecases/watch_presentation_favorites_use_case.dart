import 'package:iced26/domain/repositories/presentation_favorites_repository.dart';

/// Caso de uso: observar los favoritos de presentaciones.
class WatchPresentationFavoritesUseCase {
  WatchPresentationFavoritesUseCase(this._repo);

  /// Repositorio de presentaciones favoritas.
  final PresentationFavoritesRepository _repo;

  /// Ejecuta el caso de uso.
  Stream<Set<String>> execute() => _repo.watchFavoriteIds();
}
