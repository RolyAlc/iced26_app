import 'package:iced26/core/errors/result.dart';
import 'package:iced26/core/services/logger/logger.dart';
import 'package:iced26/domain/repositories/recently_viewed_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Implementación genérica de [RecentlyViewedRepository] usando SharedPreferences.
class RecentlyViewedRepositoryImpl implements RecentlyViewedRepository {
  const RecentlyViewedRepositoryImpl({required String prefsKey})
    : _prefsKey = prefsKey;

  final String _prefsKey;
  static const _kMaxCount = 5;

  @override
  Future<Result<List<String>>> getAll() async {
    try {
      AppLogger.d('RecentlyViewedRepo[$_prefsKey]: Cargando...');
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList(_prefsKey) ?? [];
      AppLogger.i('RecentlyViewedRepo[$_prefsKey]: ${ids.length} items');
      return Success(ids);
    } catch (e, stack) {
      AppLogger.e('RecentlyViewedRepo[$_prefsKey]: Error al cargar', e, stack);
      return const Failure('No se pudieron cargar los elementos vistos.');
    }
  }

  @override
  Future<Result<List<String>>> add(String id) async {
    try {
      final trimmed = id.trim();
      if (trimmed.isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        return Success(prefs.getStringList(_prefsKey) ?? []);
      }

      AppLogger.d('RecentlyViewedRepo[$_prefsKey]: Añadiendo "$trimmed"');

      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getStringList(_prefsKey) ?? [];

      // El más reciente va primero; se eliminan duplicados antes de insertar.
      final updated = [
        trimmed,
        ...current.where((item) => item != trimmed),
      ].take(_kMaxCount).toList();

      await prefs.setStringList(_prefsKey, updated);
      AppLogger.i('RecentlyViewedRepo[$_prefsKey]: Guardado correctamente');
      return Success(updated);
    } catch (e, stack) {
      AppLogger.e('RecentlyViewedRepo[$_prefsKey]: Error al añadir', e, stack);
      return const Failure('No se pudo guardar el elemento visto.');
    }
  }

  @override
  Future<Result<void>> clearAll() async {
    try {
      AppLogger.w('RecentlyViewedRepo[$_prefsKey]: Limpiando historial');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
      return const Success(null);
    } catch (e, stack) {
      AppLogger.e('RecentlyViewedRepo[$_prefsKey]: Error al limpiar', e, stack);
      return const Failure('No se pudo limpiar el historial.');
    }
  }
}
