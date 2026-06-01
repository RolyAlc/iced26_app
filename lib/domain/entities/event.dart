import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';

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

  Event copyWith({
    String? id,
    I18nStr? title,
    String? description,
    String? subtype,
    List<String>? tags,
    int? durationMin,
    DateTime? startDate,
    DateTime? endDate,
    String? zoneId,
    String? roomId,
    EventType? type,
    String? defaultLang,
    String? filterDate,
    String? filterTime,
    List<SpeakerEntry>? speakers,
    String? slotLabel,
    String? parentId,
    String? sessionId,
    String? track,
    I18nStr? abstract_,
    String? number,
    bool? isSession,
    List<String>? extraRooms,
    List<String>? submissionFormats,
    String? externalRef,
    String? aboutPresentationUrl,
    String? videoPresentationUrl,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subtype: subtype ?? this.subtype,
      tags: tags ?? this.tags,
      durationMin: durationMin ?? this.durationMin,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      zoneId: zoneId ?? this.zoneId,
      roomId: roomId ?? this.roomId,
      type: type ?? this.type,
      defaultLang: defaultLang ?? this.defaultLang,
      filterDate: filterDate ?? this.filterDate,
      filterTime: filterTime ?? this.filterTime,
      speakers: speakers ?? this.speakers,
      slotLabel: slotLabel ?? this.slotLabel,
      parentId: parentId ?? this.parentId,
      sessionId: sessionId ?? this.sessionId,
      track: track ?? this.track,
      abstract_: abstract_ ?? this.abstract_,
      number: number ?? this.number,
      isSession: isSession ?? this.isSession,
      extraRooms: extraRooms ?? this.extraRooms,
      submissionFormats: submissionFormats ?? this.submissionFormats,
      externalRef: externalRef ?? this.externalRef,
      aboutPresentationUrl: aboutPresentationUrl ?? this.aboutPresentationUrl,
      videoPresentationUrl: videoPresentationUrl ?? this.videoPresentationUrl,
    );
  }
}

const String _kEventSeparator = '  ·  ';

extension EventX on Event {
  /// Formato fecha y hora del evento
  String get formattedDateTime {
    return [?filterDate, ?filterTime].join(_kEventSeparator);
  }

  /// Los talks son eventos hijos de un bloque de sesión o marcados explícitamente.
  bool get isTalk => isSession == false || sessionId != null;
}
