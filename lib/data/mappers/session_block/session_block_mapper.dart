import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/mappers/json_parsers.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/session_block.dart';

/// Mapper para [SessionBlock]
abstract final class SessionBlockMapper {
  /// Crea un [SessionBlock] a partir de un mapa
  static SessionBlock fromMap(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final start = _resolveDateTime(
      date: json['date']?.toString(),
      primary: json['start']?.toString(),
      fallback: json['startTime']?.toString(),
    );
    final end = _resolveDateTime(
      date: json['date']?.toString(),
      primary: json['end']?.toString(),
      fallback: json['endTime']?.toString(),
    );

    return SessionBlock(
      id: id,
      parentId:
          json['parentId']?.toString() ?? json['sessionId']?.toString() ?? id,
      roomId: json['roomId']?.toString(),
      track: json['track']?.toString() ?? json['kind']?.toString(),
      title: json['title'] != null ? I18nMapper.fromRaw(json['title']) : null,
      startDate: JsonParsers.parseDate(start),
      endDate: JsonParsers.parseDate(end),
      submissionFormats: JsonParsers.rawStringList(json['submissionFormats']),
      defaultLang: json['defaultLang']?.toString(),
      externalRef: json['externalRef']?.toString(),
      number: (json['number'] as num?)?.toInt(),
      description: json['description']?.toString(),
      chairs: JsonParsers.rawStringList(json['chairs']),
    );
  }

  /// Crea un [SessionBlock] a partir de [SessionBlockTable]
  static SessionBlock fromDrift(SessionBlockTable data) {
    return SessionBlock(
      id: data.id,
      parentId: data.parentId,
      roomId: data.roomId,
      track: data.track,
      title: data.title,
      startDate: data.startDate,
      endDate: data.endDate,
      submissionFormats: JsonParsers.parseStringList(
        data.submissionFormatsJson,
      ),
      defaultLang: data.defaultLang,
      externalRef: data.externalRef,
      number: data.number,
      description: data.description,
      chairs: JsonParsers.parseStringList(data.chairsJson),
    );
  }

  static String? _resolveDateTime({
    required String? date,
    required String? primary,
    required String? fallback,
  }) {
    final directValue = primary ?? fallback;
    if (directValue == null || directValue.isEmpty) return null;
    if (DateTime.tryParse(directValue) != null) return directValue;
    if (date == null || date.isEmpty) return null;
    return '${date}T$directValue';
  }
}
