import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/data_providers.dart';

part 'bootstrap.g.dart';

/// Provee el bootstrap (inicialización) de la aplicación.
/// Devuelve null si todo es correcto o lanza una excepción si hay un error.
@riverpod
Future<void> bootstrap(Ref ref) async {
  final configRepo = ref.watch(configRepositoryProvider);
  final result = await configRepo.initializeDataIfNeeded();

  return switch (result) {
    Success() => null,
    Failure(message: final msg) => throw msg,
  };
}
