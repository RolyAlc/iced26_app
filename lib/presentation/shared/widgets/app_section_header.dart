import 'package:flutter/material.dart';

/// Widget estandarizado para los encabezados de sección.
///
/// Proporciona un título consistente y un widget opcional para acciones
/// como "Ver más".
class AppSectionHeader extends StatelessWidget {
  /// El título principal de la sección.
  final String title;

  /// Widget opcional que aparece a la derecha del título (ej. "See all").
  final Widget? trailing;

  /// Espaciado vertical superior entre secciones.
  final double topPadding;

  /// Espaciado vertical inferior entre secciones.
  final double bottomPadding;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.topPadding = 16,
    this.bottomPadding = 8, // Un poco menos de espacio después del título
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
        left: 20,
        right: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5, // Ajuste fino para mejor legibilidad
            ),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
