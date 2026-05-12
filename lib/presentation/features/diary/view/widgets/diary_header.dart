import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/diary/viewmodel/diary_viewmodel.dart';
import 'package:iced26/presentation/helpers/diary_helpers.dart';

/// Header de la vista del diario con el título y un botón para volver al día actual.
class DiaryHeader extends ConsumerWidget {
  const DiaryHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedDate = ref.watch(selectedDiaryDateProvider);
    final isToday = DiaryHelpers.isToday(selectedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('My Diary', style: theme.textTheme.headlineMedium),
          if (!isToday)
            ActionChip(
              label: const Text('Today'),
              onPressed: () {
                ref.read(selectedDiaryDateProvider.notifier).selectToday();
                ref
                    .read(diaryFocusedMonthProvider.notifier)
                    .set(DateTime.now());
              },
            ),
        ],
      ),
    );
  }
}
