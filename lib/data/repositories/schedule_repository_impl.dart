import 'package:iced26/core/errors/result.dart';
import 'package:iced26/core/services/logger/logger.dart';
import 'package:iced26/data/mappers/day_mapper.dart';
import 'package:iced26/data/mappers/event/event_mapper.dart';
import 'package:iced26/data/mappers/person_mapper.dart';
import 'package:iced26/data/mappers/room_mapper.dart';
import 'package:iced26/data/mappers/session_block/session_block_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/session_block.dart';
import 'package:iced26/domain/repositories/schedule_repository.dart';

/// Repositorio para la gestión del schedule.
class ScheduleRepositoryImpl implements ScheduleRepository {
  ScheduleRepositoryImpl(this._db);
  final AppDatabase _db;

  /// Método auxiliar para manejar errores de base de datos.
  Future<Result<T>> _guard<T>(Future<T> Function() call) async {
    try {
      final data = await call();
      return Success(data);
    } catch (e) {
      AppLogger.e('Database Error (Schedule): $e');
      return Failure('Error accessing schedule: $e');
    }
  }

  /// Obtiene todos los días del schedule.
  @override
  Future<Result<List<Day>>> getAllDays() async {
    return _guard(() async {
      final results = await _db.select(_db.days).get();
      return results.map(DayMapper.fromDrift).toList();
    });
  }

  /// Obtiene todas las salas del schedule.
  @override
  Future<Result<List<Room>>> getAllRooms() async {
    return _guard(() async {
      final results = await _db.select(_db.rooms).get();
      return results.map(RoomMapper.fromDrift).toList();
    });
  }

  /// Obtiene todos los eventos del schedule.
  @override
  Future<Result<List<Event>>> getAllEvents() async {
    return _guard(() async {
      final results = await _db.select(_db.events).get();
      return results.map(EventMapper.fromDrift).toList();
    });
  }

  /// Obtiene todos los bloques de sesión (N2).
  @override
  Future<Result<List<SessionBlock>>> getAllSessionBlocks() async {
    return _guard(() async {
      final results = await _db.select(_db.sessionBlocks).get();
      return results.map(SessionBlockMapper.fromDrift).toList();
    });
  }

  /// Obtiene los talks para los bloques indicados.
  @override
  Future<Result<List<Event>>> getEventsBySessionIds(
    List<String> sessionIds,
  ) async {
    return _guard(() async {
      if (sessionIds.isEmpty) return [];
      final results = await (_db.select(
        _db.events,
      )..where((t) => t.sessionId.isIn(sessionIds))).get();
      return results.map(EventMapper.fromDrift).toList();
    });
  }

  /// Obtiene eventos de un tipo concreto.
  @override
  Future<Result<List<Event>>> getEventsByType(String type) async {
    return _guard(() async {
      final results = await (_db.select(
        _db.events,
      )..where((t) => t.type.equals(type))).get();
      return results.map(EventMapper.fromDrift).toList();
    });
  }

  /// Obtiene eventos por sus IDs.
  @override
  Future<Result<List<Event>>> getEventsByIds(List<String> ids) async {
    return _guard(() async {
      if (ids.isEmpty) return [];
      final results = await (_db.select(
        _db.events,
      )..where((t) => t.id.isIn(ids))).get();
      return results.map(EventMapper.fromDrift).toList();
    });
  }

  /// Obtiene todas las personas de la conferencia.
  @override
  Future<Result<List<Person>>> getAllPeople() async {
    return _guard(() async {
      final results = await _db.select(_db.people).get();
      return results.map(PersonMapper.fromDrift).toList();
    });
  }
}
