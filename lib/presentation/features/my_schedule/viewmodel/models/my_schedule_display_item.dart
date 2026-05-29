import 'package:iced26/domain/entities/my_schedule_item.dart';

/// Tipos de fila que puede mostrar la lista agrupada de My Schedule.
sealed class MyScheduleDisplayItem {}

/// Cabecera de grupo de un día. [date] es null cuando los items no tienen fecha.
class MyScheduleDayHeader extends MyScheduleDisplayItem {
  MyScheduleDayHeader({required this.date, required this.count});
  final DateTime? date;
  final int count;
}

/// Fila de un item guardado (evento o presentación).
class MyScheduleRow extends MyScheduleDisplayItem {
  MyScheduleRow(this.item);
  final MyScheduleItem item;
}
