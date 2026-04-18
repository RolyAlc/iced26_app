import 'package:flutter/material.dart';

import 'package:iced26/features/home/domain/category.dart';
import 'package:iced26/features/home/view/sections/configs/category_style_config.dart';

class CategoryStyleResolver {
  CategoryStyleConfig resolve(Category category) {
    final name = category.name.toLowerCase();

    if (name.contains('workshop')) {
      return const CategoryStyleConfig(Icons.handyman, Colors.orange);
    }

    if (name.contains('paper')) {
      return const CategoryStyleConfig(Icons.article, Colors.blue);
    }

    if (name.contains('poster')) {
      return const CategoryStyleConfig(Icons.collections, Colors.green);
    }

    if (name.contains('talks')) {
      return const CategoryStyleConfig(Icons.record_voice_over, Colors.red);
    }

    if (name.contains('symposia')) {
      return const CategoryStyleConfig(Icons.forum, Colors.purple);
    }

    return const CategoryStyleConfig(Icons.grid_view, Colors.teal);
  }
}
