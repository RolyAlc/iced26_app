import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/session_block.dart';
import 'package:iced26/domain/repositories/schedule_repository.dart';

/// Tipo de dato que representa la información necesaria para la pantalla Schedule.
typedef ScheduleDataResult = ({
  List<Day> days,
  List<Event> allEvents,
  List<Room> allRooms,
  List<SessionBlock> allSessionBlocks,
});

/// Caso de uso: Obtener los datos crudos para la pantalla de Schedule.
class GetScheduleDataUseCase {
  GetScheduleDataUseCase(this._scheduleRepo);
  final ScheduleRepository _scheduleRepo;

  Future<Result<ScheduleDataResult>> execute() async {
    final results = await Future.wait([
      _scheduleRepo.getAllDays(),
      _scheduleRepo.getAllEvents(),
      _scheduleRepo.getAllRooms(),
      _scheduleRepo.getAllSessionBlocks(),
    ]);

    for (final result in results) {
      if (result is Failure) {
        return Failure((result as Failure).message);
      }
    }

    final days = (results[0] as Success<List<Day>>).data;
    final events = (results[1] as Success<List<Event>>).data;
    final rooms = (results[2] as Success<List<Room>>).data;
    final blocks = (results[3] as Success<List<SessionBlock>>).data;

    return Success((
      days: days,
      allEvents: events,
      allRooms: rooms,
      allSessionBlocks: blocks,
    ));
  }
}
