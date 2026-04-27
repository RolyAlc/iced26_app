import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Un widget para mostrar estados vacíos o de error de forma consistente.
///
/// Permite mostrar un icono/ilustración, un título y un mensaje.
class AppEmptyState extends StatelessWidget {
  /// El icono o ilustración principal a mostrar.
  final Widget? illustration;

  /// El título principal del estado vacío/error.
  final String title;

  /// El mensaje descriptivo debajo del título.
  final String message;

  /// Widget opcional para una acción principal (ej. un botón "Recargar").
  final Widget? actionButton;

  /// El espaciado vertical entre los elementos.
  final double spacing;

  /// El padding interno del widget.
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
              Icons.info_outline_rounded, // Icono genérico de información
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
