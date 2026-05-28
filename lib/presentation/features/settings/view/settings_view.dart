import 'package:flutter/material.dart';

import 'package:iced26/core/constants/app_config.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/settings/widgets/data_items.dart';
import 'package:iced26/presentation/features/settings/widgets/language_picker.dart';
import 'package:iced26/presentation/features/settings/widgets/settings_section.dart';
import 'package:iced26/presentation/features/settings/widgets/text_size_item.dart';
import 'package:iced26/presentation/features/settings/widgets/theme_picker.dart';
import 'package:iced26/presentation/shared/widgets/app_page.dart';
import 'package:iced26/presentation/shared/widgets/app_page_title.dart';
import 'package:url_launcher/url_launcher.dart';

const String _kSectionAppearance = 'Appearance';
const String _kSectionLanguage = 'Language';
const String _kSectionData = 'Data';
const String _kSectionAbout = 'About';
const String _kTitleSettings = 'Settings';
const String _kVersionTitle = 'Version';
const String _kVersionValue = '—';
const String _kWebsiteTitle = 'Official website';

/// Vista de ajustes de la app.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      header: const AppPageTitle(title: _kTitleSettings),
      children: [
        const SettingsSection(
          title: _kSectionAppearance,
          items: [TextSizeItem(), ThemeItem()],
        ),
        const SizedBox(height: AppSpacing.m),
        const SettingsSection(
          title: _kSectionLanguage,
          items: [LanguageItem()],
        ),
        const SizedBox(height: AppSpacing.m),
        const SettingsSection(
          title: _kSectionData,
          items: [ReloadDataItem(), ClearFavouritesItem()],
        ),
        const SizedBox(height: AppSpacing.m),
        SettingsSection(
          title: _kSectionAbout,
          items: [
            const SettingsItem(
              icon: AppIcons.info,
              title: AppConfig.edition,
              subtitle: AppConfig.location,
            ),
            const SettingsItem(
              icon: AppIcons.smartphone,
              title: _kVersionTitle,
              // TODO: obtener versión real con package_info_plus
              subtitle: _kVersionValue,
            ),
            SettingsItem(
              icon: AppIcons.language,
              title: _kWebsiteTitle,
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
