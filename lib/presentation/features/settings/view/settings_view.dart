import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/core/constants/app_config.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/domain_providers.dart';
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

/// Vista de ajustes de la app.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final conference = ref.watch(conferenceConfigProvider).asData?.value;

    final editionName = conference?.name ?? AppConfig.edition;
    final location = conference?.location ?? AppConfig.location;
    final websiteLabel = conference?.websiteLabel ?? AppConfig.websiteLabel;
    final websiteUrl = conference?.websiteUrl ?? AppConfig.websiteUrl;
    const privacyPolicyUrl = AppConfig.privacyPolicyUrl;

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
            SettingsItem(
              icon: AppIcons.info,
              title: editionName,
              subtitle: location,
            ),
            SettingsItem(
              icon: AppIcons.language,
              title: l10n.settingsWebsiteTitle,
              subtitle: websiteLabel,
              onTap: () async {
                await launchUrl(
                  Uri.parse(websiteUrl),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            SettingsItem(
              icon: AppIcons.privacyPolicy,
              title: l10n.settingsPrivacyPolicyTitle,
              onTap: () async {
                await launchUrl(
                  Uri.parse(privacyPolicyUrl),
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
