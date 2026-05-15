import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_helpers.dart';
import 'package:iced26/presentation/features/diary/viewmodel/diary_viewmodel.dart';
import 'package:table_calendar/table_calendar.dart';

const _kTitle = 'My Diary';
const _kTodayLabel = 'Today';

/// Header de la vista del diario con el título y un botón para volver al día actual.
class DiaryHeader extends ConsumerWidget {
  const DiaryHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedDate = ref.watch(selectedDiaryDateProvider);
    final focusedMonth = ref.watch(diaryFocusedMonthProvider);

    final format = ref.watch(diaryCalendarFormatProvider);
    final isSelectedToday = DiaryHelpers.isToday(selectedDate);

    // El chip es redundante solo cuando hoy ya está seleccionado
    // Y la vista actual del calendario muestra hoy (semana o mes correctos).
    final isTodayVisible = format == CalendarFormat.week
        ? DiaryHelpers.isTodayInSameCalendarWeek(focusedMonth)
        : focusedMonth.month == DateTime.now().month &&
              focusedMonth.year == DateTime.now().year;

    final isRedundant = isSelectedToday && isTodayVisible;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_kTitle, style: theme.textTheme.headlineMedium),
          AnimatedOpacity(
            opacity: isRedundant ? 0.0 : 1.0,
            duration: AppDuration.fast,
            child: IgnorePointer(
              ignoring: isRedundant,
              child: ActionChip(
                label: Text(
                  _kTodayLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                backgroundColor: theme.colorScheme.primaryContainer,
                side: BorderSide.none,
                elevation: 0,
                shadowColor: Colors.transparent,
                onPressed: () {
                  ref.read(selectedDiaryDateProvider.notifier).selectToday();
                  ref
                      .read(diaryFocusedMonthProvider.notifier)
                      .set(DateTime.now());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
