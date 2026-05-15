import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_bookmark_button.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_detail_ui_parts.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_links_section.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_speaker_list.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';

const _kLabelLetterSpacing = 0.8;
const _kLabelAbstract = 'Abstract';

/// Muestra el sheet de detalle de la presentación.
void showPresentationDetail(BuildContext context, Presentation presentation) {
  AppBottomSheet.show(
    context: context,
    title: '',
    isFullHeight: true,
    child: _PresentationDetailContent(presentation: presentation),
  );
}

/// Contenido del sheet de detalle de la presentación.
class _PresentationDetailContent extends StatelessWidget {
  final Presentation presentation;

  const _PresentationDetailContent({required this.presentation});

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
        _PresentationTitle(title: title, presentationId: presentation.id),
        const SizedBox(height: AppSpacing.s),
        _PresentationMetadata(presentation: presentation, timeRange: timeRange),
        if (presentation.speakers.isNotEmpty)
          _PresentationSection(
            child: _PresentationSpeakersSection(presentation: presentation),
          ),
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
        const SizedBox(height: AppSpacing.l),
      ],
    );
  }
}

// bookmark en la cabecera para que sea accesible sin hacer scroll.
class _PresentationTitle extends StatelessWidget {
  final String title;
  final String presentationId;

  const _PresentationTitle({required this.title, required this.presentationId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        PresentationBookmarkButton(presentationId: presentationId),
      ],
    );
  }
}

// chips compactos para no competir visualmente con el título principal.
class _PresentationMetadata extends StatelessWidget {
  final Presentation presentation;
  final String timeRange;

  const _PresentationMetadata({
    required this.presentation,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.xs,
      children: [
        if (presentation.track != null)
          PresentationChip(
            label: 'Track ${presentation.track!}',
            primary: true,
          ),
        if (timeRange.isNotEmpty) PresentationChip(label: timeRange),
        if (presentation.durationMin != null)
          PresentationChip(label: '${presentation.durationMin} min'),
      ],
    );
  }
}

// Aísla los dos provider watches para que un cambio en el índice de personas
// no rebuilde el título ni los chips de metadata.
class _PresentationSpeakersSection extends ConsumerWidget {
  final Presentation presentation;

  const _PresentationSpeakersSection({required this.presentation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final people = ref.watch(allPeopleIndexProvider).value ?? {};
    final presentationsByPerson =
        ref.watch(presentationsByPersonIdProvider).value ?? {};

    return PresentationSpeakerList(
      speakers: presentation.speakers,
      people: people,
      presentationsByPerson: presentationsByPerson,
    );
  }
}

/// Muestra el abstract de la presentación.
class _PresentationAbstractSection extends StatelessWidget {
  final String abstract_;

  const _PresentationAbstractSection({required this.abstract_});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _kLabelAbstract,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: _kLabelLetterSpacing,
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

// Wrapper para el patrón espaciado + divider + espaciado que precede a cada
// sección opcional del detalle.
class _PresentationSection extends StatelessWidget {
  final Widget child;

  const _PresentationSection({required this.child});

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
