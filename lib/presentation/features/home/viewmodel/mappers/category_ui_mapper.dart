import 'package:iced26/core/constants/design_tokens.dart';
import 'package:iced26/domain/entities/category.dart';
import 'package:iced26/presentation/app/theme/app_icons.dart';
import 'package:iced26/presentation/shared/models/icon_color_style.dart';

// Nota: matching por substring del nombre que viene del backend.
// Frágil hasta que Category tenga un campo `type` estable.
const Map<String, IconColorStyle> _kStyles = {
  'workshop': IconColorStyle(AppIcons.handyman, AppCategoryColors.workshop),
  'paper': IconColorStyle(AppIcons.article, AppCategoryColors.paper),
  'poster': IconColorStyle(AppIcons.collections, AppCategoryColors.poster),
  'talks': IconColorStyle(AppIcons.recordVoiceOver, AppCategoryColors.talks),
  'symposia': IconColorStyle(AppIcons.forum, AppCategoryColors.symposia),
};

const _kFallback = IconColorStyle(
  AppIcons.gridView,
  AppCategoryColors.fallback,
);

/// Resuelve el estilo de icono y color para una categoría.
class CategoryUiMapper {
  static IconColorStyle resolve(Category category) {
    final name = category.name.toLowerCase();
    for (final entry in _kStyles.entries) {
      if (name.contains(entry.key)) {
        return entry.value;
      }
    }
    return _kFallback;
  }
}
