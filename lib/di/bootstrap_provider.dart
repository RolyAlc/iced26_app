import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/core_providers.dart';

part 'bootstrap_provider.g.dart';

/// Provee el bootstrap (inicialización de datos) de la aplicación.
/// Devuelve un result que puede ser null o un error.
@riverpod
Future<void> bootstrap(BootstrapRef ref) async {
  final configRepo = ref.watch(configRepositoryProvider);

  final result = await configRepo.initializeDataIfNeeded();

  return switch (result) {
    Success() => null,
    Failure(message: final msg) => throw msg,
  };
}
