import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_card.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/session_slot_block.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/shared/widgets/app_empty_state.dart';

/// Sliver del timeline — gestiona sus propios providers.
///
/// Retorna un sliver (SliverList.builder, SliverPadding+SliverToBoxAdapter,
/// o SliverFillRemaining) para que AppPage lo inserte directamente en el
/// CustomScrollView sin romper el lazy rendering.
class ScheduleTimelineBody extends ConsumerWidget {
  const ScheduleTimelineBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(visibleItemsProvider);
    final isFiltered = ref.watch(
      selectedScheduleCategoryProvider.select((cat) => cat != null),
    );
    if (items.isEmpty && isFiltered) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyScheduleFilter(),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: AppSpacing.m),
      sliver: SliverList.builder(
        itemCount: items.length,
        itemBuilder: (_, index) => _buildItem(items[index]),
      ),
    );
  }

  Widget _buildItem(ScheduleItem item) {
    return switch (item) {
      SingleEventItem(:final event) => EventCard(event: event),
      SessionSlotItem() => SessionSlotBlock(item: item),
      DaySeparatorItem(:final date) => _DaySeparator(date: date),
    };
  }
}

class _EmptyScheduleFilter extends StatelessWidget {
  const _EmptyScheduleFilter();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppEmptyState(
      illustration: Icon(
        AppIcons.searchOff,
        size: 48,
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
      title: l10n.scheduleNoSessionsTitle,
      message: l10n.scheduleNoSessionsMessage,
    );
  }
}

class _DaySeparator extends StatelessWidget {
  const _DaySeparator({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l, bottom: AppSpacing.s),
      child: Row(
        children: [
          Text(
            DateHelper.formatShortDate(DateTime.parse(date), l10n.localeName),
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
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
