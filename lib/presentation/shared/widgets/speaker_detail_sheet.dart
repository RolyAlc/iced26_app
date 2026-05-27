import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/presentation_detail_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/shared/widgets/speaker_avatar.dart';

/// Sheet genérico de ponente — reutilizable desde cualquier punto de entrada de la app.
void showSpeakerDetail(
  BuildContext context,
  Person person,
  List<Event> talks,
) {
  final locale = Localizations.localeOf(context).languageCode;
  AppBottomSheet.show(
    context: context,
    title: person.name.resolve(locale),
    child: _SpeakerDetailBody(person: person, talks: talks),
  );
}

class _SpeakerDetailBody extends StatelessWidget {
  const _SpeakerDetailBody({required this.person, required this.talks});

  final Person person;
  final List<Event> talks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SpeakerHeader(person: person),
        if (person.bio != null && person.bio!.isNotEmpty)
          _SpeakerBio(bio: person.bio!),
        if (talks.isNotEmpty) _SpeakerPresentationList(talks: talks),
        const SizedBox(height: AppSpacing.l),
      ],
    );
  }
}

/// Cabecera con avatar, nombre, institución y título académico del ponente.
class _SpeakerHeader extends StatelessWidget {
  const _SpeakerHeader({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final name = person.name.resolve(locale);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        SpeakerAvatar(person: person, name: name, radius: 28),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (person.institution != null)
                Text(
                  person.institution!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              if (person.title != null)
                Text(
                  person.title!,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Bio separada del header para no saturar la cabecera cuando es larga.
class _SpeakerBio extends StatelessWidget {
  const _SpeakerBio({required this.bio});

  final String bio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.m),
      child: Text(
        bio,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
      ),
    );
  }
}

/// Lista de presentaciones del ponente — cada fila navega al detalle completo.
class _SpeakerPresentationList extends StatelessWidget {
  const _SpeakerPresentationList({required this.talks});

  final List<Event> talks;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Presentations',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s),
          ...talks.map((talk) => _PresentationRow(talk: talk)),
        ],
      ),
    );
  }
}

/// Fila tappable — abre el sheet de detalle de presentación sobre el actual.
class _PresentationRow extends StatelessWidget {
  const _PresentationRow({required this.talk});

  final Event talk;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = talk.title.resolve(locale);

    return InkWell(
      onTap: () {
        showPresentationDetail(context, talk);
      },
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
    );
  }
}
