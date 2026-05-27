import 'package:collection/collection.dart';

import 'package:iced26/core/constants/app_config.dart';
import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/category.dart';
import 'package:iced26/domain/entities/conference_theme.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/news_item.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/domain/entities/submission_type.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/domain/usecases/get_home_data_use_case.dart';
import 'package:iced26/presentation/app/navigation_constants.dart';
import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/features/home/viewmodel/mappers/event_ui_mapper.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/conference_theme_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/news_item_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/session_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/social_activity_ui_model.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

// TODO: Obtener locale dinámico desde configuración del usuario.
const _kMaxFeaturedEvents = 3;
const _kUnknownRoom = 'Unknown Room';
final _kMaxDate = DateTime(9999);
final _kMinDate = DateTime(0);

// Tipos que tienen valor de discovery para el asistente al congreso.
const _kDiscoverableTypes = {
  EventType.keynote,
  EventType.workshop,
  EventType.sessions,
  EventType.internationalPanel,
  EventType.presidents,
};

// Asigna una prioridad numérica al estado del evento para ordenación.
// Menor número = mayor relevancia en la UI.
int _statusPriority(EventStatus s) {
  return switch (s) {
    EventStatus.live => 0,
    EventStatus.next => 1,
    EventStatus.ended => 2,
  };
}

/// Filtra y ordena los eventos que NO han terminado (live o next).
List<Event> _sortLiveAndNextEvents(List<Event> events, DateTime now) {
  final liveOrNext = events.where((e) {
    return EventStatusResolver.resolve(e, now: now) != EventStatus.ended;
  }).toList();

  liveOrNext.sort((a, b) {
    final pa = _statusPriority(EventStatusResolver.resolve(a, now: now));
    final pb = _statusPriority(EventStatusResolver.resolve(b, now: now));

    if (pa != pb) {
      return pa.compareTo(pb);
    }
    return (a.startDate ?? _kMaxDate).compareTo(b.startDate ?? _kMaxDate);
  });

  return liveOrNext;
}

/// Ordena todos los [events] en orden cronológico inverso (post-conferencia).
List<Event> _sortByDateDescending(List<Event> events) {
  final sorted = [...events];
  sorted.sort((a, b) {
    return (b.startDate ?? _kMinDate).compareTo(a.startDate ?? _kMinDate);
  });
  return sorted;
}

/// Devuelve los eventos ordenados por relevancia: live → next → ended.
List<Event> _sortedByRelevance(List<Event> events) {
  final now = DateTime.now();
  final liveOrNext = _sortLiveAndNextEvents(events, now);

  if (liveOrNext.isNotEmpty) {
    return liveOrNext;
  }

  return _sortByDateDescending(events);
}

/// Construye un mapa [id → Person] para búsquedas eficientes por ID.
Map<String, Person> _buildPeopleIndex(List<Person> allPeople) {
  return {for (final p in allPeople) p.id: p};
}

/// Devuelve la [photoUrl] del primer speaker con foto válida, o null.
String? _resolveSpeakerPhoto(Event event, Map<String, Person> peopleById) {
  for (final id in event.speakers.map((s) => s.personId)) {
    final photoUrl = peopleById[id]?.photoUrl;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return photoUrl;
    }
  }
  return null;
}

/// Devuelve el nombre de la sala de [event] buscando en [allRooms].
String _resolveRoomName(Event event, List<Room> allRooms) {
  final room = allRooms.firstWhereOrNull((r) => r.id == event.roomId);
  return room?.name.resolve(AppConfig.defaultLocale) ?? _kUnknownRoom;
}

