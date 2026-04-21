import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa una persona relacionada con la conferencia
class Person {
  final String id;
  final I18nStr name;
  final String? institution;
  final String? photoUrl;

  Person({
    required this.id,
    required this.name,
    this.institution,
    this.photoUrl,
  });
}
