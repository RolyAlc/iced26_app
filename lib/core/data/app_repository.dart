import 'package:drift/drift.dart';

import 'package:iced26/core/data/database/app_database.dart';
import 'package:iced26/data/mappers/app_data_mapper.dart';
import 'package:iced26/data/sources/local_json_service.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/utils/logger.dart';

/// Repositorio de la aplicación.
class AppRepository {
  final AppDatabase _db;
  final LocalJsonService _jsonService;

  AppRepository(this._db, [this._jsonService = const LocalJsonService()]);

  /// Inicializamos la base de datos con los datos del JSON si está vacía.
  Future<void> initializeDataIfNeeded() async {
    // Miramos si ya tenemos días registrados (señal de que hay datos).
    final existingDays = await _db.select(_db.days).get();

    // Si ya hay datos, no hacemos nada.
    if (existingDays.isNotEmpty) {
      return;
    }

    // Si está vacía, cargamos el JSON original.
    logger.i('Base de datos vacía. Insertamos los datos desde el JSON...');
    final jsonString = await _jsonService.loadAppDataJson();
    final appData = AppDataMapper.fromJsonString(jsonString);

    // Volcamos los datos en SQLite usando 'batch' para que sea ultra rápido.
    await _db.batch((batch) {
      // Guardamos los días
      batch.insertAll(
        _db.days,
        appData.collections.days.map((d) {
          return DaysCompanion.insert(id: d.id, date: d.date, title: d.title);
        }),
      );

      // Guardamos las salas (Rooms)
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
      );
    });
    logger.i('Datos insertados en la base de datos.');
  }

  /// Obtiene todos los días de la conferencia.
  Future<List<Day>> getAllDays() async {
    final results = await _db.select(_db.days).get();
    // Convertimos de la clase de Drift a nuestra entidad de Domain.
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
}
