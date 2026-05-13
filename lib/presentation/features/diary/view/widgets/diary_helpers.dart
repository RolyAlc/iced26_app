import 'package:table_calendar/table_calendar.dart';

import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/event.dart';

abstract final class DiaryHelpers {
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
    return (eventsByDay[normalizeDate(day)] ?? []).isNotEmpty;
  }

  static bool hasNote(List<DiaryNote> notes, DateTime day) {
    return notes.any((n) => isSameDay(n.date, day));
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }
}
