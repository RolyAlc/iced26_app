import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_provider.g.dart';

/// Provider para la navegación entre las secciones.
@Riverpod(keepAlive: true)
class Navigation extends _$Navigation {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    if (state != index) {
      state = index;
    }
  }
}
