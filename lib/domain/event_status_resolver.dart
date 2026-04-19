import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';

/// Utiliza la información de un [Event] para determinar su estado actual.
/// Devuelve un [EventStatus] (live, next, ended) que la UI puede
/// usar para mostrar el estado correcto.
class EventStatusResolver {
  static EventStatus resolve(Event entity, {DateTime? now}) {
    final reference = now ?? DateTime.now();

    if (entity.endDate != null && reference.isAfter(entity.endDate!)) {
      return EventStatus.ended;
    }

    if (entity.startDate != null && reference.isBefore(entity.startDate!)) {
      return EventStatus.next;
    }

    return EventStatus.live;
  }
}
