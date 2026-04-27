import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/di/data_providers.dart';
import 'package:iced26/domain/usecases/get_home_data_use_case.dart';
import 'package:iced26/domain/usecases/get_schedule_data_use_case.dart';
import 'package:iced26/domain/usecases/watch_favorites_use_case.dart';
import 'package:iced26/domain/usecases/toggle_favorite_use_case.dart';

part 'domain_providers.g.dart';

/// Provee el caso de uso para obtener los datos de la Home.
@riverpod
GetHomeDataUseCase getHomeDataUseCase(GetHomeDataUseCaseRef ref) {
  final scheduleRepo = ref.watch(scheduleRepositoryProvider);
  final homeRepo = ref.watch(homeRepositoryProvider);
  return GetHomeDataUseCase(scheduleRepo, homeRepo);
}

/// Provee el caso de uso para obtener los datos de Schedule.
@riverpod
GetScheduleDataUseCase getScheduleDataUseCase(GetScheduleDataUseCaseRef ref) {
  final scheduleRepo = ref.watch(scheduleRepositoryProvider);
  return GetScheduleDataUseCase(scheduleRepo);
}

/// Provee el caso de uso para observar favoritos en tiempo real.
@riverpod
WatchFavoritesUseCase watchFavoritesUseCase(WatchFavoritesUseCaseRef ref) {
  return WatchFavoritesUseCase(ref.watch(favoritesRepositoryProvider));
}

/// Provee el caso de uso para alternar un favorito.
@riverpod
ToggleFavoriteUseCase toggleFavoriteUseCase(ToggleFavoriteUseCaseRef ref) {
  return ToggleFavoriteUseCase(ref.watch(favoritesRepositoryProvider));
}

/// IDs de eventos marcados como favoritos (stream reactivo desde Drift).
@riverpod
Stream<Set<String>> favoriteIds(FavoriteIdsRef ref) {
  return ref.watch(watchFavoritesUseCaseProvider).execute();
}
