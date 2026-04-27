import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/repositories/schedule_repository.dart';
import 'package:iced26/domain/repositories/home_repository.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/zone.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/domain/entities/submission_type.dart';

typedef HomeDataResult = ({
  List<Day> days,
  List<Event> allEvents,
  List<Room> allRooms,
  List<Zone> allZones,
  List<Person> allPeople,
  List<NewsItem> news,
  List<SocialActivity> socialActivities,
  List<SubmissionType> subTypes,
});

/// Caso de uso: Obtener toda la información necesaria para la pantalla Home.
class GetHomeDataUseCase {
  final ScheduleRepository _scheduleRepo;
  final HomeRepository _homeRepo;

  GetHomeDataUseCase(this._scheduleRepo, this._homeRepo);

  Future<Result<HomeDataResult>> execute() async {
    // Ejecutamos en paralelo pero tipado
    final futures = (
      days: _scheduleRepo.getAllDays(),
      events: _scheduleRepo.getAllEvents(),
      rooms: _scheduleRepo.getAllRooms(),
      zones: _scheduleRepo.getAllZones(),
      people: _scheduleRepo.getAllPeople(),
      news: _homeRepo.getAllNews(),
      socials: _homeRepo.getAllSocialActivities(),
      subTypes: _homeRepo.getAllSubmissionTypes(),
    );

    final results = (
      days: await futures.days,
      events: await futures.events,
      rooms: await futures.rooms,
      zones: await futures.zones,
      people: await futures.people,
      news: await futures.news,
      socials: await futures.socials,
      subTypes: await futures.subTypes,
    );

    // Validación de errores con contexto
    final failure = _findFailure(results);
    if (failure != null) {
      return Failure<HomeDataResult>(failure.message);
    }

    return Success((
      days: (results.days as Success<List<Day>>).data,
      allEvents: (results.events as Success<List<Event>>).data,
      allRooms: (results.rooms as Success<List<Room>>).data,
      allZones: (results.zones as Success<List<Zone>>).data,
      allPeople: (results.people as Success<List<Person>>).data,
      news: (results.news as Success<List<NewsItem>>).data,
      socialActivities: (results.socials as Success<List<SocialActivity>>).data,
      subTypes: (results.subTypes as Success<List<SubmissionType>>).data,
    ));
  }

  /// Busca el primer fallo en los resultados.
  Failure? _findFailure(
    ({
      Result days,
      Result events,
      Result rooms,
      Result zones,
      Result people,
      Result news,
      Result socials,
      Result subTypes,
    })
    results,
  ) {
    final allResults = [
      results.days,
      results.events,
      results.rooms,
      results.zones,
      results.people,
      results.news,
      results.socials,
      results.subTypes,
    ];

    for (final result in allResults) {
      if (result is Failure) {
        return Failure(result.message);
      }
    }

    return null;
  }
}
