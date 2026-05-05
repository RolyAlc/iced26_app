import 'dart:convert';

import 'package:iced26/data/dtos/session_block_dto.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/session_block.dart';

/// Mapper para bloques de sesiones
class SessionBlockMapper {
  /// Convierte un mapa JSON en una entidad [SessionBlock]
  static SessionBlock fromMap(Map<String, dynamic> json) {
    return SessionBlockDTO.fromMap(json).toEntity();
  }

  /// Convierte una instancia de [SessionBlock] desde la base de datos (Drift).
  static SessionBlock fromDrift(SessionBlockTable data) {
    /// Mapeo de formatos de submission
    final List<String> formats = data.submissionFormatsJson != null
        ? (jsonDecode(data.submissionFormatsJson!) as List<dynamic>)
              .cast<String>()
        : const [];

    return SessionBlock(
      id: data.id,
      parentId: data.parentId,
      roomId: data.roomId,
      track: data.track,
      title: data.title,
      startDate: data.startDate,
      endDate: data.endDate,
      submissionFormats: formats,
      defaultLang: data.defaultLang,
      externalRef: data.externalRef,
    );
  }
}
