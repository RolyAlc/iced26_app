import 'package:collection/collection.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:iced26/domain/entities/category.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/event_status.dart';
import 'package:iced26/domain/entities/event_type.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/submission_type.dart';
import 'package:iced26/domain/logic/event_status_resolver.dart';
import 'package:iced26/domain/usecases/get_home_data_use_case.dart';
import 'package:iced26/presentation/app/navigation_constants.dart';
import 'package:iced26/presentation/app/state/navigation_provider.dart';
import 'package:iced26/presentation/features/home/viewmodel/mappers/conference_theme_ui_mapper.dart';
import 'package:iced26/presentation/features/home/viewmodel/mappers/event_ui_mapper.dart';
import 'package:iced26/presentation/features/home/viewmodel/mappers/news_item_ui_mapper.dart';
import 'package:iced26/presentation/features/home/viewmodel/mappers/social_activity_ui_mapper.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/session_ui_model.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/models/schedule_state.dart';
import 'package:iced26/presentation/features/schedule/viewmodel/schedule_viewmodel.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

const _kMaxFeaturedEvents = 3;
const _kWelcomeLabel = 'Welcome to ICED26';
const _kUnknownRoom = 'Unknown Room';
final _kMaxDate = DateTime(9999);
final _kMinDate = DateTime(0);

const _kDiscoverableTypes = {
  EventType.keynote,
  EventType.workshop,
  EventType.sessions,
  EventType.internationalPanel,
  EventType.presidents,
};

