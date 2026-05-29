import 'package:iced26/presentation/app/navigation_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_provider.g.dart';

/// Provider para la navegación entre las secciones principales de la app.
@Riverpod(keepAlive: true)
class Navigation extends _$Navigation {
  @override
  AppFeature build() {
    return AppFeature.home;
  }

  /// Selecciona una nueva sección principal.
  void select(AppFeature feature) {
    if (state != feature) {
      state = feature;
    }
  }
}
