import 'package:iced26/core/models/app_data.dart';

/// ViewModel para la Home, que prepara los datos para las secciones.
class HomeViewModel {
  HomeViewModel(this.data);

  final AppData data;

  // Obtenemos el primer día disponible.
  Day? get firstDay =>
      data.collections.days.isNotEmpty ? data.collections.days.first : null;

  // Preparamos los eventos destacados del día actual.
  List<Event> get featuredEvents {
    final day = firstDay;
    if (day == null) return [];
    return data.collections.events
        .where((event) => event.filterDate == day.date)
        .toList();
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
