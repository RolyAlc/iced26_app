import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';

/// Texto superpuesto en la base de la card (nombre + institución).
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
          children: [
            Text(
              speaker.name,
              style: textTheme.titleLarge?.copyWith(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (speaker.institution != null) ...[
              const SizedBox(height: 2),
              Text(
                speaker.institution!,
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
