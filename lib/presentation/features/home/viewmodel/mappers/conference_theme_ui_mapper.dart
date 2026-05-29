import 'package:iced26/domain/entities/conference_theme.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/conference_theme_ui_model.dart';

/// Mapper para convertir un [ConferenceTheme] a un [ConferenceThemeUIModel].
class ConferenceThemeUIMapper {
  static ConferenceThemeUIModel fromEntity(
    ConferenceTheme entity,
    String locale,
  ) {
    return ConferenceThemeUIModel(
      id: entity.id,
      name: entity.name.resolve(locale),
      description: entity.description.resolve(locale),
      topics: entity.topicsInclude
          .map((t) => t.resolve(locale))
          .where((t) => t.isNotEmpty)
          .toList(),
      readMinutes: entity.estimatedReadMinutes(locale),
    );
  }
}
