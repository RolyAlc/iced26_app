import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/submission_type.dart';

/// Mapper para convertir el JSON de un tipo de presentación en una instancia de 'SubmissionType'.
class SubmissionTypeMapper {
  static SubmissionType fromMap(Map<String, dynamic> json) {
    final dynamic rawDuration = json['duration_min'];

    return SubmissionType(
      id: json['id']?.toString() ?? '',
      name: I18nMapper.fromRaw(json['name']),
      durationMin: rawDuration is int
          ? rawDuration
          : int.tryParse('$rawDuration'),
      lang: json['lang']?.toString(),
      description: I18nMapper.fromRaw(json['description']),
      scheduleDescription: I18nMapper.fromRaw(json['schedule_description']),
    );
  }
}
