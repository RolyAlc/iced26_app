import 'package:iced26/data/dtos/session_block_dto.dart';
import 'package:iced26/data/mappers/json_parsers.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/session_block.dart';

/// Mapper para [SessionBlock]
abstract final class SessionBlockMapper {
  /// Crea un [SessionBlock] a partir de un mapa
  static SessionBlock fromMap(Map<String, dynamic> json) {
    return SessionBlockDTO.fromMap(json).toEntity();
  }

  /// Crea un [SessionBlock] a partir de [SessionBlockTable]
  static SessionBlock fromDrift(SessionBlockTable data) {
    return SessionBlock(
      id: data.id,
      parentId: data.parentId,
      roomId: data.roomId,
      track: data.track,
      title: data.title,
      startDate: data.startDate,
      endDate: data.endDate,
      submissionFormats: JsonParsers.parseStringList(
        data.submissionFormatsJson,
      ),
      defaultLang: data.defaultLang,
      externalRef: data.externalRef,
    );
  }
}
