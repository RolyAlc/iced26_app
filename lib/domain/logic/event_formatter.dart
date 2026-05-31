import 'package:flutter/foundation.dart';

const _kZeroDuration = '0m';
const _kNotAvailable = 'N/A';

/// Agrupa toda la lógica de formateo relacionada con un Event.
/// Reemplaza los archivos separados en la capa de presentación.
@immutable
class EventFormatter {
  const EventFormatter();

  /// Placeholder para hora no asignada.
  static const String noTime = '--:--';

  /// Placeholder para cualquier atributo sin valor (duración, idioma, sala, etc.).
  static const String noValue = '--';

  /// Formatea la duración de un evento en texto legible (ej: "1h 30m").
  String formatDuration(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return _kNotAvailable;
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
      return _kZeroDuration;
    }
  }

  /// Devuelve la duración formateada, o null si es cero o los datos son nulos.
  String? displayDuration(DateTime? start, DateTime? end) {
    final d = formatDuration(start, end);
    if (d == _kNotAvailable || d == _kZeroDuration) {
      return null;
    }
    return d;
  }

  /// Formatea el rango de tiempo de un evento (ej: "09:00 - 10:30").
  String formatTimeRange(DateTime? start, DateTime? end) {
    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  String _formatTime(DateTime? time) {
    if (time == null) {
      return _kNotAvailable;
    }
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
