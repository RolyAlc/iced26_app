import 'package:iced26/data/mappers/conference_theme_mapper.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/conference.dart';
import 'package:iced26/domain/entities/conference_theme.dart';

/// Mapper para [Conference].
abstract final class ConferenceMapper {
  /// Crea un [Conference] a partir de dos fuentes del JSON raíz.
  static Conference fromSplitMaps({
    required Map<String, dynamic> config,
    required List<dynamic> rawThemes,
  }) {
    final name = I18nMapper.fromRaw(config['name'] ?? config['title']);
    final themes = <ConferenceTheme>[
      for (final t in rawThemes.whereType<Map<String, dynamic>>())
        ConferenceThemeMapper.fromMap(t),
    ];

    return Conference(name: name, conferenceThemes: themes);
  }
}
