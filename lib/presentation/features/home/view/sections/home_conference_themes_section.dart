import 'package:flutter/material.dart';

import 'package:iced26/core/constants/app_config.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/conference_theme.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/view/pages/conference_theme_detail_page.dart';
import 'package:iced26/presentation/shared/widgets/app_button.dart';

const _kReadMore = 'Read more';
const _kSnippetLines = 2;

/// Sección de temas de la conferencia — lista vertical de cards.
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
            AppButton(
              label: _kReadMore,
              trailingIcon: AppIcons.arrowForward,
              onPressed: () =>
                  ConferenceThemeDetailPage.open(context, conferenceTheme),
            ),
          ],
        ),
      ),
    );
  }
}
