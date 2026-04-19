import 'dart:convert';

import 'package:iced26/data/mappers/collections_mapper.dart';
import 'package:iced26/data/mappers/conference_mapper.dart';
import 'package:iced26/data/mappers/metadata_mapper.dart';
import 'package:iced26/data/mappers/theme_mapper.dart';
import 'package:iced26/domain/entities/app_data.dart';

/// Mapper para convertir el JSON de la aplicación en una instancia de AppData.
class AppDataMapper {
  /// Convierte un string JSON en una instancia de AppData.
  static AppData fromJsonString(String source) {
    return fromRaw(jsonDecode(source));
  }

  /// Convierte un objeto dinámico en una instancia de AppData.
  static AppData fromRaw(dynamic decodedRaw) {
    final Map<String, dynamic> jsonMap = _castToMap(decodedRaw);
    final metadataMap = _castToMap(jsonMap['metadata']);
    final conferenceMap = _castToMap(jsonMap['conference']);
    final themeMap = _castToMap(jsonMap['theme']);
    final collectionsMap = _castToMap(jsonMap['collections']);

    return AppData(
      metadata: MetadataMapper.fromMap(metadataMap),
      conference: ConferenceMapper.fromMap(conferenceMap),
      theme: ThemeMapper.fromMap(themeMap),
      collections: CollectionsMapper.fromMap(collectionsMap),
    );
  }

  /// Convierte un objeto dinámico a un mapa de strings y dinámicos.
  static Map<String, dynamic> _castToMap(dynamic value) {
    if (value != null && value is Map<String, dynamic>) {
      return value;
    }
    return <String, dynamic>{};
  }
}
