import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/conference_theme_mapper.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/conference.dart';
import 'package:iced26/domain/entities/conference_theme.dart';

/// Mapper para [Conference].
abstract final class ConferenceMapper {
  /// Crea un [Conference] a partir de un mapa JSON.
  static Conference fromMap(Map<String, dynamic> json) {
    final name = I18nMapper.fromRaw(json['name'] ?? json['title']);
    final List<ConferenceTheme> themes = json
        .getList('conferenceThemes')
        .whereType<Map<String, dynamic>>()
        .map(ConferenceThemeMapper.fromMap)
        .toList();

    return Conference(name: name, conferenceThemes: themes);
  }
}
