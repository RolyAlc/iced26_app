import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/core_providers.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';
import 'package:iced26/presentation/mappers/event_ui_mapper.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_categories_viewmodel.dart';
import 'package:iced26/domain/entities/category.dart';

part 'home_viewmodel.g.dart';

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
        // Mapeo UI para Featured Events
        final featuredEvents = data.allEvents.take(5).map((e) {
          final room = data.allRooms.firstWhereOrNull((r) => r.id == e.roomId);
          final roomName = room?.name.resolve('en') ?? 'Unknown Room';
          return EventUIMapper.fromEntity(e, roomName);
        }).toList();

        // Mapeo UI para Categories
        final categoriesVM = HomeCategoriesViewModel();
        final categoryLayout = categoriesVM.buildLayout(
          data.subTypes
              .map((st) => Category(name: st.name.resolve('en')))
              .toList(),
        );

        return HomeState(
          days: data.days,
          allEvents: data.allEvents,
          allRooms: data.allRooms,
          featuredEvents: featuredEvents,
          categoryLayout: categoryLayout,
          news: data.news,
          socialActivities: data.socialActivities,
          headerInfoLabel: 'Welcome to ICED26',
        );
      case Failure(message: final msg):
        throw msg;
    }
  }

  // [:: Futuro] Se pueden añadir métodos adicionales para la UI, como filtros locales
  // o navegación que dependa de la lógica de la Home.
}
