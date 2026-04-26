import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/zone.dart';

/// Mapper para convertir el JSON de una zona en una instancia de 'Zone'.
class ZoneMapper {
  static Zone fromMap(Map<String, dynamic> json) {
    final String id = json['id']?.toString() ?? '';
    final I18nStr name = I18nMapper.fromRaw(json['name']);
    final String lang = json['lang']?.toString() ?? '';
    final I18nStr description = I18nMapper.fromRaw(json['description']);

    return Zone(id: id, name: name, lang: lang, description: description);
  }

  static Zone fromDrift(ZoneTable data) {
    return Zone(
      id: data.id,
      name: I18nStr({'und': data.name}),
      lang: data.lang,
      description: data.description ?? I18nStr({}),
    );
  }
}
