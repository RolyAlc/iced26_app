/// Modelo de presentación de una noticia.
///
/// Los strings ya vienen resueltos al locale correcto — la vista no necesita
/// conocer [I18nStr] ni el locale actual.
class NewsItemUIModel {
  const NewsItemUIModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imgUrl,
    required this.webUrl,
  });

  final String id;
  final String title;
  final String content;
  final String imgUrl;
  final String webUrl;
}
