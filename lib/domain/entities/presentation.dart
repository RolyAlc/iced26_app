import 'package:iced26/domain/entities/i18n_str.dart';
import 'package:iced26/domain/entities/speaker_entry.dart';

/// Entidad que representa una presentación
class Presentation {
  const Presentation({
    required this.id,
    required this.type,
    this.subtype,
    this.sessionBlockId,
    this.title,
    this.abstract_,
    this.description,
    this.submissionRef,
    this.durationMin,
    this.startDate,
    this.endDate,
    this.speakers = const [],
    this.tags = const [],
    this.track,
    this.defaultLang,
    this.externalRef,
    this.aboutPresentationUrl,
    this.videoPresentationUrl,
  });
  final String id;
  final String type;
  final String? subtype;
  final String? sessionBlockId;
  final I18nStr? title;
  final I18nStr? abstract_;
  final String? description;
  final String? submissionRef;
  final int? durationMin;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<SpeakerEntry> speakers;
  final List<String> tags;
  final String? track;
  final String? defaultLang;
  final String? externalRef;
  final String? aboutPresentationUrl;
  final String? videoPresentationUrl;
}

extension PresentationX on Presentation {
  String resolvedTitle(String locale) {
    return title?.resolve(locale) ?? externalRef ?? '—';
  }
}
