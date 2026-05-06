import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/domain/entities/theme_config.dart';

/// Mapper para [ThemeConfig]
abstract final class ThemeMapper {
  /// Crea un [ThemeConfig] a partir de un mapa
  static ThemeConfig fromMap(Map<String, dynamic> json) {
    final dynamic rawColors = json['color'] ?? json['colors'];
    final colors = _parseColors(rawColors);
    final typography = json.getMap('typography');
    final logo = json.getMap('logo');

    return ThemeConfig(colors: colors, typography: typography, logo: logo);
  }

  /// Parsea los colores a partir de un [Map]
  static Map<String, String> _parseColors(dynamic rawColors) {
    if (rawColors is! Map) {
      return const {};
    }
    return rawColors.map(
      (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
    );
  }
}
