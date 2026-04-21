import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/view/sheets/speaker_detail_sheet.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/widgets/speaker_card.dart';

/// Sección de keynote speakers — carrusel horizontal de portrait cards.
class HomeKeynoteSection extends StatelessWidget {
  const HomeKeynoteSection({super.key, required this.speakers});

  final List<KeynoteSpeakerUIModel> speakers;

  @override
  Widget build(BuildContext context) {
    if (speakers.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * SpeakerCard.widthFactor;
        final cardHeight = cardWidth / SpeakerCard.aspectRatio;

        return SizedBox(
          height: cardHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: speakers.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.m),
            itemBuilder: (context, i) => SizedBox(
              width: cardWidth,
              child: SpeakerCard(
                speaker: speakers[i],
                onTap: () => showSpeakerDetailSheet(context, speakers[i]),
              ),
            ),
          ),
        );
      },
    );
  }
}
