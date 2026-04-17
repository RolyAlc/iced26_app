import 'package:flutter/material.dart';

import 'package:iced26/features/home/view/sections/configs/category_style_config.dart';
import 'package:iced26/features/home/view/sections/widgets/category_card.dart';

/// Sección de categorías en la pantalla principal.
class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key, required this.items});

  final List<String> items;
  final titleSection = 'Categories';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleSection,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              // Evitar overflowed
              // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //   maxCrossAxisExtent: 140,
              //   mainAxisSpacing: 12,
              //   crossAxisSpacing: 12,
              //   childAspectRatio: 0.85,
              // ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 0.60,
              ),
              itemBuilder: (context, index) {
                final name = items[index];
                return CategoryCard(
                  name: name,
                  style: CategoryStyleConfig.fromName(name),
                  onTap: () => {},
                );
              },
            );
          },
        ),
      ],
    );
  }
}
