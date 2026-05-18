import 'package:iced26/core/constants/app_strings.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';

// TODO: Revisar EventX

/// Entidad que representa un evento
class Event {
  const Event({
    required this.id,
    required this.title,
    this.description,
    this.subtype,
    this.tags = const [],
    this.durationMin,
    this.startDate,
    this.endDate,
    this.zoneId,
    this.roomId,
    required this.type,
    this.defaultLang,
    this.filterDate,
    this.filterTime,
    this.speakers = const [],
    this.slotLabel,
    this.parentId,
    this.extraRooms = const [],
    this.submissionFormats = const [],
    this.externalRef,
  });
  final String id;
  final I18nStr title;
  final String? description;
  final String? subtype;
  final List<String> tags;
  final int? durationMin;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? zoneId;
  final String? roomId;
  final EventType type;
  final String? defaultLang;
  final String? filterDate;
  final String? filterTime;
  final List<SpeakerEntry> speakers;
  final String? slotLabel;
  final String? parentId;
  final List<String> extraRooms;
  final List<String> submissionFormats;
  final String? externalRef;
}

extension EventX on Event {
  /// Formato fecha y hora del evento
  String get formattedDateTime =>
      [?filterDate, ?filterTime].join(AppStrings.separator);
}
