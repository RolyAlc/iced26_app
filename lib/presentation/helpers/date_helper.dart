/// Utilidades para el manejo y formateo de fechas en la capa de presentación.
class DateHelper {
  /// Formatea una fecha en formato ISO (o similar) a un formato legible corto (ej: "Apr 27").
  /// Si la fecha no es válida, devuelve el string original.
  static String formatShortDate(String date) {
    final dt = DateTime.tryParse(date);
    if (dt == null) {
      return date;
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[dt.month - 1]} ${dt.day}';
  }

  /// Formatea un [DateTime] a hora en formato "HH:mm". Devuelve '' si es null.
  static String formatTime(DateTime? dt) {
    if (dt == null) {
      return '';
    }
    final String timeFormated =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    return timeFormated;
  }

  /// Formatea un rango horario "HH:mm–HH:mm". Si solo hay inicio, devuelve solo ese.
  static String formatTimeRange(DateTime? start, DateTime? end) {
    final s = formatTime(start);
    if (s.isEmpty) {
      return '';
    }
    final e = formatTime(end);
    return e.isEmpty ? s : '$s-$e';
  }
}
