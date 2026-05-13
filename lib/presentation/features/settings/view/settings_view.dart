import 'package:flutter/material.dart';
import 'package:iced26/presentation/features/settings/widgets/data_items.dart';
import 'package:iced26/presentation/features/settings/widgets/settings_section.dart';
import 'package:iced26/presentation/features/settings/widgets/text_size_item.dart';
import 'package:iced26/presentation/features/settings/widgets/theme_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/widgets/app_page.dart';

/// Vista de ajustes de la app.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      header: _SettingsHeader(),
      children: [
        SettingsSection(
          title: 'Appearance',
          items: [TextSizeItem(), ThemeItem()],
        ),
        const SizedBox(height: AppSpacing.m),
        SettingsSection(
          title: 'Language',
          items: [
            SettingsItem(
              icon: AppIcons.translate,
              title: 'App language',
              subtitle: 'English',
              trailing: ComingSoonBadge(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        SettingsSection(
          title: 'Data',
          items: [ReloadDataItem(), ClearFavouritesItem()],
        ),
        const SizedBox(height: AppSpacing.m),
        SettingsSection(
          title: 'About',
          items: [
            SettingsItem(
              icon: AppIcons.info,
              title: 'ICED 26',
              subtitle: 'Salamanca, Spain',
            ),
            SettingsItem(
              icon: AppIcons.smartphone,
              title: 'Version',
              subtitle: '—',
            ),
            SettingsItem(
              icon: AppIcons.language,
              title: 'Official website',
              subtitle: 'iced26.es',
              onTap: () {
                launchUrl(
                  Uri.parse('https://iced26.es'),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// Cabecera de la pantalla de ajustes.
class _SettingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.xl,
        AppSpacing.l,
        AppSpacing.m,
      ),
      child: Text(
        'Settings',
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
