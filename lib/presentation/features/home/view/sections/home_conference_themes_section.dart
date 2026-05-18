import 'package:flutter/material.dart';

import 'package:iced26/core/constants/app_config.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/conference_theme.dart';
import 'package:iced26/presentation/shared/widgets/app_bottom_sheet.dart';
import 'package:iced26/presentation/shared/widgets/app_button.dart';

const _kSnippetLines = 2;
const _kReadMore = 'Read more';
const _kTopicsInclude = 'Topics include';

/// Sección de temas de la conferencia — lista vertical de cards con detalle en bottom sheet.
class HomeConferenceThemesSection extends StatelessWidget {
  const HomeConferenceThemesSection({super.key, required this.themes});

  final List<ConferenceTheme> themes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < themes.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.m),
          _ThemeCard(conferenceTheme: themes[i]),
        ],
      ],
    );
  }
}

/// Card con título, snippet de descripción y CTA "Read more".
class _ThemeCard extends StatelessWidget {
  const _ThemeCard({required this.conferenceTheme});

  final ConferenceTheme conferenceTheme;

  void _openDetail(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: conferenceTheme.name.resolve(AppConfig.defaultLocale),
      child: _ThemeDetailContent(conferenceTheme: conferenceTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = conferenceTheme.name.resolve(AppConfig.defaultLocale);
    final description = conferenceTheme.description.resolve(
      AppConfig.defaultLocale,
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              description,
              maxLines: _kSnippetLines,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            AppButton(label: _kReadMore, onPressed: () => _openDetail(context)),
          ],
        ),
      ),
    );
  }
}

/// Contenido del bottom sheet — descripción completa + lista de topics.
class _ThemeDetailContent extends StatelessWidget {
  const _ThemeDetailContent({required this.conferenceTheme});

  final ConferenceTheme conferenceTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = conferenceTheme.description.resolve(
      AppConfig.defaultLocale,
    );
    final topics = conferenceTheme.topicsInclude
        .map((t) => t.resolve(AppConfig.defaultLocale))
        .where((t) => t.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
        if (topics.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.l),
          Text(
            _kTopicsInclude,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          _TopicsList(topics: topics),
        ],
      ],
    );
  }
}

/// Lista de subtemas con viñeta en color primary.
class _TopicsList extends StatelessWidget {
  const _TopicsList({required this.topics});

  final List<String> topics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final topic in topics)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    topic,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
