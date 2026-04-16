import 'package:flutter/material.dart';

/// Barra de búsqueda inteligente con sugerencias dinámicas.
class SmartSearchBar extends StatelessWidget {
  const SmartSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            hintText: 'Search events...',
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onTap: () {
              controller.openView(); // Abre la vista de búsqueda
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
            trailing: [
              // Botón de filtros integrado
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () {
                  print("Abrir filtros");
                },
              ),
            ],
            // Mantenemos tu estilo de M3
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          );
        },
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
              // Aquí generas las sugerencias basadas en controller.text
              return List<ListTile>.generate(5, (int index) {
                final String item = 'Sugerencia $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    controller.closeView(item);
                  },
                );
              });
            },
      ),
    );
  }
}
