import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/data_providers.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recently_viewed_people_provider.g.dart';

/// Notifier que gestiona el estado de los ponentes vistos recientemente.
/// Persiste en SharedPreferences a través del repositorio.
@Riverpod(keepAlive: true)
class RecentlyViewedPeople extends _$RecentlyViewedPeople {
  @override
  List<String> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final repo = ref.read(recentlyViewedPeopleRepositoryProvider);
    final result = await repo.getAll();

    if (result is Success<List<String>>) {
      state = result.data;
    }
  }

  Future<void> add(String personId) async {
    final repo = ref.read(recentlyViewedPeopleRepositoryProvider);
    final result = await repo.add(personId);

    // add() devuelve la lista actualizada — sin round-trip a disco.
    if (result is Success<List<String>>) {
      state = result.data;
    }
  }

  Future<void> clearAll() async {
    final repo = ref.read(recentlyViewedPeopleRepositoryProvider);
    final result = await repo.clearAll();

    if (result is Success) {
      state = [];
    }
  }
}
