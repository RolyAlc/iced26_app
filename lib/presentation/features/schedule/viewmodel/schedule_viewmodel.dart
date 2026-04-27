import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/usecases/get_schedule_data_use_case.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';

part 'schedule_viewmodel.g.dart';

/// Día activo como índice de tab. 0 = primer día.
final selectedDayIndexProvider = StateProvider<int>((ref) => 0);

/// Categoría activa como filtro. `null` = sin filtro (mostrar todo).
final selectedScheduleCategoryProvider = StateProvider<EventType?>(
  (ref) => null,
);

/// Muestra solo los eventos guardados en favoritos.
final showOnlyFavoritesProvider = StateProvider<bool>((ref) => false);

/// Tipos de evento que pueden formar grupos de sesiones paralelas.
const _parallelTypes = {EventType.sessions, EventType.workshop};

/// Busca todos los eventos paralelos al [event] dado dentro de [events].
List<Event> _findParallelEvents({
  required Event event,
  required List<Event> events,
  required Set<String> processedIds,
}) {
  return events.where((e) {
    final notProcessed = !processedIds.contains(e.id);
    final sameTime = e.startDate == event.startDate;
    final sameType = e.type == event.type;
    return notProcessed && sameTime && sameType;
  }).toList();
}

/// Convierte una lista de eventos paralelos en un [ScheduleItem].
ScheduleItem _buildItemFromParallels({
  required Event event,
  required List<Event> parallels,
}) {
  if (parallels.length > 1) {
    return ParallelGroupItem(
      events: parallels,
      startDate: event.startDate!,
      type: event.type,
    );
  }
  return SingleEventItem(event);
}

/// Registra todos los IDs de los [parallels] en [processedIds].
void _markAsProcessed({
  required List<Event> parallels,
  required Set<String> processedIds,
}) {
  for (final e in parallels) {
    processedIds.add(e.id);
  }
}

/// Agrupa eventos con mismo [startDate] y mismo [type].
List<ScheduleItem> _groupEvents(List<Event> events) {
  final items = <ScheduleItem>[];
  final processedIds = <String>{};

  for (final event in events) {
    if (processedIds.contains(event.id)) continue;

    final bool isParallelType = _parallelTypes.contains(event.type);
    final bool hasStartDate = event.startDate != null;

    if (isParallelType && hasStartDate) {
      final parallels = _findParallelEvents(
        event: event,
        events: events,
        processedIds: processedIds,
      );

      final item = _buildItemFromParallels(event: event, parallels: parallels);
      items.add(item);

      _markAsProcessed(parallels: parallels, processedIds: processedIds);
    } else {
      items.add(SingleEventItem(event));
      processedIds.add(event.id);
    }
  }

  return items;
}

/// Ordena [events] por [startDate] de forma ascendente.
List<Event> _sortEventsByDate(List<Event> events) {
  final sorted = [...events];
  sorted.sort((a, b) {
    final aTime = a.startDate ?? DateTime(1900);
    final bTime = b.startDate ?? DateTime(1900);
    return aTime.compareTo(bTime);
  });
  return sorted;
}

/// Extrae la lista de categorías únicas de [events], ordenadas alfabéticamente.
List<EventType> _buildCategories(List<Event> events) {
  final categories = events.map((e) => e.type).toSet().toList();
  categories.sort((a, b) => a.label.compareTo(b.label));
  return categories;
}

/// Filtra de [events] los que pertenecen a la fecha indicada por [dayDate].
List<Event> _filterEventsByDay({
  required List<Event> events,
  required String dayDate,
}) {
  return events.where((event) {
    if (event.startDate == null) {
      return false;
    }
    return event.startDate!.toIso8601String().startsWith(dayDate);
  }).toList();
}

/// Construye las secciones por día a partir de [days] y [sortedEvents].
List<ScheduleDaySection> _buildDaySections({
  required List<dynamic> days,
  required List<Event> sortedEvents,
  required String locale,
}) {
  return days.map((day) {
    final dayEvents = _filterEventsByDay(
      events: sortedEvents,
      dayDate: day.date,
    );

    return ScheduleDaySection(
      title: day.title.resolve(locale),
      date: day.date,
      items: _groupEvents(dayEvents),
    );
  }).toList();
}

