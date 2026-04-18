import 'package:flutter/material.dart';

import 'package:iced26/domain/entities/app_data.dart';
import 'package:iced26/domain/entities/event.dart';

/// ViewModel para la lógica de búsqueda.
class SearchViewModel extends ChangeNotifier {
  SearchViewModel(this._data);

  final AppData _data;

  String _query = '';
  List<Event> _results = [];

  String get query => _query;
  List<Event> get results => _results;

  /// Lógica de búsqueda sobre la colección de eventos.
  void performSearch(String text) {
    _query = text;

    if (_query.isEmpty) {
      _results = [];
    } else {
      final lowercaseQuery = _query.toLowerCase();
      _results = _data.collections.events.where((event) {
        final title = event.title.resolve('en').toLowerCase();
        final subtitle = event.subtitle?.resolve('en').toLowerCase() ?? '';
        return title.contains(lowercaseQuery) ||
            subtitle.contains(lowercaseQuery);
      }).toList();
    }
    notifyListeners();
  }

  /// Limpiamos los resultados actuales.
  void clear() {
    _query = '';
    _results = [];
    notifyListeners();
  }

  /// Resolvemos el ID de la sala a un nombre.
  String getRoomName(String? roomId) {
    if (roomId == null || roomId.isEmpty) return 'No room assigned';
    final rooms = _data.collections.rooms;
    final index = rooms.indexWhere((r) => r.id == roomId);
    if (index == -1) return 'Room: $roomId';
    return rooms[index].name.resolve('en');
  }
}
