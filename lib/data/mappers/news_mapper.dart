import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/new.dart';

/// Mapper datos de 'news' del JSON en una instancia de NewsItem.
class NewsMapper {
  static NewsItem fromMap(Map<String, dynamic> map) {
    final String id = map['id']?.toString() ?? '';
    final String rawDate = map['date_publish']?.toString() ?? '';
    final DateTime datePublish = DateTime.tryParse(rawDate) ?? DateTime.now();
    final String imgUrl = map['img_url']?.toString() ?? '';
    final String webUrl = map['web_url']?.toString() ?? '';

    return NewsItem(
      id: id,
      datePublish: datePublish,
      title: I18nMapper.fromRaw(map['title']),
      content: I18nMapper.fromRaw(map['content']),
      imgUrl: imgUrl,
      webUrl: webUrl,
    );
  }
}
