import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';

/// Elemento de la lista del Schedule: evento individual, grupo de paralelas
/// o separador de día.
sealed class ScheduleItem {}

class SingleEventItem extends ScheduleItem {
  final Event event;
  SingleEventItem(this.event);
}

class ParallelGroupItem extends ScheduleItem {
  final List<Event> events;
  final DateTime startDate;
  final EventType type;
  ParallelGroupItem({
    required this.events,
    required this.startDate,
    required this.type,
  });
}

/// Separador visual entre días.
class DaySeparatorItem extends ScheduleItem {
  final String label;
  final String date;
  DaySeparatorItem({required this.label, required this.date});
}

/// Estado de la pantalla de Schedule.
class ScheduleState {
  final List<ScheduleDaySection> sections;
  final List<EventType> categories;

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
