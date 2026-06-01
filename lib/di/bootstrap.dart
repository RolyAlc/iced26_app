import 'package:iced26/core/errors/result.dart';
import 'package:iced26/di/data_providers.dart';
import 'package:iced26/di/domain_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bootstrap.g.dart';

/// Orquesta la inicialización de la aplicación al arranque.
///
/// Si detecta una nueva edición del congreso, limpia los datos de usuario
/// (favoritos y presentaciones guardadas) para evitar referencias huérfanas.
@riverpod
Future<void> bootstrap(Ref ref) async {
  final configRepo = ref.watch(configRepositoryProvider);
  final result = await configRepo.initializeDataIfNeeded();

  switch (result) {
    case Success(data: final isNewEdition):
      if (isNewEdition) {
        await ref.read(clearAllSavedItemsUseCaseProvider).execute();
      }
    case Failure(message: final msg):
      throw msg;
  }
}
