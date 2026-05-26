import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/schedule_category_filter_bar.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';

const _kFilterIconSize = 12.0;

/// Header del schedule. Recibe [topTab] del padre para evitar un watch duplicado.
class ScheduleHeader extends ConsumerWidget {
  const ScheduleHeader({
    super.key,
    required this.tabController,
    required this.categories,
    required this.sections,
    required this.topTab,
  });

  final TabController tabController;
  final List<EventType> categories;
  final List<ScheduleDaySection> sections;
  final ScheduleTab topTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedScheduleCategoryProvider);
    final isFiltered = selectedCategory != null;
    final isMySchedule = topTab == ScheduleTab.mySchedule;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppLayout.horizontalPadding(context),
          ),
          child: _TopTabBar(
            selected: topTab,
            onSelect: (tab) {
              ref.read(scheduleTopTabProvider.notifier).select(tab);
            },
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: isMySchedule
              ? const SizedBox.shrink()
              : _ScheduleSubHeader(
                  isFiltered: isFiltered,
                  sections: sections,
                  categories: categories,
                  tabController: tabController,
                  selectedCategory: selectedCategory,
                  onCategorySelect: (cat) {
                    ref
                        .read(selectedScheduleCategoryProvider.notifier)
                        .select(cat);
                  },
                ),
        ),
      ],
    );
  }
}

/// Contenido bajo el tab bar: selector de día y filtro de categoría.
class _ScheduleSubHeader extends StatelessWidget {
  const _ScheduleSubHeader({
    required this.isFiltered,
    required this.sections,
    required this.categories,
    required this.tabController,
    required this.selectedCategory,
    required this.onCategorySelect,
  });

  final bool isFiltered;
  final List<ScheduleDaySection> sections;
  final List<EventType> categories;
  final TabController tabController;
  final EventType? selectedCategory;
  final ValueChanged<EventType?> onCategorySelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sections.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppLayout.horizontalPadding(context),
            ),
            child: isFiltered
                ? const _ViewingAllDaysLabel()
                : _DayTabBar(tabController: tabController, sections: sections),
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
    );
  }
}

/// Etiqueta "Viewing all days" que aparece cuando hay un filtro de categoría activo.
class _ViewingAllDaysLabel extends StatelessWidget {
  const _ViewingAllDaysLabel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Row(
      children: [
        Icon(
          AppIcons.calendarOutline,
          size: _kFilterIconSize,
          color: colors.outline,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          AppStrings.scheduleViewingAllDays,
          style: theme.textTheme.labelSmall?.copyWith(color: colors.outline),
        ),
      ],
    );
  }
}

/// Tab bar superior Schedule / My Schedule.
class _TopTabBar extends StatelessWidget {
  const _TopTabBar({required this.selected, required this.onSelect});

  final ScheduleTab selected;
  final ValueChanged<ScheduleTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: _TopTab(
            label: AppStrings.scheduleTitle,
            isSelected: selected == ScheduleTab.timeline,
            onTap: () => onSelect(ScheduleTab.timeline),
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Flexible(
          child: _TopTab(
            label: AppStrings.myScheduleTitle,
            isSelected: selected == ScheduleTab.mySchedule,
            onTap: () => onSelect(ScheduleTab.mySchedule),
          ),
        ),
      ],
    );
  }
}

/// Fila de tabs de días.
class _DayTabBar extends ConsumerWidget {
  const _DayTabBar({required this.tabController, required this.sections});

  final TabController tabController;
  final List<ScheduleDaySection> sections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return TabBar(
      controller: tabController,
      onTap: (index) => ref.read(selectedDayIndexProvider.notifier).set(index),
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: EdgeInsets.zero,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w900,
        color: colors.primary,
      ),
      unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.normal,
        color: colors.onSurfaceVariant,
      ),
      tabs: sections
          .map((s) => Tab(text: DateHelper.formatShortDate(s.date)))
          .toList(),
    );
  }
}

/// Tab individual de la barra superior.
class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

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
