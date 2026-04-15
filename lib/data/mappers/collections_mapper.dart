import 'package:iced26/data/mappers/day_mapper.dart';
import 'package:iced26/data/mappers/event_mapper.dart';
import 'package:iced26/data/mappers/news_mapper.dart';
import 'package:iced26/data/mappers/person_mapper.dart';
import 'package:iced26/data/mappers/room_mapper.dart';
import 'package:iced26/data/mappers/social_activity_mapper.dart';
import 'package:iced26/data/mappers/submission_type_mapper.dart';
import 'package:iced26/data/mappers/zone_mapper.dart';
import 'package:iced26/domain/entities/collections.dart';

class CollectionsMapper {
  static Collections fromMap(Map<String, dynamic> map) {
    final List rawDays = map['days'] ?? [];
    final List rawEvents = map['events'] ?? [];
    final List rawPeople = map['people'] ?? [];
    final List rawRooms = map['rooms'] ?? [];
    final List rawZones = map['zones'] ?? [];
    final List rawSubTypes = map['submission_types'] ?? [];
    final List rawSocials = map['socials'] ?? [];
    final List rawNews = map['news'] ?? [];

    return Collections(
      days: _toListOf(rawDays, DayMapper.fromMap),
      events: _toListOf(rawEvents, EventMapper.fromMap),
      people: _toListOf(rawPeople, PersonMapper.fromMap),
      rooms: _toListOf(rawRooms, RoomMapper.fromMap),
      zones: _toListOf(rawZones, ZoneMapper.fromMap),
      submissionTypes: _toListOf(rawSubTypes, SubmissionTypeMapper.fromMap),
      socials: _toListOf(rawSocials, SocialActivityMapper.fromMap),
      news: _toListOf(rawNews, NewsMapper.fromMap),
    );
  }

  static List<T> _toListOf<T>(
    List rawList,
    T Function(Map<String, dynamic>) mapper,
  ) {
    return rawList.map((item) => mapper(_castToMap(item))).toList();
  }

  static Map<String, dynamic> _castToMap(dynamic item) {
    if (item is Map<String, dynamic>) {
      return item;
    }
    return <String, dynamic>{};
  }
}
