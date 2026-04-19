import 'package:iced26/core/errors/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/di/core_providers.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/home_state.dart';

part 'home_provider.g.dart';

/// Provider del estado de la página principal.
@riverpod
class Home extends _$Home {
  /// Construye el estado de la página principal.
  /// Devuelve un result que puede ser un estado de la home o un error.
  @override
  Future<HomeState> build() async {
    final useCase = ref.watch(getHomeDataUseCaseProvider);
    final Result<HomeState> result = await useCase.execute();

    return switch (result) {
      Success(data: final data) => data,
      Failure(message: final msg) => throw msg,
    };
  }
}
