import 'package:flutter/material.dart';

import 'package:iced26/presentation/features/home/viewmodel/mappers/category_ui_mapper.dart';
import 'package:iced26/presentation/features/home/widgets/category_card.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/category_layout.dart';

// TODO: aplicar Bento Grid en las screens

/// Seccion de categorias. Bento Grid.
class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key, required this.layout});

  final CategoryLayout layout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                    style: CategoryUiMapper.resolve(layout.featured),
                    isFeatured: true,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: spacing),
                Expanded(
                  flex: 2,
                  child: CategoryCard(
                    name: layout.secondary.name,
                    style: CategoryUiMapper.resolve(layout.secondary),
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
                  final itemWidth = constraints.maxWidth > spacing
                      ? (constraints.maxWidth - spacing) / 2
                      : 0.0;
                  return SizedBox(
                    width: itemWidth,
                    child: CategoryCard(
                      name: category.name,
                      style: CategoryUiMapper.resolve(category),
                      onTap: () {},
                    ),
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }
}
