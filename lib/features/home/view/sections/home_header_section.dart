import 'package:flutter/material.dart';

import 'package:iced26/app/widgets/smart_search_bar.dart';
import 'package:iced26/core/constants/assets.dart';

/// Sección de encabezado en la pantalla principal
/// Muestra el logo, la fecha y una etiqueta informativa.
class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
    required this.today,
    required this.infoLabel,
  });

  final DateTime today;
  final String infoLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Formateo de la fecha (Ej: "Monday, June 26, 2024")
    final String dateLabel = MaterialLocalizations.of(
      context,
    ).formatFullDate(today);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila superior: Logo y Datos de la sesión
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Parte izquierda: Logo de la App
            _buildLogo(),
            // Parte derecha: Fecha e información de la sesión
            _buildInfoColumn(dateLabel, colorScheme, textTheme),
          ],
        ),

        const SizedBox(height: 8),
        const SmartSearchBar(), // Barra de búsqueda compacta en el header
      ],
    );
  }

  /// Sub-widget para el Logo
  Widget _buildLogo() {
    return Image.asset(Assets.logoIced26, height: 48, fit: BoxFit.contain);
  }

  /// Sub-widget para la información de fecha y etiqueta
  Widget _buildInfoColumn(
    String dateLabel,
    ColorScheme colors,
    TextTheme texts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 14,
              color: colors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              dateLabel,
              style: texts.labelSmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Etiqueta principal de información
        // Ej: "Welcome to ICED26"
        Text(
          infoLabel,
          style: texts.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
      ],
    );
  }
}
