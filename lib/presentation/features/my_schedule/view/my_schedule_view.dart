import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/my_schedule_item.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/my_schedule/viewmodel/models/my_schedule_display_item.dart';
import 'package:iced26/presentation/features/my_schedule/viewmodel/my_schedule_viewmodel.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_card.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/shared/widgets/app_empty_state.dart';
import 'package:iced26/presentation/shared/widgets/app_page.dart';
import 'package:iced26/presentation/shared/widgets/app_page_title.dart';

const _kIllustrationIconSize = 48.0;

/// Pantalla completa de My Schedule. Envuelve [MyScheduleContent] con su propio
/// [AppPage] para poder usarse como destino de navegación independiente.
class MyScheduleView extends ConsumerWidget {
  const MyScheduleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final asyncItems = ref.watch(myScheduleGroupedProvider);
    final items = asyncItems.asData?.value;
    final hasItems = items != null && items.isNotEmpty;

    final totalCount = hasItems
        ? items.whereType<MyScheduleRow>().length
        : null;
    final title = totalCount != null
        ? l10n.myScheduleTitleWithCount(totalCount)
        : l10n.myScheduleTitle;
    final header = AppPageTitle(title: title);

    if (asyncItems.isLoading) {
      return AppPage(
        header: header,
        fillChild: const Center(child: CircularProgressIndicator()),
      );
    }

    if (asyncItems.hasError) {
      return AppPage(
        header: header,
        fillChild: Center(
          child: AppEmptyState(
            illustration: Icon(
              AppIcons.error,
              size: _kIllustrationIconSize,
              color: theme.colorScheme.error,
            ),
            title: l10n.myScheduleErrorTitle,
            message: l10n.genericErrorMessage,
            actionButton: TextButton(
              onPressed: () => ref.invalidate(myScheduleItemsProvider),
              child: Text(l10n.retry),
            ),
          ),
        ),
      );
    }

    if (!hasItems) {
      return AppPage(
        header: header,
        fillChild: Center(
          child: AppEmptyState(
            illustration: Icon(
              AppIcons.bookmarkOff,
              size: _kIllustrationIconSize,
              color: theme.colorScheme.outlineVariant,
            ),
            title: l10n.myScheduleNothingSavedTitle,
            message: l10n.myScheduleNothingSavedMessage,
          ),
        ),
      );
    }

    return AppPage(
      header: header,
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
///
/// [compact] elimina el top padding del primer day header — úsalo cuando no hay
/// un título de página encima y el header de la pantalla ya provee la separación.
class MyScheduleContent extends StatelessWidget {
  const MyScheduleContent({
    super.key,
    required this.items,
    this.compact = false,
  });

  final List<MyScheduleDisplayItem> items;
  final bool compact;

  Widget _buildDisplayItem(MyScheduleDisplayItem displayItem, bool isFirst) {
    return switch (displayItem) {
      MyScheduleDayHeader() => _MyScheduleDayHeader(
        header: displayItem,
        suppressTopPadding: compact && isFirst,
      ),
      MyScheduleRow(:final item) => _buildScheduleItem(item),
    };
  }

  static Widget _buildScheduleItem(MyScheduleItem item) {
    return switch (item) {
      SavedEventItem(:final event) => EventCard(event: event),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++)
          _buildDisplayItem(items[i], i == 0),
      ],
    );
  }
}

/// Header de sección de un día dentro de [MyScheduleContent].
class _MyScheduleDayHeader extends StatelessWidget {
  const _MyScheduleDayHeader({
    required this.header,
    this.suppressTopPadding = false,
  });

  final MyScheduleDayHeader header;
  final bool suppressTopPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final label = header.date != null
        ? DateHelper.formatDayLabel(header.date!, l10n.localeName)
        : l10n.myScheduleUnscheduled;

    return Padding(
      padding: EdgeInsets.only(
        top: suppressTopPadding ? AppSpacing.s : AppSpacing.l,
        bottom: AppSpacing.s,
      ),
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
