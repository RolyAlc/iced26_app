import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/di/bootstrap.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/presentation/widgets/app_page.dart';
import 'package:url_launcher/url_launcher.dart';

/// Vista de ajustes de la aplicación.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      header: _SettingsHeader(),
      children: [
        _SettingsSection(
          title: 'Appearance',
          items: [
            _SettingsItem(
              icon: Icons.text_fields_rounded,
              title: 'Text size',
              subtitle: 'Medium',
            ),
            _SettingsItem(
              icon: Icons.contrast_rounded,
              title: 'High contrast',
              subtitle: 'Black & white, no colour',
              trailing: _ComingSoonBadge(),
            ),
            _SettingsItem(
              icon: Icons.dark_mode_outlined,
              title: 'Theme',
              subtitle: 'System',
            ),
          ],
        ),
        SizedBox(height: AppSpacing.m),
        _SettingsSection(
          title: 'Language',
          items: [
            _SettingsItem(
              icon: Icons.translate_rounded,
              title: 'App language',
              subtitle: 'English',
              trailing: _ComingSoonBadge(),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.m),
        _SettingsSection(
          title: 'Data',
          items: [_ReloadDataItem(), _ClearFavouritesItem()],
        ),
        SizedBox(height: AppSpacing.m),
        _SettingsSection(
          title: 'About',
          items: [
            _SettingsItem(
              icon: Icons.info_outline_rounded,
              title: 'ICED 26',
              subtitle: 'Salamanca, Spain',
            ),
            _SettingsItem(
              icon: Icons.smartphone_rounded,
              title: 'Version',
              subtitle: '—',
            ),
            _SettingsItem(
              icon: Icons.language_rounded,
              title: 'Official website',
              subtitle: 'iced26.es',
              onTap: () => launchUrl(
                Uri.parse('https://iced26.es'),
                mode: LaunchMode.externalApplication,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Encabezado de la vista de ajustes.
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

/// Sección de ajustes con título y lista de items.
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              bottom: AppSpacing.s,
            ),
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.primary,
                letterSpacing: 0.8,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.m),
            child: ColoredBox(
              color: colors.surfaceContainerLow,
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    items[i],
                    if (i < items.length - 1)
                      Divider(
                        height: 1,
                        indent: AppSpacing.l + 40,
                        color: colors.outlineVariant.withValues(alpha: 0.5),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Item de "Reload data" con diálogo de confirmación.
class _ReloadDataItem extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SettingsItem(
      icon: Icons.refresh_rounded,
      title: 'Reload data',
      subtitle: 'Update the programme from the bundle',
      onTap: () => _confirmReload(context, ref),
    );
  }

  Future<void> _confirmReload(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reload data?'),
        content: const Text(
          'The programme will be refreshed from the bundled data. Your favourites will be kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reload'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.invalidate(bootstrapProvider);
    }
  }
}

/// Item de "Clear favourites" con conteo reactivo y diálogo de confirmación.
class _ClearFavouritesItem extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref
        .watch(favoriteIdsProvider)
        .when(data: (ids) => ids.length, loading: () => 0, error: (_, _) => 0);
    final hasItems = count > 0;

    return _SettingsItem(
      icon: Icons.bookmark_remove_outlined,
      title: 'Clear favourites',
      subtitle: switch (count) {
        0 => 'No saved events',
        1 => '1 saved event',
        _ => '$count saved events',
      },
      enabled: hasItems,
      onTap: hasItems ? () => _confirmClear(context, ref, count) : null,
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    WidgetRef ref,
    int count,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear favourites?'),
        content: Text(
          'Remove all $count saved ${count == 1 ? 'event' : 'events'}? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(clearFavoritesUseCaseProvider).execute();
    }
  }
}

/// Item individual de ajuste.
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      enabled: enabled,
      leading: Icon(icon, color: colors.onSurfaceVariant),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing:
          trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right_rounded, size: 20)
              : null),
      onTap: onTap,
    );
  }
}

/// Badge visual para items sin lógica aún.
class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        'Soon',
        style: TextStyle(
          fontSize: AppTextSize.chip,
          fontWeight: FontWeight.w600,
          color: colors.onSecondaryContainer,
        ),
      ),
    );
  }
}
