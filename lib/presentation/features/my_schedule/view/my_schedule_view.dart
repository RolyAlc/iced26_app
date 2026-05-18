import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/my_schedule_item.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/my_schedule/view/widgets/saved_presentation_card.dart';
import 'package:iced26/presentation/features/my_schedule/viewmodel/models/my_schedule_display_item.dart';
import 'package:iced26/presentation/features/my_schedule/viewmodel/my_schedule_viewmodel.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_card.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/shared/widgets/app_empty_state.dart';
import 'package:iced26/presentation/shared/widgets/app_page.dart';

const _kUnscheduled = 'Unscheduled';

// TODO: Gestionar los if

/// Pantalla completa de My Schedule. Envuelve [MyScheduleContent] con su propio
/// [AppPage] para poder usarse como destino de navegación independiente.
class MyScheduleView extends ConsumerWidget {
  const MyScheduleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncItems = ref.watch(myScheduleGroupedProvider);
    final items = asyncItems.asData?.value;
    final hasItems = items != null && items.isNotEmpty;

    if (asyncItems.isLoading) {
      return AppPage(
        header: const _MyScheduleHeader(),
        fillChild: const Center(child: CircularProgressIndicator()),
      );
    }

    if (asyncItems.hasError) {
      return AppPage(
        header: const _MyScheduleHeader(),
        fillChild: Center(
          child: AppEmptyState(
            illustration: Icon(
              AppIcons.error,
              size: 48,
              color: theme.colorScheme.error,
            ),
            title: AppStrings.myScheduleErrorTitle,
            message: AppStrings.genericErrorMessage,
            actionButton: TextButton(
              onPressed: () => ref.invalidate(myScheduleItemsProvider),
              child: const Text(AppStrings.retry),
            ),
          ),
        ),
      );
    }

    if (!hasItems) {
      return AppPage(
        header: const _MyScheduleHeader(),
        fillChild: Center(
          child: AppEmptyState(
            illustration: Icon(
              AppIcons.bookmarkOff,
              size: 48,
              color: theme.colorScheme.outlineVariant,
            ),
            title: AppStrings.myScheduleNothingSavedTitle,
            message: AppStrings.myScheduleNothingSavedMessage,
          ),
        ),
      );
    }

    final totalCount = items.whereType<MyScheduleRow>().length;

    return AppPage(
      header: _MyScheduleHeader(count: totalCount),
      children: [
        const SizedBox(height: AppSpacing.m),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppLayout.horizontalPadding(context),
          ),
          child: MyScheduleContent(items: items),
        ),
      ],
    );
  }
}

/// Lista de items guardados sin [AppPage] propio, para embeber en otras pantallas.
class MyScheduleContent extends StatelessWidget {
  const MyScheduleContent({super.key, required this.items});

  final List<MyScheduleDisplayItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(children: items.map(_buildDisplayItem).toList());
  }
}

Widget _buildDisplayItem(MyScheduleDisplayItem displayItem) {
  return switch (displayItem) {
    MyScheduleDayHeader() => _MyScheduleDayHeader(header: displayItem),
    MyScheduleRow(:final item) => _buildScheduleItem(item),
  };
}

Widget _buildScheduleItem(MyScheduleItem item) {
  return switch (item) {
    SavedEventItem(:final event) => EventCard(event: event),
    SavedPresentationItem(:final presentation) => SavedPresentationCard(
      presentation: presentation,
    ),
  };
}

/// Header de sección de un día dentro de [MyScheduleContent].
class _MyScheduleDayHeader extends StatelessWidget {
  const _MyScheduleDayHeader({required this.header});

  final MyScheduleDayHeader header;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = header.date != null
        ? DateHelper.formatDayLabel(header.date!)
        : _kUnscheduled;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l, bottom: AppSpacing.s),
      child: Row(
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '· ${header.count}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Divider(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header general de la pantalla [MyScheduleView].
class _MyScheduleHeader extends StatelessWidget {
  const _MyScheduleHeader({this.count});

  final int? count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = count != null
        ? '${AppStrings.myScheduleTitle} ($count)'
        : AppStrings.myScheduleTitle;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding(context),
      ),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
