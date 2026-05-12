import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Sección con título etiquetado y lista de ítems agrupados visualmente.
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const SettingsSection({super.key, required this.title, required this.items});

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

/// Ítem genérico de ajustes con icono, título, subtítulo y trailing opcional.
class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  const SettingsItem({
    super.key,
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
          (onTap != null ? const Icon(AppIcons.chevronRight, size: 20) : null),
      onTap: onTap,
    );
  }
}

/// Badge visual para funcionalidades pendientes de implementar.
class ComingSoonBadge extends StatelessWidget {
  const ComingSoonBadge({super.key});

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
