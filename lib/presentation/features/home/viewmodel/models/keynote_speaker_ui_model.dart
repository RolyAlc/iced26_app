import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/session_ui_model.dart';

/// Modelo de presentación de un keynote speaker.
class KeynoteSpeakerUIModel {
  const KeynoteSpeakerUIModel({
    required this.id,
    required this.name,
    required this.isPresentingToday,
    this.institution,
    this.photoUrl,
    this.events = const [],
    this.talk,
  });

  final String id;
  final String name;
  final String? institution;
  final String? photoUrl;
  final List<SessionUIModel> events;
  final Event? talk;
  final bool isPresentingToday;
}
