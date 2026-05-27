/// Modelo de presentación de una actividad social.
///
/// Strings pre-resueltos — la vista no necesita conocer [I18nStr].
class SocialActivityUIModel {
  const SocialActivityUIModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.imgUrl,
  });

  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String imgUrl;
}
