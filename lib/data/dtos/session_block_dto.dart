import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/session_block.dart';

/// DTO para bloques de sesiones
class SessionBlockDTO {
  SessionBlockDTO({
    required this.id,
    required this.parentId,
    this.roomId,
    this.track,
    this.title,
    this.start,
    this.end,
    this.submissionFormats = const [],
    this.defaultLang,
    this.externalRef,
  });

  factory SessionBlockDTO.fromMap(Map<String, dynamic> json) {
    final List<String> formats = _mapStringList(json['submissionFormats']);

    return SessionBlockDTO(
      id: json['id']?.toString() ?? '',
      parentId: json['parentId']?.toString() ?? '',
      roomId: json['roomId']?.toString(),
      track: json['track']?.toString(),
      title: json['title'],
      start: json['start']?.toString(),
      end: json['end']?.toString(),
      submissionFormats: formats,
      defaultLang: json['defaultLang']?.toString(),
      externalRef: json['externalRef']?.toString(),
    );
  }
  final String id;
  final String parentId;
  final String? roomId;
  final String? track;
  final dynamic title;
  final String? start;
  final String? end;
  final List<String> submissionFormats;
  final String? defaultLang;
  final String? externalRef;

  SessionBlock toEntity() {
    return SessionBlock(
      id: id,
      parentId: parentId,
      roomId: roomId,
      track: track,
      title: title != null ? I18nMapper.fromRaw(title) : null,
      startDate: _parseDate(start),
      endDate: _parseDate(end),
      submissionFormats: submissionFormats,
      defaultLang: defaultLang,
      externalRef: externalRef,
    );
  }

  /// Helper para mapear listas de strings
  static List<String> _mapStringList(dynamic raw) {
    if (raw is! List) {
      return const [];
    }
    return raw.map((e) => e.toString()).toList();
  }

  /// Helper para mapear fechas
  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value)?.toLocal();
  }
}
