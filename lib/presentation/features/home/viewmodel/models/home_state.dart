import 'package:iced26/domain/entities/category.dart';
import 'package:iced26/domain/entities/conference_theme.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/domain/entities/room.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/domain/entities/zone.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/keynote_speaker_ui_model.dart';

/// Modelo de presentación de la home.
class HomeState {
  HomeState({
    required this.days,
    required this.allEvents,
    required this.allRooms,
    required this.allZones,
    required this.featuredEvents,
    required this.keynoteSpeakers,
    required this.categories,
    required this.news,
    required this.socialActivities,
    required this.conferenceThemes,
    required this.headerInfoLabel,
    required this.today,
  });
  final List<Day> days;
  final List<Event> allEvents;
  final List<Room> allRooms;
  final List<Zone> allZones;
  final List<EventUIModel> featuredEvents;
  final List<KeynoteSpeakerUIModel> keynoteSpeakers;
  final List<Category> categories;
  final List<NewsItem> news;
  final List<SocialActivity> socialActivities;
  final List<ConferenceTheme> conferenceThemes;
  final String headerInfoLabel;
  final DateTime today;

  /// Cantidad de noticias a mostrar en la home.
  static const int _maxVisibleNews = 4;
  
  /// Verifica si hay más noticias que mostrar.
  bool get hasMoreNews => news.length > _maxVisibleNews;
}
