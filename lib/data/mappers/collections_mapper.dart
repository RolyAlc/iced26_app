import 'package:iced26/data/mappers/day_mapper.dart';
import 'package:iced26/data/mappers/event/event_mapper.dart';
import 'package:iced26/data/mappers/home/news_mapper.dart';
import 'package:iced26/data/mappers/person_mapper.dart';
import 'package:iced26/data/mappers/presentation/presentation_mapper.dart';
import 'package:iced26/data/mappers/room_mapper.dart';
import 'package:iced26/data/mappers/home/social_activity_mapper.dart';
import 'package:iced26/data/mappers/session_block/session_block_mapper.dart';
import 'package:iced26/data/mappers/submission_type_mapper.dart';
import 'package:iced26/data/mappers/zone_mapper.dart';
import 'package:iced26/domain/entities/collections.dart';

/// Mapper para colecciones de datos
class CollectionsMapper {
  static Collections fromMap(Map<String, dynamic> map) {
    final List rawDays = map['days'] ?? [];
    final List rawEvents = map['programSlots'] ?? [];
    final List rawSessionBlocks = map['sessionBlocks'] ?? [];
    final List rawPresentations = map['presentations'] ?? [];
    final List rawPeople = map['people'] ?? [];
    final List rawRooms = map['rooms'] ?? [];
    final List rawZones = map['zones'] ?? [];
    final List rawSubTypes = map['submissionTypes'] ?? [];
    final List rawSocials = map['socials'] ?? [];
    final List rawNews = map['news'] ?? [];

    return Collections(
      days: _toListOf(rawDays, DayMapper.fromMap),
      events: _toListOf(rawEvents, EventMapper.fromMap),
      sessionBlocks: _toListOf(rawSessionBlocks, SessionBlockMapper.fromMap),
      presentations: _toListOf(rawPresentations, PresentationMapper.fromMap),
      people: _toListOf(rawPeople, PeopleMapper.fromMap),
      rooms: _toListOf(rawRooms, RoomMapper.fromMap),
      zones: _toListOf(rawZones, ZoneMapper.fromMap),
      submissionTypes: _toListOf(rawSubTypes, SubmissionTypeMapper.fromMap),
      socials: _toListOf(rawSocials, SocialActivityMapper.fromMap),
      news: _toListOf(rawNews, NewsMapper.fromMap),
    );
  }

  /// Helper para mapear listas de entidades
  static List<T> _toListOf<T>(
    List rawList,
    T Function(Map<String, dynamic>) mapper,
  ) {
    return rawList.map((item) => mapper(_castToMap(item))).toList();
  }

  /// Helper para castear items a mapas
  static Map<String, dynamic> _castToMap(dynamic item) {
    if (item is Map<String, dynamic>) {
      return item;
    }
    return <String, dynamic>{};
  }
}
