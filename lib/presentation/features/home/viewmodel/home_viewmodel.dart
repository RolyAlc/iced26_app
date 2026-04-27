import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/category.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/submission_type.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/domain/usecases/get_home_data_use_case.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/session_ui_model.dart';
import 'package:iced26/presentation/mappers/event_ui_mapper.dart';

part 'home_viewmodel.g.dart';

/// Locale usado para resolver textos multilingüe.
/// [:: Futuro] Obtener dinámicamente desde configuración del usuario.
const _locale = 'en';

/// Etiqueta de cabecera de la pantalla principal.
const _headerLabel = 'Welcome to ICED26';

/// Número máximo de eventos destacados a mostrar.
const _maxFeaturedEvents = 5;

// TODO: Analizar
/// Asigna una prioridad numérica al estado del evento para ordenación.
/// Menor número = mayor relevancia en la UI.
int _statusPriority(EventStatus s) => switch (s) {
  EventStatus.live => 0,
  EventStatus.next => 1,
  EventStatus.ended => 2,
};

final maxDate = DateTime(9999);
final minDate = DateTime(0);

/// Filtra y ordena los eventos que NO han terminado (live o next).
List<Event> _sortLiveAndNextEvents(List<Event> events, DateTime now) {
  final liveOrNext = events.where((e) {
    return EventStatusResolver.resolve(e, now: now) != EventStatus.ended;
  }).toList();

  liveOrNext.sort((a, b) {
    final pa = _statusPriority(EventStatusResolver.resolve(a, now: now));
    final pb = _statusPriority(EventStatusResolver.resolve(b, now: now));

    // Primero por estado, luego por fecha de inicio
    if (pa != pb) return pa.compareTo(pb);
    return (a.startDate ?? maxDate).compareTo(b.startDate ?? maxDate);
  });

  return liveOrNext;
}

/// Ordena todos los [events] en orden cronológico inverso (post-conferencia).
List<Event> _sortByDateDescending(List<Event> events) {
  return [
    ...events,
  ]..sort((a, b) => (b.startDate ?? minDate).compareTo(a.startDate ?? minDate));
}

/// Devuelve los eventos ordenados por relevancia: live → next → ended.
List<Event> _sortedByRelevance(List<Event> events) {
  final now = DateTime.now();
  final liveOrNext = _sortLiveAndNextEvents(events, now);

  if (liveOrNext.isNotEmpty) return liveOrNext;

  return _sortByDateDescending(events);
}

/// Construye un mapa [id → Person] para búsquedas eficientes por ID.
Map<String, Person> _buildPeopleIndex(List<Person> allPeople) {
  return {for (final p in allPeople) p.id: p};
}

/// Devuelve la [photoUrl] del primer speaker con foto válida, o null.
String? _resolveSpeakerPhoto(Event event, Map<String, Person> peopleById) {
  for (final id in event.speakerIds) {
    final photoUrl = peopleById[id]?.photoUrl;
    if (photoUrl != null && photoUrl.isNotEmpty) return photoUrl;
  }
  return null;
}

/// Devuelve el nombre de la sala de [event] buscando en [allRooms].
String _resolveRoomName(Event event, List<Room> allRooms) {
  final room = allRooms.firstWhereOrNull((r) => r.id == event.roomId);
  return room?.name.resolve(_locale) ?? 'Unknown Room';
}

/// Construye la lista de [EventUIModel] para los eventos destacados.
List<EventUIModel> _buildFeaturedEvents({
  required List<Event> allEvents,
  required List<Room> allRooms,
  required Map<String, Person> peopleById,
}) {
  return _sortedByRelevance(allEvents).take(_maxFeaturedEvents).map((event) {
    final roomName = _resolveRoomName(event, allRooms);
    final imageUrl = _resolveSpeakerPhoto(event, peopleById);
    return EventUIMapper.fromEntity(event, roomName, imageUrl: imageUrl);
  }).toList();
}

/// Construye los [SessionUIModel] que un speaker tiene en los eventos keynote.
List<SessionUIModel> _buildSpeakerSessions({
  required Person speaker,
  required List<Event> keynoteEvents,
}) {
  return keynoteEvents
      .where((e) => e.speakerIds.contains(speaker.id))
      .map(
        (e) => SessionUIModel(
          type: e.type,
          title: e.title.resolve(_locale),
          formattedDateTime: e.formattedDateTime,
          event: e,
        ),
      )
      .toList();
}

/// Construye el [KeynoteSpeakerUIModel] para un [speaker] dado.
KeynoteSpeakerUIModel _buildKeynoteSpeakerModel({
  required Person speaker,
  required List<Event> keynoteEvents,
}) {
  return KeynoteSpeakerUIModel(
    id: speaker.id,
    name: speaker.name.resolve(_locale),
    institution: speaker.institution,
    photoUrl: speaker.photoUrl,
    events: _buildSpeakerSessions(
      speaker: speaker,
      keynoteEvents: keynoteEvents,
    ),
  );
}

/// Construye la lista de [KeynoteSpeakerUIModel] para la pantalla Home.
List<KeynoteSpeakerUIModel> _buildKeynoteSpeakers({
  required List<Event> allEvents,
  required List<Person> allPeople,
}) {
  final keynoteEvents = allEvents
      .where((e) => e.type == EventType.keynote)
      .toList();

  return allPeople
      .where((p) => keynoteEvents.any((e) => e.speakerIds.contains(p.id)))
      .map(
        (p) =>
            _buildKeynoteSpeakerModel(speaker: p, keynoteEvents: keynoteEvents),
      )
      .toList();
}

/// Construye la lista de [Category] a partir de los subtipos del evento.
List<Category> _buildCategories(List<SubmissionType> subTypes) {
  return subTypes
      .map((st) => Category(name: st.name.resolve(_locale)))
      .toList();
}

/// ViewModel para la pantalla Home.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeState> build() async {
    final useCase = ref.watch(getHomeDataUseCaseProvider);
    final result = await useCase.execute();

    return switch (result) {
      Success(data: final data) => _buildStateFromData(data),
      Failure(message: final msg) => throw msg,
    };
  }

  /// Orquesta la construcción del [HomeState] a partir de los datos crudos.
  HomeState _buildStateFromData(HomeDataResult data) {
    final peopleById = _buildPeopleIndex(data.allPeople);

    return HomeState(
      days: data.days,
      allEvents: data.allEvents,
      allRooms: data.allRooms,
      allZones: data.allZones,
      featuredEvents: _buildFeaturedEvents(
        allEvents: data.allEvents,
        allRooms: data.allRooms,
        peopleById: peopleById,
      ),
      keynoteSpeakers: _buildKeynoteSpeakers(
        allEvents: data.allEvents,
        allPeople: data.allPeople,
      ),
      categories: _buildCategories(data.subTypes),
      news: data.news,
      socialActivities: data.socialActivities,
      headerInfoLabel: _headerLabel,
    );
  }
}
