import 'dart:convert';

import 'package:iced26/data/dtos/presentation_dto.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';

/// Mapper para presentaciones
class PresentationMapper {
  /// Convierte un mapa JSON en una entidad [Presentation]
  static Presentation fromMap(Map<String, dynamic> json) {
    return PresentationDTO.fromMap(json).toEntity();
  }

  /// Convierte una instancia de [Presentation] desde la base de datos (Drift).
  static Presentation fromDrift(PresentationTable data) {
    /// Mapeo de speakers
    final List<SpeakerEntry> speakers = data.speakersJson != null
        ? (jsonDecode(data.speakersJson!) as List<dynamic>)
              .whereType<Map<String, dynamic>>()
              .map(
                (s) => SpeakerEntry(
                  personId: s['personId']?.toString() ?? '',
                  role: s['role']?.toString(),
                ),
              )
              .where((s) => s.personId.isNotEmpty)
              .toList()
        : const [];

    /// Mapeo de tags
    final List<String> tags = data.tagsJson != null
        ? (jsonDecode(data.tagsJson!) as List<dynamic>).cast<String>()
        : const [];

    return Presentation(
      id: data.id,
      type: data.type,
      subtype: data.subtype,
      sessionBlockId: data.sessionBlockId,
      title: data.title,
      abstract_: data.abstract_,
      description: data.description,
      submissionRef: data.submissionRef,
      durationMin: data.durationMin,
      startDate: data.startDate,
      endDate: data.endDate,
      speakers: speakers,
      tags: tags,
      track: data.track,
      defaultLang: data.defaultLang,
      externalRef: data.externalRef,
      aboutPresentationUrl: data.aboutPresentationUrl,
      videoPresentationUrl: data.videoPresentationUrl,
    );
  }
}
