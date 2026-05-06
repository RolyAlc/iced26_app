import 'package:iced26/domain/repositories/diary_repository.dart';

/// Caso de uso: eliminar una nota del diario.
class DeleteDiaryNoteUseCase {
  final DiaryRepository _repo;

  DeleteDiaryNoteUseCase(this._repo);

  /// Ejecuta la eliminación de una nota por su ID.
  Future<void> execute(int id) {
    return _repo.deleteNote(id);
  }
}
