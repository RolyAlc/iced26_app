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
const double _kDayCircleSize = 40.0;
const double _kMonthIconSize = 16.0;

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
          duration: AppDuration.fast,
          curve: Curves.easeInOut,
          child: topTab == ScheduleTab.mySchedule
              ? const SizedBox.shrink()
              : _ScheduleSubHeader(
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
    required this.sections,
    required this.categories,
    required this.tabController,
    required this.selectedCategory,
    required this.onCategorySelect,
    required this.onDaySelected,
  });

  final List<ScheduleDaySection> sections;
  final List<EventType> categories;
  final TabController tabController;
  final EventType? selectedCategory;
  final ValueChanged<EventType?> onCategorySelect;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final category = selectedCategory;
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
            child: category != null
                ? _ViewingAllDaysLabel(category: category)
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

/// Strip de días envuelto en una superficie tonal.
///
/// [Material] en lugar de [AppCard] para que los [InkWell] de cada [_DayTab]
/// puedan pintar su ripple correctamente sobre la misma superficie.
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
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final firstDate = sections.isNotEmpty
        ? DateTime.tryParse(sections.first.date)
        : null;
    final monthLabel = firstDate != null
        ? DateHelper.monthFull(firstDate)
        : '';

    return Material(
      color: colors.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(AppRadius.m),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.m,
          AppSpacing.s,
          AppSpacing.m,
          AppSpacing.s,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  AppIcons.calendarOutline,
                  size: _kMonthIconSize,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  monthLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: AppTextStyle.labelLetterSpacing,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            AnimatedBuilder(
              animation: tabController,
              builder: (context, _) {
                return Row(
                  children: [
                    for (int i = 0; i < sections.length; i++)
                      Expanded(
                        child: _DayTab(
                          date: DateTime.tryParse(sections[i].date) ??
                              DateTime.now(),
                          isSelected: tabController.index == i,
                          onTap: () {
                            tabController.animateTo(i);
                            onDaySelected(i);
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Tab individual de día: weekday, número y marcadores de selección/hoy.
///
/// Tonal Glow (primaryContainer) cuando el día es hoy — independiente de si
/// está seleccionado. Underline animado cuando está seleccionado — igual que
/// [_ScheduleTab] para mantener consistencia visual en toda la pantalla.
class _DayTab extends StatelessWidget {
  const _DayTab({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isToday = DateHelper.isSameDay(date, DateTime.now());
    final labelColor = isSelected ? colors.primary : colors.onSurfaceVariant;

    return AnimatedContainer(
      duration: AppDuration.fast,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? colors.secondaryContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.s),
        splashColor: colors.onSecondaryContainer.withValues(alpha: 0.12),
        highlightColor: colors.onSecondaryContainer.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s,
            horizontal: AppSpacing.xs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateHelper.weekdayShort(date),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AnimatedContainer(
                duration: AppDuration.fast,
                curve: Curves.easeInOut,
                width: _kDayCircleSize,
                height: _kDayCircleSize,
                decoration: BoxDecoration(
                  color: isToday
                      ? colors.primaryContainer
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isToday
                        ? (isSelected
                            ? colors.primary
                            : colors.onPrimaryContainer)
                        : labelColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
