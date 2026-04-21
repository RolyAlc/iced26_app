import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/app/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/schedule/view/helpers/event_type_style.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';
import 'package:iced26/presentation/widgets/app_network_image.dart';

/// Abre el detalle de un keynote speaker en un bottom sheet.
void showSpeakerDetailSheet(
  BuildContext context,
  KeynoteSpeakerUIModel speaker,
) {
  AppBottomSheet.show(
    context: context,
    title: speaker.name,
    child: _SpeakerDetailContent(speaker: speaker),
  );
}

/// Contenido del detalle del keynote speaker.
class _SpeakerDetailContent extends StatelessWidget {
  const _SpeakerDetailContent({required this.speaker});

  final KeynoteSpeakerUIModel speaker;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Foto grande — aspect ratio 4:3 (banner), centrada en el rostro
        if (speaker.photoUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.m),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: AppNetworkImage(
                url: speaker.photoUrl!,
                fit: BoxFit.cover,
                placeholder: ColoredBox(
                  color: colors.surfaceContainerHighest,
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 64,
                      color: colors.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),

        if (speaker.institution != null) ...[
          const SizedBox(height: AppSpacing.m),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.business_rounded,
                size: 16,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  speaker.institution!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],

        if (speaker.events.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.l),
          Text(
            'Sessions',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s),
          ...speaker.events.map((event) => _SessionRow(event: event)),
        ],
      ],
    );
  }
}

/// Fila de evento en el detalle del keynote speaker.
class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final style = resolveTypeStyle(context, event.type);
    final locale = Localizations.localeOf(context).languageCode;

    return InkWell(
      onTap: () => showDetailSheet(context, event),
      borderRadius: BorderRadius.circular(AppRadius.s),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: style.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.s),
              ),
              child: Icon(style.icon, size: 18, color: style.color),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title.resolve(locale),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (event.filterDate != null || event.filterTime != null)
                    Text(
                      [
                        if (event.filterDate != null) event.filterDate!,
                        if (event.filterTime != null) event.filterTime!,
                      ].join(' · '),
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
