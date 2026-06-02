import 'package:iced26/core/extensions/map_extensions.dart';
import 'package:iced26/data/mappers/i18n_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';

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

  /// Deriva los días de conferencia a partir de las fechas únicas de [events].
  /// Se usa como fallback cuando el API no incluye el campo `days`.
  static List<Day> fromEvents(List<Event> events) {
    final dates =
        events.map((e) => e.filterDate).whereType<String>().toSet().toList()
          ..sort();
    return [
      for (final date in dates)
        Day(
          id: date,
          date: date,
          title: I18nMapper.fromRaw(_formatDayLabel(date)),
        ),
    ];
  }

  static String _formatDayLabel(String isoDate) {
    final parts = isoDate.split('-');
    if (parts.length < 3) return isoDate;
    final month = int.tryParse(parts[1]) ?? 0;
    final day = int.tryParse(parts[2]) ?? 0;
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (month < 1 || month > 12) return isoDate;
    return '${months[month]} $day';
  }
}
