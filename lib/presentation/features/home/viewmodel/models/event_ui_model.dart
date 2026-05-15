import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';

/// Modelo de datos para representar un evento en la capa de presentación.
class EventUIModel {
  EventUIModel({
    required this.id,
    required this.title,
    required this.timeRange,
    required this.duration,
    required this.room,
    required this.status,
    required this.event,
    this.imageUrl,
  });
  final String id;
  final String title;
  final String timeRange;
  final String duration;
  final String room;
  final EventStatus status;
  final String? imageUrl;

  /// Entidad de dominio embebida exclusivamente para abrir el detail sheet.
  final Event event;
}
