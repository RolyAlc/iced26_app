import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/social_activity_ui_model.dart';

/// Mapper para convertir un [SocialActivity] a un [SocialActivityUIModel].
class SocialActivityUIMapper {
  static SocialActivityUIModel fromEntity(
    SocialActivity entity,
    String locale,
  ) {
    return SocialActivityUIModel(
      id: entity.id,
      title: entity.title.resolve(locale),
      date: entity.date,
      time: entity.time,
      location: entity.location.resolve(locale),
      imgUrl: entity.imgUrl,
    );
  }
}
