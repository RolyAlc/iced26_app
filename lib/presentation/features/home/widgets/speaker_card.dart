import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/speaker_card/speaker_card_footer.dart';
import 'package:iced26/presentation/features/home/widgets/speaker_card/speaker_card_image.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

/// Tarjeta de keynote speaker — imagen superior + footer con nombre e institución.
class SpeakerCard extends StatelessWidget {
  const SpeakerCard({super.key, required this.speaker, required this.onTap});

  final KeynoteSpeakerUIModel speaker;
  final VoidCallback onTap;

  static const double aspectRatio = 3 / 4;

  static const _imageRadius = BorderRadius.only(
    bottomLeft: Radius.circular(AppRadius.m),
    bottomRight: Radius.circular(AppRadius.m),
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final footerColor = Color.alphaBlend(
      colors.primaryContainer.withValues(alpha: 0.55),
      colors.surface,
    );

    return AppCard(
      onTap: onTap,
      color: footerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: _imageRadius,
              child: SpeakerCardImage(photoUrl: speaker.photoUrl),
            ),
          ),
          SpeakerCardFooter(speaker: speaker, color: footerColor),
        ],
      ),
    );
  }
}
