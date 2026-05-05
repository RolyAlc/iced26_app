import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/presentation.dart';

/// Representa un item en el schedule del usuario
sealed class MyScheduleItem {
  DateTime? get sortTime;
}

/// Item del schedule que es un evento
class SavedEventItem extends MyScheduleItem {
  final Event event;
  SavedEventItem(this.event);

  @override
  DateTime? get sortTime => event.startDate;
}

/// Item del schedule que es una presentación
class SavedPresentationItem extends MyScheduleItem {
  final Presentation presentation;
  SavedPresentationItem(this.presentation);

  @override
  DateTime? get sortTime => presentation.startDate;
}
