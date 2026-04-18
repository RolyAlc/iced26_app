import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iced26/core/data/app_repository.dart';
import 'package:iced26/core/data/database/database_provider.dart';

part 'app_repository_provider.g.dart';

/// Provee el repositorio de la aplicación.
@riverpod
AppRepository appRepository(AppRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return AppRepository(db);
}
