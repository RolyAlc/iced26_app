import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/domain/repositories/schedule_repository.dart';
import 'package:iced26/domain/repositories/home_repository.dart';
import 'package:iced26/domain/repositories/config_repository.dart';
import 'package:iced26/domain/repositories/favorites_repository.dart';
import 'package:iced26/domain/repositories/presentation_favorites_repository.dart';
import 'package:iced26/data/repositories/schedule_repository_impl.dart';
import 'package:iced26/data/repositories/home_repository_impl.dart';
import 'package:iced26/data/repositories/config_repository_impl.dart';
import 'package:iced26/data/repositories/favorites_repository_impl.dart';
import 'package:iced26/data/repositories/presentation_favorites_repository_impl.dart';
import 'package:iced26/data/sources/local/json/local_json_service.dart';
import 'package:iced26/di/core_providers.dart';

part 'data_providers.g.dart';

/// Provee el repositorio de horarios.
@riverpod
ScheduleRepository scheduleRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ScheduleRepositoryImpl(db);
}

/// Provee el repositorio de inicio.
@riverpod
HomeRepository homeRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return HomeRepositoryImpl(db);
}

/// Provee el repositorio de configuración.
@riverpod
ConfigRepository configRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final jsonService = LocalJsonService();
  return ConfigRepositoryImpl(db, jsonService);
}

/// Provee el repositorio de favoritos.
@riverpod
FavoritesRepository favoritesRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return FavoritesRepositoryImpl(db);
}

/// Provee el repositorio de presentaciones favoritas.
@riverpod
PresentationFavoritesRepository presentationFavoritesRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PresentationFavoritesRepositoryImpl(db);
}
