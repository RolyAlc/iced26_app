import 'package:iced26/domain/entities/theme_config.dart';

/// Mapper para convertir el JSON de la configuración de tema en una instancia de 'ThemeConfig'.
/// Devuelve un objeto 'ThemeConfig' con los campos correctamente parseados.
class ThemeMapper {
  static ThemeConfig fromMap(Map<String, dynamic> json) {
    // Extraemos las secciones del JSON
    final dynamic rawColors = json['color'] ?? json['colors'];
    final dynamic rawTypography = json['typography'];
    final dynamic rawLogo = json['logo'];

    // Procesamos el mapa de colores con seguridad (Cast de dynamic a String)
    final Map<String, String> processedColors = _parseColors(rawColors);

    return ThemeConfig(
      colors: processedColors,
      typography: _ensureMap(rawTypography),
      logo: _ensureMap(rawLogo),
    );
  }

  /// Convierte un mapa dinámico en un mapa de Strings puro para colores
  static Map<String, String> _parseColors(dynamic rawColors) {
    if (rawColors is! Map) return {};

    return rawColors.map(
      (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
    );
  }

  static Map<String, dynamic> _ensureMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return {};
  }
}
