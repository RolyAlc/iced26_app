import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/presentation.dart';
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

  /// Obtiene las presentaciones (N3) para una lista de block IDs.
  Future<Result<List<Presentation>>> getPresentationsByBlockIds(
    List<String> blockIds,
  );

  /// Obtiene las presentaciones (N3) de un tipo concreto.
  Future<Result<List<Presentation>>> getPresentationsByType(String type);

  /// Obtiene eventos por sus IDs.
  Future<Result<List<Event>>> getEventsByIds(List<String> ids);

  /// Obtiene presentaciones (N3) por sus IDs.
  Future<Result<List<Presentation>>> getPresentationsByIds(List<String> ids);

  /// Obtiene todas las personas de la conferencia.
  Future<Result<List<Person>>> getAllPeople();
}
