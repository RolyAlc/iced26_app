import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/note_color.dart';

/// Contrato para la gestión del diario personal del usuario.
abstract class DiaryRepository {
  /// Stream reactivo con todas las notas del diario.
  Stream<List<DiaryNote>> watchAllNotes();

  /// Guarda una nota. Si [id] es null, la crea; si tiene id, la actualiza.
  Future<void> saveNote({
    int? id,
    required DateTime date,
    String? title,
    required String content,
    NoteColor? color,
  });

  /// Elimina una nota por su ID.
  Future<void> deleteNote(int id);
}
