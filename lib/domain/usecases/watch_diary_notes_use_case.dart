import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/repositories/diary_repository.dart';

/// Caso de uso: observar todas las notas del diario en tiempo real.
class WatchDiaryNotesUseCase {
  WatchDiaryNotesUseCase(this._repo);
  final DiaryRepository _repo;

  /// Observa las notas del diario.
  Stream<List<DiaryNote>> execute() {
    return _repo.watchAllNotes();
  }
}
