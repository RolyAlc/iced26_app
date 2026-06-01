import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/core/services/logger/logger.dart';
import 'package:iced26/data/mappers/app_data_mapper.dart';
import 'package:iced26/data/sources/app_data_source.dart';
import 'package:iced26/data/mappers/theme_mapper.dart';
import 'package:iced26/data/sources/conference_data_seeder.dart';
import 'package:iced26/data/sources/remote/portal_api_client.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/domain/entities/theme_config.dart';
import 'package:iced26/domain/repositories/config_repository.dart';

/// Repositorio de configuración global de la app.
///
/// Decide cuándo sincronizar datos y gestiona la configuración persistida.
/// La lógica de cómo insertar datos vive en [ConferenceDataSeeder].
class ConfigRepositoryImpl implements ConfigRepository {
  ConfigRepositoryImpl(
    this._db,
    this._seeder,
    this._localSource,
    this._portalSource,
    this._portalClient,
  );

  final AppDatabase _db;
  final ConferenceDataSeeder _seeder;
  final AppDataSource _localSource;
  final AppDataSource _portalSource;
  final PortalApiClient _portalClient;

  /// Sincroniza los datos del congreso solo si la edición cambió.
  ///
  /// - Sin datos locales: si puede, mezcla el schedule remoto; si no, siembra asset.
  /// - Datos locales + portal más nuevo: re-siembra solo tablas de conferencia.
  /// - Portal igual/caído: deja la caché local intacta.
  @override
  Future<Result<void>> initializeDataIfNeeded() async {
    try {
      final localAppData = await _loadLocalAppData();
      final hasLocalConferenceData = await _hasSeededConferenceData();
      final hasLocalScheduleData = await _hasSeededScheduleData();
      final storedLastSyncAt = await _loadConfigValue(_lastSyncAtKey);
      final remoteLastUpdated = await _tryFetchRemoteLastUpdated();

      if (!hasLocalConferenceData || !hasLocalScheduleData) {
        final appData = await _loadBootstrapAppData(
          localAppData: localAppData,
          remoteLastUpdated: remoteLastUpdated,
        );

        await _replaceConferenceData(appData, lastSyncAt: remoteLastUpdated);
        AppLogger.i(
          !hasLocalConferenceData
              ? 'Conference data seeded for first launch.'
              : 'Conference cache repaired from source data.',
        );
        return const Success(null);
      }

      if (!_isRemoteNewer(remoteLastUpdated, storedLastSyncAt)) {
        AppLogger.i('Portal schedule unchanged — sync skipped.');
        return const Success(null);
      }

      final hybridAppData = await _tryLoadHybridAppData(localAppData);
      if (hybridAppData == null) {
        AppLogger.w(
          'Remote schedule unavailable — keeping local conference cache.',
        );
        return const Success(null);
      }

      await _replaceConferenceData(
        hybridAppData,
        lastSyncAt: remoteLastUpdated,
      );
      AppLogger.i('Portal schedule synced successfully.');
      return const Success(null);
    } on DioException catch (e, stackTrace) {
      AppLogger.e('Config init failed due to network error', e, stackTrace);
      return Failure('Error de red al inicializar la configuración: $e');
    } on FormatException catch (e, stackTrace) {
      AppLogger.e('Config init failed due to invalid JSON', e, stackTrace);
      return Failure('Error al parsear la configuración: $e');
    } on StateError catch (e, stackTrace) {
      AppLogger.e(
        'Config init failed due to invalid portal payload',
        e,
        stackTrace,
      );
      return Failure('Respuesta inválida del portal: $e');
    } on Object catch (e, stackTrace) {
      AppLogger.e('Error en Config Init', e, stackTrace);
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

  Future<String?> _loadConfigValue(String key) async {
    final query = _db.select(_db.appConfigs)..where((t) => t.key.equals(key));
    final row = await query.getSingleOrNull();
    return row?.value;
  }

  Future<bool> _hasSeededConferenceData() async {
    return _loadConfigValue('event_id').then((value) => value != null);
  }

  Future<bool> _hasSeededScheduleData() async {
    final eventResult = await _db
        .customSelect('SELECT COUNT(*) AS event_count FROM events')
        .getSingle();
    final eventCount = eventResult.read<int>('event_count') ?? 0;
    if (eventCount == 0) {
      return false;
    }

    final blockResult = await _db.customSelect('''
          SELECT
            COUNT(*) AS session_block_count,
            SUM(CASE WHEN start_date IS NULL OR end_date IS NULL THEN 1 ELSE 0 END)
              AS invalid_time_count
          FROM session_blocks
          ''').getSingle();
    final sessionBlockCount = blockResult.read<int>('session_block_count') ?? 0;
    final invalidTimeCount = blockResult.read<int>('invalid_time_count') ?? 0;
    if (sessionBlockCount > 0 && invalidTimeCount > 0) {
      return false;
    }

    final talkResult = await _db.customSelect('''
          SELECT
            SUM(
              CASE
                WHEN session_id IS NOT NULL
                 AND start_date IS NOT NULL
                 AND filter_time = '00:00–00:00'
                THEN 1
                ELSE 0
              END
            ) AS invalid_talk_time_count
          FROM events
          ''').getSingle();
    final invalidTalkTimeCount =
        talkResult.read<int>('invalid_talk_time_count') ?? 0;

    return invalidTalkTimeCount == 0;
  }

  Future<AppData> _loadLocalAppData() async {
    final jsonString = await _localSource.loadAppDataJson();
    return AppDataMapper.fromJsonString(jsonString);
  }

  Future<String?> _tryFetchRemoteLastUpdated() async {
    try {
      return await _portalClient.fetchLastUpdated();
    } on DioException catch (e, stackTrace) {
      AppLogger.w(
        'Portal sync-status unreachable. Falling back to local data.',
      );
      AppLogger.e('Portal sync-status error', e, stackTrace);
      return null;
    } on StateError catch (e, stackTrace) {
      AppLogger.e('Portal sync-status payload invalid', e, stackTrace);
      return null;
    }
  }

  bool _isRemoteNewer(String? remoteLastUpdated, String? localLastSyncAt) {
    if (remoteLastUpdated == null) {
      return false;
    }

    if (localLastSyncAt == null) {
      return true;
    }

    return DateTime.parse(
      remoteLastUpdated,
    ).isAfter(DateTime.parse(localLastSyncAt));
  }

  Future<AppData?> _tryLoadHybridAppData(AppData localAppData) async {
    try {
      final remoteJson = await _portalSource.loadAppDataJson();
      return AppDataMapper.mergeSchedule(
        base: localAppData,
        scheduleJson: jsonDecode(remoteJson) as Map<String, dynamic>,
      );
    } on DioException catch (e, stackTrace) {
      AppLogger.e('Portal schedule fetch failed', e, stackTrace);
      return null;
    } on FormatException catch (e, stackTrace) {
      AppLogger.e('Portal schedule JSON invalid', e, stackTrace);
      return null;
    } on StateError catch (e, stackTrace) {
      AppLogger.e('Portal schedule payload invalid', e, stackTrace);
      return null;
    }
  }

  Future<AppData> _loadBootstrapAppData({
    required AppData localAppData,
    required String? remoteLastUpdated,
  }) async {
    if (remoteLastUpdated == null) {
      return localAppData;
    }

    final remoteAppData = await _tryLoadHybridAppData(localAppData);
    return remoteAppData ?? localAppData;
  }

  Future<void> _replaceConferenceData(
    AppData appData, {
    required String? lastSyncAt,
  }) async {
    await _db.transaction(() async {
      await _seeder.reset();
      await _seeder.seed(appData);
      if (lastSyncAt != null) {
        await _db
            .into(_db.appConfigs)
            .insertOnConflictUpdate(
              AppConfigsCompanion.insert(
                key: _lastSyncAtKey,
                value: lastSyncAt,
              ),
            );
      }
    });
  }
}

const _lastSyncAtKey = 'last_sync_at';
