import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';

/// DTO para el evento de la conferencia.
class EventDTO {
  final String id;
  final dynamic title;
  final dynamic subtitle;
  final String? start;
  final String? end;
  final String? zoneId;
  final String? roomId;
  final String type;
  final String? lang;
  final String? filterDate;
  final String? filterTime;

  EventDTO({
    required this.id,
    required this.title,
    this.subtitle,
    this.start,
    this.end,
    this.zoneId,
    this.roomId,
    required this.type,
    this.lang,
    this.filterDate,
    this.filterTime,
  });

  /// Crea un DTO mapeando las claves del JSON.
  factory EventDTO.fromMap(Map<String, dynamic> json) {
    return EventDTO(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'],
      subtitle: json['subtitle'],
      start: (json['start'] ?? json['startDate'])?.toString(),
      end: (json['end'] ?? json['endDate'])?.toString(),
      zoneId: (json['zoneId'] ?? json['zone_id'])?.toString(),
      roomId: (json['roomId'] ?? json['room_id'])?.toString(),
      type: json['type']?.toString() ?? '',
      lang: json['lang']?.toString(),
      filterDate: json['filter_date']?.toString(),
      filterTime: json['filter_time']?.toString(),
    );
  }

  /// Convierte el DTO a la entidad de Dominio.
  Event toEntity() {
    return Event(
      id: id,
      title: I18nMapper.fromRaw(title),
      subtitle: subtitle != null ? I18nMapper.fromRaw(subtitle) : null,
      startDate: _parseDate(start),
      endDate: _parseDate(end),
      zoneId: zoneId,
      roomId: roomId,
      type: type,
      lang: lang,
      filterDate: filterDate,
      filterTime: filterTime,
    );
  }

  /// Parsea una fecha y la convierte a la hora local.
  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    return parsed?.toLocal();
  }
}
