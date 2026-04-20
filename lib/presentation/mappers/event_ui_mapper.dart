import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/utils/event_duration_formatter.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/presentation/utils/event_time_formatter.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';

/// Mapea un [Event] a un [EventUIModel] para la capa de presentación
/// Devuelve un modelo listo para mostrar en la UI,
/// con formato de texto y estado resuelto.
class EventUIMapper {
  static EventUIModel fromEntity(Event entity, String roomName) {
    final status = EventStatusResolver.resolve(entity);
    final timeRange = EventTimeFormatter.formatRange(
      entity.startDate,
      entity.endDate,
    );
    final duration = EventDurationFormatter.format(
      entity.startDate,
      entity.endDate,
    );

    return EventUIModel(
      title: entity.title.resolve('en'),
      timeRange: timeRange,
      duration: duration,
      room: roomName,
      status: status,
    );
  }
}
