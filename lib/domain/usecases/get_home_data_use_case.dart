import 'package:iced26/core/errors/result.dart';
import 'package:iced26/domain/repositories/agenda_repository.dart';
import 'package:iced26/domain/repositories/home_repository.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/domain/entities/submission_type.dart';
import 'package:collection/collection.dart';
import 'package:iced26/presentation/features/event/viewmodel/event_ui_mapper.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_categories_viewmodel.dart';
import 'package:iced26/domain/entities/category.dart';

/// Caso de uso: Obtener toda la información necesaria para la pantalla Home.
class GetHomeDataUseCase {
  final AgendaRepository _agendaRepo;
  final HomeRepository _homeRepo;

  GetHomeDataUseCase(this._agendaRepo, this._homeRepo);

  /// Devuelve el estado de la Home.
  Future<Result<HomeState>> execute() async {
    final results = await Future.wait([
      _agendaRepo.getAllDays(),
      _agendaRepo.getAllEvents(),
      _agendaRepo.getAllRooms(),
      _homeRepo.getAllNews(),
      _homeRepo.getAllSocialActivities(),
      _homeRepo.getAllSubmissionTypes(),
    ]);

    // Verificamos si hubo algún error en las peticiones
    for (final result in results) {
      if (result is Failure) {
        return Failure((result as Failure).message);
      }
    }

    // TODO: Mejorar el manejo de errores.
    // En caso de que todo haya ido bien, obtenemos los datos.
    final days = (results[0] as Success<List<Day>>).data;
    final events = (results[1] as Success<List<Event>>).data;
    final rooms = (results[2] as Success<List<Room>>).data;
    final news = (results[3] as Success<List<NewsItem>>).data;
    final socials = (results[4] as Success<List<SocialActivity>>).data;
    final subTypes = (results[5] as Success<List<SubmissionType>>).data;

    // Lógica de transformación.
    final featuredEvents = events.take(5).map((e) {
      final room = rooms.firstWhereOrNull((r) => r.id == e.roomId);
      final roomName = room?.name.resolve('en') ?? 'Unknown Room';
      return EventUIMapper.fromEntity(e, roomName);
    }).toList();

    final categoriesVM = HomeCategoriesViewModel();
    final categoryLayout = categoriesVM.buildLayout(
      subTypes.map((st) => Category(name: st.name.resolve('en'))).toList(),
    );

    return Success(
      HomeState(
        days: days,
        allEvents: events,
        allRooms: rooms,
        featuredEvents: featuredEvents,
        categoryLayout: categoryLayout,
        news: news,
        socialActivities: socials,
        headerInfoLabel: 'Welcome to ICED26',
      ),
    );
  }
}
