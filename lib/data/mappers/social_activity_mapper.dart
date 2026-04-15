import 'package:iced26/domain/entities/social_activity.dart';

/// Mapper datos de 'socials' del JSON en una instancia de SocialActivity.
class SocialActivityMapper {
  static SocialActivity fromMap(Map<String, dynamic> map) {
    final String id = map['id']?.toString() ?? '';

    return SocialActivity(id: id);
  }
}
