import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/day.dart';

/// Mapper para [Day]
abstract final class DayMapper {
  /// Crea un [Day] a partir de un mapa
  static Day fromMap(Map<String, dynamic> json) {
    return Day(
      id: json.getString('id'),
      date: json.getString('date'),
      title: I18nMapper.fromRaw(json['title'] ?? json['name']),
    );
  }

  /// Crea un [Day] a partir de [DayTable]
  static Day fromDrift(DayTable data) {
    return Day(id: data.id, date: data.date, title: data.title);
  }
}
