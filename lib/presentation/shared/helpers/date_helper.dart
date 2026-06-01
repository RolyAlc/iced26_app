import 'package:intl/intl.dart';

/// Helper para formatear fechas respetando el locale activo.
class DateHelper {
  // "Apr 27" / "Abr. 27" — mes abreviado y día.
  static String formatShortDate(DateTime date, String locale) {
    return _cap(DateFormat('MMM d', locale).format(date));
  }

  // "January 8, 2026" / "Junio 8, 2026" — fecha completa para cabeceras de formulario.
  static String formatFullDate(DateTime date, String locale) {
    return _cap(DateFormat('MMMM d, y', locale).format(date));
  }

  // "May 2026" / "Mayo 2026" — mes y año para cabeceras de calendario.
  static String formatMonthYear(DateTime date, String locale) {
    return _cap(DateFormat('MMMM y', locale).format(date));
  }

  // "8 May" / "8 may." — solo día y mes, sin día de la semana.
  static String formatDayShort(DateTime date, String locale) {
    return DateFormat('d MMM', locale).format(date);
  }

  // "Jun" / "Jun." — mes corto.
  static String monthShort(DateTime date, String locale) {
    return _cap(DateFormat('MMM', locale).format(date));
  }

  // "June" / "Junio" — mes completo.
  static String monthFull(DateTime date, String locale) {
    return _cap(DateFormat('MMMM', locale).format(date));
  }

  // "Mon" / "Lun." — nombre corto del día de la semana.
  static String weekdayShort(DateTime date, String locale) {
    return _cap(DateFormat('E', locale).format(date));
  }

  // "Thu · 8 May" / "Lun. · 8 may." — etiqueta compacta para cabeceras de día.
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

  static String _cap(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
