import 'package:iced26/domain/entities/event.dart';

/// Representa un item en el schedule del usuario
sealed class MyScheduleItem {
  DateTime? get sortTime;
}

/// Item del schedule que es un evento
class SavedEventItem extends MyScheduleItem {
  SavedEventItem(this.event);
  final Event event;

  @override
  DateTime? get sortTime => event.startDate;
}
