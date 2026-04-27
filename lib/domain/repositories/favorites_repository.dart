/// Contrato para la gestión de favoritos del usuario.
abstract class FavoritesRepository {
  /// Stream con los IDs de eventos marcados como favoritos.
  Stream<Set<String>> watchFavoriteIds();

  /// Alterna el estado favorito de un evento (añade si no existe, elimina si existe).
  Future<void> toggleFavorite(String eventId);
}
