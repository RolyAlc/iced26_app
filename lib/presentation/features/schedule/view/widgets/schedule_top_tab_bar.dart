import 'package:flutter/material.dart';

import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';

const double _kTabIndicatorHeight = 3.0;

/// Fila de tabs "Schedule / My Schedule" con indicador underline animado.
class ScheduleTopTabBar extends StatelessWidget {
  const ScheduleTopTabBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final ScheduleTab selected;
  final ValueChanged<ScheduleTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ScheduleTopTab(
          label: AppStrings.scheduleTitle,
          isSelected: selected == ScheduleTab.timeline,
          onTap: () {
            onSelect(ScheduleTab.timeline);
          },
        ),
        const SizedBox(width: AppSpacing.l),
        _ScheduleTopTab(
          label: AppStrings.myScheduleTitle,
          isSelected: selected == ScheduleTab.mySchedule,
          onTap: () {
            onSelect(ScheduleTab.mySchedule);
          },
        ),
      ],
    );
  }
}

/// Tab individual con texto headline y underline animado.
///
/// IntrinsicWidth acota el ancho al del Text para que CrossAxisAlignment.stretch
/// pueda estirar el AnimatedContainer al mismo ancho sin recibir constraints infinitos.
class _ScheduleTopTab extends StatelessWidget {
  const _ScheduleTopTab({
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
    final textColor = isSelected ? colors.onSurface : colors.onSurfaceVariant;
    final indicatorColor = isSelected ? colors.primary : Colors.transparent;

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
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              _buildIndicator(indicatorColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(Color color) {
    return AnimatedContainer(
      duration: AppDuration.fast,
      curve: Curves.easeInOut,
      height: _kTabIndicatorHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(_kTabIndicatorHeight / 2),
      ),
    );
  }
}
