import 'package:iced26/domain/entities/event.dart';

/// Estado de la pantalla de Agenda.
class AgendaState {
  final List<AgendaDaySection> sections;

  AgendaState({required this.sections});
}

/// Representa una sección de un día en la agenda.
class AgendaDaySection {
  final String title;
  final String date;
  final List<Event> events;

  AgendaDaySection({
    required this.title,
    required this.date,
    required this.events,
  });
}
