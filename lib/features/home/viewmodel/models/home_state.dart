import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/domain/entities/event_ui_model.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/features/home/viewmodel/models/category_layout.dart';

/// Modelo de presentación de la home.
class HomeState {
  final List<Day> days;
  final List<EventUIModel> featuredEvents;
  final CategoryLayout? categoryLayout;
  final List<NewsItem> news;
  final String headerInfoLabel;

  HomeState({
    required this.days,
    required this.featuredEvents,
    this.categoryLayout,
    required this.news,
    required this.headerInfoLabel,
  });
}
