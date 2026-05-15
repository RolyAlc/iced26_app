import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_body.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_fab.dart';
import 'package:iced26/presentation/features/diary/view/widgets/diary_header.dart';
import 'package:iced26/presentation/features/diary/viewmodel/diary_viewmodel.dart';
import 'package:iced26/presentation/shared/widgets/app_empty_state.dart';
import 'package:iced26/presentation/shared/widgets/app_page.dart';

const _kErrorTitle = 'Could not load diary';
const _kErrorMessage = 'Something went wrong. Please try again.';

/// Pantalla completa de Diary. Envuelve [DiaryBody] con su propio
/// [AppPage] para poder usarse como destino de navegación independiente.
class DiaryView extends ConsumerWidget {
  const DiaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(diaryNotesProvider);
    final eventsAsync = ref.watch(diaryConferenceEventsProvider);
    final hasError = notesAsync.hasError || eventsAsync.hasError;

    if (hasError) {
      return AppPage(
        header: const DiaryHeader(),
        fillChild: Center(
          child: AppEmptyState(
            illustration: Icon(
              AppIcons.error,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            title: _kErrorTitle,
            message: _kErrorMessage,
            actionButton: TextButton(
              onPressed: () {
                ref.invalidate(diaryNotesProvider);
                ref.invalidate(diaryConferenceEventsProvider);
              },
              child: const Text('Retry'),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        AppPage(header: const DiaryHeader(), children: const [DiaryBody()]),
        const DiaryFab(),
      ],
    );
  }
}
