import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/logic/event_formatter.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';

/// Mapea un [Event] a un [EventUIModel] para la capa de presentación
/// Devuelve un modelo listo para mostrar en la UI,
/// con formato de texto y estado resuelto.
class EventUIMapper {
  static const _formatter = EventFormatter();

  static EventUIModel fromEntity(
    Event entity,
    String roomName, {
    String? imageUrl,
  }) {
    final status = EventStatusResolver.resolve(entity);
    final timeRange = _formatter.formatTimeRange(
      entity.startDate,
      entity.endDate,
    );
    final duration = _formatter.formatDuration(
      entity.startDate,
      entity.endDate,
    );

    return EventUIModel(
      id: entity.id,
      title: entity.title.resolve('en'),
      timeRange: timeRange,
      duration: duration,
      room: roomName,
      status: status,
      imageUrl: imageUrl,
    );
  }
}
