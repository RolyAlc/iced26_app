import 'package:flutter/material.dart';

/// ViewModel que gestiona el estado de la navegación principal de la app.
class AppNavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex {
    return _currentIndex;
  }

  /// Cambia la pestaña actual y notifica a los escuchadores.
  void setIndex(int newIndex) {
    if (_currentIndex == newIndex) {
      return;
    }

    _currentIndex = newIndex;

    notifyListeners();
  }
}
