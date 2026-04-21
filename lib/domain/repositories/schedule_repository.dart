import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/event.dart';

/// Contrato para la gestión de la schedule y eventos.
abstract class ScheduleRepository {
  /// Obtiene todos los días de la conferencia.
  Future<Result<List<Day>>> getAllDays();

  /// Obtiene todas las salas.
  Future<Result<List<Room>>> getAllRooms();

  /// Obtiene todos los eventos.
  Future<Result<List<Event>>> getAllEvents();
}
