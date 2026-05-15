import 'package:iced26/domain/entities/i18n_str.dart';

/// Entidad que representa un bloque de sesiones
class SessionBlock {
  const SessionBlock({
    required this.id,
    required this.parentId,
    this.roomId,
    this.track,
    this.title,
    this.startDate,
    this.endDate,
    this.submissionFormats = const [],
    this.defaultLang,
    this.externalRef,
  });
  final String id;
  final String parentId;
  final String? roomId;
  final String? track;
  final I18nStr? title;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> submissionFormats;
  final String? defaultLang;
  final String? externalRef;
}
