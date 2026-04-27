import 'package:iced26/presentation/features/home/viewmodel/models/session_ui_model.dart';

/// Modelo de presentación de un keynote speaker.
class KeynoteSpeakerUIModel {
  final String id;
  final String name;
  final String? institution;
  final String? photoUrl;
  final List<SessionUIModel> events;

  const KeynoteSpeakerUIModel({
    required this.id,
    required this.name,
    this.institution,
    this.photoUrl,
    this.events = const [],
  });
}
