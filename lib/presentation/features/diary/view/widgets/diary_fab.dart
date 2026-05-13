import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/diary_note_editor_sheet.dart';
import 'package:iced26/presentation/features/diary/viewmodel/diary_viewmodel.dart';
import 'package:iced26/presentation/app/ui_metrics.dart';

/// Botón flotante para agregar una nota al diario.
class DiaryFab extends ConsumerWidget {
  const DiaryFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDiaryDateProvider);
    final navBarHeight = ref.watch(uiMetricsProvider).navBarHeight;
    final bottom =
        (navBarHeight > 0 ? navBarHeight : AppLayout.navBarClearanceFallback) +
        AppSpacing.m;

    return Positioned(
      right: AppSpacing.l,
      bottom: bottom,
      child: FloatingActionButton.extended(
        heroTag: 'diary_add_note',
        onPressed: () => DiaryNoteEditorSheet.show(context, date: selectedDate),
        icon: const Icon(AppIcons.add),
        label: const Text('Add note'),
      ),
    );
  }
}
