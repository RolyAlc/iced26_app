import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/repositories/presentation_favorites_repository.dart';

/// Implementación del repositorio de presentaciones favoritas.
class PresentationFavoritesRepositoryImpl
    implements PresentationFavoritesRepository {
  final AppDatabase _db;

  PresentationFavoritesRepositoryImpl(this._db);

  /// Observa las presentaciones favoritas.
  @override
  Stream<Set<String>> watchFavoriteIds() {
    return _db
        .select(_db.savedPresentations)
        .watch()
        .map((rows) => rows.map((r) => r.presentationId).toSet());
  }

  /// Limpia todas las presentaciones favoritas.
  @override
  Future<void> clearAllFavorites() => _db.delete(_db.savedPresentations).go();

  /// Alterna el estado de favorito de una presentación.
  @override
  Future<void> toggleFavorite(String presentationId) async {
    final existing = await (_db.select(
      _db.savedPresentations,
    )..where((t) => t.presentationId.equals(presentationId))).getSingleOrNull();

    if (existing != null) {
      await (_db.delete(
        _db.savedPresentations,
      )..where((t) => t.presentationId.equals(presentationId))).go();
    } else {
      await _db
          .into(_db.savedPresentations)
          .insert(
            SavedPresentationsCompanion.insert(presentationId: presentationId),
          );
    }
  }
}
