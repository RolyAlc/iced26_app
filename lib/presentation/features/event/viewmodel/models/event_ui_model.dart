import 'package:iced26/domain/entities/event_status.dart';

/// Modelo de datos para representar un evento en la capa de presentación.
class EventUIModel {
  final String title;
  final String timeRange;
  final String duration;
  final String room;
  final EventStatus status;
  final String? imageUrl;

  EventUIModel({
    required this.title,
    required this.timeRange,
    required this.duration,
    required this.room,
    required this.status,
    this.imageUrl,
  });
}
