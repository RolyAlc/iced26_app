import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa un evento de la conferencia.
class Event {
  final String id;
  final I18nStr title;
  final I18nStr? abstract_;
  final String? description;
  final String? subtype;
  final String? track;
  final List<String> tags;
  final int? durationMin;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? zoneId;
  final String? roomId;
  final String type;
  final String? lang;
  final String? filterDate;
  final String? filterTime;
  final List<String> speakerIds;
  final String? aboutPresentationUrl;
  final String? videoPresentationUrl;

  Event({
    required this.id,
    required this.title,
    this.abstract_,
    this.description,
    this.subtype,
    this.track,
    this.tags = const [],
    this.durationMin,
    this.startDate,
    this.endDate,
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
}
