import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/core/data/app_repository_provider.dart';
import 'package:iced26/data/mappers/event_ui_mapper.dart';
import 'package:iced26/features/home/viewmodel/home_categories_viewmodel.dart';
import 'package:iced26/features/home/viewmodel/models/home_state.dart';
import 'package:iced26/features/home/domain/category.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/domain/entities/submission_type.dart';

part 'home_provider.g.dart';

/// Provider del estado de la página principal.
@riverpod
class Home extends _$Home {
  /// Construye el estado de la página principal.
  /// Devuelve el estado de la home
  @override
  Future<HomeState> build() async {
    final repository = ref.watch(appRepositoryProvider);

    final results = await Future.wait([
      repository.getAllDays(),
      repository.getAllEvents(),
      repository.getAllRooms(),
      repository.getAllNews(),
      repository.getAllSocialActivities(),
      repository.getAllSubmissionTypes(),
    ]);

    final days = results[0] as List<Day>;
    final events = results[1] as List<Event>;
    final rooms = results[2] as List<Room>;
    final news = results[3] as List<NewsItem>;
    final socials = results[4] as List<SocialActivity>;
    final subTypes = results[5] as List<SubmissionType>;

    final featuredEvents = events.map((e) {
      final room = rooms.firstWhereOrNull((r) => r.id == e.roomId);
      final roomName = room?.name.resolve('en') ?? 'Unknown Room';

      return EventUIMapper.fromEntity(e, roomName);
    }).toList();

    final categoriesVM = HomeCategoriesViewModel();
    final categoryLayout = categoriesVM.buildLayout(
      subTypes.map((st) => Category(name: st.name.resolve('en'))).toList(),
    );

    return HomeState(
      days: List.from(days),
      allEvents: events,
      allRooms: rooms,
      featuredEvents: featuredEvents,
      categoryLayout: categoryLayout,
      news: news,
      socialActivities: socials,
      headerInfoLabel: 'Welcome to ICED26',
    );
  }
}
