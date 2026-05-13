import 'package:flutter/material.dart';
import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/core/services/logger/logger.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';

/// Header expresivo de búsqueda con filtros integrados
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
                leading: const Icon(AppIcons.search, size: 20),
                onTap: () => controller.openView(),
                elevation: const WidgetStatePropertyAll(AppElevation.low),
                side: const WidgetStatePropertyAll(BorderSide.none),
                shape: const WidgetStatePropertyAll(StadiumBorder()),
                trailing: [
                  IconButton(
                    icon: const Icon(AppIcons.filter),
                    onPressed: () {
                      AppLogger.d("Open advanced filters");
                    },
                  ),
                ],
              );
            },
            suggestionsBuilder: (context, controller) {
              // Sugerencias dinámicas basadas en el texto
              return [
                ListTile(
                  leading: const Icon(AppIcons.history),
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
              _buildFilterChip(context, "Time", AppIcons.time),
              const SizedBox(width: 8),
              _buildFilterChip(context, "Location", AppIcons.locationOn),
              const SizedBox(width: 8),
              _buildFilterChip(context, "Type", AppIcons.category),
              const SizedBox(width: 8),
              _buildFilterChip(context, "More", AppIcons.moreHoriz),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye un filtro circular.
  Widget _buildFilterChip(BuildContext context, String label, IconData icon) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
      onSelected: (bool selected) {
        AppLogger.d('Filter "$label" selected: $selected');
      },
      shape: const StadiumBorder(),
      showCheckmark: false,
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      labelStyle: theme.textTheme.labelMedium,
    );
  }
}
