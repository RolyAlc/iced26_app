import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/domain/entities/day.dart';
import 'package:iced26/presentation/features/event/viewmodel/models/event_ui_model.dart';
import 'package:iced26/presentation/features/event/viewmodel/event_ui_mapper.dart';
import 'package:iced26/domain/entities/new.dart';
import 'package:iced26/domain/entities/social_activity.dart';
import 'package:iced26/domain/entities/category.dart';
import 'package:iced26/presentation/features/home/viewmodel/home_categories_viewmodel.dart';
import 'package:iced26/presentation/features/home/viewmodel/models/category_layout.dart';

/// ViewModel para la Home.
/// Su única responsabilidad es preparar los datos para las secciones de la pantalla principal.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this.data);
  final AppData data;

  final _categoriesVM = HomeCategoriesViewModel();

  // --- LÓGICA DE DATOS DE LA HOME ---

  // Clave de fecha local en formato yyyy-MM-dd.
  String get _todayKey {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.toIso8601String().split('T').first;
  }

  // Obtenemos el día actual de la conferencia.
  Day? get currentDay {
    final days = data.collections.days;
    if (days.isEmpty) return null;
    final index = days.indexWhere((day) => day.date == _todayKey);
    if (index == -1) return days.first;
    return days[index];
  }

  /// Eventos destacados del día actual.
  List<EventUIModel> get featuredEvents {
    final day = currentDay;
    if (day == null) return [];

    return data.collections.events
        .where((event) => event.filterDate == day.date)
        .map(
          (event) => EventUIMapper.fromEntity(event, getRoomName(event.roomId)),
        )
        .toList();
  }

  // --- OTRAS SECCIONES ---

  // Texto dinámico para el header.
  String get headerInfoLabel {
    final days = data.collections.days;
    if (days.isEmpty || days.every((day) => day.date != _todayKey)) {
      return 'Welcome to ICED26';
    }
    final index = days.indexWhere((day) => day.date == _todayKey);
    final position = index == -1 ? 0 : index;
    return 'Welcome to day ${position + 1} of ${days.length}';
  }

  // Categorías mapeadas al nuevo dominio y layout.
  CategoryLayout? get categoryLayout {
    final types = data.collections.submissionTypes;
    if (types.isEmpty) return null;

    final categories = types
        .map((t) => Category(name: t.name.resolve('en')))
        .toList();

    return _categoriesVM.buildLayout(categories);
  }

  // Actividades sociales y noticias.
  List<SocialActivity> get socials => data.collections.socials;
  List<NewsItem> get news => data.collections.news;

  /// Helper para obtener el nombre de la habitación.
  String getRoomName(String? roomId) {
    if (roomId == null || roomId.isEmpty) return 'No room assigned';
    final rooms = data.collections.rooms;
    final index = rooms.indexWhere((r) => r.id == roomId);
    if (index == -1) return 'Room: $roomId';
    return rooms[index].name.resolve('en');
  }
}
