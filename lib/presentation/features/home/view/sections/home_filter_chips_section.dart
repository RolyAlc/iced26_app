import 'package:flutter/material.dart';
import 'package:iced26/core/services/logger/logger.dart';

/// Sección de chips de filtro horizontal para la pantalla de inicio.
class HomeFilterChipsSection extends StatelessWidget {
  const HomeFilterChipsSection({super.key});

  /// Construye la sección de chips de filtro.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _buildFilterChip(context, 'Time', Icons.access_time),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'Location', Icons.location_on),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'Type', Icons.category),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'More', Icons.tune),
          ],
        ),
      ),
    );
  }

  /// Construye un chip de filtro.
  Widget _buildFilterChip(BuildContext context, String label, IconData icon) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
      onSelected: (bool selected) {
        AppLogger.d('Filtro "$label" seleccionado: $selected');
      },
      shape: const StadiumBorder(),
      showCheckmark: false,
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      labelStyle: theme.textTheme.labelMedium,
    );
  }
}
