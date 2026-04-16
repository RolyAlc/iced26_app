/// Mapeador para formatear la duración de un evento.
/// Devuelve una cadena legible como "1h 30m", "1h", "30m" o
/// "N/A" si no se pueden calcular las fechas.
class EventDurationFormatter {
  static String format(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return 'N/A';
    }

    // Calcula la diferencia entre las fechas
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
      return '0m'; // Caso raro, pero por si acaso
    }
  }
}
