import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_calendar.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_day_content.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_error.dart';
import 'package:iced26/presentation/features/diary/viewmodel/diary_viewmodel.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_helpers.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

/// Mismos límites que DiaryCalendar — evitan navegar a días fuera del rango del congreso.
final _kFirstDay = DateTime(2025, 1, 1);
final _kLastDay = DateTime(2027, 12, 31);

/// Umbral mínimo de velocidad para considerar un swipe intencional.
const _kSwipeVelocityThreshold = 300.0;

/// Cuerpo del diario donde se muestra el calendario y el contenido del día seleccionado.
class DiaryBody extends ConsumerStatefulWidget {
  const DiaryBody({super.key});

  @override
  ConsumerState<DiaryBody> createState() => _DiaryBodyState();
}

class _DiaryBodyState extends ConsumerState<DiaryBody> {
  /// Dirección del último swipe — controla el slide de AnimatedSwitcher.
  int _slideDirection = 1;

  void _selectDay(DateTime day) {
    ref.read(selectedDiaryDateProvider.notifier).select(day);
    ref.read(diaryFocusedMonthProvider.notifier).set(day);
  }

  void _onPageChanged(DateTime month) {
    ref.read(diaryFocusedMonthProvider.notifier).set(month);
  }

  /// Avanza o retrocede un día según la velocidad del swipe horizontal.
  void _onHorizontalSwipe(double velocity, DateTime current) {
    if (velocity.abs() < _kSwipeVelocityThreshold) {
      return;
    }

    final isForward = velocity < 0;
    final next = isForward
        ? current.add(const Duration(days: 1))
        : current.subtract(const Duration(days: 1));

    if (next.isBefore(_kFirstDay) || next.isAfter(_kLastDay)) {
      return;
    }

    setState(() => _slideDirection = isForward ? 1 : -1);
    _selectDay(next);
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(diaryNotesProvider);
    final eventsAsync = ref.watch(diaryConferenceEventsProvider);
    final selectedDate = ref.watch(selectedDiaryDateProvider);
    final focusedMonth = ref.watch(diaryFocusedMonthProvider);

    final allNotes = notesAsync.value ?? [];
    final eventsByDay = eventsAsync.value ?? {};

    final notesForDay = DiaryHelpers.notesForDay(allNotes, selectedDate);
    final eventsForDay = DiaryHelpers.eventsForDay(eventsByDay, selectedDate);

    if (notesAsync.hasError) {
      return DiaryError(error: notesAsync.error!);
    }
    if (eventsAsync.hasError) {
      return DiaryError(error: eventsAsync.error!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.s,
          ),
          child: AppCard(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: DiaryCalendar(
              allNotes: allNotes,
              eventsByDay: eventsByDay,
              selectedDate: selectedDate,
              focusedMonth: focusedMonth,
              onDaySelected: _selectDay,
              onPageChanged: _onPageChanged,
            ),
          ),
        ),
        const Divider(height: 1),
        GestureDetector(
          onHorizontalDragEnd: (details) {
            _onHorizontalSwipe(details.primaryVelocity ?? 0, selectedDate);
          },
          child: AnimatedSwitcher(
            duration: AppDuration.fast,
            transitionBuilder: (child, animation) {
              final slide =
                  Tween<Offset>(
                    begin: Offset(_slideDirection.toDouble(), 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  );
              return SlideTransition(
                position: slide,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: DiaryDayContent(
              key: ValueKey(selectedDate),
              selectedDate: selectedDate,
              notes: notesForDay,
              events: eventsForDay,
              onDeleteNote: (id) =>
                  ref.read(deleteDiaryNoteUseCaseProvider).execute(id),
            ),
          ),
        ),
      ],
    );
  }
}
