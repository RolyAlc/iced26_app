/// Estados posibles de un evento para la UI.
enum EventStatus { live, next, ended }

/// Modelo de datos para representar un evento en la capa de presentación.
class EventUIModel {
  final String title;
  final String timeRange;
  final String duration;
  final String room;
  final EventStatus status;

  EventUIModel({
    required this.title,
    required this.timeRange,
    required this.duration,
    required this.room,
    required this.status,
  });
}
