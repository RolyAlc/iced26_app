import 'package:iced26/features/home/domain/category.dart';
import 'package:iced26/features/home/viewmodel/models/category_layout.dart';

class HomeCategoriesViewModel {
  CategoryLayout buildLayout(List<Category> categories) {
    if (categories.isEmpty) {
      throw Exception('No categories available');
    }

    final featured = categories.first;

    final secondary = categories.length > 1 ? categories[1] : categories.first;

    final others = categories.length > 2 ? categories.sublist(2) : <Category>[];

    return CategoryLayout(
      featured: featured,
      secondary: secondary,
      others: others,
    );
  }
}
