import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/room.dart';

/// Mapper para convertir el JSON de una sala en una instancia de 'Room'.
class RoomMapper {
  /// Convierte un mapa JSON en una entidad 'Room'.
  static Room fromMap(Map<String, dynamic> json) {
    final String id = json['id']?.toString() ?? '';
    final I18nStr name = I18nMapper.fromRaw(json['name'] ?? json['title']);
    final dynamic rawCapacity = json['capacity'];
    final String? zoneId = json['zoneId']?.toString();
    final String? sessionStyle = json['sessionStyle']?.toString();

    return Room(
      id: id,
      name: name,
      capacity: rawCapacity is int ? rawCapacity : int.tryParse('$rawCapacity'),
      zoneId: zoneId,
      sessionStyle: sessionStyle,
    );
  }

  /// Convierte un registro de la base de datos (Drift) a una entidad.
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
