import 'package:iced26/domain/entities/collections.dart';
import 'package:iced26/domain/entities/conference.dart';
import 'package:iced26/domain/entities/conference_config.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/metadata.dart';
import 'package:iced26/domain/entities/theme_config.dart';

/// Entidad que representa los datos de la aplicación.
class AppData {
  AppData({
    required this.metadata,
    required this.conference,
    required this.conferenceConfig,
    required this.theme,
    required this.collections,
  });

  /// Constructor para crear un objeto vacío.
  factory AppData.empty() {
    return AppData(
      metadata: Metadata(eventId: '', version: '0.0.0', generatedAt: ''),
      conference: Conference(name: I18nStr({}), conferenceThemes: []),
      conferenceConfig: const ConferenceConfig(
        name: '',
        tagline: '',
        location: '',
        dates: '',
        websiteUrl: '',
        defaultLocale: 'en',
      ),
      theme: ThemeConfig(colors: {}, typography: {}, logo: {}),
      collections: Collections(
        days: [],
        events: [],
        sessionBlocks: [],
        people: [],
        rooms: [],
        submissionTypes: [],
        socials: [],
        news: [],
      ),
    );
  }

  final Metadata metadata;
  final Conference conference;
  final ConferenceConfig conferenceConfig;
  final ThemeConfig theme;
  final Collections collections;
}
