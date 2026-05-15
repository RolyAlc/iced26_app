import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/conference.dart';
import 'package:iced26/domain/entities/i18n_str.dart';

/// Mapper para [Conference].
abstract final class ConferenceMapper {
  /// Crea un [Conference] a partir de un mapa.
  static Conference fromMap(Map<String, dynamic> json) {
    final I18nStr name = I18nMapper.fromRaw(json['name'] ?? json['title']);
    final List<I18nStr> themes = json
        .getList('conferenceThemes')
        .map(I18nMapper.fromRaw)
        .toList();

    return Conference(name: name, conferenceThemes: themes);
  }
}
