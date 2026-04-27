import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/repositories/schedule_repository.dart';

typedef ScheduleDataResult = ({
  List<Day> days,
  List<Event> allEvents,
  List<Room> allRooms,
});

/// Caso de uso: Obtener los datos crudos para la pantalla de Schedule.
class GetScheduleDataUseCase {
  // Repo inyectado por dependencias.
  final ScheduleRepository _scheduleRepo;

  GetScheduleDataUseCase(this._scheduleRepo);

  /// Ejecuta el caso de uso y devuelve un Result con los datos de dominio.
  Future<Result<ScheduleDataResult>> execute() async {
    final results = await Future.wait([
      _scheduleRepo.getAllDays(),
      _scheduleRepo.getAllEvents(),
      _scheduleRepo.getAllRooms(),
    ]);

    // Gestión de errores
    for (final result in results) {
      if (result is Failure) {
        return Failure((result as Failure).message);
      }
    }

    final days = (results[0] as Success<List<Day>>).data;
    final events = (results[1] as Success<List<Event>>).data;
    final rooms = (results[2] as Success<List<Room>>).data;

    return Success((days: days, allEvents: events, allRooms: rooms));
  }
}
