import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/news_item.dart';

/// DTO para noticias.
class NewsDTO {
  NewsDTO({
    required this.id,
    required this.datePublish,
    required this.title,
    required this.content,
    required this.imgUrl,
    required this.webUrl,
  });

  /// Crea un [NewsDTO] a partir de un mapa.
  factory NewsDTO.fromMap(Map<String, dynamic> map) {
    return NewsDTO(
      id: map['id']?.toString() ?? '',
      datePublish:
          map['datePublish']?.toString() ?? map['date']?.toString() ?? '',
      title: map['title'],
      content: map['content'],
      imgUrl: map['imgUrl']?.toString() ?? '',
      webUrl: map['webUrl']?.toString() ?? '',
    );
  }
  final String id;
  final String datePublish;
  final dynamic title;
  final dynamic content;
  final String imgUrl;
  final String webUrl;

  /// Convierte un [NewsDTO] a [NewsItem].
  NewsItem toEntity() {
    final date = DateTime.tryParse(datePublish);
    if (date == null) {
      throw StateError(
        'NewsDTO.toEntity: fecha inválida en id=$id (value="$datePublish")',
      );
    }
    return NewsItem(
      id: id,
      datePublish: date,
      title: I18nMapper.fromRaw(title),
      content: I18nMapper.fromRaw(content),
      imgUrl: imgUrl,
      webUrl: webUrl,
    );
  }
}
