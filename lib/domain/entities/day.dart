import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa un día de la conferencia
class Day {
  Day({required this.id, required this.date, required this.title});
  final String id;
  final String date;
  final I18nStr title;
}
