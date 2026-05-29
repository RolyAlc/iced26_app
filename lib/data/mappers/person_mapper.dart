import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/person.dart';

/// Mapper para [Person]
abstract final class PersonMapper {
  /// Crea un [Person] a partir de un mapa
  static Person fromMap(Map<String, dynamic> json) {
    final photoPath = json['photoPath'];
    final String? photoUrl = photoPath != null
        ? 'assets/$photoPath'
        : json.getStringOrNull('photoUrl');

    return Person(
      id: json.getString('id'),
      name: I18nMapper.fromRaw(json['name'] ?? json['fullName']),
      country: json.getStringOrNull('country'),
      title: json.getStringOrNull('title'),
      institution: json.getStringOrNull('institution'),
      bio: json.getStringOrNull('bio'),
      photoUrl: photoUrl,
    );
  }

  /// Crea un [Person] a partir de [PersonTable]
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
