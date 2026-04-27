import 'dart:convert';
import 'package:drift/drift.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/data/mappers/app_data_mapper.dart';
import 'package:iced26/data/mappers/theme_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/data/sources/local/json/local_json_service.dart';
import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/domain/entities/theme_config.dart';
import 'package:iced26/domain/repositories/config_repository.dart';
import 'package:iced26/core/services/logger/logger.dart';

/// Repositorio para la gestión de la configuración.
class ConfigRepositoryImpl implements ConfigRepository {
  final AppDatabase _db;
  final LocalJsonService _jsonService;

  ConfigRepositoryImpl(this._db, this._jsonService);

  /// Sincroniza los datos de la aplicación desde el JSON bundled.
  @override
  Future<Result<void>> initializeDataIfNeeded() async {
    try {
      AppLogger.i('Sincronizando DB desde JSON bundled...');

      final appData = await _loadAppData();
      await _resetTables();

      await _db.batch((batch) {
        _insertAllData(batch, appData);
      });

      AppLogger.i('Sincronización completada correctamente.');
      return const Success(null);
    } catch (e) {
      AppLogger.e('Error en Config Init: $e');
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

  /// Carga y mapea el JSON a modelo de dominio.
  Future<AppData> _loadAppData() async {
    final jsonString = await _jsonService.loadAppDataJson();
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    return AppDataMapper.fromRaw(jsonMap);
  }

  /// Limpia las tablas antes de insertar datos.
  Future<void> _resetTables() async {
    await _db.delete(_db.events).go();
    await _db.delete(_db.news).go();
    await _db.delete(_db.socialActivities).go();
    await _db.delete(_db.submissionTypes).go();
    await _db.delete(_db.rooms).go();
    await _db.delete(_db.zones).go();
    await _db.delete(_db.days).go();
    await _db.delete(_db.people).go();
  }

  /// Inserta todos los datos en batch.
  void _insertAllData(Batch batch, AppData appData) {
    _insertDays(batch, appData);
    _insertSubmissionTypes(batch, appData);
    _insertRooms(batch, appData);
    _insertZones(batch, appData);
    _insertEvents(batch, appData);
    _insertNews(batch, appData);
    _insertSocialActivities(batch, appData);
    _insertPeople(batch, appData);
    _insertTheme(batch, appData);
  }

  /// Inserta los días en la tabla days.
  void _insertDays(Batch batch, AppData appData) {
    batch.insertAll(
      _db.days,
      appData.collections.days.map(
        (d) => DaysCompanion.insert(id: d.id, date: d.date, title: d.title),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Inserta los tipos de submission en la tabla submissionTypes.
  void _insertSubmissionTypes(Batch batch, AppData appData) {
    batch.insertAll(
      _db.submissionTypes,
      appData.collections.submissionTypes.map(
        (st) => SubmissionTypesCompanion.insert(
          id: st.id,
          name: st.name,
          durationMin: Value(st.durationMin),
          lang: Value(st.lang),
          description: st.description,
          scheduleDescription: st.scheduleDescription,
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Inserta las salas en la tabla rooms.
  void _insertRooms(Batch batch, AppData appData) {
    batch.insertAll(
      _db.rooms,
      appData.collections.rooms.map(
        (r) => RoomsCompanion.insert(
          id: r.id,
          name: r.name,
          capacity: Value(r.capacity),
          zoneId: Value(r.zoneId),
          sessionStyle: Value(r.sessionStyle),
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Inserta las zonas en la tabla zones.
  void _insertZones(Batch batch, AppData appData) {
    batch.insertAll(
      _db.zones,
      appData.collections.zones.map((z) {
        final name = z.name.resolve('und').isNotEmpty
            ? z.name.resolve('und')
            : z.name.resolve('en');

        return ZonesCompanion.insert(
          id: z.id,
          name: name,
          lang: Value(z.lang),
          description: Value(z.description),
        );
      }),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Inserta los eventos en la tabla events.
  void _insertEvents(Batch batch, AppData appData) {
    batch.insertAll(
      _db.events,
      appData.collections.events.map(
        (e) => EventsCompanion.insert(
          id: e.id,
          title: e.title,
          subtitle: Value(e.abstract_),
          description: Value(e.description),
          subtype: Value(e.subtype),
          track: Value(e.track),
          tagsJson: Value(e.tags.isEmpty ? null : jsonEncode(e.tags)),
          durationMin: Value(e.durationMin),
          startDate: Value(e.startDate),
          endDate: Value(e.endDate),
          zoneId: Value(e.zoneId),
          roomId: Value(e.roomId),
          type: e.type.jsonValue,
          lang: Value(e.lang),
          filterDate: Value(e.filterDate),
          filterTime: Value(e.filterTime),
          speakerIdsJson: Value(
            e.speakerIds.isEmpty ? null : jsonEncode(e.speakerIds),
          ),
          aboutPresentationUrl: Value(e.aboutPresentationUrl),
          videoPresentationUrl: Value(e.videoPresentationUrl),
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Inserta las noticias en la tabla news.
  void _insertNews(Batch batch, AppData appData) {
    batch.insertAll(
      _db.news,
      appData.collections.news.map(
        (n) => NewsCompanion.insert(
          id: n.id,
          title: n.title,
          content: n.content,
          imgUrl: n.imgUrl,
          webUrl: n.webUrl,
          date: n.datePublish.toIso8601String(),
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Inserta las actividades sociales en la tabla socialActivities.
  void _insertSocialActivities(Batch batch, AppData appData) {
    batch.insertAll(
      _db.socialActivities,
      appData.collections.socials.map(
        (sa) => SocialActivitiesCompanion.insert(
          id: sa.id,
          title: sa.title,
          description: sa.description,
          date: sa.date,
          time: sa.time,
          location: sa.location,
          imgUrl: sa.imgUrl,
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Inserta las personas en la tabla people.
  void _insertPeople(Batch batch, AppData appData) {
    batch.insertAll(
      _db.people,
      appData.collections.people.map(
        (p) => PeopleCompanion.insert(
          id: p.id,
          name: p.name,
          country: Value(p.country),
          title: Value(p.title),
          institution: Value(p.institution),
          bio: Value(p.bio),
          photoUrl: Value(p.photoUrl),
        ),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Inserta la configuración del tema en la tabla appConfigs.
  void _insertTheme(Batch batch, AppData appData) {
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
  }
}
