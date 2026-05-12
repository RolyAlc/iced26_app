import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/app/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/session_ui_model.dart';
import 'package:iced26/presentation/helpers/event_type_style.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/presentation_detail_sheet.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SpeakerImage(photoUrl: speaker.photoUrl),
        _SpeakerInstitution(institution: speaker.institution),
        _SpeakerSessions(events: speaker.events),
        if (speaker.presentation != null)
          _PresentationRow(presentation: speaker.presentation!),
      ],
    );
  }
}

/// Imagen del keynote speaker
class _SpeakerImage extends StatelessWidget {
  final String? photoUrl;

  const _SpeakerImage({this.photoUrl});

  @override
  Widget build(BuildContext context) {
    if (photoUrl == null) {
      return const SizedBox();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.m),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: AppNetworkImage(
          url: photoUrl!,
          fit: BoxFit.cover,
          placeholder: ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Center(child: Icon(AppIcons.person, size: 64)),
          ),
        ),
      ),
    );
  }
}

/// Institución del keynote speaker
class _SpeakerInstitution extends StatelessWidget {
  final String? institution;

  const _SpeakerInstitution({this.institution});

  @override
  Widget build(BuildContext context) {
    if (institution == null) {
      return const SizedBox();
    }

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.m),
      child: Row(
        children: [
          Icon(AppIcons.business, size: 16, color: colors.onSurfaceVariant),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              institution!,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sesiones del keynote speaker
class _SpeakerSessions extends StatelessWidget {
  final List<SessionUIModel> events;

  const _SpeakerSessions({required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox();
    }

    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sessions',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s),
          ...events.map((session) => _SessionRow(session: session)),
        ],
      ),
    );
  }
}

/// Fila tappable que abre el detalle completo de la presentación del speaker.
class _PresentationRow extends StatelessWidget {
  final Presentation presentation;

  const _PresentationRow({required this.presentation});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).languageCode;
    final title =
        presentation.title?.resolve(locale) ?? presentation.externalRef ?? '—';

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Presentation',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s),
          InkWell(
            onTap: () => showPresentationDetail(context, presentation),
            borderRadius: BorderRadius.circular(AppRadius.s),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.s),
                    ),
                    child: Icon(
                      AppIcons.slideshow,
                      size: 18,
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    AppIcons.chevronRight,
                    size: 20,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fila de evento en el detalle del keynote speaker.
class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});

  final SessionUIModel session;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final style = resolveTypeStyle(context, session.type);

    return InkWell(
      onTap: () => showDetailSheet(context, session.event),
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
                    session.title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (session.formattedDateTime.isNotEmpty)
                    Text(
                      session.formattedDateTime,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              AppIcons.chevronRight,
              size: 20,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
