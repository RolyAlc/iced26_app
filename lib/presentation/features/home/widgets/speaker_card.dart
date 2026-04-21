import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/widgets/app_card.dart';
import 'package:iced26/presentation/widgets/app_network_image.dart';

/// Tarjeta de keynote speaker — diseño poster (foto grande + texto debajo).
class SpeakerCard extends StatelessWidget {
  const SpeakerCard({super.key, required this.speaker, required this.onTap});

  final KeynoteSpeakerUIModel speaker;
  final VoidCallback onTap;

  /// Fracción del ancho disponible que ocupa cada tarjeta.
  static const double widthFactor = 0.44;

  /// Relación ancho/alto total de la tarjeta.
  static const double aspectRatio = 3 / 4;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      borderRadius: AppRadius.m,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Foto — ocupa ~65% de la altura total
          Expanded(
            flex: 65,
            child: AppNetworkImage(
              url: speaker.photoUrl ?? '',
              fit: BoxFit.cover,
              placeholder: ColoredBox(
                color: colors.surfaceContainerHighest,
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),

          // Texto — ocupa ~35%
          Expanded(
            flex: 35,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.s,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    speaker.name,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (speaker.institution != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      speaker.institution!,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
