import 'dart:ui'; // Necesario para ImageFilter
import 'package:flutter/material.dart';

/// Un widget reutilizable para aplicar efectos de Glassmorphism.
///
/// Permite configurar el color de fondo, el radio de los bordes y el nivel de desenfoque.
class AppGlassmorphism extends StatelessWidget {
  /// El widget que se mostrará dentro del efecto de glassmorphism.
  final Widget child;

  /// El color de fondo del contenedor. Por defecto usa un color semi-transparente.
  final Color backgroundColor;

  /// El radio de los bordes redondeados. Por defecto 32.
  final double borderRadius;

  /// La intensidad del desenfoque. Por defecto 10.0.
  final double sigmaX;
  final double sigmaY;

  /// El padding interno del contenido.
  final EdgeInsetsGeometry padding;

  const AppGlassmorphism({
    super.key,
    required this.child,
    this.backgroundColor =
        Colors.transparent, // Por defecto no aplica color si no se especifica
    this.borderRadius = 32.0,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor == Colors.transparent
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8)
        : backgroundColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
