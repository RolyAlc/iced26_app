import 'package:iced26/data/dtos/event_dto.dart';
import 'package:iced26/data/mappers/json_parsers.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';

/// Mapper para [Event]
abstract final class EventMapper {
  /// Crea un [Event] a partir de un mapa
  static Event fromMap(Map<String, dynamic> json) {
    return EventDTO.fromMap(json).toEntity();
  }

  /// Crea un [Event] a partir de [EventTable]
  static Event fromDrift(EventTable data) {
    return Event(
      id: data.id,
      title: data.title,
      description: data.description,
      subtype: data.subtype,
      tags: JsonParsers.parseStringList(data.tagsJson),
      durationMin: data.durationMin,
      startDate: data.startDate,
      endDate: data.endDate,
      zoneId: data.zoneId,
      roomId: data.roomId,
      type: EventType.fromString(data.type),
      defaultLang: data.defaultLang,
      filterDate: data.filterDate,
      filterTime: data.filterTime,
      speakers: JsonParsers.parseSpeakers(data.speakersJson),
      slotLabel: data.slotLabel,
      parentId: data.parentId,
      sessionId: data.sessionId,
      track: data.track,
      abstract_: data.abstract_,
      number: data.number,
      isSession: data.isSession,
      extraRooms: JsonParsers.parseStringList(data.extraRoomsJson),
      submissionFormats: JsonParsers.parseStringList(
        data.submissionFormatsJson,
      ),
      externalRef: data.externalRef,
      aboutPresentationUrl: data.aboutPresentationUrl,
      videoPresentationUrl: data.videoPresentationUrl,
    );
  }
}
