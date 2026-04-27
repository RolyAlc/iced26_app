import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/i18n_str.dart';

/// Mapper para convertir el JSON de un día en una instancia de 'Day'.
class DayMapper {
  static Day fromMap(Map<String, dynamic> json) {
    final String id = json['id']?.toString() ?? '';
    final String date = json['date']?.toString() ?? '';
    final I18nStr title = I18nMapper.fromRaw(json['title'] ?? json['name']);

    return Day(id: id, date: date, title: title);
  }

  /// Convierte un registro de la base de datos (Drift) a una entidad.
  static Day fromDrift(DayTable data) {
    return Day(id: data.id, date: data.date, title: data.title);
  }
}
