import 'dart:convert';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/core/services/logger/logger.dart';
import 'package:iced26/data/mappers/conference_mapper.dart';
import 'package:iced26/data/mappers/theme_mapper.dart';
import 'package:iced26/data/sources/conference_data_seeder.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/conference_config.dart';
import 'package:iced26/domain/entities/theme_config.dart';
import 'package:iced26/domain/repositories/config_repository.dart';

/// Repositorio de configuración global de la app.
///
/// Decide cuándo sincronizar datos y gestiona la configuración persistida.
/// La lógica de cómo insertar datos vive en [ConferenceDataSeeder].
class ConfigRepositoryImpl implements ConfigRepository {
  ConfigRepositoryImpl(this._db, this._seeder);

  final AppDatabase _db;
  final ConferenceDataSeeder _seeder;

  /// Sincroniza los datos del congreso solo si la edición cambió.
  ///
  /// - Misma edición: no hace nada (arranque rápido).
  /// - Nueva edición: limpia favoritos y presentaciones guardadas, reinsertta todo.
  /// - Primera instalación (sin edición guardada): inserta sin limpiar.
  @override
  Future<Result<void>> initializeDataIfNeeded() async {
    try {
      final appData = await _seeder.loadAppData();
      final storedEventId = await _loadStoredEventId();
      final newEventId = appData.metadata.eventId;

      if (storedEventId == newEventId) {
        AppLogger.i(
          'Edición sin cambios ($newEventId) — sincronización omitida.',
        );
        return const Success(null);
      }

      AppLogger.i(
        'Nueva edición detectada: $storedEventId → $newEventId. Sincronizando...',
      );

      await _db.transaction(() async {
        if (storedEventId != null) {
          await _clearUserReferentialData();
        }
        await _seeder.reset();
        await _seeder.seed(appData);
      });

      AppLogger.i('Sincronización completada correctamente.');
      return const Success(null);
    } catch (e) {
      AppLogger.e('Error en Config Init: $e');
      return Failure('Error al inicializar la configuración: $e');
    }
  }

  /// Obtiene la configuración del tema visual guardada en la base de datos.
  @override
  Future<Result<ThemeConfig?>> getThemeConfig() async {
    try {
      final query = _db.select(_db.appConfigs)
        ..where((t) => t.key.equals('theme_config'));

      final result = await query.getSingleOrNull();
      if (result == null) {
        return const Success(null);
      }

      final Map<String, dynamic> data =
          jsonDecode(result.value) as Map<String, dynamic>;

      return Success(ThemeMapper.fromMap(data));
    } catch (e) {
      AppLogger.e('Error al obtener tema: $e');
      return Failure('No se pudo cargar la configuración del tema: $e');
    }
  }

  /// Obtiene los metadatos escalares de la edición del congreso desde la DB.
  @override
  Future<Result<ConferenceConfig?>> getConferenceConfig() async {
    try {
      final query = _db.select(_db.appConfigs)
        ..where((t) => t.key.equals('conference_config'));
      final result = await query.getSingleOrNull();
      if (result == null) {
        return const Success(null);
      }
      final Map<String, dynamic> data =
          jsonDecode(result.value) as Map<String, dynamic>;
      return Success(ConferenceMapper.configFromMap(data));
    } catch (e) {
      AppLogger.e('Error al obtener configuración del congreso: $e');
      return Failure('No se pudo cargar la configuración del congreso: $e');
    }
  }

  /// Lee el event_id guardado en la última sincronización.
  /// Devuelve null si es la primera instalación.
  Future<String?> _loadStoredEventId() async {
    final query = _db.select(_db.appConfigs)
      ..where((t) => t.key.equals('event_id'));
    final row = await query.getSingleOrNull();
    return row?.value;
  }

  /// Elimina favoritos y presentaciones guardadas al detectar nueva edición.
  /// Las notas del diario NO se eliminan — son contenido personal del usuario.
  Future<void> _clearUserReferentialData() async {
    await _db.delete(_db.favorites).go();
    await _db.delete(_db.savedPresentations).go();
    AppLogger.i(
      'Favoritos y presentaciones guardadas eliminados (nueva edición).',
    );
  }
}
