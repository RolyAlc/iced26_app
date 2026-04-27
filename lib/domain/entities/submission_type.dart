import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa un tipo de presentación en la conferencia
class SubmissionType {
  final String id;
  final I18nStr name;
  final int? durationMin;
  final String? lang;
  final I18nStr description;
  final I18nStr scheduleDescription;

  SubmissionType({
    required this.id,
    required this.name,
    required this.durationMin,
    required this.lang,
    required this.description,
    required this.scheduleDescription,
  });
}
