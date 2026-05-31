import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/features/diary/viewmodel/diary_viewmodel.dart';
import 'package:iced26/presentation/shared/widgets/app_page_title.dart';

/// Header de la vista del diario con el título y un botón para volver al día actual.
class DiaryHeader extends ConsumerWidget {
  const DiaryHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final showTodayChip = ref.watch(diaryShowTodayChipProvider);

    return AppPageTitle(
      title: l10n.diaryTitle,
      trailing: showTodayChip
          ? ActionChip(
              label: Text(
                l10n.diaryTodayChip,
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
            )
          : null,
    );
  }
}
