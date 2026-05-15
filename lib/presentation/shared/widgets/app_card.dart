import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';

/// Tarjeta base de la aplicación.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = AppRadius.m,
    this.color,
    this.elevation = 0,
    this.padding,
    this.bordered = false,
    this.clipBehavior = Clip.antiAlias,
  });

  /// El contenido de la tarjeta.
  final Widget child;

  /// Acción al pulsar la tarjeta.
  final VoidCallback? onTap;

  /// Radio de los bordes. Por defecto 24 (Estilo Premium).
  final double borderRadius;

  /// Color de fondo. Por defecto usa surfaceContainerHigh del tema.
  final Color? color;

  /// Elevación de la tarjeta. Por defecto 0 (Estilo plano moderno).
  final double elevation;

  /// Padding interno del contenido.
  final EdgeInsets? padding;

  /// Si es true, añade un borde sutil alrededor de la tarjeta.
  final bool bordered;

  /// Clip behavior. Por defecto antiAlias para recortes suaves.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = color ?? theme.colorScheme.surfaceContainerHigh;

    return Card(
      margin: EdgeInsets.zero,
      elevation: elevation,
      clipBehavior: clipBehavior,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: bordered
            ? BorderSide(color: theme.colorScheme.outlineVariant)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}
