import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/view/pages/conference_theme_detail_page.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/conference_theme_ui_model.dart';
import 'package:iced26/presentation/shared/widgets/app_button.dart';

const int _kSnippetLinesNarrow = 2;
const int _kSnippetLinesWide = 3;

/// Sección de temas de la conferencia — lista vertical de cards.
class HomeConferenceThemesSection extends StatelessWidget {
  const HomeConferenceThemesSection({super.key, required this.themes});

  final List<ConferenceThemeUIModel> themes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < themes.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.m),
          _ThemeCard(theme: themes[i]),
        ],
      ],
    );
  }
}

/// Card con título, snippet de descripción y CTA "Read more".
class _ThemeCard extends StatelessWidget {
  const _ThemeCard({required this.theme});

  final ConferenceThemeUIModel theme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isWide =
        MediaQuery.sizeOf(context).width >= 600 ||
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final snippetLines = isWide ? _kSnippetLinesWide : _kSnippetLinesNarrow;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              theme.name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              theme.description,
              maxLines: snippetLines,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            AppButton(
              label: l10n.readMore,
              trailingIcon: AppIcons.arrowForward,
              onPressed: () => ConferenceThemeDetailPage.open(context, theme),
            ),
          ],
        ),
      ),
    );
  }
}
