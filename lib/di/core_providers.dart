import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';

part 'core_providers.g.dart';

/// Proveedor de la base de datos local.
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}
