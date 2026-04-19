import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iced26/di/core_providers.dart';

part 'bootstrap_provider.g.dart';

/// Provee el bootstrap de la aplicación.
/// Obtiene el repositorio e inicializa los datos.
@riverpod
Future<void> bootstrap(BootstrapRef ref) async {
  final repository = ref.watch(appRepositoryProvider);

  await repository.initializeDataIfNeeded();
}
