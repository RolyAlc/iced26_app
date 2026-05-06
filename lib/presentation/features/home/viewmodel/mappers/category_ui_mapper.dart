import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/category.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/category_style_config.dart';

// TODO: Muchos if's

/// Mapea una [Category] de dominio a una configuración de estilo de UI.
class CategoryUiMapper {
  static CategoryStyleConfig resolve(Category category) {
    final name = category.name.toLowerCase();

    if (name.contains('workshop')) {
      return const CategoryStyleConfig(AppIcons.handyman, Colors.orange);
    }

    if (name.contains('paper')) {
      return const CategoryStyleConfig(AppIcons.article, Colors.blue);
    }

    if (name.contains('poster')) {
      return const CategoryStyleConfig(AppIcons.collections, Colors.green);
    }

    if (name.contains('talks')) {
      return const CategoryStyleConfig(AppIcons.recordVoiceOver, Colors.red);
    }

    if (name.contains('symposia')) {
      return const CategoryStyleConfig(AppIcons.forum, Colors.purple);
    }

    return const CategoryStyleConfig(AppIcons.gridView, Colors.teal);
  }
}
