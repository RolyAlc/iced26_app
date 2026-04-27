import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';

/// Modelo de presentación de una sesión en el detalle de un keynote speaker.
class SessionUIModel {
  final EventType type;
  final String title;
  final String formattedDateTime;
  final Event event;

  const SessionUIModel({
    required this.type,
    required this.title,
    required this.formattedDateTime,
    required this.event,
  });
}
