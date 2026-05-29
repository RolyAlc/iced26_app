import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/app/ui_metrics.dart';
import 'package:iced26/presentation/features/diary/view/widgets/note_editor/diary_note_editor_sheet.dart';
import 'package:iced26/presentation/features/diary/viewmodel/diary_viewmodel.dart';

const _kFabLabel = 'Add note';
const _kFabHeroTag = 'diary_add_note';

/// FAB para añadir una nueva nota en la fecha seleccionada.
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
        heroTag: _kFabHeroTag,
        onPressed: () => DiaryNoteEditorSheet.show(context, date: selectedDate),
        icon: const Icon(AppIcons.editNote),
        label: const Text(_kFabLabel),
      ),
    );
  }
}
