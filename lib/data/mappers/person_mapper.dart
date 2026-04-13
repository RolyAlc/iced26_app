import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/person.dart';

/// Mapper para convertir el JSON de una persona en una instancia de 'Person'.
class PersonMapper {
  static Person fromMap(Map<String, dynamic> json) {
    return Person(
      id: json['id']?.toString() ?? '',
      name: I18nMapper.fromRaw(json['name'] ?? json['full_name']),
    );
  }
}
