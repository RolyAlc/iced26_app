import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/domain/entities/event.dart';

part 'schedule_viewmodel.g.dart';

/// Dia activo como índice de tab. 0 = primer día.
final selectedDayIndexProvider = StateProvider<int>((ref) => 0);

/// Categoria activa como filtro. `null` = sin filtro (mostrar todo).
final selectedScheduleCategoryProvider = StateProvider<String?>((ref) => null);

/// Muestra solo los eventos guardados en favoritos.
final showOnlyFavoritesProvider = StateProvider<bool>((ref) => false);

/// IDs de eventos marcados como favoritos (stream reactivo desde Drift).
@riverpod
Stream<Set<String>> favoriteIds(FavoriteIdsRef ref) {
  return ref.watch(watchFavoritesUseCaseProvider).execute();
}

/// Tipos que pueden formar grupos de sesiones paralelas.
const _parallelTypes = {'sessions', 'workshop'};

/// Agrupa eventos con mismo [startDate] y mismo [type] en [ParallelGroupItem].
/// El resto quedan como [SingleEventItem].
List<ScheduleItem> _groupEvents(List<Event> events) {
  final items = <ScheduleItem>[];
  final processedIds = <String>{};

  for (final event in events) {
    if (processedIds.contains(event.id)) continue;

    if (_parallelTypes.contains(event.type) && event.startDate != null) {
      final parallels = events
          .where(
            (e) =>
                !processedIds.contains(e.id) &&
                e.startDate == event.startDate &&
                e.type == event.type,
          )
          .toList();

      if (parallels.length > 1) {
        items.add(
          ParallelGroupItem(
            events: parallels,
            startDate: event.startDate!,
            type: event.type,
          ),
        );
        processedIds.addAll(parallels.map((e) => e.id));
      } else {
        items.add(SingleEventItem(event));
        processedIds.add(event.id);
      }
    } else {
      items.add(SingleEventItem(event));
      processedIds.add(event.id);
    }
  }

  return items;
}

/// ViewModel para la pantalla de Schedule.
/// Maneja la obtención de eventos agrupados y el estado de carga/error.
@riverpod
class ScheduleViewModel extends _$ScheduleViewModel {
  @override
  Future<ScheduleState> build() async {
    // [:: Futuro] Obtener locale dinámico
    const locale = 'en';

    final useCase = ref.watch(getScheduleDataUseCaseProvider);
    final result = await useCase.execute();

    switch (result) {
      case Success(data: final data):
        final sortedEvents = [...data.allEvents];
        sortedEvents.sort((a, b) {
          final aTime = a.startDate ?? DateTime(1900);
          final bTime = b.startDate ?? DateTime(1900);
          return aTime.compareTo(bTime);
        });

        final categories = sortedEvents.map((e) => e.type).toSet().toList()
          ..sort();

        final sections = data.days.map((day) {
          final dayEvents = sortedEvents.where((event) {
            if (event.startDate == null) return false;
            return event.startDate!.toIso8601String().startsWith(day.date);
          }).toList();

          return ScheduleDaySection(
            title: day.title.resolve(locale),
            date: day.date,
            items: _groupEvents(dayEvents),
          );
        }).toList();

        if (sections.isEmpty) {
          final grouped = <String, List<Event>>{};
          for (final event in sortedEvents) {
            final dateKey =
                event.startDate?.toIso8601String().split('T').first ??
                'Sin fecha';
            grouped.putIfAbsent(dateKey, () => []).add(event);
          }

          final fallbackSections = grouped.entries.map((entry) {
            return ScheduleDaySection(
              title: entry.key,
              date: entry.key,
              items: _groupEvents(entry.value),
            );
          }).toList();

          return ScheduleState(
            sections: fallbackSections,
            categories: categories,
          );
        }

        return ScheduleState(sections: sections, categories: categories);

      case Failure(message: final msg):
        throw msg;
    }
  }
}
