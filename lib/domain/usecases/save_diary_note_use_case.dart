import 'package:iced26/domain/repositories/diary_repository.dart';

/// Caso de uso: crear o actualizar una nota del diario.
class SaveDiaryNoteUseCase {
  final DiaryRepository _repo;

  SaveDiaryNoteUseCase(this._repo);

  /// Guarda o actualiza una nota del diario.
  Future<void> execute({
    int? id,
    required DateTime date,
    required String content,
  }) {
    return _repo.saveNote(id: id, date: date, content: content);
  }
}
