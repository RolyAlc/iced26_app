import 'dart:convert';

import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/collections_mapper.dart';
import 'package:iced26/data/mappers/conference_mapper.dart';
import 'package:iced26/data/mappers/metadata_mapper.dart';
import 'package:iced26/data/mappers/theme_mapper.dart';
import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/domain/entities/collections.dart';

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

  /// Mezcla un payload de schedule plano del portal sobre los datos base del asset.
  ///
  /// El portal expone `events`, `sessionBlocks`, `speakers` y `rooms` en la raíz,
  /// mientras que el asset local usa `collections`.
  static AppData mergeSchedule({
    required AppData base,
    required Map<String, dynamic> scheduleJson,
  }) {
    final scheduleCollections = CollectionsMapper.fromMap(scheduleJson);
    return AppData(
      metadata: base.metadata,
      conference: base.conference,
      theme: base.theme,
      collections: Collections(
        days: base.collections.days,
        events: scheduleCollections.events,
        sessionBlocks: scheduleCollections.sessionBlocks,
        people: scheduleCollections.people,
        rooms: scheduleCollections.rooms,
        zones: base.collections.zones,
        submissionTypes: base.collections.submissionTypes,
        socials: base.collections.socials,
        news: base.collections.news,
      ),
    );
  }
}
