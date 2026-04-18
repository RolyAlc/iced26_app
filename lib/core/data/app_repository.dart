import 'package:drift/drift.dart';

import 'package:iced26/core/data/database/app_database.dart';
import 'package:iced26/data/mappers/app_data_mapper.dart';
import 'package:iced26/data/sources/local_json_service.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/utils/logger.dart';

/// Repositorio de la aplicación.
class AppRepository {
  final AppDatabase _db;
  final LocalJsonService _jsonService;

  AppRepository(this._db, [this._jsonService = const LocalJsonService()]);

  /// Inicializamos la base de datos con los datos del JSON si está vacía.
  Future<void> initializeDataIfNeeded() async {
    final existingDays = await _db.select(_db.days).get();
    final existingNews = await _db.select(_db.news).get();

    // TODO: Mejorar este control de carga de datos.
    // Si ya tenemos días y noticias, consideramos que la base de datos está completa.
    if (existingDays.isNotEmpty && existingNews.isNotEmpty) {
      return;
    }

    logger.i('Base de datos vacía. Insertamos los datos desde el JSON...');
    final jsonString = await _jsonService.loadAppDataJson();
    final appData = AppDataMapper.fromJsonString(jsonString);

    await _db.batch((batch) {
      batch.insertAll(
        _db.days,
        appData.collections.days.map((d) {
          return DaysCompanion.insert(id: d.id, date: d.date, title: d.title);
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

      // Guardamos los eventos
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
    });
    logger.i('Datos insertados en la base de datos.');
  }

  /// Obtiene todos los días de la conferencia.
  Future<List<Day>> getAllDays() async {
    final results = await _db.select(_db.days).get();
    return results
        .map((d) => Day(id: d.id, date: d.date, title: d.title))
        .toList();
  }

  /// Obtiene todas las salas.
  Future<List<Room>> getAllRooms() async {
    final results = await _db.select(_db.rooms).get();
    return results
        .map(
          (r) => Room(
            id: r.id,
            name: r.name,
            capacity: r.capacity,
            zoneId: r.zoneId,
            sessionStyle: r.sessionStyle,
          ),
        )
        .toList();
  }

  /// Obtiene todos los eventos.
  Future<List<Event>> getAllEvents() async {
    final results = await _db.select(_db.events).get();
    return results
        .map(
          (e) => Event(
            id: e.id,
            title: e.title,
            subtitle: e.subtitle,
            startDate: e.startDate,
            endDate: e.endDate,
            zoneId: e.zoneId,
            roomId: e.roomId,
            type: e.type,
            lang: e.lang,
            filterDate: e.filterDate,
            filterTime: e.filterTime,
          ),
        )
        .toList();
  }

  /// Obtiene todas las noticias.
  Future<List<NewsItem>> getAllNews() async {
    final results = await _db.select(_db.news).get();
    return results
        .map(
          (n) => NewsItem(
            id: n.id,
            title: n.title,
            content: n.content,
            imgUrl: n.imgUrl,
            webUrl: n.webUrl,
            datePublish: DateTime.tryParse(n.date) ?? DateTime.now(),
          ),
        )
        .toList();
  }

  /// Obtiene todas las actividades sociales.
  Future<List<SocialActivity>> getAllSocialActivities() async {
    final results = await _db.select(_db.socialActivities).get();
    return results
        .map(
          (s) => SocialActivity(
            id: s.id,
            title: s.title,
            description: s.description,
            date: s.date,
            time: s.time,
            location: s.location,
            imgUrl: s.imgUrl,
          ),
        )
        .toList();
  }
}
