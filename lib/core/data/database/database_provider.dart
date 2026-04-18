import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iced26/core/data/database/app_database.dart';

part 'database_provider.g.dart';

/// Proveedor de la base de datos.
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase(); // Instancia de la base de datos.

  ref.onDispose(() => db.close()); // Cierra la conexión a la base de datos.

  return db;
}
