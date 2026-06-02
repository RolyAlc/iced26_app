import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/person.dart';

/// Mapper para [Person]
abstract final class PersonMapper {
  /// Crea un [Person] a partir de un mapa
  static Person fromMap(Map<String, dynamic> json) {
    final photoPath = json['photoPath'];
    final String? photoUrl = photoPath != null
        ? 'assets/$photoPath'
        : json.getStringOrNull('photoUrl');

    final firstName = json.getStringOrNull('firstName');
    final lastName = json.getStringOrNull('lastName');
    final I18nStr name;
    if (firstName != null || lastName != null) {
      name = I18nMapper.fromRaw(
        [firstName, lastName].whereType<String>().join(' '),
      );
    } else {
      name = I18nMapper.fromRaw(json['name'] ?? json['fullName']);
    }

    return Person(
      id: json.getString('id'),
      name: name,
      country: json.getStringOrNull('country'),
      title: json.getStringOrNull('title'),
      institution:
          json.getStringOrNull('affiliation') ??
          json.getStringOrNull('institution'),
      bio: json.getStringOrNull('bio'),
      photoUrl: photoUrl,
      email: json.getStringOrNull('email'),
      webPage: json.getStringOrNull('webPage'),
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
      email: data.email,
      webPage: data.webPage,
    );
  }
}
