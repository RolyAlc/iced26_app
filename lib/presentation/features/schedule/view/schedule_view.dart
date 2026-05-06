import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/app/widgets/app_async_value_widget.dart';
import 'package:iced26/presentation/features/my_schedule/view/my_schedule_view.dart';
import 'package:iced26/presentation/features/schedule/view/schedule_category_filter_bar.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_card.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/session_slot_block.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/helpers/date_helper.dart';
import 'package:iced26/presentation/widgets/app_page.dart';

// TODO: revisar

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

/// Contenido principal del schedule.
class _ScheduleContent extends ConsumerWidget {
  const _ScheduleContent({required this.state});

  final ScheduleState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topTab = ref.watch(scheduleTopTabProvider);
    final selectedCategory = ref.watch(selectedScheduleCategoryProvider);
    final visibleItems = ref.watch(visibleItemsProvider);
    final safeDayIndex = ref.watch(safeDayIndexProvider);
    final isFiltered = selectedCategory != null;
    final isMySchedule = topTab == ScheduleTab.mySchedule;

    return DefaultTabController(
      length: state.sections.length,
      initialIndex: safeDayIndex,
      child: AppPage(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
        header: _ScheduleHeader(
          topTab: topTab,
          onTopTabSelect: (tab) =>
              ref.read(scheduleTopTabProvider.notifier).select(tab),
          categories: state.categories,
          selectedCategory: selectedCategory,
          onCategorySelect: (cat) =>
              ref.read(selectedScheduleCategoryProvider.notifier).select(cat),
          sections: state.sections,
          onDaySelect: (index) =>
              ref.read(selectedDayIndexProvider.notifier).set(index),
          isFiltered: isFiltered,
          isMySchedule: isMySchedule,
        ),
        children: [
          const SizedBox(height: AppSpacing.m),
          if (isMySchedule)
            const MyScheduleContent()
          else
            _ScheduleBody(visibleItems: visibleItems, isFiltered: isFiltered),
        ],
      ),
    );
  }
}

/// Cuerpo del schedule.
class _ScheduleBody extends StatelessWidget {
  const _ScheduleBody({required this.visibleItems, required this.isFiltered});

  final List<ScheduleItem> visibleItems;
  final bool isFiltered;

  @override
  Widget build(BuildContext context) {
    if (visibleItems.isEmpty && isFiltered) {
      return const _EmptyFilter();
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

/// Texto de cabecera de la pantalla Schedule.
const _kScheduleTitle = 'Schedule';

/// Header de la pantalla Schedule.
class _ScheduleHeader extends StatelessWidget {
  const _ScheduleHeader({
    required this.topTab,
    required this.onTopTabSelect,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelect,
    required this.sections,
    required this.onDaySelect,
    required this.isFiltered,
    required this.isMySchedule,
  });

  final ScheduleTab topTab;
  final ValueChanged<ScheduleTab> onTopTabSelect;
  final List<EventType> categories;
  final EventType? selectedCategory;
  final ValueChanged<EventType?> onCategorySelect;
  final List<ScheduleDaySection> sections;
  final ValueChanged<int> onDaySelect;
  final bool isFiltered;
  final bool isMySchedule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          child: _TopTabBar(selected: topTab, onSelect: onTopTabSelect),
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
                      onTap: onDaySelect,
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
              onSelect: onCategorySelect,
            ),
          ],
        ],
      ],
    );
  }
}

/// Tap bar superior.
class _TopTabBar extends StatelessWidget {
  final ScheduleTab selected;
  final ValueChanged<ScheduleTab> onSelect;

  const _TopTabBar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        _TopTab(
          label: _kScheduleTitle,
          isSelected: selected == ScheduleTab.timeline,
          onTap: () => onSelect(ScheduleTab.timeline),
          theme: theme,
          colors: colors,
        ),
        const SizedBox(width: AppSpacing.m),
        _TopTab(
          label: 'My Schedule',
          isSelected: selected == ScheduleTab.mySchedule,
          onTap: () => onSelect(ScheduleTab.mySchedule),
          theme: theme,
          colors: colors,
        ),
      ],
    );
  }
}

/// Tap de la tap bar superior.
class _TopTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;
  final ColorScheme colors;

  const _TopTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Text(
          label,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isSelected ? colors.onSurface : colors.outline,
          ),
        ),
      ),
    );
  }
}

/// Estado cuando el schedule está vacío debido a filtros.
class _EmptyFilter extends StatelessWidget {
  const _EmptyFilter();

  @override
  Widget build(BuildContext context) => _EmptyState(
    icon: AppIcons.searchOff,
    title: 'No sessions match your filters',
    subtitle: 'Try a different category or clear the filter',
  );
}

/// Estado genérico de Schedule vacío.
class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(icon, size: 48, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: AppSpacing.m),
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
