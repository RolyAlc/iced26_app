import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_detail_ui_parts.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_links_section.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_speaker_list.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_button.dart';

const _kSpeakersCollapseThreshold = 3;

/// Muestra el sheet de detalle de la presentación.
void showPresentationDetail(BuildContext context, Presentation presentation) {
  AppBottomSheet.show(
    context: context,
    title: '',
    isFullHeight: true,
    stickyBottom: _PresentationSaveButton(presentationId: presentation.id),
    child: _PresentationDetailContent(presentation: presentation),
  );
}

/// Contenido del sheet de detalle de la presentación.
class _PresentationDetailContent extends StatelessWidget {
  const _PresentationDetailContent({required this.presentation});
  final Presentation presentation;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final title = presentation.resolvedTitle(locale);
    final abstract_ = presentation.abstract_?.resolve(locale);
    final timeRange = DateHelper.formatTimeRange(
      presentation.startDate,
      presentation.endDate,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PresentationTitle(title: title),
        const SizedBox(height: AppSpacing.sm),
        _PresentationMetadata(presentation: presentation, timeRange: timeRange),
        if (presentation.speakers.isNotEmpty)
          _PresentationSpeakersCard(presentation: presentation),
        if (abstract_ != null && abstract_.isNotEmpty)
          _PresentationSection(
            child: _PresentationAbstractSection(abstract_: abstract_),
          ),
        if (presentation.tags.isNotEmpty)
          _PresentationSection(
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: presentation.tags
                  .map((tag) => PresentationChip(label: '#$tag'))
                  .toList(),
            ),
          ),
        if (presentation.aboutPresentationUrl != null ||
            presentation.videoPresentationUrl != null)
          _PresentationSection(
            child: PresentationLinkButtons(
              aboutUrl: presentation.aboutPresentationUrl,
              videoUrl: presentation.videoPresentationUrl,
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

// chips compactos para no competir visualmente con el título principal.
// ConsumerWidget para resolver el nombre de sala via sessionBlockId → allSessionBlocksIndex → allRoomsIndex.
class _PresentationMetadata extends ConsumerWidget {
  const _PresentationMetadata({
    required this.presentation,
    required this.timeRange,
  });
  final Presentation presentation;
  final String timeRange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final blocksIndex = ref.watch(allSessionBlocksIndexProvider).value ?? {};
    final roomsIndex = ref.watch(allRoomsIndexProvider).value ?? {};

    final block = blocksIndex[presentation.sessionBlockId];
    final roomName = block != null
        ? roomsIndex[block.roomId]?.name.resolve(locale)
        : null;

    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.xs,
      children: [
        if (presentation.track != null)
          PresentationChip(
            label: l10n.scheduleDetailTrack(presentation.track!),
            primary: true,
          ),
        if (timeRange.isNotEmpty)
          PresentationChip(label: timeRange, icon: AppIcons.time),
        if (presentation.durationMin != null)
          PresentationChip(
            label: l10n.scheduleDetailDuration(presentation.durationMin!),
            icon: AppIcons.duration,
          ),
        if (roomName != null)
          PresentationChip(label: roomName, icon: AppIcons.meetingRoom),
      ],
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
    final people = ref.watch(allPeopleIndexProvider).value ?? {};
    final presentationsByPerson =
        ref.watch(presentationsByPersonIdProvider).value ?? {};

    return PresentationSpeakerList(
      speakers: speakers,
      people: people,
      presentationsByPerson: presentationsByPerson,
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
        Text(
          abstract_,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// Card semirredondeada que agrupa los ponentes — da separación visual sin divider.
/// Se colapsa a los primeros [_kSpeakersCollapseThreshold] speakers si hay más.
class _PresentationSpeakersCard extends StatefulWidget {
  const _PresentationSpeakersCard({required this.presentation});
  final Presentation presentation;

  @override
  State<_PresentationSpeakersCard> createState() =>
      _PresentationSpeakersCardState();
}

class _PresentationSpeakersCardState extends State<_PresentationSpeakersCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final speakers = widget.presentation.speakers;
    final needsCollapse = speakers.length > _kSpeakersCollapseThreshold;
    final visibleSpeakers = needsCollapse && !_isExpanded
        ? speakers.sublist(0, _kSpeakersCollapseThreshold)
        : speakers;

    final l10n = AppLocalizations.of(context)!;
    final headerLabel = speakers.length > 1
        ? l10n.scheduleSpeakersHeaderCount(speakers.length)
        : l10n.scheduleLabelSpeakers;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.m),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.m),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
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
              size: 16,
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
  const _PresentationSaveButton({required this.presentationId});
  final String presentationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final favoriteIds = ref.watch(presentationFavoriteIdsProvider).value ?? {};
    final isSaved = favoriteIds.contains(presentationId);

    return AppButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        ref
            .read(togglePresentationFavoriteUseCaseProvider)
            .execute(presentationId);
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
