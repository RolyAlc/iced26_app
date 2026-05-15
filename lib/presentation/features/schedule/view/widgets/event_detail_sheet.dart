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
import 'package:iced26/presentation/shared/helpers/event_type_style.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_button.dart';
import 'package:iced26/presentation/shared/widgets/attribute_cell.dart';
import 'package:iced26/presentation/shared/widgets/event_status_chip.dart';
import 'package:iced26/presentation/shared/widgets/speaker_avatar.dart';
import 'package:iced26/presentation/shared/widgets/speaker_detail_sheet.dart';

/// Separador entre secciones basado en label.
const _kLabelLetterSpacing = 0.8;

void showEventDetail(BuildContext context, Event event) {
  AppBottomSheet.show(
    context: context,
    title: '',
    child: EventDetailContent(event: event),
  );
}

/// Contenido principal del detalle del evento.
class EventDetailContent extends ConsumerWidget {
  const EventDetailContent({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final status = EventStatusResolver.resolve(event);
    final duration = const EventFormatter().displayDuration(
      event.startDate,
      event.endDate,
    );
    final people = ref.watch(allPeopleIndexProvider).value ?? {};
    final presentationsByPerson =
        ref.watch(presentationsByPersonIdProvider).value ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EventTypeHeader(event: event, status: status),
        const SizedBox(height: AppSpacing.m),
        Text(
          event.title.resolve(locale),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: AppSpacing.l),
        _EventAttributesGrid(event: event, duration: duration),
        if (event.speakers.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.l),
          _SpeakerSection(
            speakers: event.speakers,
            people: people,
            presentationsByPerson: presentationsByPerson,
          ),
        ],
        const SizedBox(height: AppSpacing.l),
        _EventFavoriteButton(eventId: event.id),
      ],
    );
  }
}

/// Header del tipo de evento con su badge de estado si aplica.
class _EventTypeHeader extends StatelessWidget {
  const _EventTypeHeader({required this.event, required this.status});
  final Event event;
  final EventStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = event.type.style(theme.colorScheme);
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
}

/// Grilla de atributos del evento.
class _EventAttributesGrid extends StatelessWidget {
  const _EventAttributesGrid({required this.event, required this.duration});
  final Event event;
  final String? duration;

  @override
  Widget build(BuildContext context) {
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
                child: AttributeCell(
                  icon: AppIcons.accessTime,
                  label: 'Time',
                  value: event.filterTime ?? '--:--',
                ),
              ),
              Expanded(
                child: AttributeCell(
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
                child: AttributeCell(
                  icon: AppIcons.duration,
                  label: 'Duration',
                  value: duration ?? '--',
                ),
              ),
              Expanded(
                child: AttributeCell(
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
}

/// Botón de favorito con su propio watch — rebuilds aislados del resto del sheet.
class _EventFavoriteButton extends ConsumerWidget {
  const _EventFavoriteButton({required this.eventId});
  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(
      favoriteIdsProvider.select(
        (ids) => ids.value?.contains(eventId) ?? false,
      ),
    );
    return AppButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        ref.read(toggleFavoriteUseCaseProvider).execute(eventId);
      },
      icon: isFavorite ? AppIcons.bookmarkOn : AppIcons.bookmarkAdd,
      label: isFavorite ? 'Saved to my schedule' : 'Add to my schedule',
    );
  }
}

/// Sección de ponentes del evento.
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Speakers',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: _kLabelLetterSpacing,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        ...speakers.map(
          (s) => _SpeakerRow(
            entry: s,
            person: people[s.personId],
            presentations: presentationsByPerson[s.personId] ?? [],
          ),
        ),
      ],
    );
  }
}

/// Fila de ponente: avatar + nombre/afiliación + enlace a detalle.
class _SpeakerRow extends StatelessWidget {
  const _SpeakerRow({
    required this.entry,
    required this.person,
    required this.presentations,
  });
  final SpeakerEntry entry;
  final Person? person;
  final List<Presentation> presentations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final name = person?.name.resolve(locale) ?? entry.personId;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: InkWell(
        onTap: person != null
            ? () {
                showSpeakerDetail(context, person!, presentations);
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
                    if (person?.institution != null)
                      Text(
                        person!.institution!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (person != null)
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
  }
}
