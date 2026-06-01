import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/data_providers.dart';
import 'package:iced26/domain/entities/conference_config.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/my_schedule_item.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/session_block.dart';
import 'package:iced26/domain/usecases/clear_all_saved_items_use_case.dart';
import 'package:iced26/domain/usecases/clear_favorites_use_case.dart';
import 'package:iced26/domain/usecases/delete_diary_note_use_case.dart';
import 'package:iced26/domain/usecases/get_home_data_use_case.dart';
import 'package:iced26/domain/usecases/get_schedule_data_use_case.dart';
import 'package:iced26/domain/usecases/save_diary_note_use_case.dart';
import 'package:iced26/domain/usecases/toggle_favorite_use_case.dart';
import 'package:iced26/domain/usecases/watch_diary_notes_use_case.dart';
import 'package:iced26/domain/usecases/watch_favorites_use_case.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'domain_providers.g.dart';

/// Provee los metadatos escalares de la edición del congreso.
@riverpod
Future<ConferenceConfig?> conferenceConfig(Ref ref) async {
  final result = await ref
      .watch(configRepositoryProvider)
      .getConferenceConfig();
  return switch (result) {
    Success(data: final config) => config,
    Failure(message: final msg) => throw Exception(msg),
  };
}

/// Locale por defecto del congreso — sincrónico para uso en viewmodels.
@riverpod
String defaultLocale(Ref ref) {
  return ref.watch(conferenceConfigProvider).asData?.value?.defaultLocale ??
      'en';
}

/// Provee el caso de uso para obtener los datos de la página de inicio.
@riverpod
GetHomeDataUseCase getHomeDataUseCase(Ref ref) {
  final scheduleRepo = ref.watch(scheduleRepositoryProvider);
  final homeRepo = ref.watch(homeRepositoryProvider);
  return GetHomeDataUseCase(scheduleRepo, homeRepo);
}

/// Provee el caso de uso para obtener los datos de la página de horarios.
@riverpod
GetScheduleDataUseCase getScheduleDataUseCase(Ref ref) {
  final scheduleRepo = ref.watch(scheduleRepositoryProvider);
  return GetScheduleDataUseCase(scheduleRepo);
}

/// Provee el caso de uso para observar los favoritos.
@riverpod
WatchFavoritesUseCase watchFavoritesUseCase(Ref ref) {
  return WatchFavoritesUseCase(ref.watch(favoritesRepositoryProvider));
}

/// Provee el caso de uso para alternar los favoritos.
@riverpod
ToggleFavoriteUseCase toggleFavoriteUseCase(Ref ref) {
  return ToggleFavoriteUseCase(ref.watch(favoritesRepositoryProvider));
}

/// Provee el caso de uso para limpiar los favoritos de eventos (N1).
@riverpod
ClearEventFavoritesUseCase clearFavoritesUseCase(Ref ref) {
  return ClearEventFavoritesUseCase(ref.watch(favoritesRepositoryProvider));
}

/// Provee el caso de uso para limpiar todos los items guardados (N1 + N3).
@riverpod
ClearAllSavedItemsUseCase clearAllSavedItemsUseCase(Ref ref) {
  return ClearAllSavedItemsUseCase(ref.watch(favoritesRepositoryProvider));
}

/// Provee el stream de IDs de eventos favoritos.
@riverpod
Stream<Set<String>> favoriteIds(Ref ref) {
  return ref.watch(watchFavoritesUseCaseProvider).execute();
}

/// Provee los talks agrupados por session block.
@riverpod
Future<Map<String, List<Event>>> presentationsForSlot(
  Ref ref,
  List<String> blockIds,
) async {
  final result = await ref
      .watch(scheduleRepositoryProvider)
      .getEventsBySessionIds(blockIds);
  final list = result is Success<List<Event>> ? result.data : <Event>[];
  final grouped = <String, List<Event>>{};
  for (final event in list) {
    if (event.sessionId != null) {
      grouped.putIfAbsent(event.sessionId!, () => []).add(event);
    }
  }
  return grouped;
}

