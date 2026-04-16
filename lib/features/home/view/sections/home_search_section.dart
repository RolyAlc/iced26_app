import 'package:flutter/material.dart';

/// Sección de búsqueda en la pantalla principal.
class HomeSearchSection extends StatelessWidget {
  const HomeSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Barra de búsqueda
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              // TODO: Abrir pantalla de búsqueda
            },
            borderRadius: BorderRadius.circular(28),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search events...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Botón de filtros
        IconButton.filledTonal(
          onPressed: () {
            // TODO: Abrir filtros
          },
          icon: const Icon(Icons.tune, size: 20),
          constraints: const BoxConstraints(minHeight: 52, minWidth: 52),
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
