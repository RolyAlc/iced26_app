import 'package:flutter/material.dart';

import 'package:iced26/features/home/view/sections/configs/category_style_config.dart';

/// Tarjeta individual para cada categoría.
class CategoryCard extends StatelessWidget {
  final String name;
  final CategoryStyleConfig style;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Contenedor del Icono
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: style.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: style.color.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(style.icon, color: style.color, size: 30),
            ),
            const SizedBox(height: 6),
            // Texto adaptativo
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