/// Provee los items de "My Schedule" ordenados por tiempo.
@riverpod
Future<List<MyScheduleItem>> myScheduleItems(Ref ref) async {
  final eventIds = ref.watch(favoriteIdsProvider).value ?? {};
  final repo = ref.watch(scheduleRepositoryProvider);

  final eventsResult = await repo.getEventsByIds(eventIds.toList());
  final events = eventsResult is Success<List<Event>>
      ? eventsResult.data
      : <Event>[];

  final items = <MyScheduleItem>[...events.map(SavedEventItem.new)];

  items.sort(
    (a, b) =>
        (a.sortTime ?? DateTime(9999)).compareTo(b.sortTime ?? DateTime(9999)),
  );
  return items;
}

/// Provee el índice de personas por ID.
@riverpod
Future<Map<String, Person>> allPeopleIndex(Ref ref) async {
  final result = await ref.watch(scheduleRepositoryProvider).getAllPeople();
  if (result is! Success<List<Person>>) {
    return {};
  }
  return {for (final p in result.data) p.id: p};
}

/// Provee el caso de uso para observar las notas del diario.
@riverpod
WatchDiaryNotesUseCase watchDiaryNotesUseCase(Ref ref) {
  return WatchDiaryNotesUseCase(ref.watch(diaryRepositoryProvider));
}

/// Provee el caso de uso para guardar una nota del diario.
@riverpod
SaveDiaryNoteUseCase saveDiaryNoteUseCase(Ref ref) {
  return SaveDiaryNoteUseCase(ref.watch(diaryRepositoryProvider));
}

/// Provee el caso de uso para eliminar una nota del diario.
@riverpod
DeleteDiaryNoteUseCase deleteDiaryNoteUseCase(Ref ref) {
  return DeleteDiaryNoteUseCase(ref.watch(diaryRepositoryProvider));
}

/// Stream reactivo con todas las notas del diario.
@riverpod
Stream<List<DiaryNote>> diaryNotes(Ref ref) {
  return ref.watch(watchDiaryNotesUseCaseProvider).execute();
}

/// True si existe al menos una nota del diario para hoy.
/// Derivado de [diaryNotesProvider] para que el NavBar solo se reconstruya
/// cuando el bool cambia, no en cada actualización de la lista.
@riverpod
bool hasDiaryNoteForToday(Ref ref) {
  final today = DateTime.now();
  final notes = ref.watch(diaryNotesProvider).value ?? [];
  return notes.any((n) {
    return n.date.year == today.year &&
        n.date.month == today.month &&
        n.date.day == today.day;
  });
}

/// Provee el índice de eventos por ID.
@riverpod
Future<Map<String, Event>> allEventsIndex(Ref ref) async {
  final result = await ref.watch(scheduleRepositoryProvider).getAllEvents();
  if (result is! Success<List<Event>>) {
    return {};
  }
  return {for (final e in result.data) e.id: e};
}

/// Provee el índice de salas por ID.
@riverpod
Future<Map<String, Room>> allRoomsIndex(Ref ref) async {
  final result = await ref.watch(scheduleRepositoryProvider).getAllRooms();
  if (result is! Success<List<Room>>) {
    return {};
  }
  return {for (final r in result.data) r.id: r};
}

/// Provee el índice de bloques de sesión por ID.
@riverpod
Future<Map<String, SessionBlock>> allSessionBlocksIndex(Ref ref) async {
  final result = await ref
      .watch(scheduleRepositoryProvider)
      .getAllSessionBlocks();
  if (result is! Success<List<SessionBlock>>) {
    return {};
  }
  return {for (final b in result.data) b.id: b};
}

/// Índice inverso para listar los talks de un ponente sin escanear toda la lista en cada tap.
@riverpod
Future<Map<String, List<Event>>> presentationsByPersonId(Ref ref) async {
  final result = await ref.watch(scheduleRepositoryProvider).getAllEvents();
  final list = result is Success<List<Event>>
      ? result.data.where((event) => event.isTalk).toList()
      : <Event>[];
  final index = <String, List<Event>>{};
  for (final event in list) {
    for (final speaker in event.speakers) {
      index.putIfAbsent(speaker.personId, () => []).add(event);
    }
  }
  return index;
}
