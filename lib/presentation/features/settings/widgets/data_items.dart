import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/di/bootstrap.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/settings/widgets/settings_section.dart';

/// Ítem de recarga de datos con diálogo de confirmación.
class ReloadDataItem extends ConsumerWidget {
  const ReloadDataItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsItem(
      icon: AppIcons.refresh,
      title: 'Reload data',
      subtitle: 'Update the programme from the bundle',
      onTap: () {
        _confirmReload(context, ref);
      },
    );
  }

  Future<void> _confirmReload(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Reload data?'),
          content: const Text(
            'The programme will be refreshed from the bundled data. Your favourites will be kept.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Reload'),
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
    final count = ref
        .watch(favoriteIdsProvider)
        .when(data: (ids) => ids.length, loading: () => 0, error: (_, _) => 0);
    final hasItems = count > 0;

    return SettingsItem(
      icon: AppIcons.bookmarkRemove,
      title: 'Clear favourites',
      subtitle: switch (count) {
        0 => 'No saved events',
        1 => '1 saved event',
        _ => '$count saved events',
      },
      enabled: hasItems,
      onTap: hasItems
          ? () {
              _confirmClear(context, ref, count);
            }
          : null,
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    WidgetRef ref,
    int count,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Clear favourites?'),
          content: Text(
            'Remove all $count saved ${count == 1 ? 'event' : 'events'}? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Clear all'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await ref.read(clearFavoritesUseCaseProvider).execute();
    }
  }
}
