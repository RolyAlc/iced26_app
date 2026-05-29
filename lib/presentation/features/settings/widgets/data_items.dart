import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:iced26/di/bootstrap.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/settings/widgets/settings_section.dart';

/// Ítem de recarga de datos con diálogo de confirmación.
class ReloadDataItem extends ConsumerWidget {
  const ReloadDataItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return SettingsItem(
      icon: AppIcons.refresh,
      title: l10n.settingsReloadDataTitle,
      subtitle: l10n.settingsReloadDataSubtitle,
      onTap: () {
        _confirmReload(context, ref);
      },
    );
  }

  Future<void> _confirmReload(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.settingsReloadDialogTitle),
          content: Text(l10n.settingsReloadDialogBody),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: Text(l10n.settingsReload),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      ref.invalidate(bootstrapProvider);
    }
  }
}

/// Ítem de borrado de favoritos con conteo reactivo y diálogo de confirmación.
class ClearFavouritesItem extends ConsumerWidget {
  const ClearFavouritesItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final eventCount = ref
        .watch(favoriteIdsProvider)
        .when(data: (ids) => ids.length, loading: () => 0, error: (_, _) => 0);
    final presentationCount = ref
        .watch(presentationFavoriteIdsProvider)
        .when(data: (ids) => ids.length, loading: () => 0, error: (_, _) => 0);
    final totalCount = eventCount + presentationCount;
    final hasItems = totalCount > 0;

    return SettingsItem(
      icon: AppIcons.bookmarkRemove,
      title: l10n.settingsClearFavouritesTitle,
      subtitle: _favouritesSubtitle(l10n, totalCount),
      enabled: hasItems,
      onTap: hasItems
          ? () {
              _confirmClear(context, ref, totalCount);
            }
          : null,
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    WidgetRef ref,
    int count,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.settingsClearFavouritesDialogTitle),
          content: Text(
            count == 1
                ? l10n.settingsClearFavouritesDialogBodyOne
                : l10n.settingsClearFavouritesDialogBodyMany(count),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: Text(l10n.settingsClearAll),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await ref.read(clearAllSavedItemsUseCaseProvider).execute();
    }
  }
}

String _favouritesSubtitle(AppLocalizations l10n, int count) {
  return switch (count) {
    0 => l10n.settingsClearFavouritesEmpty,
    1 => l10n.settingsClearFavouritesOne,
    _ => l10n.settingsClearFavouritesMany(count),
  };
}
