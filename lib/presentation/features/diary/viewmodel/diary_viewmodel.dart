import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/data_providers.dart';
import 'package:iced26/domain/entities/event.dart';

part 'diary_viewmodel.g.dart';

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

/// Fecha seleccionada en el calendario del diario.
@riverpod
class SelectedDiaryDate extends _$SelectedDiaryDate {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Selecciona una fecha en el calendario del diario.
  void select(DateTime date) {
    state = DateTime(date.year, date.month, date.day);
  }
}

/// Mes visible en el calendario (usado por TableCalendar como focusedDay).
@riverpod
class DiaryFocusedMonth extends _$DiaryFocusedMonth {
  @override
  DateTime build() {
    return DateTime.now();
  }

  /// Establece el mes visible en el calendario.
  void set(DateTime date) {
    state = date;
  }
}
