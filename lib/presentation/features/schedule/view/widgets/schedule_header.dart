import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/schedule_category_filter_bar.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/schedule_day_tab_bar.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/schedule_top_tab_bar.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';

const double _kFilterIconSize = 12.0;

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
          child: ScheduleTopTabBar(
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
                : ScheduleDayTabBar(
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

/// Etiqueta que reemplaza el selector de días cuando hay un filtro activo.
/// Muestra "All days · [categoría]" para que el usuario sepa qué está filtrando.
class _ViewingAllDaysLabel extends StatelessWidget {
  const _ViewingAllDaysLabel({required this.category});

  final EventType category;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          '${l10n.scheduleAllDays} · ${category.label}',
          style: theme.textTheme.labelSmall?.copyWith(color: colors.outline),
        ),
      ],
    );
  }
}
