import 'package:flutter/material.dart';

import 'package:iced26/core/constants/app_config.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/settings/widgets/data_items.dart';
import 'package:iced26/presentation/features/settings/widgets/language_picker.dart';
import 'package:iced26/presentation/features/settings/widgets/settings_section.dart';
import 'package:iced26/presentation/features/settings/widgets/text_size_item.dart';
import 'package:iced26/presentation/features/settings/widgets/theme_picker.dart';
import 'package:iced26/presentation/shared/widgets/app_page.dart';
import 'package:iced26/presentation/shared/widgets/app_page_title.dart';
import 'package:url_launcher/url_launcher.dart';

const String _kVersionValue = '—';

/// Vista de ajustes de la app.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppPage(
      header: AppPageTitle(title: l10n.settingsTitle),
      children: [
        SettingsSection(
          title: l10n.settingsSectionAppearance,
          items: const [TextSizeItem(), ThemeItem()],
        ),
        const SizedBox(height: AppSpacing.m),
        SettingsSection(
          title: l10n.settingsSectionLanguage,
          items: const [LanguageItem()],
        ),
        const SizedBox(height: AppSpacing.m),
        SettingsSection(
          title: l10n.settingsSectionData,
          items: const [ReloadDataItem(), ClearFavouritesItem()],
        ),
        const SizedBox(height: AppSpacing.m),
        SettingsSection(
          title: l10n.settingsSectionAbout,
          items: [
            const SettingsItem(
              icon: AppIcons.info,
              title: AppConfig.edition,
              subtitle: AppConfig.location,
            ),
            SettingsItem(
              icon: AppIcons.smartphone,
              title: l10n.settingsVersionTitle,
              // TODO: obtener versión real con package_info_plus
              subtitle: _kVersionValue,
            ),
            SettingsItem(
              icon: AppIcons.language,
              title: l10n.settingsWebsiteTitle,
              subtitle: AppConfig.websiteLabel,
              onTap: () async {
                await launchUrl(
                  Uri.parse(AppConfig.websiteUrl),
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
