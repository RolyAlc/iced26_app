import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';

/// Texto superpuesto en la base de la card: nombre del ponente e institución.
class SpeakerCardContent extends StatelessWidget {
  const SpeakerCardContent({super.key, required this.speaker});

  final KeynoteSpeakerUIModel speaker;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildName(textTheme), ..._buildInstitution(textTheme)],
        ),
      ),
    );
  }

  Widget _buildName(TextTheme textTheme) {
    return Text(
      speaker.name,
      style: textTheme.titleLarge?.copyWith(
        color: AppOverlayColors.heroText,
        // Bold solo si el ponente presenta hoy — refuerzo visual en el día activo.
        fontWeight: speaker.isPresentingToday ? FontWeight.bold : null,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Devuelve lista vacía si no hay institución — permite usar spread en el Column.
  List<Widget> _buildInstitution(TextTheme textTheme) {
    final institution = speaker.institution;
    if (institution == null) {
      return [];
    }

    return [
      const SizedBox(height: AppSpacing.xxs),
      Text(
        institution,
        style: textTheme.labelSmall?.copyWith(
          color: AppOverlayColors.cardTextSecondary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }
}
