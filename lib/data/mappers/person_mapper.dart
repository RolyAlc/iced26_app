import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/person.dart';

/// Mapper para convertir el JSON de una persona en una instancia de 'Person'.
class PersonMapper {
  static Person fromMap(Map<String, dynamic> json) {
    return Person(
      id: json['id']?.toString() ?? '',
      name: I18nMapper.fromRaw(json['name'] ?? json['full_name']),
      institution: json['institution']?.toString(),
      photoUrl: json['photo_url']?.toString(),
    );
  }

  /// Convierte una fila de la tabla Person a una instancia de 'Person'.
  static Person fromDrift(PersonTable data) {
    return Person(
      id: data.id,
      name: data.name,
      institution: data.institution,
      photoUrl: data.photoUrl,
    );
  }
}
