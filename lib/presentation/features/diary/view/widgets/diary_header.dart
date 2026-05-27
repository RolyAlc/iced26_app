import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/diary/viewmodel/diary_viewmodel.dart';
import 'package:iced26/presentation/shared/widgets/app_page_title.dart';

const _kTitle = 'My diary';
const _kTodayLabel = 'Today';

/// Header de la vista del diario con el título y un botón para volver al día actual.
class DiaryHeader extends ConsumerWidget {
  const DiaryHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isRedundant = ref.watch(diaryIsChipRedundantProvider);

    return AppPageTitle(
      title: _kTitle,
      trailing: AnimatedOpacity(
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
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              ref.read(selectedDiaryDateProvider.notifier).selectToday();
              ref.read(diaryFocusedMonthProvider.notifier).set(DateTime.now());
            },
          ),
        ),
      ),
    );
  }
}
