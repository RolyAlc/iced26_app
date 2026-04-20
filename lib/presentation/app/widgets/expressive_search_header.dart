import 'package:flutter/material.dart';
import 'package:iced26/core/logger/logger.dart';

/// Header expresivo de búsqueda con filtros integrados
/// Combina un 'SearchBar' moderno con 'FilterChips' para una experiencia
/// de búsqueda avanzada.
class ExpressiveSearchHeader extends StatelessWidget {
  const ExpressiveSearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SearchAnchor(
            builder: (context, controller) {
              return SearchBar(
                controller: controller,
                hintText: "Search events...",
                leading: const Icon(Icons.search, size: 20),
                onTap: () => controller.openView(),
                elevation: const WidgetStatePropertyAll(2),
                side: const WidgetStatePropertyAll(BorderSide.none),
                shape: const WidgetStatePropertyAll(StadiumBorder()),
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () {
                      logger.d("Abrir filtros avanzados");
                    },
                  ),
                ],
              );
            },
            suggestionsBuilder: (context, controller) {
              // Sugerencias dinámicas basadas en el texto
              return [
                ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(
                    controller.text.isEmpty
                        ? 'Recent searches'
                        : 'Search for "${controller.text}"',
                  ),
                  onTap: () {
                    controller.closeView(controller.text);
                  },
                ),
              ];
            },
          ),
        ),
        // Los filtros circulares
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildFilterChip(context, "Time", Icons.access_time),
              const SizedBox(width: 8),
              _buildFilterChip(context, "Location", Icons.location_on),
              const SizedBox(width: 8),
              _buildFilterChip(context, "Type", Icons.category),
              const SizedBox(width: 8),
              _buildFilterChip(context, "More", Icons.more_horiz),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, IconData icon) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
      onSelected: (bool selected) {
        logger.d('Filtro "$label" seleccionado: $selected');
      },
      shape: const StadiumBorder(),
      showCheckmark: false,
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      labelStyle: theme.textTheme.labelMedium,
    );
  }
}
