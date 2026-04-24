import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/person.dart';

/// Mapper para convertir el JSON de una persona en una instancia de 'Person'.
class PersonMapper {
  static Person fromMap(Map<String, dynamic> json) {
    return Person(
      id: json['id']?.toString() ?? '',
      name: I18nMapper.fromRaw(json['name'] ?? json['full_name']),
      country: json['country']?.toString(),
      title: json['title']?.toString(),
      institution: json['institution']?.toString(),
      bio: json['bio']?.toString(),
      photoUrl:
          json['photo_url']?.toString() ??
          (json['photo_path'] != null ? 'assets/${json['photo_path']}' : null),
    );
  }

  /// Convierte una fila de la tabla Person a una instancia de 'Person'.
  static Person fromDrift(PersonTable data) {
    return Person(
      id: data.id,
      name: data.name,
      country: data.country,
      title: data.title,
      institution: data.institution,
      bio: data.bio,
      photoUrl: data.photoUrl,
    );
  }
}
