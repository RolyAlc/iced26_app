import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/repositories/agenda_repository.dart';

typedef AgendaDataResult = ({
  List<Day> days,
  List<Event> allEvents,
  List<Room> allRooms,
});

/// Caso de uso: Obtener los datos crudos para la pantalla de Agenda.
class GetAgendaDataUseCase {
  // Repo inyectado por dependencias.
  final AgendaRepository _agendaRepo;

  GetAgendaDataUseCase(this._agendaRepo);

  /// Ejecuta el caso de uso y devuelve un Result con los datos de dominio.
  Future<Result<AgendaDataResult>> execute() async {
    final results = await Future.wait([
      _agendaRepo.getAllDays(),
      _agendaRepo.getAllEvents(),
      _agendaRepo.getAllRooms(),
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
