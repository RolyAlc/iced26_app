import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/domain/repositories/schedule_repository.dart';
import 'package:iced26/domain/repositories/home_repository.dart';
import 'package:iced26/domain/repositories/config_repository.dart';
import 'package:iced26/domain/repositories/favorites_repository.dart';
import 'package:iced26/data/repositories/schedule_repository_impl.dart';
import 'package:iced26/data/repositories/home_repository_impl.dart';
import 'package:iced26/data/repositories/config_repository_impl.dart';
import 'package:iced26/data/repositories/favorites_repository_impl.dart';
import 'package:iced26/data/sources/local/json/local_json_service.dart';
import 'package:iced26/di/core_providers.dart';

part 'data_providers.g.dart';

/// Provee el repositorio de la Schedule.
@riverpod
ScheduleRepository scheduleRepository(ScheduleRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return ScheduleRepositoryImpl(db);
}

/// Provee el repositorio de la Home.
@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return HomeRepositoryImpl(db);
}

/// Provee el repositorio de Configuración.
@riverpod
ConfigRepository configRepository(ConfigRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  final jsonService = LocalJsonService();
  return ConfigRepositoryImpl(db, jsonService);
}

/// Provee el repositorio de Favoritos.
@riverpod
FavoritesRepository favoritesRepository(FavoritesRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return FavoritesRepositoryImpl(db);
}
