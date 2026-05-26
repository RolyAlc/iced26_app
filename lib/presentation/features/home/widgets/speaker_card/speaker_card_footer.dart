import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';

/// Footer de la card del keynote speaker: nombre, institución, badge y acceso al detalle.
class SpeakerCardFooter extends StatelessWidget {
  const SpeakerCardFooter({super.key, required this.speaker});

  final KeynoteSpeakerUIModel speaker;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                _NameRow(speaker: speaker),
                if (speaker.institution != null)
                  _InstitutionText(institution: speaker.institution!),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          const _GoCircle(),
        ],
      ),
    );
  }
}

/// Fila con el nombre del speaker y el badge "Today" si presenta hoy.
class _NameRow extends StatelessWidget {
  const _NameRow({required this.speaker});

  final KeynoteSpeakerUIModel speaker;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

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
}

/// Texto con la institución del speaker.
class _InstitutionText extends StatelessWidget {
  const _InstitutionText({required this.institution});

  final String institution;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}

/// Botón circular que indica que la card es navegable.
class _GoCircle extends StatelessWidget {
  const _GoCircle();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 48,
      height: 48,
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
