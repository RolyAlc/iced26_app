import 'package:iced26/domain/repositories/diary_repository.dart';

/// Caso de uso: eliminar una nota del diario.
class DeleteDiaryNoteUseCase {
  DeleteDiaryNoteUseCase(this._repo);
  final DiaryRepository _repo;

  /// Ejecuta la eliminación de una nota por su ID.
  Future<void> execute(int id) {
    return _repo.deleteNote(id);
  }
}
