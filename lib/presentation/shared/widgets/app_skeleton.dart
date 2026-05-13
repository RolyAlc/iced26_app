import 'package:flutter/material.dart';

/// Un widget de carga "esqueleto" que simula la estructura de los elementos
/// que se mostrarán una vez que los datos estén disponibles.
///
/// Ayuda a mejorar la percepción de velocidad y a mantener la continuidad visual
/// durante los estados de carga.
class AppSkeleton extends StatelessWidget {
  /// La altura total del esqueleto.
  final double height;

  /// El radio de los bordes redondeados. Por defecto 20.
  final double borderRadius;

  /// El número de líneas de texto simuladas. Por defecto 3.
  final int textLines;

  /// El número de elementos de imagen simulados. Por defecto 1.
  final int imagePlaceholders;

  /// El espaciado entre elementos simulados.
  final double spacing;

  /// El color de fondo de los elementos simulados.
  final Color skeletonColor;

  /// El color del borde.
  final Color borderColor;

  const AppSkeleton({
    super.key,
    this.height = 120.0,
    this.borderRadius = 20.0,
    this.textLines = 3,
    this.imagePlaceholders = 1,
    this.spacing = 12.0,
    this.skeletonColor =
        Colors.transparent, // Usar el color del tema por defecto
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveSkeletonColor = skeletonColor == Colors.transparent
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
        : skeletonColor;
    final effectiveBorderColor = borderColor == Colors.transparent
        ? theme.colorScheme.outlineVariant.withValues(alpha: 0.5)
        : borderColor;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: effectiveSkeletonColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorderColor, width: 1.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder para imagen si aplica
          if (imagePlaceholders > 0) ...[
            Container(
              height: 60, // Altura fija para el placeholder de imagen
              width: double.infinity,
              decoration: BoxDecoration(
                color: effectiveSkeletonColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            SizedBox(height: spacing),
          ],

          // Placeholders de texto
          for (var i = 0; i < textLines; i++) ...[
            Container(
              height: 14, // Altura para línea de texto
              width:
                  MediaQuery.of(context).size.width *
                  (0.6 + i * 0.1), // Ancho variable
              decoration: BoxDecoration(
                color: effectiveSkeletonColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            if (i < textLines - 1) SizedBox(height: spacing / 2),
          ],
        ],
      ),
    );
  }
}
