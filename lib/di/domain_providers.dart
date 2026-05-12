import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/data_providers.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/my_schedule_item.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/usecases/get_home_data_use_case.dart';
import 'package:iced26/domain/usecases/get_schedule_data_use_case.dart';
import 'package:iced26/domain/usecases/clear_favorites_use_case.dart';
import 'package:iced26/domain/usecases/toggle_favorite_use_case.dart';
import 'package:iced26/domain/usecases/watch_favorites_use_case.dart';
import 'package:iced26/domain/usecases/toggle_presentation_favorite_use_case.dart';
import 'package:iced26/domain/usecases/watch_presentation_favorites_use_case.dart';
import 'package:iced26/domain/usecases/watch_diary_notes_use_case.dart';
import 'package:iced26/domain/usecases/save_diary_note_use_case.dart';
import 'package:iced26/domain/usecases/delete_diary_note_use_case.dart';
import 'package:iced26/domain/entities/diary_note.dart';

part 'domain_providers.g.dart';

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

/// Provee el caso de uso para limpiar los favoritos.
@riverpod
ClearFavoritesUseCase clearFavoritesUseCase(Ref ref) {
  return ClearFavoritesUseCase(ref.watch(favoritesRepositoryProvider));
}

/// Provee el stream de IDs de eventos favoritos.
@riverpod
Stream<Set<String>> favoriteIds(Ref ref) {
  return ref.watch(watchFavoritesUseCaseProvider).execute();
}

/// Provee el caso de uso para observar las presentaciones favoritas.
@riverpod
WatchPresentationFavoritesUseCase watchPresentationFavoritesUseCase(Ref ref) {
  return WatchPresentationFavoritesUseCase(
    ref.watch(presentationFavoritesRepositoryProvider),
  );
}

/// Provee el caso de uso para alternar las presentaciones favoritas.
@riverpod
TogglePresentationFavoriteUseCase togglePresentationFavoriteUseCase(Ref ref) {
  return TogglePresentationFavoriteUseCase(
    ref.watch(presentationFavoritesRepositoryProvider),
  );
}

/// Provee el stream de IDs de presentaciones favoritas.
@riverpod
Stream<Set<String>> presentationFavoriteIds(Ref ref) {
  return ref.watch(watchPresentationFavoritesUseCaseProvider).execute();
}

/// Provee las presentaciones agrupadas por sessionBlockId.
@riverpod
Future<Map<String, List<Presentation>>> presentationsForSlot(
  Ref ref,
  List<String> blockIds,
) async {
  final result = await ref
      .watch(scheduleRepositoryProvider)
      .getPresentationsByBlockIds(blockIds);
  final list = result is Success<List<Presentation>>
      ? result.data
      : <Presentation>[];
  final grouped = <String, List<Presentation>>{};
  for (final p in list) {
    if (p.sessionBlockId != null) {
      grouped.putIfAbsent(p.sessionBlockId!, () => []).add(p);
    }
  }
  return grouped;
}

/// Provee los items de "My Schedule" ordenados por tiempo.
@riverpod
Future<List<MyScheduleItem>> myScheduleItems(Ref ref) async {
  final eventIds = ref.watch(favoriteIdsProvider).value ?? {};
  final presentationIds =
      ref.watch(presentationFavoriteIdsProvider).value ?? {};
  final repo = ref.watch(scheduleRepositoryProvider);

  final eventsResult = await repo.getEventsByIds(eventIds.toList());
  final presentationsResult = await repo.getPresentationsByIds(
    presentationIds.toList(),
  );

  final events = eventsResult is Success<List<Event>>
      ? eventsResult.data
      : <Event>[];
  final presentations = presentationsResult is Success<List<Presentation>>
      ? presentationsResult.data
      : <Presentation>[];

  final items = <MyScheduleItem>[
    ...events.map(SavedEventItem.new),
    ...presentations.map(SavedPresentationItem.new),
  ];

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

/// Provee el índice de salas por ID.
@riverpod
Future<Map<String, Room>> allRoomsIndex(Ref ref) async {
  final result = await ref.watch(scheduleRepositoryProvider).getAllRooms();
  if (result is! Success<List<Room>>) {
    return {};
  }
  return {for (final r in result.data) r.id: r};
}

/// Índice inverso para listar las presentaciones de un ponente sin escanear toda la lista en cada tap.
@riverpod
Future<Map<String, List<Presentation>>> presentationsByPersonId(Ref ref) async {
  final result = await ref
      .watch(scheduleRepositoryProvider)
      .getAllPresentations();
  final list = result is Success<List<Presentation>>
      ? result.data
      : <Presentation>[];
  final index = <String, List<Presentation>>{};
  for (final p in list) {
    for (final s in p.speakers) {
      index.putIfAbsent(s.personId, () => []).add(p);
    }
  }
  return index;
}
