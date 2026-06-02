import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';
import 'package:iced26/domain/logic/event_formatter.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_detail_ui_parts.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_links_section.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_speaker_list.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_button.dart';
import 'package:iced26/presentation/shared/widgets/attribute_cell.dart';

const _kSpeakersCollapseThreshold = 3;

/// Muestra el sheet de detalle de la presentación.
void showPresentationDetail(BuildContext context, Event talk) {
  AppBottomSheet.show(
    context: context,
    title: '',
    isFullHeight: true,
    stickyBottom: _PresentationSaveButton(eventId: talk.id),
    child: _PresentationDetailContent(talk: talk),
  );
}

/// Contenido del sheet de detalle de la presentación.
class _PresentationDetailContent extends StatelessWidget {
  const _PresentationDetailContent({required this.talk});
  final Event talk;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final title = talk.title.resolve(locale);
    final abstract_ = talk.abstract_?.resolve(locale);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PresentationTitle(title: title),
        const SizedBox(height: AppSpacing.sm),
        _PresentationMetadata(talk: talk),
        if (talk.speakers.isNotEmpty) _PresentationSpeakersCard(talk: talk),
        if (abstract_ != null && abstract_.isNotEmpty)
          _PresentationSection(
            child: _PresentationAbstractSection(abstract_: abstract_),
          ),
        if (talk.tags.isNotEmpty)
          _PresentationSection(
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: talk.tags
                  .map((tag) => PresentationChip(label: '#$tag'))
                  .toList(),
            ),
          ),
        if (talk.aboutPresentationUrl != null ||
            talk.videoPresentationUrl != null)
          _PresentationSection(
            child: PresentationLinkButtons(
              aboutUrl: talk.aboutPresentationUrl,
              videoUrl: talk.videoPresentationUrl,
            ),
          ),
        const SizedBox(height: AppSpacing.m),
      ],
    );
  }
}

class _PresentationTitle extends StatelessWidget {
  const _PresentationTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

// ConsumerWidget para resolver sala y bloque via sessionBlockId → allSessionBlocksIndex → allRoomsIndex.
class _PresentationMetadata extends ConsumerWidget {
  const _PresentationMetadata({required this.talk});
  final Event talk;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final blocksAsync = ref.watch(allSessionBlocksIndexProvider);
    final roomsAsync = ref.watch(allRoomsIndexProvider);

    if (blocksAsync.isLoading || roomsAsync.isLoading) {
      return const SizedBox(
        height: 20,
        child: LinearProgressIndicator(minHeight: 2),
      );
    }

    final blocksIndex = blocksAsync.value ?? {};
    final roomsIndex = roomsAsync.value ?? {};
    final block = blocksIndex[talk.sessionId];
    final startDate = block?.startDate ?? talk.startDate;
    final endDate = block?.endDate ?? talk.endDate;
    final timeRange = DateHelper.formatTimeRange(startDate, endDate);
    final timeLabel = timeRange.isNotEmpty ? timeRange : EventFormatter.noTime;
    final dateLabel = startDate != null
        ? DateHelper.formatDayLabel(startDate, locale)
        : EventFormatter.noValue;
    final roomName = block != null
        ? roomsIndex[block.roomId]?.name.resolve(locale)
        : null;
    final duration = talk.durationMin != null
        ? l10n.scheduleDetailDuration(talk.durationMin!)
        : EventFormatter.noValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (talk.number != null || talk.track != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.xs,
              children: [
                if (talk.number != null)
                  PresentationChip(label: '#${talk.number!}'),
                if (talk.track != null)
                  PresentationChip(
                    label: l10n.scheduleDetailTrack(talk.track!),
                    primary: true,
                  ),
              ],
            ),
          ),
        _PresentationAttributesGrid(
          timeLabel: timeLabel,
          roomName: roomName ?? l10n.scheduleRoomTba,
          duration: duration,
          language: talk.defaultLang?.toUpperCase() ?? EventFormatter.noValue,
          dateLabel: dateLabel,
          typeLabel: talk.type.label,
        ),
      ],
    );
  }
}

class _PresentationAttributesGrid extends StatelessWidget {
  const _PresentationAttributesGrid({
    required this.timeLabel,
    required this.roomName,
    required this.duration,
    required this.language,
    required this.dateLabel,
    required this.typeLabel,
  });

