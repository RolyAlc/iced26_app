import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event_ui_model.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/features/home/viewmodel/models/category_layout.dart';

/// Modelo de presentación de la home.
class HomeState {
  final List<Day> days;
  final List<Event> allEvents;
  final List<Room> allRooms;
  final List<EventUIModel> featuredEvents;
  final CategoryLayout? categoryLayout;
  final List<NewsItem> news;
  final List<SocialActivity> socialActivities;
  final String headerInfoLabel;

  HomeState({
    required this.days,
    required this.allEvents,
    required this.allRooms,
    required this.featuredEvents,
    this.categoryLayout,
    required this.news,
    required this.socialActivities,
    required this.headerInfoLabel,
  });
}
