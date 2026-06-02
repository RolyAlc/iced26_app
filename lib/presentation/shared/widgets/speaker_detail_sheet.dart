import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/helpers/event_sheet_router.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/shared/widgets/speaker_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

/// Sheet genérico de ponente — reutilizable desde cualquier punto de entrada de la app.
void showSpeakerDetail(BuildContext context, Person person, List<Event> talks) {
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
        if (person.email != null || person.webPage != null)
          _SpeakerLinks(email: person.email, webPage: person.webPage),
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
              if (person.country != null)
                Text(
                  person.country!,
                  style: textTheme.labelSmall?.copyWith(
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

class _SpeakerLinks extends StatelessWidget {
  const _SpeakerLinks({this.email, this.webPage});

  final String? email;
  final String? webPage;

  Future<void> _open(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.m),
      child: Wrap(
        spacing: AppSpacing.s,
        runSpacing: AppSpacing.s,
        children: [
          if (email != null)
            OutlinedButton.icon(
              onPressed: () {
                _open(Uri(scheme: 'mailto', path: email));
              },
              icon: const Icon(AppIcons.email, size: 18),
              label: const Text('Email'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.outline),
                textStyle: theme.textTheme.labelMedium,
              ),
            ),
          if (webPage != null)
            OutlinedButton.icon(
              onPressed: () {
                final uri = Uri.tryParse(webPage!);
                if (uri != null) _open(uri);
              },
              icon: const Icon(AppIcons.language, size: 18),
              label: const Text('Website'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.outline),
                textStyle: theme.textTheme.labelMedium,
              ),
            ),
        ],
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
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final headerLabel = talks.length > 1
        ? l10n.speakerDetailPresentationsHeaderCount(talks.length)
        : l10n.speakerDetailPresentationsLabel;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerLabel,
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
        showEventSheet(context, talk);
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
