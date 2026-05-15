import 'package:iced26/domain/entities/my_schedule_item.dart';

/// Tipos de fila que puede mostrar la lista agrupada de My Schedule.
sealed class MyScheduleDisplayItem {}

/// Cabecera de grupo de un día. [date] es null cuando los items no tienen fecha.
class MyScheduleDayHeader extends MyScheduleDisplayItem {
  final DateTime? date;
  final int count;

  MyScheduleDayHeader({required this.date, required this.count});
}

/// Fila de un item guardado (evento o presentación).
class MyScheduleRow extends MyScheduleDisplayItem {
  final MyScheduleItem item;

  MyScheduleRow(this.item);
}
