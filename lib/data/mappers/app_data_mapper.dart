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
    return fromRaw(jsonDecode(source));
  }

  /// Crea un [AppData] a partir de un mapa.
  static AppData fromRaw(dynamic decodedRaw) {
    final Map<String, dynamic> json = decodedRaw is Map<String, dynamic>
        ? decodedRaw
        : const {};
    final metadata = MetadataMapper.fromMap(json.getMap('metadata'));
    final conference = ConferenceMapper.fromMap(json.getMap('conference'));
    final theme = ThemeMapper.fromMap(json.getMap('theme'));
    final collections = CollectionsMapper.fromMap(json.getMap('collections'));

    return AppData(
      metadata: metadata,
      conference: conference,
      theme: theme,
      collections: collections,
    );
  }
}
