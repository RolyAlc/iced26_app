/// Helper para formatear fechas.
class DateHelper {
  static const _months = [
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

  static const _fullMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Parsea un string ISO y lo muestra como "Apr 27". Devuelve el original si no es parseable.
  static String formatShortDate(String date) {
    final dt = DateTime.tryParse(date);
    if (dt == null) return date;
    return '${_months[dt.month - 1]} ${dt.day}';
  }

  // "January 8, 2026" — fecha completa para cabeceras de formulario.
  static String formatFullDate(DateTime date) {
    return '${_fullMonths[date.month - 1]} ${date.day}, ${date.year}';
  }

  // "May 2026" — mes y año para cabeceras de calendario.
  static String formatMonthYear(DateTime date) {
    return '${_fullMonths[date.month - 1]} ${date.year}';
  }

  // "8 May" — solo día y mes, sin día de la semana.
  static String formatDayShort(DateTime date) {
    return '${date.day} ${_months[date.month - 1]}';
  }

  // "Mon", "Tue"… — nombre corto del día de la semana.
  static String weekdayShort(DateTime date) {
    return _weekdays[date.weekday - 1];
  }

  // Comprueba si dos fechas caen en el mismo día (ignora la hora).
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // "Thu · 8 May" — etiqueta compacta para cabeceras de día.
  static String formatDayLabel(DateTime date) {
    return '${_weekdays[date.weekday - 1]} · ${formatDayShort(date)}';
  }

  // Devuelve '' si dt es null para que los callers no necesiten null-check.
  static String formatTime(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  // Devuelve '' si los tiempos son nulos.
  static String formatTimeRange(DateTime? start, DateTime? end) {
    final s = formatTime(start);
    if (s.isEmpty) return '';
    final e = formatTime(end);
    return e.isEmpty ? s : '$s–$e';
  }
}
