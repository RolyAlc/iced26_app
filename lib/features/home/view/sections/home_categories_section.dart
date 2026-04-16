import 'package:flutter/material.dart';

/// Sección de categorías compacta (4x2) con diseño Material 3 mejorado.
class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Grid compacto (4x2) con proporciones cuadradas.
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio:
                0.95, // Proporción más equilibrada (menos espacio abajo)
          ),
          itemBuilder: (context, index) {
            final categoryName = items[index];
            final style = _getCategoryStyle(categoryName);

            return InkWell(
              onTap: () {
                // TODO: Navegar al filtro
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: style.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centrado vertical total
                  children: [
                    // Icono envuelto en un círculo suave para contraste
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: style.rootColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(style.icon, color: style.rootColor, size: 24),
                    ),
                    const SizedBox(height: 6),
                    // Texto flexible de hasta 2 líneas (KISS)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        categoryName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: style.rootColor.withOpacity(0.9),
                          height: 1.1, // Un pelín más compacto entre líneas
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Mapeo de estilos para cada tipo de categoría.
  _CategoryConfig _getCategoryStyle(String name) {
    final lowerName = name.toLowerCase();

    if (lowerName.contains('workshop')) {
      return _CategoryConfig(
        Icons.handyman_rounded,
        Colors.orange[800]!,
        Colors.orange[50]!,
      );
    } else if (lowerName.contains('paper')) {
      return _CategoryConfig(
        Icons.article_rounded,
        Colors.blue[800]!,
        Colors.blue[50]!,
      );
    } else if (lowerName.contains('poster')) {
      return _CategoryConfig(
        Icons.collections_rounded,
        Colors.green[800]!,
        Colors.green[50]!,
      );
    } else if (lowerName.contains('talks')) {
      return _CategoryConfig(
        Icons.record_voice_over_rounded,
        Colors.red[800]!,
        Colors.red[50]!,
      );
    } else if (lowerName.contains('symposia')) {
      return _CategoryConfig(
        Icons.forum_rounded,
        Colors.purple[800]!,
        Colors.purple[50]!,
      );
    } else {
      return _CategoryConfig(
        Icons.grid_view_rounded,
        Colors.teal[800]!,
        Colors.teal[50]!,
      );
    }
  }
}

class _CategoryConfig {
  final IconData icon;
  final Color rootColor;
  final Color backgroundColor;

  _CategoryConfig(this.icon, this.rootColor, this.backgroundColor);
}