  final String timeLabel;
  final String roomName;
  final String duration;
  final String language;
  final String dateLabel;
  final String typeLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final divider = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Divider(
        height: 1,
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
      ),
    );

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
                  label: l10n.scheduleAttrTime,
                  value: timeLabel,
                ),
              ),
              Expanded(
                child: AttributeCell(
                  icon: AppIcons.meetingRoom,
                  label: l10n.scheduleAttrRoom,
                  value: roomName,
                ),
              ),
            ],
          ),
          divider,
          Row(
            children: [
              Expanded(
                child: AttributeCell(
                  icon: AppIcons.duration,
                  label: l10n.scheduleAttrDuration,
                  value: duration,
                ),
              ),
              Expanded(
                child: AttributeCell(
                  icon: AppIcons.translate,
                  label: l10n.scheduleAttrLanguage,
                  value: language,
                ),
              ),
            ],
          ),
          divider,
          Row(
            children: [
              Expanded(
                child: AttributeCell(
                  icon: AppIcons.calendarToday,
                  label: l10n.scheduleAttrDate,
                  value: dateLabel,
                ),
              ),
              Expanded(
                child: AttributeCell(
                  icon: AppIcons.category,
                  label: l10n.scheduleAttrType,
                  value: typeLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Aísla los dos provider watches para que un cambio en el índice de personas
// no rebuilde el título ni los chips de metadata.
class _PresentationSpeakersSection extends ConsumerWidget {
  const _PresentationSpeakersSection({required this.speakers});
  final List<SpeakerEntry> speakers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peopleAsync = ref.watch(allPeopleIndexProvider);
    final presentationsAsync = ref.watch(presentationsByPersonIdProvider);

    if (peopleAsync.isLoading || presentationsAsync.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.m),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return PresentationSpeakerList(
      speakers: speakers,
      people: peopleAsync.value ?? {},
      presentationsByPerson: presentationsAsync.value ?? {},
    );
  }
}

/// Muestra el abstract de la presentación.
class _PresentationAbstractSection extends StatelessWidget {
  const _PresentationAbstractSection({required this.abstract_});
  final String abstract_;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.scheduleDetailAbstract,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: AppTextStyle.labelLetterSpacing,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        Html(
          data: abstract_,
          style: {
            'body': Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              fontSize: FontSize(theme.textTheme.bodyMedium?.fontSize ?? 14),
              color: theme.colorScheme.onSurfaceVariant,
              lineHeight: const LineHeight(1.5),
            ),
            'p': Style(margin: Margins.only(bottom: 8)),
          },
        ),
      ],
    );
  }
}

/// Card semirredondeada que agrupa los ponentes — da separación visual sin divider.
/// Se colapsa a los primeros [_kSpeakersCollapseThreshold] speakers si hay más.
class _PresentationSpeakersCard extends StatefulWidget {
  const _PresentationSpeakersCard({required this.talk});
  final Event talk;

  @override
  State<_PresentationSpeakersCard> createState() =>
      _PresentationSpeakersCardState();
}

class _PresentationSpeakersCardState extends State<_PresentationSpeakersCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final speakers = widget.talk.speakers;
    final needsCollapse = speakers.length > _kSpeakersCollapseThreshold;
    final visibleSpeakers = needsCollapse && !_isExpanded
        ? speakers.sublist(0, _kSpeakersCollapseThreshold)
        : speakers;
    final headerLabel = speakers.length > 1
        ? l10n.scheduleSpeakersHeaderCount(speakers.length)
        : l10n.scheduleLabelSpeakers;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: AppTextStyle.labelLetterSpacing,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          _PresentationSpeakersSection(speakers: visibleSpeakers),
          if (needsCollapse)
            _SpeakersToggleFooter(
              isExpanded: _isExpanded,
              totalCount: speakers.length,
              onToggle: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
        ],
      ),
    );
  }
}

/// Footer que alterna entre "Show all (N)" y "Show less".
class _SpeakersToggleFooter extends StatelessWidget {
  const _SpeakersToggleFooter({
    required this.isExpanded,
    required this.totalCount,
    required this.onToggle,
  });

  final bool isExpanded;
  final int totalCount;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(AppRadius.s),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isExpanded
                  ? l10n.scheduleDetailShowLess
                  : l10n.scheduleDetailShowAll(totalCount),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              isExpanded ? AppIcons.collapse : AppIcons.expandMore,
              size: AppIconSize.inline,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Botón CTA full-width al pie del sheet — acción principal de guardar.
class _PresentationSaveButton extends ConsumerWidget {
  const _PresentationSaveButton({required this.eventId});
  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final favoriteIds = ref.watch(favoriteIdsProvider).value ?? {};
    final isSaved = favoriteIds.contains(eventId);

    return AppButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        ref.read(toggleFavoriteUseCaseProvider).execute(eventId);
      },
      icon: isSaved ? AppIcons.bookmarkOn : AppIcons.bookmarkAdd,
      label: isSaved ? l10n.scheduleButtonSaved : l10n.scheduleButtonAdd,
    );
  }
}

// Wrapper para el patrón espaciado + divider + espaciado que precede a cada
// sección opcional del detalle.
class _PresentationSection extends StatelessWidget {
  const _PresentationSection({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.m),
        const PresentationDivider(),
        const SizedBox(height: AppSpacing.m),
        child,
      ],
    );
  }
}
