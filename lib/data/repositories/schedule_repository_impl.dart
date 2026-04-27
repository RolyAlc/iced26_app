import 'package:iced26/core/errors/result.dart';
import 'package:iced26/data/mappers/day_mapper.dart';
import 'package:iced26/data/mappers/event/event_mapper.dart';
import 'package:iced26/data/mappers/person_mapper.dart';
import 'package:iced26/data/mappers/room_mapper.dart';
import 'package:iced26/data/mappers/zone_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/zone.dart';
import 'package:iced26/domain/repositories/schedule_repository.dart';
import 'package:iced26/core/services/logger/logger.dart';

/// Repositorio para la gestión del schedule.
class ScheduleRepositoryImpl implements ScheduleRepository {
  final AppDatabase _db;

  ScheduleRepositoryImpl(this._db);

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
      return results.map((e) => DayMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todas las salas del schedule.
  @override
  Future<Result<List<Room>>> getAllRooms() async {
    return _guard(() async {
      final results = await _db.select(_db.rooms).get();
      return results.map((e) => RoomMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todas las zonas de la conferencia.
  @override
  Future<Result<List<Zone>>> getAllZones() async {
    return _guard(() async {
      final results = await _db.select(_db.zones).get();
      return results.map((z) => ZoneMapper.fromDrift(z)).toList();
    });
  }

  /// Obtiene todos los eventos del schedule.
  @override
  Future<Result<List<Event>>> getAllEvents() async {
    return _guard(() async {
      final results = await _db.select(_db.events).get();
      return results.map((e) => EventMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todas las personas de la conferencia.
  @override
  Future<Result<List<Person>>> getAllPeople() async {
    return _guard(() async {
      final results = await _db.select(_db.people).get();
      return results.map((p) => PeopleMapper.fromDrift(p)).toList();
    });
  }
}
