import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/my_schedule_item.dart';
import 'package:iced26/presentation/features/my_schedule/view/widgets/saved_presentation_card.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_card.dart';
import 'package:iced26/presentation/widgets/app_page.dart';

/// Vista standalone de My Schedule (con AppPage propio).
/// Usada cuando My Schedule ocupa una pantalla completa.
class MyScheduleView extends ConsumerWidget {
  const MyScheduleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPage(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      header: _MyScheduleHeader(),
      children: [
        const SizedBox(height: AppSpacing.m),
        const MyScheduleContent(),
      ],
    );
  }
}

/// Contenido de My Schedule sin AppPage — para embeber dentro de otra pantalla.
class MyScheduleContent extends ConsumerWidget {
  const MyScheduleContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(myScheduleItemsProvider);

    return asyncItems.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (items) => items.isEmpty
          ? const _EmptyMySchedule()
          : Column(children: items.map(_buildItem).toList()),
    );
  }
}

/// Construye un widget basado en el tipo de item de My Schedule.
Widget _buildItem(MyScheduleItem item) {
  return switch (item) {
    SavedEventItem(:final event) => EventCard(event: event),
    SavedPresentationItem(:final presentation) => SavedPresentationCard(
      presentation: presentation,
    ),
  };
}

/// Cabecera de My Schedule.
class _MyScheduleHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: Text(
        'My Schedule',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Estado cuando My Schedule está vacío.
class _EmptyMySchedule extends StatelessWidget {
  const _EmptyMySchedule();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border,
            size: 48,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            'Nothing saved yet',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Bookmark sessions and talks to build your schedule',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
