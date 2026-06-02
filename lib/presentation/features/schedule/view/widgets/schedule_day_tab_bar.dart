import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
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
    this.compact = false,
  });

  final TabController tabController;
  final List<ScheduleDaySection> sections;
  final ValueChanged<int> onDaySelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactChips();
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final firstDate = sections.isNotEmpty
        ? DateTime.tryParse(sections.first.date)
        : null;
    final monthLabel = firstDate != null
        ? DateHelper.monthFull(firstDate, l10n.localeName)
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
            _buildMonthHeader(colors, theme.textTheme, monthLabel),
            const SizedBox(height: AppSpacing.xs),
            _buildTabRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactChips() {
    return ListenableBuilder(
      listenable: tabController,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < sections.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.xs),
              _CompactDayChip(
                date: DateTime.tryParse(sections[i].date) ?? DateTime.now(),
                isSelected: tabController.index == i,
                onTap: () {
                  tabController.index = i;
                  onDaySelected(i);
                },
              ),
            ],
          ],
        );
      },
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

/// Chip compacto de día para layout landscape: muestra "Lun 9" en una línea.
class _CompactDayChip extends StatelessWidget {
  const _CompactDayChip({
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
    final l10n = AppLocalizations.of(context)!;
    final isToday = DateHelper.isSameDay(date, DateTime.now());
    final label =
        '${DateHelper.weekdayShort(date, l10n.localeName)} ${date.day}';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isSelected ? colors.secondaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.s),
        border: isToday && !isSelected
            ? Border.all(color: colors.primary.withValues(alpha: 0.5))
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.s),
        splashColor: colors.onSecondaryContainer.withValues(alpha: 0.12),
        highlightColor: colors.onSecondaryContainer.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.s,
          ),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected ? colors.primary : colors.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
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
    final l10n = AppLocalizations.of(context)!;
    final isToday = DateHelper.isSameDay(date, DateTime.now());
    final labelColor = isSelected ? colors.primary : colors.onSurfaceVariant;
    final backgroundColor = isSelected
        ? colors.secondaryContainer
        : colors.secondaryContainer.withValues(alpha: 0.0);

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
                DateHelper.weekdayShort(date, l10n.localeName),
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
    final circleColor = isToday
        ? colors.primaryContainer
        : colors.primaryContainer.withValues(alpha: 0.0);
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
