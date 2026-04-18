import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/social_activity.dart';

// TODO: JSON no coincide (fuente de la verdad)
/// Mapper de datos de actividades sociales.
class SocialActivityMapper {
  static SocialActivity fromMap(Map<String, dynamic> map) {
    final String id = map['id']?.toString() ?? '';
    final I18nStr title = I18nMapper.fromRaw(map['title']);
    final I18nStr description = I18nMapper.fromRaw(map['description']);
    final String date = map['date']?.toString() ?? '';
    final String time = map['time']?.toString() ?? '';
    final I18nStr location = I18nMapper.fromRaw(map['location']);
    final String imgUrl = map['imgUrl']?.toString() ?? '';

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
}
