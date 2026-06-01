import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_card.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/schedule_agenda_view.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/session_slot_block.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/shared/widgets/app_empty_state.dart';

/// Cuerpo del schedule — lee sus propios providers.
class ScheduleTimelineBody extends ConsumerWidget {
  const ScheduleTimelineBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleItems = ref.watch(visibleItemsProvider);
    final isFiltered = ref.watch(
      selectedScheduleCategoryProvider.select((cat) => cat != null),
    );
    final viewFormat = ref.watch(selectedScheduleViewFormatProvider);

    if (visibleItems.isEmpty && isFiltered) {
      return const _EmptyScheduleFilter();
    }

    if (viewFormat == ScheduleViewFormat.agenda) {
      return ScheduleAgendaView(items: visibleItems);
    }

    return Column(children: visibleItems.map(_buildScheduleItem).toList());
  }
}

Widget _buildScheduleItem(ScheduleItem item) {
  return switch (item) {
    SingleEventItem(:final event) => EventCard(event: event),
    SessionSlotItem() => SessionSlotBlock(item: item),
    DaySeparatorItem(:final date) => _DaySeparator(date: date),
  };
}

/// Estado vacío del schedule cuando se aplica un filtro.
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

/// Separador de días.
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
