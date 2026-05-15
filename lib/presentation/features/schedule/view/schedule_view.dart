import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/widgets/app_async_value_widget.dart';
import 'package:iced26/presentation/features/my_schedule/view/my_schedule_view.dart';
import 'package:iced26/presentation/features/my_schedule/viewmodel/my_schedule_viewmodel.dart';
import 'package:iced26/presentation/features/schedule/view/schedule_category_filter_bar.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_card.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/session_slot_block.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/shared/widgets/app_empty_state.dart';
import 'package:iced26/presentation/shared/widgets/app_page.dart';

// TODO: Revisar _ScheduleHeader codigo con muchos tabs

const _kScheduleTitle = 'Schedule';

/// Vista principal del schedule.
class ScheduleView extends ConsumerWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleStateAsync = ref.watch(scheduleViewModelProvider);
    return AppAsyncValueWidget(
      asyncValue: scheduleStateAsync,
      data: (state) => _ScheduleContent(state: state),
    );
  }
}

/// Orquestador del schedule. Gestiona el TabController y decide
/// si mostrar el timeline o MySchedule.
class _ScheduleContent extends ConsumerStatefulWidget {
  const _ScheduleContent({required this.state});

  final ScheduleState state;

  @override
  ConsumerState<_ScheduleContent> createState() => _ScheduleContentState();
}

/// Estado del schedule content.
class _ScheduleContentState extends ConsumerState<_ScheduleContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.state.sections.length,
      vsync: this,
      initialIndex: ref.read(safeDayIndexProvider),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMySchedule =
        ref.watch(scheduleTopTabProvider) == ScheduleTab.mySchedule;

    // Sincroniza el tab cuando el día cambia externamente al TabBar
    ref.listen(safeDayIndexProvider, (_, next) {
      if (_tabController.index != next) {
        _tabController.animateTo(next);
      }
    });

    final header = _ScheduleHeader(
      tabController: _tabController,
      categories: widget.state.categories,
      sections: widget.state.sections,
    );

    if (isMySchedule) {
      return _MyScheduleTab(header: header);
    }

    return AppPage(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      header: header,
      children: [
        const SizedBox(height: AppSpacing.m),
        const _ScheduleBody(),
      ],
    );
  }
}

/// Tab de My Schedule dentro del Schedule. Gestiona el estado async y decide
/// entre [AppPage.fillChild] (loading/error/vacío) y [AppPage.children] (con datos)
/// para que los estados vacíos queden centrados verticalmente.
class _MyScheduleTab extends ConsumerWidget {
  const _MyScheduleTab({required this.header});

  final Widget header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncItems = ref.watch(myScheduleGroupedProvider);

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
              size: 48,
              color: theme.colorScheme.error,
            ),
            title: 'Could not load your schedule',
            message: 'Something went wrong. Please try again.',
            actionButton: TextButton(
              onPressed: () => ref.invalidate(myScheduleItemsProvider),
              child: const Text('Retry'),
            ),
          ),
        ),
      );
    }

    final items = asyncItems.value ?? const [];

    if (items.isEmpty) {
      return AppPage(
        header: header,
        fillChild: Center(
          child: AppEmptyState(
            illustration: Icon(
              AppIcons.bookmarkOff,
              size: 48,
              color: theme.colorScheme.outlineVariant,
            ),
            title: 'Nothing saved yet',
            message: 'Bookmark sessions and talks to build your schedule',
          ),
        ),
      );
    }

    return AppPage(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      header: header,
      children: [
        const SizedBox(height: AppSpacing.m),
        MyScheduleContent(items: items),
      ],
    );
  }
}

/// Cuerpo del schedule — lee sus propios providers.
class _ScheduleBody extends ConsumerWidget {
  const _ScheduleBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleItems = ref.watch(visibleItemsProvider);
    final isFiltered = ref.watch(
      selectedScheduleCategoryProvider.select((cat) => cat != null),
    );

    if (visibleItems.isEmpty && isFiltered) {
      return const _EmptyScheduleFilter();
    }
    return Column(children: visibleItems.map(_buildItem).toList());
  }

  static Widget _buildItem(ScheduleItem item) {
    return switch (item) {
      SingleEventItem(:final event) => EventCard(event: event),
      SessionSlotItem() => SessionSlotBlock(item: item),
      DaySeparatorItem(:final date) => _DaySeparator(date: date),
    };
  }
}

/// Separador de días.
class _DaySeparator extends StatelessWidget {
  const _DaySeparator({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l, bottom: AppSpacing.s),
      child: Row(
        children: [
          Text(
            DateHelper.formatShortDate(date),
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

/// Header del schedule — lee su propio estado de providers.
class _ScheduleHeader extends ConsumerWidget {
  const _ScheduleHeader({
    required this.tabController,
    required this.categories,
    required this.sections,
  });

  final TabController tabController;
  final List<EventType> categories;
  final List<ScheduleDaySection> sections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final topTab = ref.watch(scheduleTopTabProvider);
    final selectedCategory = ref.watch(selectedScheduleCategoryProvider);
    final isFiltered = selectedCategory != null;
    final isMySchedule = topTab == ScheduleTab.mySchedule;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: _TopTabBar(
            selected: topTab,
            onSelect: (tab) =>
                ref.read(scheduleTopTabProvider.notifier).select(tab),
          ),
        ),
        if (!isMySchedule) ...[
          if (sections.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: isFiltered
                  ? Row(
                      children: [
                        Icon(
                          AppIcons.calendarOutline,
                          size: 12,
                          color: colors.outline,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Viewing all days',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.outline,
                          ),
                        ),
                      ],
                    )
                  : TabBar(
                      controller: tabController,
                      onTap: (index) => ref
                          .read(selectedDayIndexProvider.notifier)
                          .set(index),
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.zero,
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colors.primary,
                      ),
                      unselectedLabelStyle: theme.textTheme.bodyMedium
                          ?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: colors.onSurfaceVariant,
                          ),
                      tabs: sections
                          .map(
                            (s) =>
                                Tab(text: DateHelper.formatShortDate(s.date)),
                          )
                          .toList(),
                    ),
            ),
          ],
          if (categories.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            ScheduleCategoryFilterBar(
              categories: categories,
              selected: selectedCategory,
              onSelect: (cat) => ref
                  .read(selectedScheduleCategoryProvider.notifier)
                  .select(cat),
            ),
          ],
        ],
      ],
    );
  }
}

/// Tap bar superior Schedule / My Schedule.
class _TopTabBar extends StatelessWidget {
  final ScheduleTab selected;
  final ValueChanged<ScheduleTab> onSelect;

  const _TopTabBar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: _TopTab(
            label: _kScheduleTitle,
            isSelected: selected == ScheduleTab.timeline,
            onTap: () => onSelect(ScheduleTab.timeline),
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Flexible(
          child: _TopTab(
            label: 'My Schedule',
            isSelected: selected == ScheduleTab.mySchedule,
            onTap: () => onSelect(ScheduleTab.mySchedule),
          ),
        ),
      ],
    );
  }
}

/// Estado vacío del schedule cuando se aplica un filtro.
class _EmptyScheduleFilter extends StatelessWidget {
  const _EmptyScheduleFilter();

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      illustration: Icon(
        AppIcons.searchOff,
        size: 48,
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
      title: 'No sessions match your filters',
      message: 'Try a different category or clear the filter',
    );
  }
}

/// Tab individual de la barra superior.
class _TopTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TopTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isSelected ? colors.onSurface : colors.outline,
          ),
        ),
      ),
    );
  }
}
