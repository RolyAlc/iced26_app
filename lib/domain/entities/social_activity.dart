import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa una actividad social de la conferencia.
class SocialActivity {
  SocialActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.imgUrl,
  });
  final String id;
  final I18nStr title;
  final I18nStr description;
  final String date;
  final String time;
  final I18nStr location;
  final String imgUrl;
}
