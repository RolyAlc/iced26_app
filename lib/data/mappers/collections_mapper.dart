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
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/session_block.dart';

abstract final class CollectionsMapper {
  static Collections fromMap(Map<String, dynamic> map) {
    final people = map.getList('people').isNotEmpty
        ? map.getList('people')
        : map.getList('speakers');
    final sessionBlocks = _toListOf(
      map.getList('sessionBlocks'),
      SessionBlockMapper.fromMap,
    );
    final eventMaps = [
      ...map.getList('programSlots'),
      ...map.getList('events'),
      ...map.getList('presentations'),
    ];
    final events = _inheritSessionBlockTimes(
      _toListOf(eventMaps, EventMapper.fromMap),
      sessionBlocks,
    );

    return Collections(
      days: _toListOf(map.getList('days'), DayMapper.fromMap),
      events: events,
      sessionBlocks: sessionBlocks,
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

  static List<Event> _inheritSessionBlockTimes(
    List<Event> events,
    List<SessionBlock> sessionBlocks,
  ) {
    if (events.isEmpty || sessionBlocks.isEmpty) {
      return events;
    }

    final blocksById = {for (final block in sessionBlocks) block.id: block};

    return events.map((event) {
      final sessionId = event.sessionId;
      if (sessionId == null) {
        return event;
      }

      final block = blocksById[sessionId];
      if (block == null || !_needsSessionBlockTime(event)) {
        return event;
      }

      return event.copyWith(
        startDate: block.startDate,
        endDate: block.endDate,
        roomId: event.roomId ?? block.roomId,
        filterDate: _formatFilterDate(block.startDate) ?? event.filterDate,
        filterTime: _formatFilterTime(block.startDate, block.endDate),
      );
    }).toList();
  }

  static bool _needsSessionBlockTime(Event event) {
    final start = event.startDate;
    final end = event.endDate;
    if (start == null || end == null) {
      return true;
    }

    final isPlaceholderTime =
        start.hour == 0 &&
        start.minute == 0 &&
        end.hour == 0 &&
        end.minute == 0;

    return isPlaceholderTime;
  }

  static String? _formatFilterDate(DateTime? value) {
    return value?.toIso8601String().split('T').first;
  }

  static String? _formatFilterTime(DateTime? start, DateTime? end) {
    if (start == null) {
      return null;
    }

    final startLabel = _formatTime(start);
    if (end == null) {
      return startLabel;
    }

    return '$startLabel–${_formatTime(end)}';
  }

  static String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
