/// Nota personal del diario del usuario.
class DiaryNote {
  final int id;
  final DateTime date;
  final String? title;
  final String content;
  final int colorIndex;
  final DateTime createdAt;

  const DiaryNote({
    required this.id,
    required this.date,
    this.title,
    required this.content,
    this.colorIndex = 0,
    required this.createdAt,
  });
}
