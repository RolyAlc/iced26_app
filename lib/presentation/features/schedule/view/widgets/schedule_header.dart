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

const double _kFilterIconSize = 12.0;
const double _kTabIndicatorHeight = 3.0;

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
    final horizontal = AppLayout.horizontalPadding(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: horizontal,
            right: horizontal,
            top: AppSpacing.xl,
          ),
          child: _ScheduleTabBar(
            selected: topTab,
            onSelect: (tab) {
              ref.read(scheduleTopTabProvider.notifier).select(tab);
            },
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: topTab == ScheduleTab.mySchedule
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
                  onDaySelected: (index) {
                    ref.read(selectedDayIndexProvider.notifier).set(index);
                  },
                ),
        ),
      ],
    );
  }
}

/// Fila de tabs "Schedule / My Schedule" con indicador underline animado.
class _ScheduleTabBar extends StatelessWidget {
  const _ScheduleTabBar({required this.selected, required this.onSelect});

  final ScheduleTab selected;
  final ValueChanged<ScheduleTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ScheduleTab(
          label: AppStrings.scheduleTitle,
          isSelected: selected == ScheduleTab.timeline,
          onTap: () => onSelect(ScheduleTab.timeline),
        ),
        const SizedBox(width: AppSpacing.l),
        _ScheduleTab(
          label: AppStrings.myScheduleTitle,
          isSelected: selected == ScheduleTab.mySchedule,
          onTap: () => onSelect(ScheduleTab.mySchedule),
        ),
      ],
    );
  }
}

/// Tab individual con texto headline y underline animado.
///
/// IntrinsicWidth acota el ancho al del Text para que CrossAxisAlignment.stretch
/// pueda estirar el AnimatedContainer al mismo ancho sin recibir constraints infinitos.
class _ScheduleTab extends StatelessWidget {
  const _ScheduleTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.s),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? colors.onSurface
                      : colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AnimatedContainer(
                duration: AppDuration.fast,
                curve: Curves.easeInOut,
                height: _kTabIndicatorHeight,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(_kTabIndicatorHeight / 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Contenido bajo los tabs: selector de día y filtro de categoría.
class _ScheduleSubHeader extends StatelessWidget {
  const _ScheduleSubHeader({
    required this.isFiltered,
    required this.sections,
    required this.categories,
    required this.tabController,
    required this.selectedCategory,
    required this.onCategorySelect,
    required this.onDaySelected,
  });

  final bool isFiltered;
  final List<ScheduleDaySection> sections;
  final List<EventType> categories;
  final TabController tabController;
  final EventType? selectedCategory;
  final ValueChanged<EventType?> onCategorySelect;
  final ValueChanged<int> onDaySelected;

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
                ? _ViewingAllDaysLabel(category: selectedCategory!)
                : _DayTabBar(
                    tabController: tabController,
                    sections: sections,
                    onDaySelected: onDaySelected,
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
    );
  }
}

/// Etiqueta que reemplaza el selector de días cuando hay un filtro de categoría activo.
/// Muestra "All days · [categoría]" para que el usuario sepa qué está filtrando.
class _ViewingAllDaysLabel extends StatelessWidget {
  const _ViewingAllDaysLabel({required this.category});

  final EventType category;

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
          '${AppStrings.scheduleAllDays} · ${category.label}',
          style: theme.textTheme.labelSmall?.copyWith(color: colors.outline),
        ),
      ],
    );
  }
}

/// Fila de tabs de días.
class _DayTabBar extends StatelessWidget {
  const _DayTabBar({
    required this.tabController,
    required this.sections,
    required this.onDaySelected,
  });

  final TabController tabController;
  final List<ScheduleDaySection> sections;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return TabBar(
      controller: tabController,
      onTap: onDaySelected,
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
