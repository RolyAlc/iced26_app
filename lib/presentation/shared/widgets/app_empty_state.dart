import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Pantalla genérica que muestra estado vacío con ilustración, título,
/// mensaje y acción opcional.
class AppEmptyState extends StatelessWidget {
  final Widget? illustration;
  final String title;
  final String message;
  final Widget? actionButton;
  final double spacing;
  final EdgeInsetsGeometry padding;

  const AppEmptyState({
    super.key,
    this.illustration,
    required this.title,
    required this.message,
    this.actionButton,
    this.spacing = AppSpacing.m,
    this.padding = const EdgeInsets.all(AppSpacing.l),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (illustration != null) ...[
            illustration!,
            SizedBox(height: spacing),
          ] else ...[
            Icon(
              AppIcons.info,
              size: 60,
              color: colors.primary.withValues(alpha: 0.6),
            ),
            SizedBox(height: spacing),
          ],

          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing / 2),

          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionButton != null) ...[
            SizedBox(height: spacing),
            actionButton!,
          ],
        ],
      ),
    );
  }
}

/// Wrapper para mostrar un SVG con dimensionado y color adaptable al tema.
class AppSvgIllustration extends StatelessWidget {
  final String svgPath;
  final double size;
  final Color? color;

  const AppSvgIllustration({
    super.key,
    required this.svgPath,
    this.size = 120,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPath,
      height: size,
      width: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
