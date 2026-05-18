import 'dart:convert';

import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/collections_mapper.dart';
import 'package:iced26/data/mappers/conference_mapper.dart';
import 'package:iced26/data/mappers/metadata_mapper.dart';
import 'package:iced26/data/mappers/theme_mapper.dart';
import 'package:iced26/domain/entities/app_data.dart';

// TODO: Revisar unificación

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

    final configMap = json.getMap('config');
    final collectionsMap = json.getMap('collections');

    final metadata = MetadataMapper.fromMap(json.getMap('metadata'));
    final theme = ThemeMapper.fromMap(configMap.getMap('theme'));
    final collections = CollectionsMapper.fromMap(collectionsMap);

    // El JSON tiene dos fuentes para ConferenceMapper:
    //   config.conference   → { "name": "...", ... }     (metadatos de la conferencia)
    //   collections.conferenceThemes → [ {...}, ... ]    (lista de temas)
    // Se mezclan aquí para que ConferenceMapper reciba un único mapa uniforme.
    final conferenceJson = <String, dynamic>{
      ...configMap.getMap('conference'),
      'conferenceThemes': collectionsMap.getList('conferenceThemes'),
    };
    final conference = ConferenceMapper.fromMap(conferenceJson);

    return AppData(
      metadata: metadata,
      conference: conference,
      theme: theme,
      collections: collections,
    );
  }
}
