import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/social_activity.dart';

// TODO: JSON no coincide (fuente de la verdad)
/// Mapper de datos de actividades sociales.
class SocialActivityMapper {
  static SocialActivity fromMap(Map<String, dynamic> map) {
    final String id = map['id']?.toString() ?? '';
    final I18nStr title = map['title'] != null
        ? I18nMapper.fromRaw(map['title'])
        : I18nStr({'en': 'Social Event'});
    final I18nStr description = map['description'] != null
        ? I18nMapper.fromRaw(map['description'])
        : I18nStr({'en': 'Social activity for participants.'});
    final String date = map['date']?.toString() ?? '';
    final String time = map['time']?.toString() ?? '';
    final I18nStr location = map['location'] != null
        ? I18nMapper.fromRaw(map['location'])
        : I18nStr({'en': 'Conference Venue'});
    final String imgUrl = map['img_url']?.toString() ?? '';

    return SocialActivity(
      id: id,
      title: title,
      description: description,
      date: date,
      time: time,
      location: location,
      imgUrl: imgUrl,
    );
  }

  /// Convierte un registro de la base de datos (Drift) a una entidad.
  static SocialActivity fromDrift(SocialActivityTable data) {
    return SocialActivity(
      id: data.id,
      title: data.title,
      description: data.description,
      date: data.date,
      time: data.time,
      location: data.location,
      imgUrl: data.imgUrl,
    );
  }
}
