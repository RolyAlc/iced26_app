import 'dart:convert';
import 'package:drift/drift.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/data/mappers/app_data_mapper.dart';
import 'package:iced26/data/mappers/theme_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/data/sources/local/json/local_json_service.dart';
import 'package:iced26/domain/entities/theme_config.dart';
import 'package:iced26/domain/repositories/config_repository.dart';
import 'package:iced26/core/logger/logger.dart';

/// Repositorio para la gestión de la configuración.
class ConfigRepositoryImpl implements ConfigRepository {
  final AppDatabase _db;
  final LocalJsonService _jsonService;

  ConfigRepositoryImpl(this._db, this._jsonService);

  /// Inicializa los datos de la aplicación si no existen.
  @override
  Future<Result<void>> initializeDataIfNeeded() async {
    try {
      // Comprobamos si hay datos básicos (ej. días)
      final existingDays = await _db.select(_db.days).get();

      if (existingDays.isEmpty) {
        logger.i('Base de datos vacía. Sembrando datos...');

        final jsonString = await _jsonService.loadAppDataJson();
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        final appData = AppDataMapper.fromRaw(jsonMap);

        await _db.batch((batch) {
          // Sembrar días
          batch.insertAll(
            _db.days,
            appData.collections.days.map(
              (d) =>
                  DaysCompanion.insert(id: d.id, date: d.date, title: d.title),
            ),
            mode: InsertMode.insertOrReplace,
          );

          // [:: Futuro] Añadir en caso de nuevos sections en el JSON.
          // Noticias, actividades, etc.

          // Guardar configuración inicial de tema
          batch.insert(
            _db.appConfigs,
            AppConfigsCompanion.insert(
              key: 'theme_config',
              value: jsonEncode({
                'colors': appData.theme.colors,
                'typography': appData.theme.typography,
                'logo': appData.theme.logo,
              }),
            ),
            mode: InsertMode.insertOrReplace,
          );
        });
        logger.i('Datos inicializados correctamente.');
      }
      return const Success(null);
    } catch (e) {
      logger.e('Error en Config Init: $e');
      return Failure('Error al inicializar la configuración: $e');
    }
  }

  /// Obtiene la configuración del tema.
  @override
  Future<Result<ThemeConfig?>> getThemeConfig() async {
    try {
      final query = _db.select(_db.appConfigs)
        ..where((t) => t.key.equals('theme_config'));
      final result = await query.getSingleOrNull();

      if (result == null) return const Success(null);

      final Map<String, dynamic> data =
          jsonDecode(result.value) as Map<String, dynamic>;
      return Success(ThemeMapper.fromMap(data));
    } catch (e) {
      logger.e('Error al obtener tema: $e');
      return Failure('No se pudo cargar la configuración del tema: $e');
    }
  }
}
