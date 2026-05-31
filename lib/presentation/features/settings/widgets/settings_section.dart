import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/l10n/app_localizations.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

// Ancho del área leading de ListTile M3: icono(24dp) + gap al título(16dp).
const _kListTileLeadingWidth = 40.0;

/// Sección con título etiquetado y lista de ítems agrupados visualmente.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.items});

  final String title;
  final List<Widget> items;

  Widget _buildSectionTitle(ThemeData theme, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.s),
      child: Text(
        title,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.primary,
          letterSpacing: AppTextStyle.labelLetterSpacing,
        ),
      ),
    );
  }

  Widget _buildItemsCard(ColorScheme colors) {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: colors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1)
              Divider(
                height: 1,
                // indent alinea el divisor con el texto tras el icono del ListTile.
                indent: AppSpacing.l + _kListTileLeadingWidth,
                color: colors.outlineVariant.withValues(alpha: 0.5),
              ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppLayout.horizontalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildSectionTitle(theme, colors), _buildItemsCard(colors)],
      ),
    );
  }
}

/// Ítem genérico de ajustes con icono, título, subtítulo y trailing opcional.
class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  Widget? _resolveTrailing() {
    if (trailing != null) {
      return trailing;
    }
    if (onTap != null) {
      return const Icon(AppIcons.chevronRight, size: 20);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      enabled: enabled,
      leading: Icon(icon, color: colors.onSurfaceVariant),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: _resolveTrailing(),
      onTap: onTap,
    );
  }
}

/// Badge visual para funcionalidades pendientes de implementar.
class ComingSoonBadge extends StatelessWidget {
  const ComingSoonBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        l10n.settingsComingSoon,
        style: TextStyle(
          fontSize: AppTextSize.chip,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
        ),
      ),
    );
  }
}
