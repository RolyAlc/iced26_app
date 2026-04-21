import 'package:iced26/domain/entities/event.dart';

/// Modelo de presentación de un keynote speaker.
class KeynoteSpeakerUIModel {
  final String id;
  final String name;
  final String? institution;
  final String? photoUrl;
  final List<Event> events;

  const KeynoteSpeakerUIModel({
    required this.id,
    required this.name,
    this.institution,
    this.photoUrl,
    this.events = const [],
  });
}
