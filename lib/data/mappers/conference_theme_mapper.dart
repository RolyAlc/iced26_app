import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/conference_theme.dart';

/// Mapper para [ConferenceTheme].
abstract final class ConferenceThemeMapper {
  /// Crea un [ConferenceTheme] a partir de un mapa JSON.
  static ConferenceTheme fromMap(Map<String, dynamic> json) {
    final topics = (json['topicsInclude'] as List<dynamic>? ?? [])
        .map(I18nMapper.fromRaw)
        .toList();

    return ConferenceTheme(
      id: json['id'] as String? ?? '',
      name: I18nMapper.fromRaw(json['name']),
      description: I18nMapper.fromRaw(json['description']),
      topicsInclude: topics,
    );
  }

  /// Convierte un [ConferenceTheme] a un mapa JSON serializable.
  static Map<String, dynamic> toMap(ConferenceTheme theme) {
    // .values expone el Map<String, String> interno de I18nStr (ej. {"en": "...", "es": "..."}).
    // Es la forma canónica de serializar un campo i18n a JSON.
    return {
      'id': theme.id,
      'name': theme.name.values,
      'description': theme.description.values,
      'topicsInclude': theme.topicsInclude.map((t) => t.values).toList(),
    };
  }
}
