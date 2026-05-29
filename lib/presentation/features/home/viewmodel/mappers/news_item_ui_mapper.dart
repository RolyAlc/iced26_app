import 'package:iced26/domain/entities/news_item.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/news_item_ui_model.dart';

/// Mapper para convertir un [NewsItem] a un [NewsItemUIModel].
class NewsItemUIMapper {
  static NewsItemUIModel fromEntity(NewsItem entity, String locale) {
    return NewsItemUIModel(
      id: entity.id,
      title: entity.title.resolve(locale),
      content: entity.content.resolve(locale),
      imgUrl: entity.imgUrl,
      webUrl: entity.webUrl,
    );
  }
}
