import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/day.dart';

/// Mapper para convertir el JSON de un día en una instancia de 'Day'.
class DayMapper {
  static Day fromMap(Map<String, dynamic> json) {
    return Day(
      id: json['id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      title: I18nMapper.fromRaw(json['title'] ?? json['name']),
    );
  }
}
