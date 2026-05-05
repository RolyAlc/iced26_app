import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/submission_type.dart';

/// Mapper de submission types de JSON (categorias).
class SubmissionTypeMapper {
  /// Convierte un mapa JSON en una entidad 'SubmissionType'.
  static SubmissionType fromMap(Map<String, dynamic> json) {
    final dynamic rawDuration = json['durationMin'];
    final String id = json['id']?.toString() ?? '';
    final I18nStr name = I18nMapper.fromRaw(json['name']);
    final I18nStr description = I18nMapper.fromRaw(json['description']);
    final I18nStr scheduleDescription = I18nMapper.fromRaw(
      json['scheduleDescription'],
    );
    final String lang = json['lang']?.toString() ?? '';

    return SubmissionType(
      id: id,
      name: name,
      durationMin: rawDuration is int
          ? rawDuration
          : int.tryParse('$rawDuration'),
      lang: lang,
      description: description,
      scheduleDescription: scheduleDescription,
    );
  }

  /// Convierte una instancia de [SubmissionType] desde la base de datos (Drift).
  static SubmissionType fromDrift(SubmissionTypeTable data) {
    return SubmissionType(
      id: data.id,
      name: data.name,
      durationMin: data.durationMin,
      lang: data.lang,
      description: data.description,
      scheduleDescription: data.scheduleDescription,
    );
  }
}
