import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/person.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/submission_type.dart';
import 'package:iced26/domain/entities/zone.dart';

/// Entidad que representa las colecciones de datos en la aplicación
class Collections {
  final List<Day> days;
  final List<Event> events;
  final List<Person> people;
  final List<Room> rooms;
  final List<Zone> zones;
  final List<SubmissionType> submissionTypes;

  Collections({
    required this.days,
    required this.events,
    required this.people,
    required this.rooms,
    required this.zones,
    required this.submissionTypes,
  });
}
