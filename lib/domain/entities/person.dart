import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa una persona relacionada con la conferencia
class Person {
  Person({
    required this.id,
    required this.name,
    this.country,
    this.title,
    this.institution,
    this.bio,
    this.photoUrl,
  });
  final String id;
  final I18nStr name;
  final String? country;
  final String? title;
  final String? institution;
  final String? bio;
  final String? photoUrl;
}
