import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';
import 'package:iced26/domain/logic/event_formatter.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/app/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/helpers/event_type_style.dart';
import 'package:iced26/presentation/widgets/event_status_chip.dart';
import 'package:iced26/presentation/widgets/app_button.dart';
import 'package:iced26/presentation/widgets/speaker_avatar.dart';
import 'package:iced26/presentation/widgets/speaker_detail_sheet.dart';

/// Muestra el detalle de un evento en un bottom sheet con estética Vision 2026.
void showDetailSheet(BuildContext context, Event event) {
  AppBottomSheet.show(
    context: context,
    title: '',
    child: EventDetailContent(event: event),
  );
}

/// Contenido principal del detalle del evento.
class EventDetailContent extends ConsumerWidget {
  final Event event;
  const EventDetailContent({super.key, required this.event});

  /// duración como '0m' indica que los datos de fechas son iguales — no aporta info al usuario.
  String? _duration() {
    if (event.startDate == null || event.endDate == null) {
      return null;
    }
    final duration = const EventFormatter().formatDuration(
      event.startDate,
      event.endDate,
    );

    if (duration == '0m') {
      return null;
    }

    return duration;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final status = EventStatusResolver.resolve(event);
    final duration = _duration();
    final isFavorite = ref.watch(
      favoriteIdsProvider.select(
        (ids) => ids.value?.contains(event.id) ?? false,
      ),
    );

    final people = ref.watch(allPeopleIndexProvider).value ?? {};
    final presentationsByPerson =
        ref.watch(presentationsByPersonIdProvider).value ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTypeHeader(context, status),
        const SizedBox(height: AppSpacing.m),
        _buildTitle(context, locale),
        const SizedBox(height: AppSpacing.l),
        _buildAttributesGrid(context, duration),
        if (event.speakers.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.l),
          _SpeakerSection(
            speakers: event.speakers,
            people: people,
            presentationsByPerson: presentationsByPerson,
          ),
        ],
        const SizedBox(height: AppSpacing.l),
        _buildFavoriteButton(context, ref, isFavorite),
      ],
    );
  }

  Widget _buildTypeHeader(BuildContext context, EventStatus status) {
    final theme = Theme.of(context);
    final style = resolveTypeStyle(context, event.type);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: style.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.s),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(style.icon, size: 12, color: style.color),
              const SizedBox(width: AppSpacing.xs),
              Text(
                event.type.label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: style.color,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        if (status != EventStatus.ended) ...[
          const SizedBox(width: AppSpacing.s),
          EventStatusChip(status: status),
        ],
      ],
    );
  }

  Widget _buildTitle(BuildContext context, String locale) {
    return Text(
      event.title.resolve(locale),
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
    );
  }

  /// Grid que muestra la fecha y hora, sala, duración e idioma del evento.
  Widget _buildAttributesGrid(BuildContext context, String? duration) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _AttributeCell(
                  icon: AppIcons.accessTime,
                  label: 'Time',
                  value: event.filterTime ?? '--:--',
                ),
              ),
              Expanded(
                child: _AttributeCell(
                  icon: AppIcons.meetingRoom,
                  label: 'Room',
                  value: event.roomId ?? 'TBA',
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
            child: Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _AttributeCell(
                  icon: AppIcons.duration,
                  label: 'Duration',
                  value: duration ?? '--',
                ),
              ),
              Expanded(
                child: _AttributeCell(
                  icon: AppIcons.translate,
                  label: 'Language',
                  value: event.defaultLang?.toUpperCase() ?? '--',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton(
    BuildContext context,
    WidgetRef ref,
    bool isFavorite,
  ) {
    return AppButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        ref.read(toggleFavoriteUseCaseProvider).execute(event.id);
      },
      icon: isFavorite ? AppIcons.bookmarkOn : AppIcons.bookmarkAdd,
      label: isFavorite ? 'Saved to my schedule' : 'Add to my schedule',
    );
  }
}

/// Sección de ponentes del evento — solo visible cuando el JSON incluye speakers.
class _SpeakerSection extends StatelessWidget {
  const _SpeakerSection({
    required this.speakers,
    required this.people,
    required this.presentationsByPerson,
  });

  final List<SpeakerEntry> speakers;
  final Map<String, Person> people;
  final Map<String, List<Presentation>> presentationsByPerson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Speakers',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        ...speakers.map((s) {
          final person = people[s.personId];
          final name = person?.name.resolve(locale) ?? s.personId;
          final institution = person?.institution;
          final speakerPresentations = presentationsByPerson[s.personId] ?? [];
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
        }),
      ],
    );
  }
}

/// Celda de atributo para el Grid.
class _AttributeCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AttributeCell({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.s),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: AppSpacing.s),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
