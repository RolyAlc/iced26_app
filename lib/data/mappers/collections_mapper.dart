import 'package:iced26/data/mappers/day_mapper.dart';
import 'package:iced26/data/mappers/event_mapper.dart';
import 'package:iced26/data/mappers/person_mapper.dart';
import 'package:iced26/data/mappers/room_mapper.dart';
import 'package:iced26/data/mappers/submission_type_mapper.dart';
import 'package:iced26/data/mappers/zone_mapper.dart';
import 'package:iced26/domain/entities/collections.dart';

/// Mapper para convertir el JSON de las colecciones en una instancia de Collections
class CollectionsMapper {
  static Collections fromMap(Map<String, dynamic> json) {
    return Collections(
      days: _parseList(json['days'], (item) => DayMapper.fromMap(item)),
      events: _parseList(json['events'], (item) => EventMapper.fromMap(item)),
      people: _parseList(json['people'], (item) => PersonMapper.fromMap(item)),
      rooms: _parseList(json['rooms'], (item) => RoomMapper.fromMap(item)),
      zones: _parseList(json['zones'], (item) => ZoneMapper.fromMap(item)),
      submissionTypes: _parseList(
        json['submission_types'],
        (item) => SubmissionTypeMapper.fromMap(item),
      ),
    );
  }

  /// Procesa cualquier lista del JSON, aplicando el mapper correspondiente a cada elemento
  static List<T> _parseList<T>(
    dynamic rawList,
    T Function(Map<String, dynamic>) mapper,
  ) {
    if (rawList is! List) return [];

    return rawList.map((item) => mapper(_ensureMap(item))).toList();
  }

  static Map<String, dynamic> _ensureMap(dynamic item) {
    if (item is Map<String, dynamic>) return item;
    return {};
  }
}
