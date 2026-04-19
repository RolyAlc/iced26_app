import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/domain/repositories/agenda_repository.dart';
import 'package:iced26/domain/repositories/home_repository.dart';
import 'package:iced26/domain/repositories/config_repository.dart';
import 'package:iced26/data/repositories/agenda_repository_impl.dart';
import 'package:iced26/data/repositories/home_repository_impl.dart';
import 'package:iced26/data/repositories/config_repository_impl.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/data/sources/local/json/local_json_service.dart';
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
AgendaRepository agendaRepository(AgendaRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return AgendaRepositoryImpl(db);
}

/// Provee el repositorio de la home.
@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return HomeRepositoryImpl(db);
}

/// Provee el repositorio de configuración.
@riverpod
ConfigRepository configRepository(ConfigRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  final jsonService = LocalJsonService();
  return ConfigRepositoryImpl(db, jsonService);
}

/// Proveedor de la base de datos.
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  // Instancia de la base de datos.
  final db = AppDatabase();
  // Cierra la conexión a la base de datos.
  ref.onDispose(() => db.close());
  return db;
}
