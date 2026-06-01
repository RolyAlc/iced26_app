import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/session_block.dart';
import 'package:iced26/domain/entities/zone.dart';

/// Contrato para la gestión de la schedule y eventos.
abstract class ScheduleRepository {
  /// Obtiene todos los días de la conferencia.
  Future<Result<List<Day>>> getAllDays();

  /// Obtiene todas las salas.
  Future<Result<List<Room>>> getAllRooms();

  /// Obtiene todas las zonas de la conferencia.
  Future<Result<List<Zone>>> getAllZones();

  /// Obtiene todos los eventos.
  Future<Result<List<Event>>> getAllEvents();

  /// Obtiene todos los bloques de sesión (N2).
  Future<Result<List<SessionBlock>>> getAllSessionBlocks();

  /// Obtiene los talks asociados a una lista de bloques.
  Future<Result<List<Event>>> getEventsBySessionIds(List<String> sessionIds);

  /// Obtiene eventos de un tipo concreto.
  Future<Result<List<Event>>> getEventsByType(String type);

  /// Obtiene eventos por sus IDs.
  Future<Result<List<Event>>> getEventsByIds(List<String> ids);

  /// Obtiene todas las personas de la conferencia.
  Future<Result<List<Person>>> getAllPeople();
}
