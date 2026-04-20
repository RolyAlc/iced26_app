import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/data/models/dto/news_dto.dart';
import 'package:iced26/domain/entities/new.dart';

/// Mapper datos de 'news' del JSON en una instancia de NewsItem.
class NewsMapper {
  static NewsItem fromMap(Map<String, dynamic> map) {
    return NewsDTO.fromMap(map).toEntity();
  }

  /// Convierte un registro de la base de datos (Drift) a una entidad.
  static NewsItem fromDrift(NewsTable data) {
    return NewsItem(
      id: data.id,
      title: data.title,
      content: data.content,
      imgUrl: data.imgUrl,
      webUrl: data.webUrl,
      datePublish: DateTime.tryParse(data.date) ?? DateTime.now(),
    );
  }
}
