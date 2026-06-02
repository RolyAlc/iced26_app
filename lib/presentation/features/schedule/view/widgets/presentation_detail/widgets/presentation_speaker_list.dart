import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_detail_ui_parts.dart';
import 'package:iced26/presentation/shared/widgets/speaker_avatar.dart';
import 'package:iced26/presentation/shared/widgets/speaker_detail_sheet.dart';

/// Lista de ponentes de la presentación — cada fila abre el detalle del ponente.
class PresentationSpeakerList extends StatelessWidget {
  const PresentationSpeakerList({
    super.key,
    required this.speakers,
    required this.people,
    required this.presentationsByPerson,
  });
  final List<SpeakerEntry> speakers;
  final Map<String, Person> people;
  final Map<String, List<Event>> presentationsByPerson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: speakers.map((s) {
        final person = people[s.personId];
        final name = person?.name.resolve(locale) ?? s.personId;
        final institution = person?.institution;
        final speakerPresentations = presentationsByPerson[s.personId] ?? [];
        final isPresenter = s.isPresenter == true;

        final canTap = person != null;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s),
          child: Opacity(
            opacity: canTap ? 1.0 : 0.5,
            child: InkWell(
              onTap: canTap
                  ? () {
                      showSpeakerDetail(context, person, speakerPresentations);
                    }
                  : null,
              borderRadius: BorderRadius.circular(AppRadius.s),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xs,
                  horizontal: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.s),
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
                          if (isPresenter) ...[
                            const SizedBox(height: AppSpacing.xs),
                            PresentationChip(
                              label: l10n.scheduleDetailPresenter,
                              icon: AppIcons.recordVoiceOver,
                              primary: true,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (canTap)
                      Icon(
                        AppIcons.chevronRight,
                        size: AppIconSize.inline,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
