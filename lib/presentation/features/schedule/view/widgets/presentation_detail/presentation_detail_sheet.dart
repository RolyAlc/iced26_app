import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/presentation/app/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_bookmark_button.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_detail_ui_parts.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_links_section.dart';
import 'package:iced26/presentation/features/schedule/view/widgets/presentation_detail/widgets/presentation_speaker_list.dart';
import 'package:iced26/presentation/helpers/date_helper.dart';

/// Muestra el detalle de la presentación.
void showPresentationDetail(BuildContext context, Presentation presentation) {
  AppBottomSheet.show(
    context: context,
    title: '',
    isFullHeight: true,
    child: _PresentationDetailContent(presentation: presentation),
  );
}

/// Contenido principal del detalle de la presentación.
class _PresentationDetailContent extends ConsumerWidget {
  final Presentation presentation;

  const _PresentationDetailContent({required this.presentation});

  /// externalRef como fallback si el JSON no incluye título multilingüe.
  String _resolveTitle(String locale) {
    return presentation.title?.resolve(locale) ??
        presentation.externalRef ??
        '—';
  }

  /// abstract puede ser null — campo opcional en el esquema del JSON.
  String? _resolveAbstract(String locale) {
    return presentation.abstract_?.resolve(locale);
  }

  /// bookmark en la cabecera para que sea accesible sin hacer scroll.
  Widget _buildTitle(String title, ThemeData theme) {
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
        PresentationBookmarkButton(presentationId: presentation.id),
      ],
    );
  }

  /// chips compactos para no competir visualmente con el título principal.
  Widget _buildMetadata(String timeRange) {
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

  /// sección opcional — el Divider no debe renderizarse si no hay speakers.
  Widget _buildSpeakersSection(
    Map<String, Person> people,
    Map<String, List<Presentation>> presentationsByPerson,
  ) {
    if (presentation.speakers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: AppSpacing.m),
        PresentationDivider(),
        const SizedBox(height: AppSpacing.m),
        PresentationSpeakerList(
          speakers: presentation.speakers,
          people: people,
          presentationsByPerson: presentationsByPerson,
        ),
      ],
    );
  }

  /// sección opcional — el Divider no debe renderizarse si no hay abstract.
  Widget _buildAbstractSection(String? abstract_, ThemeData theme) {
    if (abstract_ == null || abstract_.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.m),
        PresentationDivider(),
        const SizedBox(height: AppSpacing.m),

        Text(
          'Abstract',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
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

  /// tags opcionales según el JSON de la conferencia.
  Widget _buildTagsSection() {
    if (presentation.tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: AppSpacing.m),
        PresentationDivider(),
        const SizedBox(height: AppSpacing.m),

        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: presentation.tags
              .map((tag) => PresentationChip(label: '#$tag'))
              .toList(),
        ),
      ],
    );
  }

  /// links opcionales del JSON — se ocultan cuando no hay datos.
  Widget _buildLinksSection() {
    if (presentation.aboutPresentationUrl == null &&
        presentation.videoPresentationUrl == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: AppSpacing.m),
        PresentationDivider(),
        const SizedBox(height: AppSpacing.m),

        PresentationLinkButtons(
          aboutUrl: presentation.aboutPresentationUrl,
          videoUrl: presentation.videoPresentationUrl,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);

    final peopleAsync = ref.watch(allPeopleIndexProvider);
    final people = peopleAsync.value ?? {};

    final presentationsByPersonAsync = ref.watch(
      presentationsByPersonIdProvider,
    );
    final presentationsByPerson = presentationsByPersonAsync.value ?? {};

    final title = _resolveTitle(locale);
    final abstract_ = _resolveAbstract(locale);
    final timeRange = DateHelper.formatTimeRange(
      presentation.startDate,
      presentation.endDate,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(title, theme),
        const SizedBox(height: AppSpacing.s),
        _buildMetadata(timeRange),
        _buildSpeakersSection(people, presentationsByPerson),
        _buildAbstractSection(abstract_, theme),
        _buildTagsSection(),
        _buildLinksSection(),
        const SizedBox(height: AppSpacing.l),
      ],
    );
  }
}
