import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

const _kActionsColumnWidth = 44.0;
const _kActionMinSize = 40.0;

/// Variante de color para [ScheduleInfoChip].
enum ScheduleChipVariant { secondary, tertiary, primary }

/// Tamaño visual para [ScheduleInfoChip].
enum ScheduleChipSize { small, medium }

/// Layout base compartido por las cards de agenda (EventCard, SessionSlotBlock,
/// SavedPresentationCard).
class ScheduleCardRow extends StatelessWidget {
  const ScheduleCardRow({
    super.key,
    required this.title,
    required this.bottomAction,
    this.topAction,
    this.infoBadges = const [],
    this.time,
    this.isLive = false,
  });

  final String title;
  final List<Widget> infoBadges;
  final String? time;
  final bool isLive;
  final Widget? topAction;
  final Widget bottomAction;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _CardContentColumn(
                time: time,
                isLive: isLive,
                title: title,
                infoBadges: infoBadges,
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            _CardActionsColumn(
              topAction: topAction,
              bottomAction: bottomAction,
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip informativo reutilizable para las cards de agenda.
class ScheduleInfoChip extends StatelessWidget {
  const ScheduleInfoChip({
    super.key,
    required this.label,
    this.icon,
    this.variant = ScheduleChipVariant.secondary,
    this.size = ScheduleChipSize.small,
  });

  final String label;
  final IconData? icon;
  final ScheduleChipVariant variant;
  final ScheduleChipSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bgColor = switch (variant) {
      ScheduleChipVariant.secondary => colors.secondaryContainer,
      ScheduleChipVariant.tertiary => colors.tertiaryContainer,
      ScheduleChipVariant.primary => colors.primaryContainer,
    };
    final fgColor = switch (variant) {
      ScheduleChipVariant.secondary => colors.onSecondaryContainer,
      ScheduleChipVariant.tertiary => colors.onTertiaryContainer,
      ScheduleChipVariant.primary => colors.onPrimaryContainer,
    };
    final textStyle = switch (size) {
      ScheduleChipSize.small => theme.textTheme.labelSmall,
      ScheduleChipSize.medium => theme.textTheme.labelMedium,
    };
    final iconSize = switch (size) {
      ScheduleChipSize.small => AppTextSize.chip,
      ScheduleChipSize.medium => 14.0,
    };
    final hPadding = switch (size) {
      ScheduleChipSize.small => AppSpacing.s,
      ScheduleChipSize.medium => AppSpacing.sm,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: fgColor),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle?.copyWith(
                color: fgColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Columna izquierda expandida: hora, título y chips informativos.
class _CardContentColumn extends StatelessWidget {
  const _CardContentColumn({
    required this.title,
    required this.infoBadges,
    required this.isLive,
    this.time,
  });

  final String title;
  final List<Widget> infoBadges;
  final bool isLive;
  final String? time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (time != null) ...[
          _TimeBadge(time: time!, isLive: isLive),
          const SizedBox(height: AppSpacing.s),
        ],
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (infoBadges.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.xs,
            children: infoBadges,
          ),
        ],
      ],
    );
  }
}

/// Columna derecha de ancho fijo: acción superior e inferior.
class _CardActionsColumn extends StatelessWidget {
  const _CardActionsColumn({required this.bottomAction, this.topAction});

  final Widget? topAction;
  final Widget bottomAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kActionsColumnWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(child: topAction ?? const SizedBox(height: _kActionMinSize)),
          Center(child: bottomAction),
        ],
      ),
    );
  }
}

/// Badge para la hora.
class _TimeBadge extends StatelessWidget {
  const _TimeBadge({required this.time, required this.isLive});
  final String time;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final color = isLive ? colors.primary : colors.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppIcons.time, size: 14, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          time,
          style: theme.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: isLive ? FontWeight.bold : FontWeight.w600,
            letterSpacing: AppTextStyle.timeLetterSpacing,
          ),
        ),
      ],
    );
  }
}
