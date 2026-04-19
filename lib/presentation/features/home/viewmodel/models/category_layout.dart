import 'package:iced26/domain/entities/category.dart';

class CategoryLayout {
  final Category featured;
  final Category secondary;
  final List<Category> others;

  const CategoryLayout({
    required this.featured,
    required this.secondary,
    required this.others,
  });
}
