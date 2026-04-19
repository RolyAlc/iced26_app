import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/core_providers.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';

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
    final Result<HomeState> result = await useCase.execute();

    return switch (result) {
      Success(data: final data) => data,
      Failure(message: final msg) => throw msg,
    };
  }

  // [:: Futuro] Se pueden añadir métodos adicionales para la UI, como filtros locales
  // o navegación que dependa de la lógica de la Home.
}
