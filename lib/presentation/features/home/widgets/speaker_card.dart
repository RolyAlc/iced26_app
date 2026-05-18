import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/speaker_card/speaker_card_content.dart';
import 'package:iced26/presentation/features/home/widgets/speaker_card/speaker_card_image.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

// TODO: Cambiar diseño¿?

/// Tarjeta de keynote speaker — foto full-bleed con overlay degradado.
class SpeakerCard extends StatelessWidget {
  const SpeakerCard({super.key, required this.speaker, required this.onTap});

  final KeynoteSpeakerUIModel speaker;
  final VoidCallback onTap;

  static const double aspectRatio = 3 / 4;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SpeakerCardImage(photoUrl: speaker.photoUrl),
          const _GradientOverlay(),
          SpeakerCardContent(speaker: speaker),
          if (speaker.isPresentingToday)
            const Positioned(
              top: AppSpacing.m,
              right: AppSpacing.m,
              child: _TodayBadge(),
            ),
        ],
      ),
    );
  }
}

/// Overlay degradado de la tarjeta de keynote speaker.
class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppOverlayColors.heroGradientStart,
            AppOverlayColors.speakerCardGradientEnd,
          ],
          stops: [0.45, 1.0],
        ),
      ),
    );
  }
}

/// Badge "Today" que aparece en la esquina superior derecha de la card
/// cuando el speaker presenta en el día de hoy.
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
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        'Today',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colors.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
