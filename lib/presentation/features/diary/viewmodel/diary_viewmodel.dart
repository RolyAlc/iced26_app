import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/data_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';

part 'diary_viewmodel.g.dart';

// Devuelve true cuando el chip "Today" debe mostrarse.
@riverpod
bool diaryShowTodayChip(Ref ref) {
  final selected = ref.watch(selectedDiaryDateProvider);
  final focusedMonth = ref.watch(diaryFocusedMonthProvider);
  final format = ref.watch(diaryCalendarFormatProvider);
  final today = DateTime.now();
  final todayNorm = DateTime(today.year, today.month, today.day);

  final isSelectedToday = DateHelper.isSameDay(selected, today);

  final bool isTodayVisible;
  if (format == CalendarFormat.week) {
    final weekStart = focusedMonth.subtract(
      Duration(days: focusedMonth.weekday - 1),
    );
    final weekStartNorm = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );
    final weekEnd = weekStartNorm.add(const Duration(days: 6));
    isTodayVisible =
        !todayNorm.isBefore(weekStartNorm) && !todayNorm.isAfter(weekEnd);
  } else {
    isTodayVisible =
        focusedMonth.month == today.month && focusedMonth.year == today.year;
  }

  return !(isSelectedToday && isTodayVisible);
}

/// Índice de eventos del congreso por día.
@riverpod
Future<Map<DateTime, List<Event>>> diaryConferenceEvents(Ref ref) async {
  final result = await ref.watch(scheduleRepositoryProvider).getAllEvents();
  if (result is! Success<List<Event>>) {
    return {};
  }

  final map = <DateTime, List<Event>>{};
  for (final event in result.data) {
    if (event.startDate == null) continue;
    final day = DateTime(
      event.startDate!.year,
      event.startDate!.month,
      event.startDate!.day,
    );
    map.putIfAbsent(day, () => []).add(event);
  }
  return map;
}

// Estado inicial = hoy normalizado (sin hora) para que isSameDay funcione correctamente.
@riverpod
class SelectedDiaryDate extends _$SelectedDiaryDate {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void select(DateTime date) {
    state = DateTime(date.year, date.month, date.day);
  }

  void selectToday() {
    final now = DateTime.now();
    state = DateTime(now.year, now.month, now.day);
  }
}

// focusedDay de TableCalendar — controla el mes/semana visible en el calendario.
@riverpod
class DiaryFocusedMonth extends _$DiaryFocusedMonth {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void set(DateTime date) {
    state = date;
  }
}

// Formato activo del calendario (semana / mes). Estado elevado al viewmodel
// para que DiaryHeader pueda calcular si "Today" es redundante en cada vista.
@riverpod
class DiaryCalendarFormat extends _$DiaryCalendarFormat {
  @override
  CalendarFormat build() {
    return CalendarFormat.week;
  }

  void set(CalendarFormat format) {
    state = format;
  }
}
