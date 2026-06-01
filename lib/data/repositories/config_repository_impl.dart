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
  @override
  Future<Result<bool>> initializeDataIfNeeded() async {
    try {
      final appData = await _seeder.loadAppData();
      final storedEventId = await _loadStoredEventId();
      final newEventId = appData.metadata.eventId;

      if (storedEventId == newEventId) {
        AppLogger.i(
          'Edición sin cambios ($newEventId) — sincronización omitida.',
        );
        return const Success(false);
      }

      AppLogger.i(
        'Nueva edición detectada: $storedEventId → $newEventId. Sincronizando...',
      );

      await _db.transaction(() async {
        await _seeder.reset();
        await _seeder.seed(appData);
      });

      AppLogger.i('Sincronización completada correctamente.');
      return const Success(true);
    } catch (e) {
      AppLogger.e('Error en Config Init: $e');
      return Failure('Error al inicializar la configuración: $e');
    }
  }

  /// Obtiene la configuración del tema visual guardada en la base de datos.
  @override
  Future<Result<ThemeConfig?>> getThemeConfig() async {
    try {
      final data = await _readConfigMap('theme_config');
      if (data == null) return const Success(null);
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
      final data = await _readConfigMap('conference_config');
      if (data == null) return const Success(null);
      return Success(ConferenceMapper.configFromMap(data));
    } catch (e) {
      AppLogger.e('Error al obtener configuración del congreso: $e');
      return Failure('No se pudo cargar la configuración del congreso: $e');
    }
  }

  /// Lee una fila de [AppConfigs] por [key] y la decodifica como mapa JSON.
  /// Devuelve null si la clave no existe.
  Future<Map<String, dynamic>?> _readConfigMap(String key) async {
    final row = await (_db.select(
      _db.appConfigs,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    if (row == null) return null;
    return jsonDecode(row.value) as Map<String, dynamic>;
  }

  /// Lee el event_id guardado en la última sincronización.
  /// Devuelve null si es la primera instalación.
  Future<String?> _loadStoredEventId() async {
    final row = await (_db.select(
      _db.appConfigs,
    )..where((t) => t.key.equals('event_id'))).getSingleOrNull();
    return row?.value;
  }
}