/// ViewModel para la pantalla Home.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeState> build() async {
    final useCase = ref.watch(getHomeDataUseCaseProvider);
    final locale = ref.watch(defaultLocaleProvider);
    final result = await useCase.execute();

    return switch (result) {
      Success(data: final data) => _buildStateFromData(data, locale),
      Failure(message: final msg) => throw msg,
    };
  }

  /// Navega al Schedule reseteando el tab a Timeline.
  void navigateToScheduleTimeline() {
    ref.read(scheduleTopTabProvider.notifier).select(ScheduleTab.timeline);
    ref.read(navigationProvider.notifier).select(AppFeature.schedule);
  }

  /// Orquesta la construcción del [HomeState] a partir de los datos crudos.
  HomeState _buildStateFromData(HomeDataResult data, String locale) {
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
        locale: locale,
      ),
      keynoteSpeakers: _buildKeynoteSpeakers(
        keynoteTalks: data.keynoteTalks,
        allEvents: data.allEvents,
        allPeople: data.allPeople,
        today: now,
        locale: locale,
      ),
      categories: _buildCategories(data.subTypes, locale),
      news: data.news
          .map((e) => NewsItemUIMapper.fromEntity(e, locale))
          .toList(),
      socialActivities: data.socialActivities
          .map((e) => SocialActivityUIMapper.fromEntity(e, locale))
          .toList(),
      conferenceThemes: data.conferenceThemes
          .map((e) => ConferenceThemeUIMapper.fromEntity(e, locale))
          .toList(),
      headerInfoLabel: _kWelcomeLabel,
      today: now,
    );
  }

  static int _statusPriority(EventStatus s) {
    return switch (s) {
      EventStatus.live => 0,
      EventStatus.next => 1,
      EventStatus.ended => 2,
    };
  }

  static List<Event> _sortLiveAndNextEvents(List<Event> events, DateTime now) {
    final liveOrNext = events.where((e) {
      return EventStatusResolver.resolve(e, now: now) != EventStatus.ended;
    }).toList();

    liveOrNext.sort((a, b) {
      final pa = _statusPriority(EventStatusResolver.resolve(a, now: now));
      final pb = _statusPriority(EventStatusResolver.resolve(b, now: now));
      if (pa != pb) return pa.compareTo(pb);
      return (a.startDate ?? _kMaxDate).compareTo(b.startDate ?? _kMaxDate);
    });

    return liveOrNext;
  }

  static List<Event> _sortByDateDescending(List<Event> events) {
    final sorted = [...events];
    sorted.sort(
      (a, b) => (b.startDate ?? _kMinDate).compareTo(a.startDate ?? _kMinDate),
    );
    return sorted;
  }

  static List<Event> _sortedByRelevance(List<Event> events) {
    final now = DateTime.now();
    final liveOrNext = _sortLiveAndNextEvents(events, now);
    return liveOrNext.isNotEmpty ? liveOrNext : _sortByDateDescending(events);
  }

  static Map<String, Person> _buildPeopleIndex(List<Person> allPeople) {
    return {for (final p in allPeople) p.id: p};
  }

  static String? _resolveSpeakerPhoto(
    Event event,
    Map<String, Person> peopleById,
  ) {
    for (final id in event.speakers.map((s) => s.personId)) {
      final photoUrl = peopleById[id]?.photoUrl;
      if (photoUrl != null && photoUrl.isNotEmpty) return photoUrl;
    }
    return null;
  }

  static String _resolveRoomName(
    Event event,
    List<Room> allRooms,
    String locale,
  ) {
    final room = allRooms.firstWhereOrNull((r) => r.id == event.roomId);
    return room?.name.resolve(locale) ?? _kUnknownRoom;
  }

  static List<EventUIModel> _buildFeaturedEvents({
    required List<Event> allEvents,
    required List<Room> allRooms,
    required Map<String, Person> peopleById,
    required String locale,
  }) {
    final discoverableEvents = [
      for (final e in allEvents)
        if (_kDiscoverableTypes.contains(e.type)) e,
    ];
    final topEvents = _sortedByRelevance(
      discoverableEvents,
    ).take(_kMaxFeaturedEvents);
    return topEvents.map((event) {
      final roomName = _resolveRoomName(event, allRooms, locale);
      final imageUrl = _resolveSpeakerPhoto(event, peopleById);
      return EventUIMapper.fromEntity(event, roomName, imageUrl: imageUrl);
    }).toList();
  }

  static List<SessionUIModel> _buildSpeakerSessions({
    required Person speaker,
    required List<Event> keynoteEvents,
    required String locale,
  }) {
    return keynoteEvents
        .where((e) => e.speakers.any((s) => s.personId == speaker.id))
        .map(
          (e) => SessionUIModel(
            type: e.type,
            title: e.title.resolve(locale),
            formattedDateTime: e.formattedDateTime,
            event: e,
          ),
        )
        .toList();
  }

  static KeynoteSpeakerUIModel _buildKeynoteSpeakerModel({
    required Person speaker,
    required List<Event> keynoteEvents,
    required List<Event> keynoteTalks,
    required DateTime today,
    required String locale,
  }) {
    final talk = keynoteTalks.firstWhereOrNull(
      (event) => event.speakers.any((s) => s.personId == speaker.id),
    );
    final events = _buildSpeakerSessions(
      speaker: speaker,
      keynoteEvents: keynoteEvents,
      locale: locale,
    );
    final isPresentingToday = events.any((s) {
      final d = s.event.startDate;
      return d != null && DateHelper.isSameDay(d, today);
    });

    return KeynoteSpeakerUIModel(
      id: speaker.id,
      name: speaker.name.resolve(locale),
      institution: speaker.institution,
      photoUrl: speaker.photoUrl,
      events: events,
      talk: talk,
      isPresentingToday: isPresentingToday,
    );
  }

  static List<KeynoteSpeakerUIModel> _buildKeynoteSpeakers({
    required List<Event> keynoteTalks,
    required List<Event> allEvents,
    required List<Person> allPeople,
    required DateTime today,
    required String locale,
  }) {
    final peopleById = _buildPeopleIndex(allPeople);
    final keynoteEvents = allEvents
        .where((e) => e.type == EventType.keynote)
        .toList();
    final speakerIds = keynoteTalks
        .expand((event) => event.speakers.map((s) => s.personId))
        .toSet();
    final speakers = speakerIds.map((id) => peopleById[id]).whereType<Person>();

    return [
      for (final speaker in speakers)
        _buildKeynoteSpeakerModel(
          speaker: speaker,
          keynoteEvents: keynoteEvents,
          keynoteTalks: keynoteTalks,
          today: today,
          locale: locale,
        ),
    ];
  }

  static List<Category> _buildCategories(
    List<SubmissionType> subTypes,
    String locale,
  ) {
    return subTypes
        .map((st) => Category(name: st.name.resolve(locale)))
        .toList();
  }
}
