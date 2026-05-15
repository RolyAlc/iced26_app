import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/zone.dart';

/// Mapper para [Zone]
abstract final class ZoneMapper {
  /// Crea un [Zone] a partir de un mapa
  static Zone fromMap(Map<String, dynamic> json) {
    final id = json.getString('id');
    final name = I18nMapper.fromRaw(json['name']);
    final lang = json.getString('lang');
    final description = I18nMapper.fromRaw(json['description']);

    return Zone(id: id, name: name, lang: lang, description: description);
  }

  /// Crea un [Zone] a partir de [ZoneTable]
  static Zone fromDrift(ZoneTable data) {
    return Zone(
      id: data.id,
      name: I18nStr({'und': data.name}),
      lang: data.lang,
      description: data.description ?? I18nStr({}),
    );
  }

  /// Resuelve el nombre de la zona
  static String resolveDisplayName(Zone zone) {
    final und = zone.name.resolve('und');
    return und.isNotEmpty ? und : zone.name.resolve('en');
  }
}
