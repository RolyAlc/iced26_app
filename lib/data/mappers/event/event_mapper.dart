import 'dart:convert';

import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/data/dtos/event_dto.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';

/// Mapper para eventos
class EventMapper {
  /// Convierte un mapa JSON en una entidad 'Event'.
  static Event fromMap(Map<String, dynamic> json) {
    return EventDTO.fromMap(json).toEntity();
  }

  /// Convierte una instancia de [Event] desde la base de datos (Drift).
  static Event fromDrift(EventTable data) {
    /// Mapeo de speakers
    final List<SpeakerEntry> speakers = data.speakersJson != null
        ? (jsonDecode(data.speakersJson!) as List<dynamic>)
              .whereType<Map<String, dynamic>>()
              .map(
                (s) => SpeakerEntry(
                  personId: s['personId']?.toString() ?? '',
                  role: s['role']?.toString(),
                ),
              )
              .where((s) => s.personId.isNotEmpty)
              .toList()
        : const [];

    /// Mapeo de tags
    final List<String> tags = data.tagsJson != null
        ? (jsonDecode(data.tagsJson!) as List<dynamic>).cast<String>()
        : const [];

    /// Mapeo de salas adicionales
    final List<String> extraRooms = data.extraRoomsJson != null
        ? (jsonDecode(data.extraRoomsJson!) as List<dynamic>).cast<String>()
        : const [];

    /// Mapeo de formatos de submission
    final List<String> submissionFormats = data.submissionFormatsJson != null
        ? (jsonDecode(data.submissionFormatsJson!) as List<dynamic>)
              .cast<String>()
        : const [];

    return Event(
      id: data.id,
      title: data.title,
      description: data.description,
      subtype: data.subtype,
      tags: tags,
      durationMin: data.durationMin,
      startDate: data.startDate,
      endDate: data.endDate,
      zoneId: data.zoneId,
      roomId: data.roomId,
      type: EventType.fromString(data.type),
      defaultLang: data.defaultLang,
      filterDate: data.filterDate,
      filterTime: data.filterTime,
      speakers: speakers,
      slotLabel: data.slotLabel,
      parentId: data.parentId,
      extraRooms: extraRooms,
      submissionFormats: submissionFormats,
      externalRef: data.externalRef,
    );
  }
}
