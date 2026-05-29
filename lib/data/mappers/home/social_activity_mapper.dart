import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/social_activity.dart';

/// Mapper para [SocialActivity]
abstract final class SocialActivityMapper {
  static const _kFallbackTitle = 'Social event';
  static const _kFallbackDescription = 'Social activity for participants.';
  static const _kFallbackLocation = 'Conference venue';

  /// Crea un [SocialActivity] a partir de un mapa
  static SocialActivity fromMap(Map<String, dynamic> map) {
    return SocialActivity(
      id: map.getString('id'),
      title: _i18n(map['title'], _kFallbackTitle),
      description: _i18n(map['description'], _kFallbackDescription),
      date: map.getString('date'),
      time: map.getString('time'),
      location: _i18n(map['location'], _kFallbackLocation),
      imgUrl: map.getString('imgUrl'),
    );
  }

  /// Crea un [SocialActivity] a partir de [SocialActivityTable]
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

  /// Crea un [I18nStr] a partir de un [Map] con un fallback
  static I18nStr _i18n(dynamic value, String fallback) {
    if (value == null) {
      return I18nStr({'en': fallback});
    }
    return I18nMapper.fromRaw(value);
  }
}
