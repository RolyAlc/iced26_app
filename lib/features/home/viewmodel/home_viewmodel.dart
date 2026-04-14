import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';

/// ViewModel para la Home, que prepara los datos para las secciones.
class HomeViewModel {
  HomeViewModel(this.data);
  final AppData data;

  // Clave de fecha local en formato yyyy-MM-dd.
  String get _todayKey {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.toIso8601String().split('T').first;
  }

  // Obtenemos el día actual de la conferencia (si coincide con la fecha de hoy).
  Day? get currentDay {
    final days = data.collections.days;
    if (days.isEmpty) return null;
    final index = days.indexWhere((day) => day.date == _todayKey);
    if (index == -1) return days.first;
    return days[index];
  }

  // Preparamos los eventos destacados del día actual.
  List<Event> get featuredEvents {
    final day = currentDay;
    if (day == null) return [];
    return data.collections.events
        .where((event) => event.filterDate == day.date)
        .toList();
  }

  // Texto dinámico para el header (evita huecos vacíos).
  String get headerInfoLabel {
    final days = data.collections.days;
    if (days.isEmpty || days.every((day) => day.date != _todayKey)) {
      return 'Welcome to ICED26';
    }
    final index = days.indexWhere((day) => day.date == _todayKey);
    final position = index == -1 ? 0 : index;
    return 'Welcome to day ${position + 1} of ${days.length}';
  }

  // Preparamos las categorías visibles.
  List<String> get categoryLabels {
    final types = data.collections.submissionTypes;
    if (types.isEmpty) {
      return List.generate(8, (index) => 'Category ${index + 1}');
    }
    return types.map((t) => t.name.resolve('en')).toList();
  }
}
