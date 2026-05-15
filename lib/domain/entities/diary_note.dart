import 'package:iced26/domain/entities/note_color.dart';

/// Nota personal del diario del usuario.
class DiaryNote {
  final int id;
  final DateTime date;
  final String? title;
  final String content;
  final NoteColor? color;
  final DateTime createdAt;

  const DiaryNote({
    required this.id,
    required this.date,
    this.title,
    required this.content,
    this.color,
    required this.createdAt,
  });
}
