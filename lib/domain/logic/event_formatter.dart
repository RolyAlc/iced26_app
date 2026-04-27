import 'package:flutter/foundation.dart';

/// Agrupa toda la lógica de formateo relacionada con un Event.
/// Reemplaza los archivos separados en la capa de presentación.
@immutable
class EventFormatter {
  const EventFormatter();

  /// Formatea la duración de un evento en texto legible (ej: "1h 30m").
  String formatDuration(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return 'N/A';
    }

    final diff = end.difference(start);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '0m';
    }
  }

  /// Formatea el rango de tiempo de un evento (ej: "09:00 - 10:30").
  String formatTimeRange(DateTime? start, DateTime? end) {
    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  String _formatTime(DateTime? time) {
    if (time == null) {
      return 'N/A';
    }
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
