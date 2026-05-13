import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/speaker_card/speaker_card_content.dart';
import 'package:iced26/presentation/features/home/widgets/speaker_card/speaker_card_image.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

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
      borderRadius: AppRadius.m,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SpeakerCardImage(photoUrl: speaker.photoUrl),
          const _GradientOverlay(),
          SpeakerCardContent(speaker: speaker),
        ],
      ),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00000000), Color(0xCC000000)],
          stops: [0.45, 1.0],
        ),
      ),
    );
  }
}
