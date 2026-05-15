import 'package:iced26/data/dtos/news_dto.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/new.dart';

/// Mapper para [NewsItem]
abstract final class NewsMapper {
  /// Crea un [NewsItem] a partir de un mapa
  static NewsItem fromMap(Map<String, dynamic> map) {
    return NewsDTO.fromMap(map).toEntity();
  }

  /// Crea un [NewsItem] a partir de [NewsTable]
  static NewsItem fromDrift(NewsTable data) {
    final date = DateTime.tryParse(data.date);
    if (date == null) {
      throw StateError(
        'NewsMapper.fromDrift: fecha inválida en id=${data.id} (value="${data.date}")',
      );
    }
    return NewsItem(
      id: data.id,
      title: data.title,
      content: data.content,
      imgUrl: data.imgUrl,
      webUrl: data.webUrl,
      datePublish: date,
    );
  }
}
