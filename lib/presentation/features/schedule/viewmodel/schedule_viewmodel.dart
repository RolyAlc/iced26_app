import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/session_block.dart';
import 'package:iced26/domain/usecases/get_schedule_data_use_case.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';

part 'schedule_viewmodel.g.dart';

/// Tab superior de Schedule: 0 = Schedule, 1 = My Schedule.
@riverpod
class ScheduleTopTab extends _$ScheduleTopTab {
  @override
  int build() => 0;
  void select(int index) => state = index;
}

/// Día activo como índice de tab. 0 = primer día.
@riverpod
class SelectedDayIndex extends _$SelectedDayIndex {
  @override
  int build() => 0;
  void set(int value) => state = value;
}

/// Categoría activa como filtro. `null` = sin filtro (mostrar todo).
@riverpod
class SelectedScheduleCategory extends _$SelectedScheduleCategory {
  @override
  EventType? build() => null;

  void set(EventType? value) => state = value;

  /// Selecciona [cat] o lo deselecciona si ya estaba activo. `null` limpia el filtro.
  void select(EventType? cat) =>
      state = (cat != null && state == cat) ? null : cat;
}

/// Muestra solo los eventos guardados en favoritos.
@riverpod
class ShowOnlyFavorites extends _$ShowOnlyFavorites {
  @override
  bool build() => false;
  void toggle() => state = !state;
}

/// Indexa los bloques de sesión por su `parentId` (N1 event id).
Map<String, List<SessionBlock>> _indexBlocksByParent(
  List<SessionBlock> blocks,
) {
  final map = <String, List<SessionBlock>>{};
  for (final block in blocks) {
    map.putIfAbsent(block.parentId, () => []).add(block);
  }
  return map;
}

/// Convierte una lista de eventos en [ScheduleItem]s usando la relación parentId.
List<ScheduleItem> _buildItems({
  required List<Event> events,
  required Map<String, List<SessionBlock>> blocksByParent,
}) {
  return events.map((event) {
    final blocks = blocksByParent[event.id] ?? [];
    if (blocks.isNotEmpty) {
      return SessionSlotItem(event: event, blocks: blocks);
    }
    return SingleEventItem(event);
  }).toList();
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
  final day = DateTime.tryParse(dayDate);
  if (day == null) return [];
  return events.where((event) {
    final d = event.startDate;
    if (d == null) return false;
    return d.year == day.year && d.month == day.month && d.day == day.day;
  }).toList();
}

/// Construye las secciones por día a partir de [days] y [sortedEvents].
List<ScheduleDaySection> _buildDaySections({
  required List<dynamic> days,
  required List<Event> sortedEvents,
  required Map<String, List<SessionBlock>> blocksByParent,
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
      items: _buildItems(events: dayEvents, blocksByParent: blocksByParent),
    );
  }).toList();
}

/// Genera secciones de fallback agrupando eventos por fecha.
List<ScheduleDaySection> _buildFallbackSections({
  required List<Event> sortedEvents,
  required Map<String, List<SessionBlock>> blocksByParent,
}) {
  final grouped = <String, List<Event>>{};
  for (final event in sortedEvents) {
    final dateKey =
        event.startDate?.toIso8601String().split('T').first ?? 'Sin fecha';
    grouped.putIfAbsent(dateKey, () => []).add(event);
  }
  return grouped.entries.map((entry) {
    return ScheduleDaySection(
      title: entry.key,
      date: entry.key,
      items: _buildItems(events: entry.value, blocksByParent: blocksByParent),
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
      SessionSlotItem(:final event) => event.type == category,
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
      SessionSlotItem(:final event) => favIds.contains(event.id),
      DaySeparatorItem() => false,
    };
  }).toList();
}

/// Índice del día activo ajustado al rango válido de secciones.
final safeDayIndexProvider = Provider<int>((ref) {
  final state = ref.watch(scheduleViewModelProvider).value;
  final dayIndex = ref.watch(selectedDayIndexProvider);
  if (state == null || state.sections.isEmpty) {
    return 0;
  }
  return dayIndex.clamp(0, state.sections.length - 1);
});

/// Devuelve los [ScheduleItem] visibles aplicando los filtros activos.
final visibleItemsProvider = Provider<List<ScheduleItem>>((ref) {
  final state = ref.watch(scheduleViewModelProvider).value;
  if (state == null || state.sections.isEmpty) {
    return [];
  }

  final dayIndex = ref.watch(selectedDayIndexProvider);
  final category = ref.watch(selectedScheduleCategoryProvider);
  final showFavorites = ref.watch(showOnlyFavoritesProvider);
  final favIds = ref.watch(favoriteIdsProvider).value ?? const <String>{};

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

  final safeIndex = dayIndex.clamp(0, state.sections.length - 1);
  return state.sections[safeIndex].items;
});

/// ViewModel para la pantalla de Schedule.
@riverpod
class ScheduleViewModel extends _$ScheduleViewModel {
  // TODO: Obtener locale dinámico desde configuración del usuario
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
    final blocksByParent = _indexBlocksByParent(data.allSessionBlocks);

    final sections = _buildDaySections(
      days: data.days,
      sortedEvents: sortedEvents,
      blocksByParent: blocksByParent,
      locale: _locale,
    );

    final finalSections = sections.isEmpty
        ? _buildFallbackSections(
            sortedEvents: sortedEvents,
            blocksByParent: blocksByParent,
          )
        : sections;

    return ScheduleState(sections: finalSections, categories: categories);
  }
}
