import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/room.dart';

/// Mapper para convertir el JSON de una sala en una instancia de 'Room'.
class RoomMapper {
  static Room fromMap(Map<String, dynamic> json) {
    final String id = json['id']?.toString() ?? '';
    final I18nStr name = I18nMapper.fromRaw(json['name'] ?? json['title']);
    final dynamic rawCapacity = json['capacity'];
    final String? zoneId = (json['zoneId'] ?? json['zone_id'])?.toString();
    final String? sessionStyle = json['session_style']?.toString();

    return Room(
      id: id,
      name: name,
      capacity: rawCapacity is int ? rawCapacity : int.tryParse('$rawCapacity'),
      zoneId: zoneId,
      sessionStyle: sessionStyle,
    );
  }
}
