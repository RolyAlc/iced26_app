import 'package:intl/intl.dart';

/// Helper para formatear fechas respetando el locale activo.
class DateHelper {
  // Parsea un string ISO y lo muestra como "Apr 27" / "abr. 27". Devuelve el original si no es parseable.
  static String formatShortDate(String date, String locale) {
    final dt = DateTime.tryParse(date);
    if (dt == null) return date;
    return DateFormat('MMM d', locale).format(dt);
  }

  // "January 8, 2026" / "enero 8, 2026" — fecha completa para cabeceras de formulario.
  static String formatFullDate(DateTime date, String locale) {
    return DateFormat('MMMM d, y', locale).format(date);
  }

  // "May 2026" / "mayo 2026" — mes y año para cabeceras de calendario.
  static String formatMonthYear(DateTime date, String locale) {
    return DateFormat('MMMM y', locale).format(date);
  }

  // "8 May" / "8 may." — solo día y mes, sin día de la semana.
  static String formatDayShort(DateTime date, String locale) {
    return DateFormat('d MMM', locale).format(date);
  }

  // "Jun" / "jun." — mes corto.
  static String monthShort(DateTime date, String locale) {
    return DateFormat('MMM', locale).format(date);
  }

  // "June" / "junio" — mes completo.
  static String monthFull(DateTime date, String locale) {
    return DateFormat('MMMM', locale).format(date);
  }

  // "Mon" / "lun." — nombre corto del día de la semana.
  static String weekdayShort(DateTime date, String locale) {
    return DateFormat('E', locale).format(date);
  }

  // "Thu · 8 May" / "jue. · 8 may." — etiqueta compacta para cabeceras de día.
  static String formatDayLabel(DateTime date, String locale) {
    return '${weekdayShort(date, locale)} · ${formatDayShort(date, locale)}';
  }

  // Comprueba si dos fechas caen en el mismo día (ignora la hora).
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