/// Construye la lista de [EventUIModel] para los eventos destacados.
List<EventUIModel> _buildFeaturedEvents({
  required List<Event> allEvents,
  required List<Room> allRooms,
  required Map<String, Person> peopleById,
}) {
  final discoverableEvents = [
    for (final e in allEvents)
      if (_kDiscoverableTypes.contains(e.type)) e,
  ];
  final topEvents = _sortedByRelevance(
    discoverableEvents,
  ).take(_kMaxFeaturedEvents);
  return topEvents.map((event) {
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
      .where((e) => e.speakers.any((s) => s.personId == speaker.id))
      .map(
        (e) => SessionUIModel(
          type: e.type,
          title: e.title.resolve(AppConfig.defaultLocale),
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
  required List<Presentation> keynotePresentations,
  required DateTime today,
}) {
  final presentation = keynotePresentations.firstWhereOrNull(
    (p) => p.speakers.any((s) => s.personId == speaker.id),
  );

  final events = _buildSpeakerSessions(
    speaker: speaker,
    keynoteEvents: keynoteEvents,
  );

  final isPresentingToday = events.any((s) {
    final d = s.event.startDate;
    return d != null && DateHelper.isSameDay(d, today);
  });

  return KeynoteSpeakerUIModel(
    id: speaker.id,
    name: speaker.name.resolve(AppConfig.defaultLocale),
    institution: speaker.institution,
    photoUrl: speaker.photoUrl,
    events: events,
    presentation: presentation,
    isPresentingToday: isPresentingToday,
  );
}

/// Construye la lista de [KeynoteSpeakerUIModel] para la pantalla Home.
List<KeynoteSpeakerUIModel> _buildKeynoteSpeakers({
  required List<Presentation> keynotePresentations,
  required List<Event> allEvents,
  required List<Person> allPeople,
  required DateTime today,
}) {
  final peopleById = {for (final p in allPeople) p.id: p};
  final keynoteEvents = allEvents
      .where((e) => e.type == EventType.keynote)
      .toList();

  final speakerIds = keynotePresentations
      .expand((p) => p.speakers.map((s) => s.personId))
      .toSet();

  final speakers = speakerIds.map((id) => peopleById[id]).whereType<Person>();

  return [
    for (final speaker in speakers)
      _buildKeynoteSpeakerModel(
        speaker: speaker,
        keynoteEvents: keynoteEvents,
        keynotePresentations: keynotePresentations,
        today: today,
      ),
  ];
}

/// Construye la lista de [Category] a partir de los subtipos del evento.
List<Category> _buildCategories(List<SubmissionType> subTypes) {
  return subTypes
      .map((st) => Category(name: st.name.resolve(AppConfig.defaultLocale)))
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

  /// Navega al Schedule reseteando el tab a Timeline.
  void navigateToScheduleTimeline() {
    ref.read(scheduleTopTabProvider.notifier).select(ScheduleTab.timeline);
    ref.read(navigationProvider.notifier).select(AppFeature.schedule);
  }

  /// Convierte las noticias de dominio en modelos de presentación.
  List<NewsItemUIModel> _buildNews(List<NewsItem> rawNews) {
    final locale = AppConfig.defaultLocale;
    return [
      for (final item in rawNews)
        NewsItemUIModel(
          id: item.id,
          title: item.title.resolve(locale),
          content: item.content.resolve(locale),
          imgUrl: item.imgUrl,
          webUrl: item.webUrl,
        ),
    ];
  }

  /// Convierte las actividades sociales de dominio en modelos de presentación.
  List<SocialActivityUIModel> _buildSocialActivities(
    List<SocialActivity> rawActivities,
  ) {
    final locale = AppConfig.defaultLocale;
    return [
      for (final activity in rawActivities)
        SocialActivityUIModel(
          id: activity.id,
          title: activity.title.resolve(locale),
          date: activity.date,
          time: activity.time,
          location: activity.location.resolve(locale),
          imgUrl: activity.imgUrl,
        ),
    ];
  }

  /// Convierte los temas de la conferencia de dominio en modelos de presentación.
  List<ConferenceThemeUIModel> _buildConferenceThemes(
    List<ConferenceTheme> rawThemes,
  ) {
    final locale = AppConfig.defaultLocale;
    return [
      for (final theme in rawThemes)
        ConferenceThemeUIModel(
          id: theme.id,
          name: theme.name.resolve(locale),
          description: theme.description.resolve(locale),
          topics: theme.topicsInclude
              .map((t) => t.resolve(locale))
              .where((t) => t.isNotEmpty)
              .toList(),
          readMinutes: theme.estimatedReadMinutes(locale),
        ),
    ];
  }

  /// Orquesta la construcción del [HomeState] a partir de los datos crudos.
  HomeState _buildStateFromData(HomeDataResult data) {
    final peopleById = _buildPeopleIndex(data.allPeople);
    final now = DateTime.now();

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
        keynotePresentations: data.keynotePresentations,
        allEvents: data.allEvents,
        allPeople: data.allPeople,
        today: now,
      ),
      categories: _buildCategories(data.subTypes),
      news: _buildNews(data.news),
      socialActivities: _buildSocialActivities(data.socialActivities),
      conferenceThemes: _buildConferenceThemes(data.conferenceThemes),
      headerInfoLabel: AppConfig.welcomeLabel,
      today: now,
    );
  }
}
