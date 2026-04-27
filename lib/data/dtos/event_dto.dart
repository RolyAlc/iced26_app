import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';

/// DTO para el evento de la conferencia.
class EventDTO {
  final String id;
  final dynamic title;
  final dynamic abstract_;
  final String? description;
  final String? subtype;
  final String? track;
  final List<String> tags;
  final int? durationMin;
  final String? start;
  final String? end;
  final String? zoneId;
  final String? roomId;
  final String type;
  final String? lang;
  final String? filterDate;
  final String? filterTime;
  final List<String> speakerIds;
  final String? aboutPresentationUrl;
  final String? videoPresentationUrl;

  EventDTO({
    required this.id,
    required this.title,
    this.abstract_,
    this.description,
    this.subtype,
    this.track,
    this.tags = const [],
    this.durationMin,
    this.start,
    this.end,
    this.zoneId,
    this.roomId,
    required this.type,
    this.lang,
    this.filterDate,
    this.filterTime,
    this.speakerIds = const [],
    this.aboutPresentationUrl,
    this.videoPresentationUrl,
  });

  /// Crea un DTO mapeando las claves del JSON.
  factory EventDTO.fromMap(Map<String, dynamic> json) {
    final List<String> speakerIds = _mapSpeakerIds(json);
    final List<String> tags = _mapTags(json);

    return EventDTO(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'],
      abstract_: json['abstract'],
      description: json['description']?.toString(),
      subtype: json['subtype']?.toString(),
      track: json['track']?.toString(),
      tags: tags,
      durationMin: (json['duration_min'] as num?)?.toInt(),
      start: (json['start'] ?? json['startDate'])?.toString(),
      end: (json['end'] ?? json['endDate'])?.toString(),
      zoneId: (json['zoneId'] ?? json['zone_id'])?.toString(),
      roomId: (json['roomId'] ?? json['room_id'])?.toString(),
      type: json['type']?.toString() ?? '',
      lang: json['lang']?.toString(),
      filterDate: json['filter_date']?.toString(),
      filterTime: json['filter_time']?.toString(),
      speakerIds: speakerIds,
      aboutPresentationUrl: json['about_presentation_url']?.toString(),
      videoPresentationUrl: json['video_presentation_url']?.toString(),
    );
  }

  /// Convierte el DTO a la entidad de Dominio.
  Event toEntity() {
    final DateTime? startDate = _parseDate(start);
    final DateTime? endDate = _parseDate(end);

    return Event(
      id: id,
      title: I18nMapper.fromRaw(title),
      abstract_: abstract_ != null ? I18nMapper.fromRaw(abstract_) : null,
      description: description,
      subtype: subtype,
      track: track,
      tags: tags,
      durationMin: durationMin,
      startDate: startDate,
      endDate: endDate,
      zoneId: zoneId,
      roomId: roomId,
      type: EventType.fromString(type),
      lang: lang,
      filterDate: filterDate,
      filterTime: filterTime,
      speakerIds: speakerIds,
      aboutPresentationUrl: aboutPresentationUrl,
      videoPresentationUrl: videoPresentationUrl,
    );
  }

  /// Mapea los speakers del JSON a una lista de IDs válidos.
  static List<String> _mapSpeakerIds(Map<String, dynamic> json) {
    final rawSpeakers = json['speakers'] as List<dynamic>? ?? [];

    final List<String> result = [];

    for (final speaker in rawSpeakers) {
      final id = speaker['personId']?.toString();

      if (id != null && id.isNotEmpty) {
        result.add(id);
      }
    }

    return result;
  }

  /// Mapea los tags del JSON a lista de strings.
  static List<String> _mapTags(Map<String, dynamic> json) {
    final rawTags = json['tags'] as List<dynamic>? ?? [];

    final List<String> result = [];

    for (final tag in rawTags) {
      result.add(tag.toString());
    }

    return result;
  }

  /// Parsea una fecha y la convierte a la hora local.
  static DateTime? _parseDate(String? value) {
    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return null;
    }

    final DateTime? parsed = DateTime.tryParse(value);

    if (parsed == null) {
      return null;
    }

    return parsed.toLocal();
  }
}
