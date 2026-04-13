import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/conference.dart';
import 'package:iced26/domain/entities/i18n_str.dart';

/// Mapper para convertir el JSON de la conferencia en una instancia de 'Conference'.
/// Devueleve un objeto 'Conference' con el nombre y la lista de temas.
class ConferenceMapper {
  static Conference fromMap(Map<String, dynamic> json) {
    // Extraemos el nombre de la conferencia, considerando que puede venir como 'name' o 'title'
    final dynamic rawName = json['name'] ?? json['title'];
    final I18nStr nameEntity = I18nMapper.fromRaw(rawName);

    // Extraemos la lista de temas
    final List<dynamic> rawThemes = _ensureList(json['conference_themes']);

    // Convertimos cada elemento de la lista en un 'I18nStr'
    final List<I18nStr> themesList = rawThemes.map((item) {
      return I18nMapper.fromRaw(item);
    }).toList();

    return Conference(name: nameEntity, conferenceThemes: themesList);
  }

  /// Asegura que el valor es una lista, devolviendo una lista vacía si no lo es
  static List<dynamic> _ensureList(dynamic value) {
    if (value is List) {
      return value;
    }
    return [];
  }
}
