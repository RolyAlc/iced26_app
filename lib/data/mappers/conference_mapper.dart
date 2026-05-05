import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/conference.dart';
import 'package:iced26/domain/entities/i18n_str.dart';

/// Mapper para convertir el JSON de la conferencia en una instancia de 'Conference'.
class ConferenceMapper {
  /// Convierte un mapa JSON en una entidad 'Conference'.
  static Conference fromMap(Map<String, dynamic> json) {
    final dynamic rawName = json['name'] ?? json['title'];
    final I18nStr nameEntity = I18nMapper.fromRaw(rawName);
    final List<dynamic> rawThemes = _ensureList(json['conferenceThemes']);
    final List<I18nStr> themesList = rawThemes.map((item) {
      return I18nMapper.fromRaw(item);
    }).toList();

    return Conference(name: nameEntity, conferenceThemes: themesList);
  }

  /// Helper para asegurar que el valor es una lista
  static List<dynamic> _ensureList(dynamic value) {
    if (value is List) {
      return value;
    }
    return [];
  }
}
