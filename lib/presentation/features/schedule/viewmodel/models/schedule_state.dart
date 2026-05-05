import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/session_block.dart';

/// Base item para cada elemento de la schedule
sealed class ScheduleItem {}

/// Evento único que no está en un bloque de sesión
class SingleEventItem extends ScheduleItem {
  final Event event;
  SingleEventItem(this.event);
}

/// Slot N1 con sus bloques de sesión N2 (tracks paralelos).
class SessionSlotItem extends ScheduleItem {
  final Event event;
  final List<SessionBlock> blocks;
  SessionSlotItem({required this.event, required this.blocks});
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
