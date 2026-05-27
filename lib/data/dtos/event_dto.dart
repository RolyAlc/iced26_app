import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';

/// DTO para eventos
class EventDTO {
  EventDTO({
    required this.id,
    required this.title,
    this.description,
    this.subtype,
    this.tags = const [],
    this.durationMin,
    this.start,
    this.end,
    this.zoneId,
    this.roomId,
    required this.type,
    this.defaultLang,
    this.filterDate,
    this.filterTime,
    this.speakers = const [],
    this.slotLabel,
    this.parentId,
    this.sessionId,
    this.track,
    this.abstract_,
    this.number,
    this.isSession,
    this.extraRooms = const [],
    this.submissionFormats = const [],
    this.externalRef,
    this.aboutPresentationUrl,
    this.videoPresentationUrl,
  });

  factory EventDTO.fromMap(Map<String, dynamic> json) {
    return EventDTO(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'],
      description: json['description']?.toString(),
      subtype: json['subtype']?.toString(),
      tags: _mapStringList(json['tags']),
      durationMin: (json['durationMin'] as num?)?.toInt(),
      start: json['start']?.toString(),
      end: json['end']?.toString(),
      zoneId: json['zoneId']?.toString(),
      roomId: json['roomId']?.toString(),
      type: json['type']?.toString() ?? '',
      defaultLang: json['defaultLang']?.toString(),
      filterDate: json['filterDate']?.toString(),
      filterTime: json['filterTime']?.toString(),
      speakers: _mapSpeakers(json['speakers']),
      slotLabel: json['slotLabel']?.toString(),
      parentId: json['parentId']?.toString(),
      sessionId:
          json['sessionId']?.toString() ?? json['sessionBlockId']?.toString(),
      track: json['track']?.toString(),
      abstract_: json['abstract'],
      number: json['number']?.toString() ?? json['submissionRef']?.toString(),
      isSession: _mapBool(json['isSession']) ?? _inferIsSession(json),
      extraRooms: _mapStringList(json['extraRooms']),
      submissionFormats: _mapStringList(json['submissionFormats']),
      externalRef: json['externalRef']?.toString(),
      aboutPresentationUrl: json['aboutPresentationUrl']?.toString(),
      videoPresentationUrl: json['videoPresentationUrl']?.toString(),
    );
  }
  final String id;
  final dynamic title;
  final String? description;
  final String? subtype;
  final List<String> tags;
  final int? durationMin;
  final String? start;
  final String? end;
  final String? zoneId;
  final String? roomId;
  final String type;
  final String? defaultLang;
  final String? filterDate;
  final String? filterTime;
  final List<SpeakerEntry> speakers;
  final String? slotLabel;
  final String? parentId;
  final String? sessionId;
  final String? track;
  final dynamic abstract_;
  final String? number;
  final bool? isSession;
  final List<String> extraRooms;
  final List<String> submissionFormats;
  final String? externalRef;
  final String? aboutPresentationUrl;
  final String? videoPresentationUrl;

  Event toEntity() {
    return Event(
      id: id,
      title: I18nMapper.fromRaw(title),
      description: description,
      subtype: subtype,
      tags: tags,
      durationMin: durationMin,
      startDate: _parseDate(start),
      endDate: _parseDate(end),
      zoneId: zoneId,
      roomId: roomId,
      type: EventType.fromString(type),
      defaultLang: defaultLang,
      filterDate: filterDate,
      filterTime: filterTime,
      speakers: speakers,
      slotLabel: slotLabel,
      parentId: parentId,
      sessionId: sessionId,
      track: track,
      abstract_: abstract_ != null ? I18nMapper.fromRaw(abstract_) : null,
      number: number,
      isSession: isSession,
      extraRooms: extraRooms,
      submissionFormats: submissionFormats,
      externalRef: externalRef,
      aboutPresentationUrl: aboutPresentationUrl,
      videoPresentationUrl: videoPresentationUrl,
    );
  }

  /// Helper para mapear listas de speakers
  static List<SpeakerEntry> _mapSpeakers(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(
          (s) => SpeakerEntry(
            personId: s['personId']?.toString() ?? '',
            role: s['role']?.toString(),
          ),
        )
        .where((s) => s.personId.isNotEmpty)
        .toList();
  }

  /// Helper para mapear listas de strings
  static List<String> _mapStringList(dynamic raw) {
    if (raw is! List) return const [];
    return raw.map((e) => e.toString()).toList();
  }

  static bool? _mapBool(dynamic raw) {
    if (raw is bool) {
      return raw;
    }
    if (raw is String) {
      switch (raw.toLowerCase()) {
        case 'true':
          return true;
        case 'false':
          return false;
      }
    }
    return null;
  }

  static bool? _inferIsSession(Map<String, dynamic> json) {
    if (json['sessionBlockId'] != null ||
        json['abstract'] != null ||
        json['submissionRef'] != null) {
      return false;
    }
    return null;
  }

  /// Helper para mapear fechas
  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value)?.toLocal();
  }
}
