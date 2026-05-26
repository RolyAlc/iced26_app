import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';

/// Footer de la card del keynote speaker: nombre, institución, badge y acceso al detalle.
class SpeakerCardFooter extends StatelessWidget {
  const SpeakerCardFooter({
    super.key,
    required this.speaker,
    required this.color,
  });

  final KeynoteSpeakerUIModel speaker;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return ColoredBox(
      color: color,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.m,
          AppSpacing.sm,
          AppSpacing.m,
          AppSpacing.m,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNameRow(textTheme, colors),
                  ..._buildInstitution(textTheme, colors),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            const _GoCircle(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameRow(TextTheme textTheme, ColorScheme colors) {
    return Row(
      children: [
        Expanded(
          child: Text(
            speaker.name,
            style: textTheme.titleLarge?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (speaker.isPresentingToday) ...[
          const SizedBox(width: AppSpacing.s),
          const _TodayBadge(),
        ],
      ],
    );
  }

  List<Widget> _buildInstitution(TextTheme textTheme, ColorScheme colors) {
    final institution = speaker.institution;
    if (institution == null) {
      return [];
    }

    return [
      const SizedBox(height: AppSpacing.s),
      Text(
        institution,
        style: textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }
}

/// Botón circular que indica que la card es navegable.
class _GoCircle extends StatelessWidget {
  const _GoCircle();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
      child: Icon(
        AppIcons.keyboardArrowRight,
        size: 30,
        color: colors.onPrimary,
      ),
    );
  }
}

/// Badge "Today" — indica que el speaker presenta hoy.
class _TodayBadge extends StatelessWidget {
  const _TodayBadge();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        'Today',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colors.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
