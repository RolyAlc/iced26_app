import 'package:iced26/data/sources/local/database/app_database.dart';
import 'package:iced26/domain/entities/diary_note.dart';

/// Mapper de notas del diario.
class DiaryNoteMapper {
  static DiaryNote fromDrift(DiaryNoteTable data) {
    final date = DateTime(data.date.year, data.date.month, data.date.day);
    return DiaryNote(
      id: data.id,
      date: date,
      title: data.title,
      content: data.content,
      color: data.colorIndex, // NoteColor? gracias al NoteColorConverter
      createdAt: data.createdAt,
    );
  }
}
