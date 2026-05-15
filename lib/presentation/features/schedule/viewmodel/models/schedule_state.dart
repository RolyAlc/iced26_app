import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/session_block.dart';

/// Base item para cada elemento de la schedule
sealed class ScheduleItem {}

/// Evento único que no está en un bloque de sesión
class SingleEventItem extends ScheduleItem {
  SingleEventItem(this.event);
  final Event event;
}

/// Slot N1 con sus bloques de sesión N2 (tracks paralelos).
class SessionSlotItem extends ScheduleItem {
  SessionSlotItem({required this.event, required this.blocks});
  final Event event;
  final List<SessionBlock> blocks;
}

/// Separador visual entre días.
class DaySeparatorItem extends ScheduleItem {
  DaySeparatorItem({required this.label, required this.date});
  final String label;
  final String date;
}

/// Estado de la pantalla de Schedule.
class ScheduleState {
  ScheduleState({required this.sections, required this.categories});
  final List<ScheduleDaySection> sections;
  final List<EventType> categories;
}

/// Representa una sección de un día en la schedule.
class ScheduleDaySection {
  ScheduleDaySection({
    required this.title,
    required this.date,
    required this.items,
  });
  final String title;
  final String date;
  final List<ScheduleItem> items;
}
