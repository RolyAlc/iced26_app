import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_calendar.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_day_content.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_helpers.dart';
import 'package:iced26/presentation/features/diary/viewmodel/diary_viewmodel.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

const _kSwipeVelocityThreshold = 300.0;

/// Cuerpo de la pantalla [DiaryView]. Envuelve [DiaryCalendar] y [DiaryDayContent]
/// con su propio [AppPage] para poder usarse como destino de navegación independiente.
class DiaryBody extends ConsumerStatefulWidget {
  const DiaryBody({super.key});

  @override
  ConsumerState<DiaryBody> createState() => _DiaryBodyState();
}

/// Estado de [DiaryBody].
class _DiaryBodyState extends ConsumerState<DiaryBody> {
  // int y no bool: el valor se pasa directamente al eje X del Offset del Tween (1 = derecha, -1 = izquierda).
  int _slideDirection = 1;

  void _selectDay(DateTime day) {
    final current = ref.read(selectedDiaryDateProvider);
    setState(() => _slideDirection = day.isAfter(current) ? 1 : -1);
    ref.read(selectedDiaryDateProvider.notifier).select(day);
    ref.read(diaryFocusedMonthProvider.notifier).set(day);
  }

  void _onPageChanged(DateTime month) {
    ref.read(diaryFocusedMonthProvider.notifier).set(month);
  }

  void _onHorizontalSwipe(double velocity, DateTime current) {
    if (velocity.abs() < _kSwipeVelocityThreshold) {
      return;
    }

    // Velocidad negativa = deslizamiento hacia la izquierda = avanzar al día siguiente.
    final isForward = velocity < 0;
    final next = isForward
        ? current.add(const Duration(days: 1))
        : current.subtract(const Duration(days: 1));

    if (next.isBefore(DiaryHelpers.firstDay) ||
        next.isAfter(DiaryHelpers.lastDay)) {
      return;
    }

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppLayout.horizontalPadding(context),
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
        _buildAnimatedDayContent(
          selectedDate: selectedDate,
          notesForDay: notesForDay,
          eventsForDay: eventsForDay,
        ),
      ],
    );
  }

  Widget _buildAnimatedDayContent({
    required DateTime selectedDate,
    required List<DiaryNote> notesForDay,
    required List<Event> eventsForDay,
  }) {
    return ClipRect(
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          _onHorizontalSwipe(details.primaryVelocity ?? 0, selectedDate);
        },
        child: AnimatedSwitcher(
          duration: AppDuration.fast,
          layoutBuilder: (currentChild, previousChildren) {
            // Ancla en topCenter: días con contenido de altura variable se mantienen
            // alineados arriba durante la animación. Sin esto, el hijo más corto
            // flotaría al centro del Stack visualmente.
            return Stack(
              alignment: Alignment.topCenter,
              children: [...previousChildren, ?currentChild],
            );
          },
          transitionBuilder: (child, animation) {
            final isIncoming = child.key == ValueKey(selectedDate);
            final dx = isIncoming
                ? _slideDirection.toDouble()
                : -_slideDirection.toDouble();
            final slide = Tween<Offset>(begin: Offset(dx, 0), end: Offset.zero)
                .animate(
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
    );
  }
}
