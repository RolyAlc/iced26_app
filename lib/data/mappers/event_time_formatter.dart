/// Mapea un [Event] a un formato de tiempo legible para la UI
/// Devuelve un string legible para mostrar en la UI.
class EventTimeFormatter {
  static String formatRange(DateTime? start, DateTime? end) {
    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  static String _formatTime(DateTime? time) {
    if (time == null) return 'N/A';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
