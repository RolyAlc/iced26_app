import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/day_mapper.dart';
import 'package:iced26/data/mappers/event/event_mapper.dart';
import 'package:iced26/data/mappers/home/news_mapper.dart';
import 'package:iced26/data/mappers/home/social_activity_mapper.dart';
import 'package:iced26/data/mappers/person_mapper.dart';
import 'package:iced26/data/mappers/room_mapper.dart';
import 'package:iced26/data/mappers/session_block/session_block_mapper.dart';
import 'package:iced26/data/mappers/submission_type_mapper.dart';
import 'package:iced26/data/mappers/zone_mapper.dart';
import 'package:iced26/domain/entities/collections.dart';

abstract final class CollectionsMapper {
  static Collections fromMap(Map<String, dynamic> map) {
    final people =
        map.getList('people').isNotEmpty
            ? map.getList('people')
            : map.getList('speakers');
    final eventMaps = [
      ...map.getList('programSlots'),
      ...map.getList('events'),
      ...map.getList('presentations'),
    ];

    return Collections(
      days: _toListOf(map.getList('days'), DayMapper.fromMap),
      events: _toListOf(eventMaps, EventMapper.fromMap),
      sessionBlocks: _toListOf(
        map.getList('sessionBlocks'),
        SessionBlockMapper.fromMap,
      ),
      people: _toListOf(people, PersonMapper.fromMap),
      rooms: _toListOf(map.getList('rooms'), RoomMapper.fromMap),
      zones: _toListOf(map.getList('zones'), ZoneMapper.fromMap),
      submissionTypes: _toListOf(
        map.getList('submissionTypes'),
        SubmissionTypeMapper.fromMap,
      ),
      socials: _toListOf(map.getList('socials'), SocialActivityMapper.fromMap),
      news: _toListOf(map.getList('news'), NewsMapper.fromMap),
    );
  }

  static List<T> _toListOf<T>(
    List raw,
    T Function(Map<String, dynamic>) mapper,
  ) {
    return raw.whereType<Map<String, dynamic>>().map(mapper).toList();
  }
}
