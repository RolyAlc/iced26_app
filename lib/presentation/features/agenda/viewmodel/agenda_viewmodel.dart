import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/presentation/features/agenda/viewmodel/models/agenda_state.dart';
import 'package:iced26/domain/entities/event.dart';

part 'agenda_viewmodel.g.dart';

/// ViewModel para la pantalla de Agenda.
/// Maneja la obtención de eventos agrupados y el estado de carga/error.
@riverpod
class AgendaViewModel extends _$AgendaViewModel {
  @override
  Future<AgendaState> build() async {
    // [:: Futuro] Obtener locale dinámico
    const locale = 'en';

    final useCase = ref.watch(getAgendaDataUseCaseProvider);
    final result = await useCase.execute();

    switch (result) {
      case Success(data: final data):
        // Agrupar eventos por día
        final sortedEvents = [...data.allEvents];
        sortedEvents.sort((a, b) {
          final aTime = a.startDate ?? DateTime(1900);
          final bTime = b.startDate ?? DateTime(1900);
          return aTime.compareTo(bTime);
        });

        // Crear secciones basadas en los días disponibles.
        final sections = data.days.map((day) {
          final dayEvents = sortedEvents.where((event) {
            if (event.startDate == null) return false;
            return event.startDate!.toIso8601String().startsWith(day.date);
          }).toList();

          return AgendaDaySection(
            title: day.title.resolve(locale),
            date: day.date,
            events: dayEvents, // [:: Futuro] Mapear a EventUIModel
          );
        }).toList();

        // Si no hay días definidos, agrupamos por fecha única
        if (sections.isEmpty) {
          final grouped = <String, List<Event>>{};
          for (final event in sortedEvents) {
            final dateKey =
                event.startDate?.toIso8601String().split('T').first ??
                'Sin fecha';
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

          return AgendaState(sections: fallbackSections);
        }

        return AgendaState(sections: sections);

      case Failure(message: final msg):
        throw msg;
    }
  }
}
