import 'package:iced26/domain/repositories/presentation_favorites_repository.dart';

/// Caso de uso: observar los favoritos de presentaciones.
class WatchPresentationFavoritesUseCase {
  /// Repositorio de presentaciones favoritas.
  final PresentationFavoritesRepository _repo;

  WatchPresentationFavoritesUseCase(this._repo);

  /// Ejecuta el caso de uso.
  Stream<Set<String>> execute() => _repo.watchFavoriteIds();
}
