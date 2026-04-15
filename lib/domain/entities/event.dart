import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa un evento de la conferencia.
class Event {
  final String id;
  final I18nStr title;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? zoneId;
  final String? roomId;
  final String type;
  final String? lang;
  final String? filterDate;
  final String? filterTime;

  Event({
    required this.id,
    required this.title,
    this.startDate,
    this.endDate,
    this.zoneId,
    this.roomId,
    required this.type,
    this.lang,
    this.filterDate,
    this.filterTime,
  });
}
