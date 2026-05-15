import 'package:drift/drift.dart';
import 'package:iced26/domain/entities/note_color.dart';

/// Convierte NoteColor? ↔ int para persistir en SQLite.
/// 0 representa "sin color" (null en Dart). 1–N mapean a NoteColor.values[i-1].
class NoteColorConverter extends TypeConverter<NoteColor?, int> {
  const NoteColorConverter();

  @override
  NoteColor? fromSql(int fromDb) {
    if (fromDb <= 0 || fromDb > NoteColor.values.length) return null;
    return NoteColor.values[fromDb - 1];
  }

  @override
  int toSql(NoteColor? value) {
    if (value == null) return 0;
    return NoteColor.values.indexOf(value) + 1;
  }
}
