import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';

const double _kDayCircleSize = 40.0;
const double _kMonthIconSize = 16.0;

/// Strip de días envuelto en una superficie tonal.
///
/// [Material] en lugar de [AppCard] para que los [InkWell] de cada [_DayTab]
/// puedan pintar su ripple correctamente sobre la misma superficie.
class ScheduleDayTabBar extends StatelessWidget {
  const ScheduleDayTabBar({
    super.key,
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
    final firstDate = sections.isNotEmpty
        ? DateTime.tryParse(sections.first.date)
        : null;
    final monthLabel = firstDate != null ? DateHelper.monthFull(firstDate) : '';

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
            _buildMonthHeader(colors, theme.textTheme, monthLabel),
            const SizedBox(height: AppSpacing.xs),
            _buildTabRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader(
    ColorScheme colors,
    TextTheme textTheme,
    String monthLabel,
  ) {
    return Row(
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
          style: textTheme.labelMedium?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: AppTextStyle.labelLetterSpacing,
          ),
        ),
      ],
    );
  }

  Widget _buildTabRow() {
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, _) {
        return Row(
          children: [
            for (int i = 0; i < sections.length; i++)
              Expanded(
                child: _DayTab(
                  date: DateTime.tryParse(sections[i].date) ?? DateTime.now(),
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
    );
  }
}

/// Tab individual de día: weekday, número y marcadores de selección/hoy.
///
/// Tonal glow (primaryContainer) cuando el día es hoy — independiente de si
/// está seleccionado. Fondo secondaryContainer cuando está seleccionado.
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
    final backgroundColor = isSelected
        ? colors.secondaryContainer
        : Colors.transparent;

    return AnimatedContainer(
      duration: AppDuration.fast,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: backgroundColor,
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
              _buildDayCircle(colors, theme.textTheme, isToday, labelColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCircle(
    ColorScheme colors,
    TextTheme textTheme,
    bool isToday,
    Color labelColor,
  ) {
    final circleColor = isToday ? colors.primaryContainer : Colors.transparent;

    // Cuando es hoy: primary si está seleccionado, onPrimaryContainer si no.
    // Cuando no es hoy: labelColor (primary o onSurfaceVariant según selección).
    final dayNumberColor = isToday
        ? (isSelected ? colors.primary : colors.onPrimaryContainer)
        : labelColor;

    return AnimatedContainer(
      duration: AppDuration.fast,
      curve: Curves.easeInOut,
      width: _kDayCircleSize,
      height: _kDayCircleSize,
      decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '${date.day}',
        style: textTheme.titleLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: dayNumberColor,
        ),
      ),
    );
  }
}
