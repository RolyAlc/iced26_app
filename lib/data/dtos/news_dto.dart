import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';

/// DTO para la noticia.
class NewsDTO {
  final String id;
  final String datePublish;
  final dynamic title;
  final dynamic content;
  final String imgUrl;
  final String webUrl;

  NewsDTO({
    required this.id,
    required this.datePublish,
    required this.title,
    required this.content,
    required this.imgUrl,
    required this.webUrl,
  });

  /// Crea un DTO desde un Map (JSON o DB row).
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

  /// Convierte el DTO en una Entity del dominio.
  NewsItem toEntity() {
    return NewsItem(
      id: id,
      datePublish: DateTime.tryParse(datePublish) ?? DateTime.now(),
      title: I18nMapper.fromRaw(title),
      content: I18nMapper.fromRaw(content),
      imgUrl: imgUrl,
      webUrl: webUrl,
    );
  }
}