/// Genera secciones de fallback agrupando eventos por fecha cuando
/// no hay días definidos explícitamente en los datos.
List<ScheduleDaySection> _buildFallbackSections(List<Event> sortedEvents) {
  final grouped = <String, List<Event>>{};
  for (final event in sortedEvents) {
    final dateKey =
        event.startDate?.toIso8601String().split('T').first ?? 'Sin fecha';
    grouped.putIfAbsent(dateKey, () => []).add(event);
  }

  // Convertir cada grupo en una sección
  return grouped.entries.map((entry) {
    return ScheduleDaySection(
      title: entry.key,
      date: entry.key,
      items: _groupEvents(entry.value),
    );
  }).toList();
}

/// Filtra [items] para mostrar solo los que pertenecen a [category].
List<ScheduleItem> _filterByCategory({
  required List<ScheduleItem> items,
  required EventType category,
}) {
  return items.where((item) {
    return switch (item) {
      SingleEventItem(:final event) => event.type == category,
      ParallelGroupItem(:final type) => type == category,
      DaySeparatorItem() => false,
    };
  }).toList();
}

/// Filtra [items] para mostrar solo los que tienen al menos un evento favorito.
List<ScheduleItem> _filterByFavorites({
  required List<ScheduleItem> items,
  required Set<String> favIds,
}) {
  return items.where((item) {
    return switch (item) {
      SingleEventItem(:final event) => favIds.contains(event.id),
      ParallelGroupItem(:final events) => events.any(
        (e) => favIds.contains(e.id),
      ),
      DaySeparatorItem() => false,
    };
  }).toList();
}

/// Calcula el índice de día seguro: si no hay secciones devuelve 0,
/// si el índice supera el rango lo recorta al máximo posible.
int _safeDay({required int dayIndex, required int sectionCount}) {
  if (sectionCount == 0) {
    return 0;
  }
  return dayIndex.clamp(0, sectionCount - 1);
}

/// Devuelve los [ScheduleItem] visibles aplicando los filtros activos.
final visibleItemsProvider = Provider<List<ScheduleItem>>((ref) {
  final state = ref.watch(scheduleViewModelProvider).valueOrNull;
  if (state == null || state.sections.isEmpty) {
    return [];
  }

  final dayIndex = ref.watch(selectedDayIndexProvider);
  final category = ref.watch(selectedScheduleCategoryProvider);
  final showFavorites = ref.watch(showOnlyFavoritesProvider);
  final favIds = ref.watch(favoriteIdsProvider).valueOrNull ?? const <String>{};

  final isFiltered = category != null || showFavorites;

  if (isFiltered) {
    final result = <ScheduleItem>[];
    for (final section in state.sections) {
      var items = section.items;
      if (category != null) {
        items = _filterByCategory(items: items, category: category);
      }
      if (showFavorites) {
        items = _filterByFavorites(items: items, favIds: favIds);
      }
      if (items.isNotEmpty) {
        result.add(DaySeparatorItem(label: section.title, date: section.date));
        result.addAll(items);
      }
    }
    return result;
  }

  final safeIndex = _safeDay(
    dayIndex: dayIndex,
    sectionCount: state.sections.length,
  );
  return state.sections[safeIndex].items;
});

/// ViewModel para la pantalla de Schedule.
@riverpod
class ScheduleViewModel extends _$ScheduleViewModel {
  // [:: Futuro] Obtener locale dinámico desde configuración del usuario
  static const String _locale = 'en';

  @override
  Future<ScheduleState> build() async {
    final useCase = ref.watch(getScheduleDataUseCaseProvider);
    final result = await useCase.execute();

    return switch (result) {
      Success(data: final data) => _buildStateFromData(data),
      Failure(message: final msg) => throw msg,
    };
  }

  /// Construye el [ScheduleState] a partir de los datos obtenidos del use case.
  ScheduleState _buildStateFromData(ScheduleDataResult data) {
    final sortedEvents = _sortEventsByDate(data.allEvents);
    final categories = _buildCategories(sortedEvents);

    final sections = _buildDaySections(
      days: data.days,
      sortedEvents: sortedEvents,
      locale: _locale,
    );

    // Si no vienen días definidos, generamos secciones por fecha de los eventos
    final finalSections = sections.isEmpty
        ? _buildFallbackSections(sortedEvents)
        : sections;

    return ScheduleState(sections: finalSections, categories: categories);
  }
}
