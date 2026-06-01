import 'package:iced26/core/constants/app_config.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:table_calendar/table_calendar.dart';

/// Clase abstracta final con utilidades para la pantalla de diario.
abstract final class DiaryHelpers {
  static final firstDay = AppConfig.firstDay;
  static final lastDay = AppConfig.lastDay;

  static DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static List<DiaryNote> notesForDay(List<DiaryNote> notes, DateTime day) {
    return notes.where((n) => isSameDay(n.date, day)).toList();
  }

  static List<Event> eventsForDay(
    Map<DateTime, List<Event>> eventsByDay,
    DateTime day,
  ) {
    final key = normalizeDate(day);
    return eventsByDay[key] ?? [];
  }

  static List<Object> itemsForDay({
    required DateTime day,
    required List<DiaryNote> notes,
    required Map<DateTime, List<Event>> eventsByDay,
  }) {
    return [...eventsForDay(eventsByDay, day), ...notesForDay(notes, day)];
  }

  static bool hasEvent(Map<DateTime, List<Event>> eventsByDay, DateTime day) {
    final events = eventsByDay[normalizeDate(day)] ?? [];
    return events.isNotEmpty;
  }

  static bool hasNote(List<DiaryNote> notes, DateTime day) {
    return notes.any((n) => isSameDay(n.date, day));
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  // Comprueba si hoy cae dentro de la semana de calendario (lunes-domingo)
  // que contiene [focusedDay]. table_calendar usa lunes como inicio de semana.
  static bool isTodayInSameCalendarWeek(DateTime focusedDay) {
    final now = DateTime.now();
    final normalizedNow = DateTime(now.year, now.month, now.day);
    final weekStart = focusedDay.subtract(
      Duration(days: focusedDay.weekday - 1),
    );
    final weekStartNormalized = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );
    final weekEnd = weekStartNormalized.add(const Duration(days: 6));
    final isOnOrAfterStart = !normalizedNow.isBefore(weekStartNormalized);
    final isOnOrBeforeEnd = !normalizedNow.isAfter(weekEnd);

    return isOnOrAfterStart && isOnOrBeforeEnd;
  }

  // "Today · 3 May" cuando es hoy, nombre completo del día en otro caso.
  static String formatDayHeader(DateTime date, AppLocalizations l10n) {
    if (isToday(date)) {
      return l10n.diaryTodayHeader(DateHelper.formatDayShort(date));
    }
    return DateHelper.formatDayLabel(date);
  }
}
