import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/person.dart';

/// Mapper para convertir el JSON de una persona en una instancia de 'Person'.
class PersonMapper {
  static Person fromMap(Map<String, dynamic> json) {
    final String id = json['id']?.toString() ?? '';
    final dynamic rawName = json['name'] ?? json['full_name'];

    return Person(id: id, name: I18nMapper.fromRaw(rawName));
  }
}
