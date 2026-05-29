import 'dart:convert';

import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/collections_mapper.dart';
import 'package:iced26/data/mappers/conference_mapper.dart';
import 'package:iced26/data/mappers/metadata_mapper.dart';
import 'package:iced26/data/mappers/theme_mapper.dart';
import 'package:iced26/domain/entities/app_data.dart';

/// Mapper para AppData.
abstract final class AppDataMapper {
  /// Crea un [AppData] a partir de un json string.
  static AppData fromJsonString(String source) {
    return fromMap(jsonDecode(source) as Map<String, dynamic>);
  }

  /// Crea un [AppData] a partir de un mapa ya decodificado.
  static AppData fromMap(Map<String, dynamic> json) {
    final configMap = json.getMap('config');
    final collectionsMap = json.getMap('collections');

    final metadata = MetadataMapper.fromMap(json.getMap('metadata'));
    final theme = ThemeMapper.fromMap(configMap.getMap('theme'));
    final collections = CollectionsMapper.fromMap(collectionsMap);
    final conference = ConferenceMapper.fromSplitMaps(
      config: configMap.getMap('conference'),
      rawThemes: collectionsMap.getList('conferenceThemes'),
    );

    return AppData(
      metadata: metadata,
      conference: conference,
      theme: theme,
      collections: collections,
    );
  }
}
