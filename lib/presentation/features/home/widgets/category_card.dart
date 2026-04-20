import 'package:flutter/material.dart';

import 'package:iced26/presentation/features/home/viewmodel/models/category_style_config.dart';

import 'package:iced26/presentation/widgets/app_card.dart';

/// Tarjeta individual para cada categoría en formato "Bento Capsule".
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.name,
    required this.style,
    required this.onTap,
    this.isFeatured =
        false, // Para permitir variaciones de tamaño en el Bento Grid
  });

  final String name;
  final CategoryStyleConfig style;
  final VoidCallback onTap;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final Color cardBackground = Color.alphaBlend(
      style.color.withValues(alpha: 0.12),
      colors.surfaceContainerLow,
    );

    return AppCard(
      onTap: onTap,
      borderRadius: 28,
      color: cardBackground,
      bordered: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: isFeatured
          ? _buildFeaturedLayout(theme, style)
          : _buildStandardLayout(theme, style),
    );
  }

  /// Layout estándar.
  Widget _buildStandardLayout(ThemeData theme, CategoryStyleConfig style) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(style.icon, color: style.color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: style.color.withValues(alpha: 0.8),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  /// Layout destacado (Icono grande y Texto debajo)
  Widget _buildFeaturedLayout(ThemeData theme, CategoryStyleConfig style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(style.icon, color: style.color, size: 32),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: style.color,
          ),
        ),
      ],
    );
  }
}
