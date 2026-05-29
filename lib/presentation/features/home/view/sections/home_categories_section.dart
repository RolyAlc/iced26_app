import 'package:flutter/material.dart';

import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/category.dart';
import 'package:iced26/presentation/features/home/viewmodel/mappers/category_ui_mapper.dart';
import 'package:iced26/presentation/features/home/widgets/category_card.dart';

/// Seccion de categorias. Grid uniforme de 2 columnas.
class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key, required this.categories});

  final List<Category> categories;

  static const double _childAspectRatio = 2.8;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.s,
      mainAxisSpacing: AppSpacing.s,
      childAspectRatio: _childAspectRatio,
      children: [
        for (final category in categories)
          CategoryCard(
            name: category.name,
            style: CategoryUiMapper.resolve(category),
          ),
      ],
    );
  }
}
