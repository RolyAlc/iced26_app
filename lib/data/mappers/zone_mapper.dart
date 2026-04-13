import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/zone.dart';

/// Mapper para convertir el JSON de una zona en una instancia de 'Zone'.
/// Devuelve un objeto 'Zone' con los campos correctamente parseados.
class ZoneMapper {
  static Zone fromMap(Map<String, dynamic> json) {
    return Zone(
      id: json['id']?.toString() ?? '',
      name: I18nMapper.fromRaw(json['name']),
      lang: json['lang']?.toString(),
      description: I18nMapper.fromRaw(json['description']),
    );
  }
}
