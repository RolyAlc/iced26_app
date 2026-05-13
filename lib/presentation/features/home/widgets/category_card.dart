import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/category_style_config.dart';
import 'package:iced26/presentation/shared/widgets/app_card.dart';

/// Tarjeta individual para cada categoría.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.name,
    required this.style,
    required this.onTap,
  });

  final String name;
  final CategoryStyleConfig style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      borderRadius: AppRadius.l,
      bordered: true,
      color: Color.alphaBlend(
        style.color.withValues(alpha: 0.12),
        colors.surfaceContainerLow,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.sm,
      ),
      child: Row(
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
      ),
    );
  }
}
