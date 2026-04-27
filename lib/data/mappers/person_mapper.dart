import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/person.dart';

/// Mapper para convertir distintas fuentes de datos en una instancia de 'People'.
class PeopleMapper {
  /// Construye una instancia de [Person] desde un JSON.
  static Person fromMap(Map<String, dynamic> json) {
    final String id = _parseId(json);
    final I18nStr name = _parseName(json);
    final String? country = _parseString(json, 'country');
    final String? title = _parseString(json, 'title');
    final String? institution = _parseString(json, 'institution');
    final String? bio = _parseString(json, 'bio');
    final String? photoUrl = _parsePhotoUrl(json);

    return Person(
      id: id,
      name: name,
      country: country,
      title: title,
      institution: institution,
      bio: bio,
      photoUrl: photoUrl,
    );
  }

  /// Construye una instancia de [Person] desde la base de datos (Drift).
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

  /// Extrae y normaliza el ID.
  static String _parseId(Map<String, dynamic> json) {
    return json['id']?.toString() ?? '';
  }

  /// Extrae y traduce el nombre usando I18nMapper.
  static I18nStr _parseName(Map<String, dynamic> json) {
    final rawName = json['name'] ?? json['full_name'];
    return I18nMapper.fromRaw(rawName);
  }

  /// Extrae un string opcional de forma segura.
  static String? _parseString(Map<String, dynamic> json, String key) {
    final value = json[key];
    return value?.toString();
  }

  /// Construye la URL de la foto según prioridad.
  static String? _parsePhotoUrl(Map<String, dynamic> json) {
    final String? localPath = _buildLocalPhotoPath(json);
    final String? remoteUrl = _parseString(json, 'photo_url');

    return localPath ?? remoteUrl;
  }

  /// Construye la ruta local de la imagen si existe.
  static String? _buildLocalPhotoPath(Map<String, dynamic> json) {
    final photoPath = json['photo_path'];
    if (photoPath == null) {
      return null;
    }

    return 'assets/$photoPath';
  }
}
