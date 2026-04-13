import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/i18n_str.dart';

/// Mapper para convertir el JSON de un evento en una instancia de 'Event'.
/// Devuelve un objeto 'Event' con los campos correctamente parseados.
class EventMapper {
  static Event fromMap(Map<String, dynamic> json) {
    // Extraemos los datos crudos primero
    final String id = json['id']?.toString() ?? '';
    final dynamic rawTitle = json['title'] ?? json['name'];
    final String? rawStart = json['start']?.toString();
    final String? rawEnd = json['end']?.toString();
    final String? zoneId = (json['zoneId'] ?? json['zone_id'])?.toString();
    final String type = json['type']?.toString() ?? '';
    final String? lang = json['lang']?.toString();
    final String? filterDate = json['filter_date']?.toString();
    final String? filterTime = json['filter_time']?.toString();

    // Convertimos a tipos de dominio
    final I18nStr title = I18nMapper.fromRaw(rawTitle);
    final DateTime? startDate = _parseDate(rawStart);
    final DateTime? endDate = _parseDate(rawEnd);

    return Event(
      id: id,
      title: title,
      startDate: startDate,
      endDate: endDate,
      zoneId: zoneId,
      type: type,
      lang: lang,
      filterDate: filterDate,
      filterTime: filterTime,
    );
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
