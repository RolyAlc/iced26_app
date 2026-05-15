import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/session_ui_model.dart';
import 'package:iced26/presentation/shared/helpers/event_type_style.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/event_detail_sheet.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/presentation_detail_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_network_image.dart';

const _kIconBadgeSize = 36.0;
const _kIconSize = 18.0;
const _kPlaceholderIconSize = 64.0;
const _kLabelPresentation = 'Presentation';
const _kLabelSession = 'Sessions';

/// Muestra el sheet de detalle de un keynote speaker.
void showKeynoteSpeakerDetail(
  BuildContext context,
  KeynoteSpeakerUIModel speaker,
) {
  AppBottomSheet.show(
    context: context,
    title: speaker.name,
    child: _SpeakerDetailContent(speaker: speaker),
  );
}

/// Contenido del sheet de detalle de un keynote speaker.
class _SpeakerDetailContent extends StatelessWidget {
  const _SpeakerDetailContent({required this.speaker});

  final KeynoteSpeakerUIModel speaker;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (speaker.photoUrl != null)
          _SpeakerImage(photoUrl: speaker.photoUrl!),
        if (speaker.institution != null)
          _SpeakerInstitution(institution: speaker.institution!),
        _SpeakerSessions(events: speaker.events),
        if (speaker.presentation != null)
          _PresentationRow(presentation: speaker.presentation!),
      ],
    );
  }
}

/// Imagen del keynote speaker.
class _SpeakerImage extends StatelessWidget {
  const _SpeakerImage({required this.photoUrl});

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.m),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: AppNetworkImage(
          url: photoUrl,
          fit: BoxFit.cover,
          placeholder: ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Center(
              child: Icon(AppIcons.person, size: _kPlaceholderIconSize),
            ),
          ),
        ),
      ),
    );
  }
}

/// Información de la institución del keynote speaker.
class _SpeakerInstitution extends StatelessWidget {
  const _SpeakerInstitution({required this.institution});

  final String institution;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.m),
      child: Row(
        children: [
          Icon(
            AppIcons.business,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              institution,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sección de sesiones dentro del detalle de un keynote speaker.
class _SpeakerSessions extends StatelessWidget {
  const _SpeakerSessions({required this.events});

  final List<SessionUIModel> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _kLabelSession,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s),
          ...events.map((session) => _SessionRow(session: session)),
        ],
      ),
    );
  }
}

/// Row de una presentación dentro del detalle de un keynote speaker.
class _PresentationRow extends StatelessWidget {
  const _PresentationRow({required this.presentation});

  final Presentation presentation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _kLabelPresentation,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          InkWell(
            onTap: () => showPresentationDetail(context, presentation),
            borderRadius: BorderRadius.circular(AppRadius.s),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  _IconBadge(
                    icon: AppIcons.slideshow,
                    iconColor: theme.colorScheme.onPrimaryContainer,
                    bgColor: theme.colorScheme.primaryContainer,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      presentation.resolvedTitle(locale),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    AppIcons.chevronRight,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
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

/// Row de una sesión dentro del detalle de un keynote speaker.
class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});

  final SessionUIModel session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = session.type.style(theme.colorScheme);

    return InkWell(
      onTap: () => showEventDetail(context, session.event),
      borderRadius: BorderRadius.circular(AppRadius.s),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            _IconBadge(
              icon: style.icon,
              iconColor: style.color,
              bgColor: style.color.withValues(alpha: 0.12),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (session.formattedDateTime.isNotEmpty)
                    Text(
                      session.formattedDateTime,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              AppIcons.chevronRight,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge con icono y fondo de color.
class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kIconBadgeSize,
      height: _kIconBadgeSize,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Icon(icon, size: _kIconSize, color: iconColor),
    );
  }
}
