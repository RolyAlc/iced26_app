import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/submission_type.dart';

/// Mapper para [SubmissionType]
abstract final class SubmissionTypeMapper {
  /// Crea un [SubmissionType] a partir de un mapa
  static SubmissionType fromMap(Map<String, dynamic> json) {
    return SubmissionType(
      id: json.getString('id'),
      name: I18nMapper.fromRaw(json['name']),
      durationMin: json.getInt('durationMin'),
      lang: json.getString('lang'),
      description: I18nMapper.fromRaw(json['description']),
      scheduleDescription: I18nMapper.fromRaw(json['scheduleDescription']),
    );
  }

  /// Crea un [SubmissionType] a partir de [SubmissionTypeTable]
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
