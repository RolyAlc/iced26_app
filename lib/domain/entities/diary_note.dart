/// Nota personal del diario del usuario.
class DiaryNote {
  final int id;
  final DateTime date;
  final String content;
  final DateTime createdAt;

  const DiaryNote({
    required this.id,
    required this.date,
    required this.content,
    required this.createdAt,
  });
}
