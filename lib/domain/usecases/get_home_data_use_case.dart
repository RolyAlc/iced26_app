import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/entities/conference_theme.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/news_item.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/domain/entities/submission_type.dart';
import 'package:iced26/domain/entities/zone.dart';
import 'package:iced26/domain/repositories/home_repository.dart';
import 'package:iced26/domain/repositories/schedule_repository.dart';

const _kKeynoteType = 'keynote_speaker';

/// Datos necesarios para la pantalla Home.
typedef HomeDataResult = ({
  List<Day> days,
  List<Event> allEvents,
  List<Room> allRooms,
  List<Zone> allZones,
  List<Person> allPeople,
  List<Presentation> keynotePresentations,
  List<NewsItem> news,
  List<SocialActivity> socialActivities,
  List<SubmissionType> subTypes,
  List<ConferenceTheme> conferenceThemes,
});

/// Caso de uso: obtiene toda la información necesaria para la pantalla Home.
class GetHomeDataUseCase {
  GetHomeDataUseCase(this._scheduleRepo, this._homeRepo);
  final ScheduleRepository _scheduleRepo;
  final HomeRepository _homeRepo;

  Future<Result<HomeDataResult>> execute() async {
    // Lanzamos todas las peticiones a la vez (concurrente).
    final daysF = _scheduleRepo.getAllDays();
    final eventsF = _scheduleRepo.getAllEvents();
    final roomsF = _scheduleRepo.getAllRooms();
    final zonesF = _scheduleRepo.getAllZones();
    final peopleF = _scheduleRepo.getAllPeople();
    final keynotesF = _scheduleRepo.getPresentationsByType(_kKeynoteType);
    final newsF = _homeRepo.getAllNews();
    final socialsF = _homeRepo.getAllSocialActivities();
    final subTypesF = _homeRepo.getAllSubmissionTypes();
    final themesF = _homeRepo.getConferenceThemes();

    // Recogemos los resultados.
    final days = await daysF;
    final events = await eventsF;
    final rooms = await roomsF;
    final zones = await zonesF;
    final people = await peopleF;
    final keynotes = await keynotesF;
    final news = await newsF;
    final socials = await socialsF;
    final subTypes = await subTypesF;
    final themes = await themesF;

    // En caso de que falle, devolvemos el primer error.
    final failure = _firstFailure([
      days,
      events,
      rooms,
      zones,
      people,
      keynotes,
      news,
      socials,
      subTypes,
      themes,
    ]);

    if (failure != null) {
      return Failure<HomeDataResult>(failure.message);
    }

    return Success((
      days: (days as Success<List<Day>>).data,
      allEvents: (events as Success<List<Event>>).data,
      allRooms: (rooms as Success<List<Room>>).data,
      allZones: (zones as Success<List<Zone>>).data,
      allPeople: (people as Success<List<Person>>).data,
      keynotePresentations: (keynotes as Success<List<Presentation>>).data,
      news: (news as Success<List<NewsItem>>).data,
      socialActivities: (socials as Success<List<SocialActivity>>).data,
      subTypes: (subTypes as Success<List<SubmissionType>>).data,
      conferenceThemes: (themes as Success<List<ConferenceTheme>>).data,
    ));
  }

  /// Devuelve el primer [Failure] de la lista, o null si todos son [Success].
  Failure? _firstFailure(List<Result> results) {
    for (final result in results) {
      if (result is Failure) {
        return result;
      }
    }
    return null;
  }
}
