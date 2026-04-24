import 'dart:convert';

import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/data/dtos/event_dto.dart';
import 'package:iced26/domain/entities/event.dart';

/// Mapper para convertir el JSON de un evento en una instancia de 'Event'.
class EventMapper {
  static Event fromMap(Map<String, dynamic> json) {
    return EventDTO.fromMap(json).toEntity();
  }

  /// Convierte un registro de la base de datos (Drift) a una entidad.
  static Event fromDrift(EventTable data) {
    final speakerIds = data.speakerIdsJson != null
        ? (jsonDecode(data.speakerIdsJson!) as List<dynamic>).cast<String>()
        : <String>[];
    final tags = data.tagsJson != null
        ? (jsonDecode(data.tagsJson!) as List<dynamic>).cast<String>()
        : <String>[];
    return Event(
      id: data.id,
      title: data.title,
      abstract_: data.subtitle,
      description: data.description,
      subtype: data.subtype,
      track: data.track,
      tags: tags,
      durationMin: data.durationMin,
      startDate: data.startDate,
      endDate: data.endDate,
      zoneId: data.zoneId,
      roomId: data.roomId,
      type: data.type,
      lang: data.lang,
      filterDate: data.filterDate,
      filterTime: data.filterTime,
      speakerIds: speakerIds,
      aboutPresentationUrl: data.aboutPresentationUrl,
      videoPresentationUrl: data.videoPresentationUrl,
    );
  }
}
