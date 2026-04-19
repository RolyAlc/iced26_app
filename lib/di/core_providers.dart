import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/domain/repositories/i_agenda_repository.dart';
import 'package:iced26/domain/repositories/i_home_repository.dart';
import 'package:iced26/domain/repositories/i_config_repository.dart';
import 'package:iced26/data/repositories/app_repository.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/usecases/get_home_data_use_case.dart';

part 'core_providers.g.dart';

/// Provee el caso de uso para obtener los datos de la Home.
@riverpod
GetHomeDataUseCase getHomeDataUseCase(GetHomeDataUseCaseRef ref) {
  final agendaRepo = ref.watch(agendaRepositoryProvider);
  final homeRepo = ref.watch(homeRepositoryProvider);
  return GetHomeDataUseCase(agendaRepo, homeRepo);
}

/// Provee el repositorio de la agenda.
@riverpod
IAgendaRepository agendaRepository(AgendaRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return AppRepository(db);
}

/// Provee el repositorio de la home.
@riverpod
IHomeRepository homeRepository(HomeRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return AppRepository(db);
}

/// Provee el repositorio de configuración.
@riverpod
IConfigRepository configRepository(ConfigRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return AppRepository(db);
}

/// Proveedor de la base de datos.
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase(); // Instancia de la base de datos.

  ref.onDispose(() => db.close()); // Cierra la conexión a la base de datos.

  return db;
}
