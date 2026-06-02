import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/logic/event_formatter.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_speaker_list.dart';
import 'package:iced26/presentation/shared/helpers/event_type_style.dart';
import 'package:iced26/presentation/shared/models/icon_color_style.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_button.dart';
import 'package:iced26/presentation/shared/widgets/event_attributes_card.dart';
import 'package:iced26/presentation/shared/widgets/event_status_chip.dart';

const _kTypeIconSize = 12.0;
// Espacio de letras para la etiqueta de tipo de evento (badge inline, más compacto que labelLetterSpacing).
const _kTypeBadgeLetterSpacing = 0.5;

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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
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
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.l),
        _EventAttributesGrid(event: event, duration: duration),
        if (event.speakers.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.l),
          Text(
            l10n.scheduleLabelSpeakers,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: AppTextStyle.labelLetterSpacing,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          PresentationSpeakerList(
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
        _buildTypeBadge(theme, style),
        if (status != EventStatus.ended) ...[
          const SizedBox(width: AppSpacing.s),
          EventStatusChip(status: status),
        ],
      ],
    );
  }

  Widget _buildTypeBadge(ThemeData theme, IconColorStyle style) {
    return Container(
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
          Icon(style.icon, size: _kTypeIconSize, color: style.color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            event.type.label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: style.color,
              fontWeight: FontWeight.bold,
              letterSpacing: _kTypeBadgeLetterSpacing,
            ),
          ),
        ],
      ),
    );
  }
}

/// Grilla de atributos del evento: hora, sala, duración e idioma.
class _EventAttributesGrid extends StatelessWidget {
  const _EventAttributesGrid({required this.event, required this.duration});

  final Event event;
  final String? duration;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return EventAttributesCard(
      cells: [
        AttributeCellData(
          icon: AppIcons.accessTime,
          label: l10n.scheduleAttrTime,
          value: event.filterTime ?? EventFormatter.noTime,
        ),
        AttributeCellData(
          icon: AppIcons.meetingRoom,
          label: l10n.scheduleAttrRoom,
          value: event.roomId ?? l10n.scheduleRoomTba,
        ),
        AttributeCellData(
          icon: AppIcons.duration,
          label: l10n.scheduleAttrDuration,
          value: duration ?? EventFormatter.noValue,
        ),
        AttributeCellData(
          icon: AppIcons.translate,
          label: l10n.scheduleAttrLanguage,
          value: event.defaultLang?.toUpperCase() ?? EventFormatter.noValue,
        ),
      ],
    );
  }
}

/// Botón de favorito con su propio watch — rebuilds aislados del resto del sheet.
class _EventFavoriteButton extends ConsumerWidget {
  const _EventFavoriteButton({required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
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
      label: isFavorite ? l10n.scheduleButtonSaved : l10n.scheduleButtonAdd,
    );
  }
}
