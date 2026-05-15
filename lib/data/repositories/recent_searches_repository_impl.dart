import 'package:iced26/core/errors/result.dart';
import 'package:iced26/core/services/logger/logger.dart';
import 'package:iced26/domain/repositories/recent_searches_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementación del repositorio de búsquedas recientes usando SharedPreferences.
class RecentSearchesRepositoryImpl implements RecentSearchesRepository {
  static const _kPrefsKey = 'recent_searches';
  static const _kMaxCount = 5;

  @override
  Future<Result<List<String>>> getRecentSearches() async {
    try {
      AppLogger.d('RecentSearchesRepo: Cargando desde SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList(_kPrefsKey) ?? [];
      AppLogger.i(
        'RecentSearchesRepo: Cargado con éxito (${searches.length} items)',
      );
      return Success(searches);
    } catch (e, stack) {
      AppLogger.e('RecentSearchesRepo: Error al obtener búsquedas', e, stack);
      return const Failure('No se pudieron cargar las búsquedas recientes.');
    }
  }

  @override
  Future<Result<void>> addSearch(String query) async {
    try {
      final trimmed = query.trim();
      if (trimmed.isEmpty) return const Success(null);

      AppLogger.d('RecentSearchesRepo: Añadiendo query "$trimmed"');

      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getStringList(_kPrefsKey) ?? [];

      final updated = [
        trimmed,
        ...current.where((q) => q != trimmed),
      ].take(_kMaxCount).toList();

      await prefs.setStringList(_kPrefsKey, updated);
      AppLogger.i('RecentSearchesRepo: Guardado correctamente');
      return const Success(null);
    } catch (e, stack) {
      AppLogger.e('RecentSearchesRepo: Error al añadir búsqueda', e, stack);
      return const Failure('No se pudo guardar la búsqueda.');
    }
  }

  @override
  Future<Result<void>> removeSearch(String query) async {
    try {
      AppLogger.d('RecentSearchesRepo: Eliminando query "$query"');
      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getStringList(_kPrefsKey) ?? [];
      final updated = current.where((q) => q != query).toList();

      await prefs.setStringList(_kPrefsKey, updated);
      return const Success(null);
    } catch (e, stack) {
      AppLogger.e('RecentSearchesRepo: Error al eliminar búsqueda', e, stack);
      return const Failure('No se pudo eliminar la búsqueda.');
    }
  }

  @override
  Future<Result<void>> clearAll() async {
    try {
      AppLogger.w('RecentSearchesRepo: Limpiando todo el historial');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kPrefsKey);
      return const Success(null);
    } catch (e, stack) {
      AppLogger.e('RecentSearchesRepo: Error al limpiar historial', e, stack);
      return const Failure('No se pudo limpiar el historial.');
    }
  }
}
