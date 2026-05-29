import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/room.dart';

/// Mapper para [Room]
abstract final class RoomMapper {
  /// Crea un [Room] a partir de un mapa
  static Room fromMap(Map<String, dynamic> json) {
    final id = json.getString('id');
    final name = I18nMapper.fromRaw(json['name'] ?? json['title']);
    final capacity = json.getInt('capacity');
    final zoneId = json.getStringOrNull('zoneId');
    final sessionStyle = json.getStringOrNull('sessionStyle');

    return Room(
      id: id,
      name: name,
      capacity: capacity,
      zoneId: zoneId,
      sessionStyle: sessionStyle,
    );
  }

  /// Crea un [Room] a partir de [RoomTable]
  static Room fromDrift(RoomTable data) {
    return Room(
      id: data.id,
      name: data.name,
      capacity: data.capacity,
      zoneId: data.zoneId,
      sessionStyle: data.sessionStyle,
    );
  }
}
