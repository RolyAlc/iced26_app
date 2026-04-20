import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/di/data_providers.dart';
import 'package:iced26/domain/usecases/get_home_data_use_case.dart';
import 'package:iced26/domain/usecases/get_agenda_data_use_case.dart';

part 'domain_providers.g.dart';

/// Provee el caso de uso para obtener los datos de la Home.
@riverpod
GetHomeDataUseCase getHomeDataUseCase(GetHomeDataUseCaseRef ref) {
  final agendaRepo = ref.watch(agendaRepositoryProvider);
  final homeRepo = ref.watch(homeRepositoryProvider);
  return GetHomeDataUseCase(agendaRepo, homeRepo);
}

/// Provee el caso de uso para obtener los datos de la Agenda.
@riverpod
GetAgendaDataUseCase getAgendaDataUseCase(GetAgendaDataUseCaseRef ref) {
  final agendaRepo = ref.watch(agendaRepositoryProvider);
  return GetAgendaDataUseCase(agendaRepo);
}
