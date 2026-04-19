import 'dart:convert';
import 'package:drift/drift.dart';

import 'package:iced26/data/mappers/day_mapper.dart';
import 'package:iced26/data/mappers/room_mapper.dart';
import 'package:iced26/data/mappers/event_mapper.dart';
import 'package:iced26/data/mappers/news_mapper.dart';
import 'package:iced26/data/mappers/social_activity_mapper.dart';
import 'package:iced26/data/mappers/submission_type_mapper.dart';
import 'package:iced26/data/mappers/theme_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/data/mappers/app_data_mapper.dart';
import 'package:iced26/data/sources/local/json/local_json_service.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/domain/entities/submission_type.dart';
import 'package:iced26/domain/entities/theme_config.dart';
import 'package:iced26/domain/repositories/i_agenda_repository.dart';
import 'package:iced26/domain/repositories/i_home_repository.dart';
import 'package:iced26/domain/repositories/i_config_repository.dart';
import 'package:iced26/core/errors/result.dart';
import 'package:iced26/core/logger/logger.dart';

/// Repositorio unificado que implementa los contratos de Agenda, Home y Configuración.
class AppRepository
    implements IAgendaRepository, IHomeRepository, IConfigRepository {
  final AppDatabase _db;
  final LocalJsonService _jsonService;

  AppRepository(this._db, [this._jsonService = const LocalJsonService()]);

  /// Inicializamos la base de datos con los datos del JSON si está vacía.
  @override
  Future<Result<void>> initializeDataIfNeeded() async {
    try {
      final existingDays = await getAllDays();
      final existingNews = await getAllNews();
      final existingSocials = await getAllSocialActivities();
      final existingSubTypes = await getAllSubmissionTypes();

      // Comprobamos si alguno de los resultados es fallo
      if (existingDays is Failure ||
          existingNews is Failure ||
          existingSocials is Failure ||
          existingSubTypes is Failure) {
        return const Failure('No se pudieron verificar los datos existentes');
      }

      final days = (existingDays as Success<List<Day>>).data;
      final news = (existingNews as Success<List<NewsItem>>).data;
      final socials = (existingSocials as Success<List<SocialActivity>>).data;
      final subTypes = (existingSubTypes as Success<List<SubmissionType>>).data;

      if (days.isEmpty || news.isEmpty || socials.isEmpty || subTypes.isEmpty) {
        logger.i('Base de datos incompleta o vacía. Sembrando datos...');

        final jsonString = await _jsonService.loadAppDataJson();
        final appData = AppDataMapper.fromJsonString(jsonString);

        await _db.batch((batch) {
          // ... (rest of the batch logic)
          // I'll keep the batch logic inside the try block
          batch.insertAll(
            _db.days,
            appData.collections.days.map((d) {
              return DaysCompanion.insert(
                id: d.id,
                date: d.date,
                title: d.title,
              );
            }),
            mode: InsertMode.insertOrReplace,
          );

          batch.insertAll(
            _db.rooms,
            appData.collections.rooms.map((r) {
              return RoomsCompanion.insert(
                id: r.id,
                name: r.name,
                capacity: Value(r.capacity),
                zoneId: Value(r.zoneId),
                sessionStyle: Value(r.sessionStyle),
              );
            }),
            mode: InsertMode.insertOrReplace,
          );

          batch.insertAll(
            _db.events,
            appData.collections.events.map((e) {
              return EventsCompanion.insert(
                id: e.id,
                title: e.title,
                subtitle: Value(e.subtitle),
                startDate: Value(e.startDate),
                endDate: Value(e.endDate),
                zoneId: Value(e.zoneId),
                roomId: Value(e.roomId),
                type: e.type,
                lang: Value(e.lang),
                filterDate: Value(e.filterDate),
                filterTime: Value(e.filterTime),
              );
            }),
            mode: InsertMode.insertOrReplace,
          );

          batch.insertAll(
            _db.news,
            appData.collections.news.map((n) {
              return NewsCompanion.insert(
                id: n.id,
                title: n.title,
                content: n.content,
                imgUrl: n.imgUrl,
                webUrl: n.webUrl,
                date: n.datePublish.toIso8601String(),
              );
            }),
            mode: InsertMode.insertOrReplace,
          );

          batch.insertAll(
            _db.socialActivities,
            appData.collections.socials.map((s) {
              return SocialActivitiesCompanion.insert(
                id: s.id,
                title: s.title,
                description: s.description,
                date: s.date,
                time: s.time,
                location: s.location,
                imgUrl: s.imgUrl,
              );
            }),
            mode: InsertMode.insertOrReplace,
          );

          batch.insertAll(
            _db.submissionTypes,
            appData.collections.submissionTypes.map((st) {
              return SubmissionTypesCompanion.insert(
                id: st.id,
                name: st.name,
                durationMin: Value(st.durationMin),
                lang: Value(st.lang),
                description: st.description,
                scheduleDescription: st.scheduleDescription,
              );
            }),
            mode: InsertMode.insertOrReplace,
          );

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
        logger.i('Datos insertados en la base de datos.');
      }
      return const Success(null);
    } catch (e) {
      logger.e('Error al inicializar datos: $e');
      return Failure('Fallo al inicializar la base de datos local: $e');
    }
  }

  /// Helper para capturar errores de base de datos y devolver un Result.
  Future<Result<T>> _guard<T>(Future<T> Function() call) async {
    try {
      final data = await call();
      return Success(data);
    } catch (e) {
      logger.e('Database Error: $e');
      return Failure('Error al acceder a la base de datos: $e');
    }
  }

  /// Obtiene todos los días de la conferencia.
  @override
  Future<Result<List<Day>>> getAllDays() async {
    return _guard(() async {
      final results = await _db.select(_db.days).get();
      return results.map((e) => DayMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todas las salas.
  @override
  Future<Result<List<Room>>> getAllRooms() async {
    return _guard(() async {
      final results = await _db.select(_db.rooms).get();
      return results.map((e) => RoomMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todos los eventos.
  @override
  Future<Result<List<Event>>> getAllEvents() async {
    return _guard(() async {
      final results = await _db.select(_db.events).get();
      return results.map((e) => EventMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todas las noticias.
  @override
  Future<Result<List<NewsItem>>> getAllNews() async {
    return _guard(() async {
      final results = await _db.select(_db.news).get();
      return results.map((e) => NewsMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todas las actividades sociales.
  @override
  Future<Result<List<SocialActivity>>> getAllSocialActivities() async {
    return _guard(() async {
      final results = await _db.select(_db.socialActivities).get();
      return results.map((e) => SocialActivityMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todos los tipos de presentación.
  @override
  Future<Result<List<SubmissionType>>> getAllSubmissionTypes() async {
    return _guard(() async {
      final results = await _db.select(_db.submissionTypes).get();
      return results.map((e) => SubmissionTypeMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene la configuración del tema.
  @override
  Future<Result<ThemeConfig?>> getThemeConfig() async {
    return _guard(() async {
      final query = _db.select(_db.appConfigs)
        ..where((t) => t.key.equals('theme_config'));
      final result = await query.getSingleOrNull();

      if (result == null) return null;

      final Map<String, dynamic> data =
          jsonDecode(result.value) as Map<String, dynamic>;
      return ThemeMapper.fromMap(data);
    });
  }
}
