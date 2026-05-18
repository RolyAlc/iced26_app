import 'package:iced26/domain/entities/presentation.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/session_ui_model.dart';
import 'package:iced26/presentation/shared/helpers/date_helper.dart';

/// Modelo de presentación de un keynote speaker.
class KeynoteSpeakerUIModel {
  const KeynoteSpeakerUIModel({
    required this.id,
    required this.name,
    this.institution,
    this.photoUrl,
    this.events = const [],
    this.presentation,
  });
  final String id;
  final String name;
  final String? institution;
  final String? photoUrl;
  final List<SessionUIModel> events;
  final Presentation? presentation;

  /// `true` si el speaker tiene al menos una sesión programada para hoy.
  bool get isPresentingToday {
    final today = DateTime.now();
    return events.any((s) {
      final d = s.event.startDate;
      return d != null && DateHelper.isSameDay(d, today);
    });
  }
}
