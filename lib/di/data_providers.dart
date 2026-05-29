import 'package:iced26/data/repositories/config_repository_impl.dart';
import 'package:iced26/data/repositories/diary_repository_impl.dart';
import 'package:iced26/data/repositories/favorites_repository_impl.dart';
import 'package:iced26/data/repositories/home_repository_impl.dart';
import 'package:iced26/data/repositories/presentation_favorites_repository_impl.dart';
import 'package:iced26/data/repositories/recent_searches_repository_impl.dart';
import 'package:iced26/data/repositories/recently_viewed_repository_impl.dart';
import 'package:iced26/data/repositories/schedule_repository_impl.dart';
import 'package:iced26/data/sources/app_data_source.dart';
import 'package:iced26/data/sources/conference_data_seeder.dart';
import 'package:iced26/data/sources/local/json/local_json_service.dart';
import 'package:iced26/di/core_providers.dart';
import 'package:iced26/domain/repositories/config_repository.dart';
import 'package:iced26/domain/repositories/diary_repository.dart';
import 'package:iced26/domain/repositories/favorites_repository.dart';
import 'package:iced26/domain/repositories/home_repository.dart';
import 'package:iced26/domain/repositories/presentation_favorites_repository.dart';
import 'package:iced26/domain/repositories/recent_searches_repository.dart';
import 'package:iced26/domain/repositories/recently_viewed_repository.dart';
import 'package:iced26/domain/repositories/schedule_repository.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  final AppDataSource source = const LocalJsonService();
  final seeder = ConferenceDataSeeder(db, source);
  return ConfigRepositoryImpl(db, seeder);
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

/// Provee el repositorio del diario personal.
@riverpod
DiaryRepository diaryRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DiaryRepositoryImpl(db);
}

/// Provee el repositorio de búsquedas recientes.
@riverpod
RecentSearchesRepository recentSearchesRepository(Ref ref) {
  return RecentSearchesRepositoryImpl();
}

/// Provee el repositorio de eventos vistos recientemente.
@riverpod
RecentlyViewedRepository recentlyViewedRepository(Ref ref) {
  return const RecentlyViewedRepositoryImpl(prefsKey: 'recently_viewed_events');
}

/// Provee el repositorio de ponentes vistos recientemente.
/// Misma implementación que eventos, distinta clave de almacenamiento.
@riverpod
RecentlyViewedRepository recentlyViewedPeopleRepository(Ref ref) {
  return const RecentlyViewedRepositoryImpl(prefsKey: 'recently_viewed_people');
}
