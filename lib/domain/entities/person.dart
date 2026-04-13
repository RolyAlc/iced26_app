import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa una persona relacionada con la conferencia
class Person {
  final String id;
  final I18nStr name;

  Person({required this.id, required this.name});
}
