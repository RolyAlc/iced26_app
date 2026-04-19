import 'package:flutter/material.dart';

import 'package:iced26/presentation/features/home/viewmodel/category_style_resolver.dart';
import 'package:iced26/presentation/features/home/view/sections/widgets/category_card.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/category_layout.dart';

// TODO: aplicar Bento Grid en las screens

/// Seccion de categorias. Bento Grid.
class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key, required this.layout});

  final CategoryLayout layout;
  final String titleSection = 'Categories';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolver = CategoryStyleResolver();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            titleSection,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CategoryCard(
                        name: layout.featured.name,
                        style: resolver.resolve(layout.featured),
                        isFeatured: true,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: spacing),
                    Expanded(
                      flex: 2,
                      child: CategoryCard(
                        name: layout.secondary.name,
                        style: resolver.resolve(layout.secondary),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacing),
                if (layout.others.isNotEmpty)
                  Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: layout.others.map((category) {
                      return SizedBox(
                        width: (constraints.maxWidth - spacing) / 2,
                        child: CategoryCard(
                          name: category.name,
                          style: resolver.resolve(category),
                          onTap: () {},
                        ),
                      );
                    }).toList(),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
