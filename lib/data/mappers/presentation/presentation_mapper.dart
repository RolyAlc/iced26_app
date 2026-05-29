import 'package:iced26/data/dtos/presentation_dto.dart';
import 'package:iced26/data/mappers/json_parsers.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/presentation.dart';

/// Mapper para [Presentation]
abstract final class PresentationMapper {
  /// Crea un [Presentation] a partir de un mapa
  static Presentation fromMap(Map<String, dynamic> json) {
    return PresentationDTO.fromMap(json).toEntity();
  }

  /// Crea un [Presentation] a partir de [PresentationTable]
  static Presentation fromDrift(PresentationTable data) {
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
      speakers: JsonParsers.parseSpeakers(data.speakersJson),
      tags: JsonParsers.parseStringList(data.tagsJson),
      track: data.track,
      defaultLang: data.defaultLang,
      externalRef: data.externalRef,
      aboutPresentationUrl: data.aboutPresentationUrl,
      videoPresentationUrl: data.videoPresentationUrl,
    );
  }
}
