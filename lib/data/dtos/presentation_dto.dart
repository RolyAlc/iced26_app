import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';

/// DTO para presentaciones
class PresentationDTO {
  final String id;
  final String type;
  final String? subtype;
  final String? sessionBlockId;
  final dynamic title;
  final dynamic abstract_;
  final String? description;
  final String? submissionRef;
  final int? durationMin;
  final String? start;
  final String? end;
  final List<SpeakerEntry> speakers;
  final List<String> tags;
  final String? track;
  final String? defaultLang;
  final String? externalRef;
  final String? aboutPresentationUrl;
  final String? videoPresentationUrl;

  PresentationDTO({
    required this.id,
    required this.type,
    this.subtype,
    this.sessionBlockId,
    this.title,
    this.abstract_,
    this.description,
    this.submissionRef,
    this.durationMin,
    this.start,
    this.end,
    this.speakers = const [],
    this.tags = const [],
    this.track,
    this.defaultLang,
    this.externalRef,
    this.aboutPresentationUrl,
    this.videoPresentationUrl,
  });

  factory PresentationDTO.fromMap(Map<String, dynamic> json) {
    return PresentationDTO(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      subtype: json['subtype']?.toString(),
      sessionBlockId: json['sessionBlockId']?.toString(),
      title: json['title'],
      abstract_: json['abstract'],
      description: json['description']?.toString(),
      submissionRef: json['submissionRef']?.toString(),
      durationMin: (json['durationMin'] as num?)?.toInt(),
      start: json['start']?.toString(),
      end: json['end']?.toString(),
      speakers: _mapSpeakers(json['speakers']),
      tags: _mapStringList(json['tags']),
      track: json['track']?.toString(),
      defaultLang: json['defaultLang']?.toString(),
      externalRef: json['externalRef']?.toString(),
      aboutPresentationUrl: json['aboutPresentationUrl']?.toString(),
      videoPresentationUrl: json['videoPresentationUrl']?.toString(),
    );
  }

  Presentation toEntity() {
    return Presentation(
      id: id,
      type: type,
      subtype: subtype,
      sessionBlockId: sessionBlockId,
      title: title != null ? I18nMapper.fromRaw(title) : null,
      abstract_: abstract_ != null ? I18nMapper.fromRaw(abstract_) : null,
      description: description,
      submissionRef: submissionRef,
      durationMin: durationMin,
      startDate: _parseDate(start),
      endDate: _parseDate(end),
      speakers: speakers,
      tags: tags,
      track: track,
      defaultLang: defaultLang,
      externalRef: externalRef,
      aboutPresentationUrl: aboutPresentationUrl,
      videoPresentationUrl: videoPresentationUrl,
    );
  }

  /// Helper para mapear listas de speakers
  static List<SpeakerEntry> _mapSpeakers(dynamic raw) {
    if (raw is! List) {
      return const [];
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map(
          (s) => SpeakerEntry(
            personId: s['personId']?.toString() ?? '',
            role: s['role']?.toString(),
          ),
        )
        .where((s) => s.personId.isNotEmpty)
        .toList();
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
