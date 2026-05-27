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
  final String? sessionId;
  final String? track;
  final I18nStr? abstract_;
  final String? number;
  final bool? isSession;
  final List<String> extraRooms;
  final List<String> submissionFormats;
  final String? externalRef;
  final String? aboutPresentationUrl;
  final String? videoPresentationUrl;
}

extension EventX on Event {
  /// Formato fecha y hora del evento
  String get formattedDateTime =>
      [?filterDate, ?filterTime].join(AppStrings.separator);

  /// Los talks son eventos hijos de un bloque de sesión o marcados explícitamente.
  bool get isTalk => isSession == false || sessionId != null;
}
