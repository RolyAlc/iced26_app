import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';
import 'package:iced26/presentation/app/widgets/app_bottom_sheet.dart';
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

  /// Resuelve título según locale
  String _resolveTitle(String locale) {
    return presentation.title?.resolve(locale) ??
        presentation.externalRef ??
        '—';
  }

  /// Resuelve abstract
  String? _resolveAbstract(String locale) {
    return presentation.abstract_?.resolve(locale);
  }

  /// Construye el título y el botón de favorito.
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
        _PresentationBookmarkButton(presentationId: presentation.id),
      ],
    );
  }

  /// Construye los metadatos de la presentación.
  Widget _buildMetadata(String timeRange) {
    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.xs,
      children: [
        if (presentation.track != null)
          _Chip(label: 'Track ${presentation.track!}', primary: true),

        if (timeRange.isNotEmpty) _Chip(label: timeRange),

        if (presentation.durationMin != null)
          _Chip(label: '${presentation.durationMin} min'),
      ],
    );
  }

  /// Construye la sección de speakers.
  Widget _buildSpeakersSection(Map<String, Person> people) {
    if (presentation.speakers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: AppSpacing.m),
        _Divider(),
        const SizedBox(height: AppSpacing.m),
        _SpeakerList(speakers: presentation.speakers, people: people),
      ],
    );
  }

  /// Construye la sección del abstract.
  Widget _buildAbstractSection(String? abstract_, ThemeData theme) {
    if (abstract_ == null || abstract_.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.m),
        _Divider(),
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

  /// Construye la sección de tags.
  Widget _buildTagsSection() {
    if (presentation.tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: AppSpacing.m),
        _Divider(),
        const SizedBox(height: AppSpacing.m),

        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: presentation.tags
              .map((tag) => _Chip(label: '#$tag'))
              .toList(),
        ),
      ],
    );
  }

  /// Construye la sección de enlaces.
  Widget _buildLinksSection() {
    if (presentation.aboutPresentationUrl == null &&
        presentation.videoPresentationUrl == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: AppSpacing.m),
        _Divider(),
        const SizedBox(height: AppSpacing.m),

        _LinkButtons(
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

    // derivados (separación de lógica)
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
        _buildSpeakersSection(people),
        _buildAbstractSection(abstract_, theme),
        _buildTagsSection(),
        _buildLinksSection(),
        const SizedBox(height: AppSpacing.l),
      ],
    );
  }
}

/// Lista de speakers.
class _SpeakerList extends StatelessWidget {
  final List<SpeakerEntry> speakers;
  final Map<String, Person> people;

  const _SpeakerList({required this.speakers, required this.people});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Column(
      children: speakers.map((s) {
        final person = people[s.personId];
        final name = person?.name.resolve(locale) ?? s.personId;
        final institution = person?.institution;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s),
          child: Row(
            children: [
              _SpeakerAvatar(person: person, name: name),
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
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Avatar del speaker.
class _SpeakerAvatar extends StatelessWidget {
  final Person? person;
  final String name;

  const _SpeakerAvatar({required this.person, required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photoUrl = person?.photoUrl;

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: photoUrl.startsWith('assets/')
            ? AssetImage(photoUrl) as ImageProvider
            : NetworkImage(photoUrl),
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Chip reutilizable para mostrar información adicional.
class _Chip extends StatelessWidget {
  final String label;
  final bool primary;

  const _Chip({required this.label, this.primary = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: primary
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: primary
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Botones para abrir enlaces relacionados con la presentación.
class _LinkButtons extends StatelessWidget {
  final String? aboutUrl;
  final String? videoUrl;

  const _LinkButtons({this.aboutUrl, this.videoUrl});

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: [
        if (aboutUrl != null)
          OutlinedButton.icon(
            onPressed: () => _open(aboutUrl!),
            icon: Icon(Icons.description_outlined, size: 18),
            label: Text('About the presentation'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.outline),
              textStyle: theme.textTheme.labelMedium,
            ),
          ),
        if (videoUrl != null)
          OutlinedButton.icon(
            onPressed: () => _open(videoUrl!),
            icon: Icon(Icons.play_circle_outline, size: 18),
            label: Text('Watch video'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.outline),
              textStyle: theme.textTheme.labelMedium,
            ),
          ),
      ],
    );
  }
}

/// Botón para marcar como favorito.
class _PresentationBookmarkButton extends ConsumerWidget {
  final String presentationId;

  const _PresentationBookmarkButton({required this.presentationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final favoriteIds = ref.watch(presentationFavoriteIdsProvider).value ?? {};
    final isFavorite = favoriteIds.contains(presentationId);

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.bookmark : Icons.bookmark_outline,
        color: isFavorite ? colors.primary : colors.onSurfaceVariant,
        size: 22,
      ),
      onPressed: () => ref
          .read(togglePresentationFavoriteUseCaseProvider)
          .execute(presentationId),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}

/// Divisor horizontal reutilizable.
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }
}
