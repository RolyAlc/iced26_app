import 'package:iced26/core/errors/result.dart';
import 'package:iced26/data/mappers/day_mapper.dart';
import 'package:iced26/data/mappers/event/event_mapper.dart';
import 'package:iced26/data/mappers/room_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/repositories/agenda_repository.dart';
import 'package:iced26/core/services/logger/logger.dart';

/// Repositorio para la gestión de la agenda.
class AgendaRepositoryImpl implements AgendaRepository {
  final AppDatabase _db;

  AgendaRepositoryImpl(this._db);

  /// Método auxiliar para manejar errores de base de datos.
  Future<Result<T>> _guard<T>(Future<T> Function() call) async {
    try {
      final data = await call();
      return Success(data);
    } catch (e) {
      AppLogger.e('Database Error (Agenda): $e');
      return Failure('Error al acceder a la agenda: $e');
    }
  }

  /// Obtiene todos los días de la agenda.
  @override
  Future<Result<List<Day>>> getAllDays() async {
    return _guard(() async {
      final results = await _db.select(_db.days).get();
      return results.map((e) => DayMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todas las salas de la agenda.
  @override
  Future<Result<List<Room>>> getAllRooms() async {
    return _guard(() async {
      final results = await _db.select(_db.rooms).get();
      return results.map((e) => RoomMapper.fromDrift(e)).toList();
    });
  }

  /// Obtiene todos los eventos de la agenda.
  @override
  Future<Result<List<Event>>> getAllEvents() async {
    return _guard(() async {
      final results = await _db.select(_db.events).get();
      return results.map((e) => EventMapper.fromDrift(e)).toList();
    });
  }
}
