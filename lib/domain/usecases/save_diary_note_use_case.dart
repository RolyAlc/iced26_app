import 'package:iced26/domain/entities/note_color.dart';
import 'package:iced26/domain/repositories/diary_repository.dart';

/// Caso de uso: crear o actualizar una nota del diario.
class SaveDiaryNoteUseCase {
  final DiaryRepository _repo;

  SaveDiaryNoteUseCase(this._repo);

  Future<void> execute({
    int? id,
    required DateTime date,
    String? title,
    required String content,
    NoteColor? color,
  }) {
    return _repo.saveNote(
      id: id,
      date: date,
      title: title,
      content: content,
      color: color,
    );
  }
}
