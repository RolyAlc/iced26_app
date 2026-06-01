import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa una noticia de la conferencia.
class NewsItem {
  NewsItem({
    required this.id,
    required this.datePublish,
    required this.title,
    required this.content,
    required this.imgUrl,
    required this.webUrl,
  });
  final String id;
  final DateTime datePublish;
  final I18nStr title;
  final I18nStr content;
  final String imgUrl;
  final String webUrl;
}
