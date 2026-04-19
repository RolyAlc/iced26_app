import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iced26/data/repositories/app_repository.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';

part 'core_providers.g.dart';

/// Provee el repositorio de la aplicación.
@riverpod
AppRepository appRepository(AppRepositoryRef ref) {
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
