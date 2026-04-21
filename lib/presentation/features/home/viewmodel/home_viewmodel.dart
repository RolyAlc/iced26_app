import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/category.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/mappers/event_ui_mapper.dart';

part 'home_viewmodel.g.dart';

/// Helper que asigna una prioridad numérica al estado del evento.
int _statusPriority(EventStatus s) => switch (s) {
  EventStatus.live => 0,
  EventStatus.next => 1,
  EventStatus.ended => 2,
};

/// Ordena eventos por relevancia: live, next y ended.
List<Event> _sortedByRelevance(List<Event> events) {
  final now = DateTime.now();
  final liveOrNext =
      events
          .where(
            (e) =>
                EventStatusResolver.resolve(e, now: now) != EventStatus.ended,
          )
          .toList()
        ..sort((a, b) {
          final pa = _statusPriority(EventStatusResolver.resolve(a, now: now));
          final pb = _statusPriority(EventStatusResolver.resolve(b, now: now));
          if (pa != pb) return pa.compareTo(pb);
          return (a.startDate ?? DateTime(9999)).compareTo(
            b.startDate ?? DateTime(9999),
          );
        });

  if (liveOrNext.isNotEmpty) return liveOrNext;

  // Post-conferencia: mostrar los últimos eventos por orden cronológico inverso
  return [...events]..sort(
    (a, b) =>
        (b.startDate ?? DateTime(0)).compareTo(a.startDate ?? DateTime(0)),
  );
}

/// Devuelve la foto del primer speaker con photoUrl, o null si no hay ninguna.
String? _resolveSpeakerPhoto(Event event, Map<String, Person> peopleById) {
  for (final id in event.speakerIds) {
    final photoUrl = peopleById[id]?.photoUrl;
    if (photoUrl != null && photoUrl.isNotEmpty) return photoUrl;
  }
  return null;
}

/// ViewModel para la pantalla Home.
/// Centraliza la obtención de datos a través del 'UseCase' y gestiona el estado de la UI.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  /// Construye el estado de la página principal.
  /// Obtiene los datos del UseCase y mapea el Result a un estado consumible por la UI.
  @override
  Future<HomeState> build() async {
    final useCase = ref.watch(getHomeDataUseCaseProvider);
    final result = await useCase.execute();

    switch (result) {
      case Success(data: final data):
        // Mapeo UI para Featured Events — ordenados por relevancia: live → next → ended
        final peopleById = {for (final p in data.allPeople) p.id: p};
        final featuredEvents = _sortedByRelevance(data.allEvents).take(5).map((
          e,
        ) {
          final room = data.allRooms.firstWhereOrNull((r) => r.id == e.roomId);
          final roomName = room?.name.resolve('en') ?? 'Unknown Room';
          final imageUrl = _resolveSpeakerPhoto(e, peopleById);
          return EventUIMapper.fromEntity(e, roomName, imageUrl: imageUrl);
        }).toList();

        // Keynote speakers: personas referenciadas en eventos de tipo keynote
        final keynoteEvents = data.allEvents
            .where((e) => e.type == 'keynote')
            .toList();
        final keynoteSpeakers = data.allPeople
            .where((p) => keynoteEvents.any((e) => e.speakerIds.contains(p.id)))
            .map(
              (p) => KeynoteSpeakerUIModel(
                id: p.id,
                name: p.name.resolve('en'),
                institution: p.institution,
                photoUrl: p.photoUrl,
                events: keynoteEvents
                    .where((e) => e.speakerIds.contains(p.id))
                    .toList(),
              ),
            )
            .toList();

        // Mapeo UI para Categories
        final categories = data.subTypes
            .map((st) => Category(name: st.name.resolve('en')))
            .toList();

        return HomeState(
          days: data.days,
          allEvents: data.allEvents,
          allRooms: data.allRooms,
          featuredEvents: featuredEvents,
          keynoteSpeakers: keynoteSpeakers,
          categories: categories,
          news: data.news,
          socialActivities: data.socialActivities,
          headerInfoLabel: 'Welcome to ICED26',
        );
      case Failure(message: final msg):
        throw msg;
    }
  }
}
