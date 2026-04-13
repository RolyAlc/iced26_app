import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/room.dart';

/// Mapper para convertir el JSON de una sala en una instancia de 'Room'.
class RoomMapper {
  static Room fromMap(Map<String, dynamic> json) {
    final dynamic rawCapacity = json['capacity'];

    return Room(
      id: json['id']?.toString() ?? '',
      name: I18nMapper.fromRaw(json['name'] ?? json['title']),
      capacity: rawCapacity is int ? rawCapacity : int.tryParse('$rawCapacity'),
      zoneId: (json['zoneId'] ?? json['zone_id'])?.toString(),
      sessionStyle: json['session_style']?.toString(),
    );
  }
}
