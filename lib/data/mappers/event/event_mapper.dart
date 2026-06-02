import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/mappers/json_parsers.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';

/// Mapper para [Event]
abstract final class EventMapper {
  /// Crea un [Event] a partir de un mapa
  static Event fromMap(Map<String, dynamic> json) {
    final start = json['start']?.toString() ?? json['startDate']?.toString();
    final end = json['end']?.toString() ?? json['endDate']?.toString();
    final type = json['type']?.toString() ?? _inferTypeFromKind(json);
    final isSession = _mapBool(json['isSession']) ?? _inferIsSession(json);

    return Event(
      id: json['id']?.toString() ?? '',
      title: I18nMapper.fromRaw(json['title'] ?? json['name']),
      description: json['description']?.toString(),
      subtype: json['subtype']?.toString(),
      tags: JsonParsers.rawStringList(json['tags']),
      durationMin:
          (json['durationMin'] as num?)?.toInt() ??
          (json['duration'] as num?)?.toInt(),
      startDate: JsonParsers.parseDate(start),
      endDate: JsonParsers.parseDate(end),
      zoneId: json['zoneId']?.toString(),
      roomId: json['roomId']?.toString(),
      type: EventType.fromString(type),
      defaultLang: json['defaultLang']?.toString(),
      filterDate:
          json['filterDate']?.toString() ??
          _buildFilterDate(start, json['date']?.toString()),
      filterTime:
          json['filterTime']?.toString() ?? _buildFilterTime(start, end),
      speakers: JsonParsers.rawSpeakers(json['speakers'] ?? json['authors']),
      slotLabel: json['slotLabel']?.toString(),
      parentId: json['parentId']?.toString(),
      sessionId:
          json['sessionId']?.toString() ?? json['sessionBlockId']?.toString(),
      track: json['track']?.toString(),
      abstract_: json['abstract'] != null
          ? I18nMapper.fromRaw(json['abstract'])
          : null,
      number: json['number']?.toString() ?? json['submissionRef']?.toString(),
      isSession: isSession,
      extraRooms: JsonParsers.rawStringList(json['extraRooms']),
      submissionFormats: JsonParsers.rawStringList(json['submissionFormats']),
      externalRef: json['externalRef']?.toString(),
      aboutPresentationUrl: json['aboutPresentationUrl']?.toString(),
      videoPresentationUrl: json['videoPresentationUrl']?.toString(),
    );
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

  static bool? _mapBool(dynamic raw) {
    if (raw is bool) return raw;
    if (raw is String) {
      return switch (raw.toLowerCase()) {
        'true' => true,
        'false' => false,
        _ => null,
      };
    }
    return null;
  }

  static String _inferTypeFromKind(Map<String, dynamic> json) {
    final kind = json['kind']?.toString();
    final hasAbstract = json['abstract'] != null;
    final isSession = _mapBool(json['isSession']);

    return switch (kind) {
      'sessions' => 'sessions',
      'panel' => _inferPanelType(json['title']?.toString()),
      'empty' => 'break',
      null when hasAbstract => 'paper',
      null when isSession == true => 'sessions',
      _ => '',
    };
  }

  static String _inferPanelType(String? title) {
    if (title == null) return 'sessions';
    final t = title.toLowerCase();
    if (t.startsWith('keynote')) {
      return 'keynote_speaker';
    }
    if (t.startsWith('international panel')) return 'international_panel';
    if (t.contains("presidents'") || t.contains('presidents')) {
      return 'presidents';
    }
    if (t.startsWith('opening')) return 'opening';
    if (t.startsWith('closing')) return 'closing';
    return 'sessions';
  }

  static bool? _inferIsSession(Map<String, dynamic> json) {
    if (json['sessionBlockId'] != null ||
        json['abstract'] != null ||
        json['submissionRef'] != null) {
      return false;
    }
    return null;
  }

  static String? _buildFilterDate(String? start, String? fallbackDate) {
    final startDate = JsonParsers.parseDate(start);
    if (startDate != null) {
      return startDate.toIso8601String().split('T').first;
    }
    return fallbackDate;
  }

  static String? _buildFilterTime(String? start, String? end) {
    return JsonParsers.formatFilterTime(
      JsonParsers.parseDate(start),
      JsonParsers.parseDate(end),
    );
  }
}
