import 'package:iced26/data/mappers/conference_theme_mapper.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/conference.dart';
import 'package:iced26/domain/entities/conference_config.dart';
import 'package:iced26/domain/entities/conference_theme.dart';

/// Mapper para [Conference] y [ConferenceConfig].
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

  /// Crea un [ConferenceConfig] a partir del mapa `config.conference` del JSON.
  static ConferenceConfig configFromMap(Map<String, dynamic> config) {
    return ConferenceConfig(
      name: config['name'] as String? ?? '',
      tagline: config['tagline'] as String? ?? '',
      location: config['location'] as String? ?? '',
      dates: config['dates'] as String? ?? '',
      websiteUrl: config['website_url'] as String? ?? '',
      defaultLocale: config['default_locale'] as String? ?? 'en',
    );
  }

  /// Serializa un [ConferenceConfig] para persistencia en [AppConfigs].
  static Map<String, dynamic> configToMap(ConferenceConfig config) {
    return {
      'name': config.name,
      'tagline': config.tagline,
      'location': config.location,
      'dates': config.dates,
      'website_url': config.websiteUrl,
      'default_locale': config.defaultLocale,
    };
  }
}
