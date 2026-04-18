import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/submission_type.dart';

/// Mapper de submission types de JSON (categorias).
class SubmissionTypeMapper {
  static SubmissionType fromMap(Map<String, dynamic> json) {
    final dynamic rawDuration = json['duration_min'];
    final String id = json['id']?.toString() ?? '';
    final I18nStr name = I18nMapper.fromRaw(json['name']);
    final I18nStr description = I18nMapper.fromRaw(json['description']);
    final I18nStr scheduleDescription = I18nMapper.fromRaw(
      json['schedule_description'],
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
}
