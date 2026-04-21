import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/repositories/favorites_repository.dart';

/// Implementación del repositorio de favoritos.
class FavoritesRepositoryImpl implements FavoritesRepository {
  final AppDatabase _db;

  FavoritesRepositoryImpl(this._db);

  @override
  Stream<Set<String>> watchFavoriteIds() {
    return _db
        .select(_db.favorites)
        .watch()
        .map((rows) => rows.map((r) => r.eventId).toSet());
  }

  @override
  Future<void> toggleFavorite(String eventId) async {
    final existing = await (_db.select(
      _db.favorites,
    )..where((t) => t.eventId.equals(eventId))).getSingleOrNull();

    if (existing != null) {
      await (_db.delete(
        _db.favorites,
      )..where((t) => t.eventId.equals(eventId))).go();
    } else {
      await _db
          .into(_db.favorites)
          .insert(FavoritesCompanion.insert(eventId: eventId));
    }
  }
}
