import 'package:drift/drift.dart';

import 'package:iced26/data/mappers/diary/diary_note_mapper.dart';
import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/diary_note.dart';
import 'package:iced26/domain/entities/note_color.dart';
import 'package:iced26/domain/repositories/diary_repository.dart';

/// Implementación del repositorio del diario personal.
class DiaryRepositoryImpl implements DiaryRepository {
  DiaryRepositoryImpl(this._db);
  final AppDatabase _db;

  @override
  Stream<List<DiaryNote>> watchAllNotes() {
    return (_db.select(_db.diaryNotes)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .map((rows) => rows.map(DiaryNoteMapper.fromDrift).toList());
  }

  @override
  Future<void> saveNote({
    int? id,
    required DateTime date,
    String? title,
    required String content,
    NoteColor? color,
  }) async {
    final day = DateTime(date.year, date.month, date.day);
    final companion = DiaryNotesCompanion(
      date: Value(day),
      title: Value(title),
      content: Value(content),
      colorIndex: Value(color),
    );

    if (id == null) {
      await _db.into(_db.diaryNotes).insert(companion);
    } else {
      await (_db.update(
        _db.diaryNotes,
      )..where((t) => t.id.equals(id))).write(companion);
    }
  }

  @override
  Future<void> deleteNote(int id) async {
    await (_db.delete(_db.diaryNotes)..where((t) => t.id.equals(id))).go();
  }
}
