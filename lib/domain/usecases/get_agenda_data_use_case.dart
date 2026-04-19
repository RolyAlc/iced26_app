import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/repositories/agenda_repository.dart';
import 'package:iced26/presentation/features/agenda/viewmodel/models/agenda_state.dart';

/// Caso de uso: Obtener y organizar los datos para la pantalla de Agenda.
class GetAgendaDataUseCase {
  // Repo inyectado por dependencias.
  final AgendaRepository _agendaRepo;

  GetAgendaDataUseCase(this._agendaRepo);

  /// Ejecuta el caso de uso y devuelve un Result con el estado de la agenda.
  Future<Result<AgendaState>> execute(String locale) async {
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

    // Agrupar eventos por día
    final sortedEvents = [...events];
    sortedEvents.sort((a, b) {
      final aTime = a.startDate ?? DateTime(1900);
      final bTime = b.startDate ?? DateTime(1900);
      return aTime.compareTo(bTime);
    });

    // Crear secciones basadas en los días disponibles.
    final sections = days.map((day) {
      final dayEvents = sortedEvents.where((event) {
        if (event.startDate == null) return false;
        return event.startDate!.toIso8601String().startsWith(day.date);
      }).toList();

      return AgendaDaySection(
        title: day.title.resolve(locale),
        date: day.date,
        events: dayEvents,
      );
    }).toList();

    // Si no hay días definidos, agrupamos por fecha única
    if (sections.isEmpty) {
      final grouped = <String, List<Event>>{};
      for (final event in sortedEvents) {
        final dateKey =
            event.startDate?.toIso8601String().split('T').first ?? 'Sin fecha';
        grouped.putIfAbsent(dateKey, () => []).add(event);
      }

      // Crear secciones basadas en las fechas de los eventos.
      final fallbackSections = grouped.entries.map((entry) {
        return AgendaDaySection(
          title: entry.key,
          date: entry.key,
          events: entry.value,
        );
      }).toList();

      return Success(AgendaState(sections: fallbackSections));
    }

    return Success(AgendaState(sections: sections));
  }
}
