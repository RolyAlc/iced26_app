import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Widget para mostrar estados vacíos o de error de forma consistente.
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
    this.spacing = 16.0,
    this.padding = const EdgeInsets.all(24.0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ilustración o Icono
          if (illustration != null) ...[
            illustration!,
            SizedBox(height: spacing),
          ] else ...[
            // Icono por defecto si no se proporciona ilustración
            Icon(
              AppIcons.info,
              size: 60,
              color: colors.primary.withValues(alpha: 0.6),
            ),
            SizedBox(height: spacing),
          ],

          // Título
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing / 2),

          // Mensaje descriptivo
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

/// Ejemplo de uso con un icono SVG personalizado.
/// Requiere la dependencia `flutter_svg`.
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
