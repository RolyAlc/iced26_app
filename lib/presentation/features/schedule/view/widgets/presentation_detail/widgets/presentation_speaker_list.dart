import 'package:flutter/material.dart';

import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';
import 'package:iced26/presentation/shared/widgets/speaker_avatar.dart';
import 'package:iced26/presentation/shared/widgets/speaker_detail_sheet.dart';

/// Lista de ponentes de la presentación — cada fila abre el detalle del ponente.
class PresentationSpeakerList extends StatelessWidget {
  final List<SpeakerEntry> speakers;
  final Map<String, Person> people;
  final Map<String, List<Presentation>> presentationsByPerson;

  const PresentationSpeakerList({
    super.key,
    required this.speakers,
    required this.people,
    required this.presentationsByPerson,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Column(
      children: speakers.map((s) {
        final person = people[s.personId];
        final name = person?.name.resolve(locale) ?? s.personId;
        final institution = person?.institution;
        final speakerPresentations = presentationsByPerson[s.personId] ?? [];

        /// solo tappable si tenemos datos del ponente para mostrar en el detalle.
        final canTap = person != null;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s),
          child: InkWell(
            onTap: canTap
                ? () {
                    showSpeakerDetail(context, person, speakerPresentations);
                  }
                : null,
            borderRadius: BorderRadius.circular(AppRadius.s),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xs,
                horizontal: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  SpeakerAvatar(person: person, name: name),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (institution != null)
                          Text(
                            institution,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (canTap)
                    Icon(
                      AppIcons.chevronRight,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
