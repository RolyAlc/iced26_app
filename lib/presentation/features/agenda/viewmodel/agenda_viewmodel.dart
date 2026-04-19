import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/core_providers.dart';
import 'package:iced26/presentation/features/agenda/viewmodel/models/agenda_state.dart';

part 'agenda_viewmodel.g.dart';

/// ViewModel para la pantalla de Agenda.
/// Maneja la obtención de eventos agrupados y el estado de carga/error.
@riverpod
class AgendaViewModel extends _$AgendaViewModel {
  @override
  Future<AgendaState> build() async {
    // [:: Futuro] Obtener locale dinámico
    const locale = 'en';

    final useCase = ref.watch(getAgendaDataUseCaseProvider);
    final result = await useCase.execute(locale);

    return switch (result) {
      Success(data: final data) => data,
      Failure(message: final msg) => throw msg,
    };
  }
}
