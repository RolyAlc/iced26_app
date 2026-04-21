import 'package:iced26/domain/entities/event.dart';

/// Elemento de la lista del Schedule: evento individual o grupo de paralelas.
sealed class ScheduleItem {}

class SingleEventItem extends ScheduleItem {
  final Event event;
  SingleEventItem(this.event);
}

class ParallelGroupItem extends ScheduleItem {
  final List<Event> events;
  final DateTime startDate;
  final String type;
  ParallelGroupItem({
    required this.events,
    required this.startDate,
    required this.type,
  });
}

/// Estado de la pantalla de Schedule.
class ScheduleState {
  final List<ScheduleDaySection> sections;
  final List<String> categories;

  ScheduleState({required this.sections, required this.categories});
}

/// Representa una sección de un día en la schedule.
class ScheduleDaySection {
  final String title;
  final String date;
  final List<ScheduleItem> items;

  ScheduleDaySection({
    required this.title,
    required this.date,
    required this.items,
  });
}
