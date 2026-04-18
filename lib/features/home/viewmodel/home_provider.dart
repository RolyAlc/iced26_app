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

part 'home_provider.g.dart';

/// Provee el estado de la home.
/// Retorna el estado completo de la UI
@riverpod
class Home extends _$Home {
  @override
  Future<HomeState> build() async {
    final repository = ref.watch(appRepositoryProvider);

    final results = await Future.wait([
      repository.getAllDays(),
      repository.getAllEvents(),
      repository.getAllRooms(),
    ]);

    final days = results[0] as List<Day>;
    final events = results[1] as List<Event>;
    final rooms = results[2] as List<Room>;

    final featuredEvents = events.map((e) {
      final room = rooms.firstWhereOrNull((r) => r.id == e.roomId);
      final roomName = room?.name.resolve('en') ?? 'Unknown Room';

      return EventUIMapper.fromEntity(e, roomName);
    }).toList();

    final categoriesVM = HomeCategoriesViewModel();
    final distinctTypes = events.map((e) => e.type).toSet().toList();
    final categoryLayout = categoriesVM.buildLayout(
      distinctTypes.map((t) => Category(name: t)).toList(),
    );

    return HomeState(
      days: List.from(days),
      featuredEvents: featuredEvents,
      categoryLayout: categoryLayout,
      news: [], // Próximamente desde la DB
      headerInfoLabel: 'Welcome to ICED26',
    );
  }
}
