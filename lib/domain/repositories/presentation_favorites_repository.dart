/// Repositorio para la gestión de presentaciones favoritas.
abstract class PresentationFavoritesRepository {
  /// Observa los identificadores de las presentaciones favoritas.
  Stream<Set<String>> watchFavoriteIds();

  /// Cambia el estado de favorito de una presentación.
  Future<void> toggleFavorite(String presentationId);

  /// Elimina todas las presentaciones favoritas.
  Future<void> clearAllFavorites();
}
