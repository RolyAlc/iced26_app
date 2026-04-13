import 'dart:convert';
import 'package:iced26/data/mappers/collections_mapper.dart';
import 'package:iced26/data/mappers/conference_mapper.dart';
import 'package:iced26/data/mappers/metadata_mapper.dart';
import 'package:iced26/data/mappers/theme_mapper.dart';
import 'package:iced26/domain/entities/app_data.dart';

/// Mapper para convertir el JSON de la aplicación en una instancia de AppData
class AppDataMapper {
  static AppData fromJsonString(String source) {
    final dynamic decoded = jsonDecode(source);
    final Map<String, dynamic> jsonMap = _ensureMap(decoded);

    return AppData(
      metadata: MetadataMapper.fromMap(_ensureMap(jsonMap['metadata'])),
      conference: ConferenceMapper.fromMap(_ensureMap(jsonMap['conference'])),
      theme: ThemeMapper.fromMap(_ensureMap(jsonMap['theme'])),
      collections: CollectionsMapper.fromMap(
        _ensureMap(jsonMap['collections']),
      ),
    );
  }

  static Map<String, dynamic> _ensureMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return {};
  }
}
